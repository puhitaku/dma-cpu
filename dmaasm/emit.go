package dmaasm

import (
	"fmt"
	"strings"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

// emit is pass 2: with the layout fixed, walk the statements again and
// materialize segments, blocks, relocations, init writes, and the symbol
// table. Generated labels are re-derived deterministically (same counter,
// same statement order as pass 1).
func (a *asm) emit() (*Result, error) {
	bld := img.NewBuilder()
	text := bld.Seg(a.opts.TextBase)
	data := bld.Seg(a.opts.DataBase)

	segOf := func(sym symbol) *img.Seg {
		if sym.text {
			return text
		}
		return data
	}

	// resolve turns an operand into a pointer for a block field.
	resolve := func(op operand, line int) (img.Ptr, error) {
		switch op.kind {
		case opMMIO, opAbs:
			return img.Abs(op.num), nil
		case opLit:
			return img.In(data, a.litOffs[litKey(op)]), nil
		default:
			sym, ok := a.syms[op.sym]
			if !ok {
				return img.Ptr{}, fmt.Errorf("line %d: undefined symbol %q", line, op.sym)
			}
			if op.field != 0 && !sym.text {
				return img.Ptr{}, fmt.Errorf("line %d: block field on data symbol %q", line, op.sym)
			}
			return img.In(segOf(sym), sym.off+op.field), nil
		}
	}

	// --- Data segment, in layout order ---
	for _, s := range a.stmts {
		if s.dir == "" {
			continue
		}
		switch s.dir {
		case "word":
			for _, arg := range s.args {
				if v, err := parseNum(arg); err == nil {
					data.Word(v)
				} else {
					sym, ok := a.syms[arg]
					if !ok {
						return nil, fmt.Errorf("line %d: .word of undefined symbol %q", s.line, arg)
					}
					data.WordRef(segOf(sym), sym.off)
				}
			}
		case "space":
			n, _ := parseNum(s.args[0])
			for i := uint32(0); i < n; i += 4 {
				data.Word(0)
			}
		case "regs":
			for range abiRegs {
				data.Word(0)
			}
		}
	}
	// Literal pool.
	for _, k := range a.litOrder {
		op := a.lits[k]
		if op.isNum {
			data.Word(op.num)
			continue
		}
		sym, ok := a.syms[op.sym]
		if !ok {
			return nil, fmt.Errorf("undefined symbol %q (used as $%s)", op.sym, op.sym)
		}
		data.WordRef(segOf(sym), sym.off)
	}

	// --- Init writes: sniffer first (ABI default), then user writes ---
	if !a.noSniff {
		bld.AddWrite(a.v.SniffCtrlAddr(),
			emu.SniffCtrlEN|emu.SniffCtrlDmach(a.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
		bld.AddWrite(a.v.SniffDataAddr(), 0)
	}
	for _, w := range a.writes {
		if w.valSym == "" {
			bld.AddWrite(w.addr, w.valNum)
			continue
		}
		sym, ok := a.syms[w.valSym]
		if !ok {
			return nil, fmt.Errorf("line %d: .write of undefined symbol %q", w.line, w.valSym)
		}
		bld.AddWriteRef(w.addr, segOf(sym), sym.off)
	}

	// --- Text segment ---
	a.genLabel = 0 // regenerate the same internal label names as pass 1
	nextGen := func() operand {
		a.genLabel++
		return operand{kind: opLit, sym: fmt.Sprintf("__L%d", a.genLabel)}
	}
	execCtrl := a.cfg.ExecCtrl(a.v)
	sniffP := img.Abs(a.v.SniffDataAddr())
	pcP := img.Abs(emu.ChanRegAddr(a.cfg.Fetch, emu.OffReadAddr))
	symP := func(name string, line int) (img.Ptr, error) {
		return resolve(operand{kind: opSym, sym: name}, line)
	}
	litNumP := func(v uint32) img.Ptr {
		return img.In(data, a.litOffs[litKey(operand{kind: opLit, num: v, isNum: true})])
	}
	mv := func(src, dst img.Ptr, count, ctrl uint32) {
		text.BlockP(src, dst, count, ctrl)
	}

	for _, s := range a.stmts {
		if s.mnem == "" {
			continue
		}
		// Common operand resolutions per shape.
		var ops []img.Ptr
		resolveArgs := func(idxs ...int) error {
			ops = ops[:0]
			for _, i := range idxs {
				op, err := a.parseOperand(s.args[i], s.line)
				if err != nil {
					return err
				}
				p, err := resolve(op, s.line)
				if err != nil {
					return err
				}
				ops = append(ops, p)
			}
			return nil
		}
		nullP, _ := symP("null", s.line)
		zeroP, _ := symP("zero", s.line)

		switch s.mnem {
		case "move":
			f, err := a.parseMoveFlags(s.args[2:], s.line)
			if err != nil {
				return nil, err
			}
			if err := resolveArgs(0, 1); err != nil {
				return nil, err
			}
			ctrl := execCtrl&^emu.CtrlSize32 | f.size | f.ctrlExtra
			mv(ops[0], ops[1], f.count, ctrl)
		case "add":
			if err := resolveArgs(0, 1, 2); err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[1], nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, ops[2], 1, execCtrl)
		case "sub":
			if err := resolveArgs(0, 1, 2); err != nil {
				return nil, err
			}
			mv(ops[1], sniffP, 1, execCtrl)
			mv(litNumP(0xFFFFFFFF), img.Abs(a.v.SniffDataXORAddr()), 1, execCtrl)
			mv(litNumP(1), nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(ops[0], nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, ops[2], 1, execCtrl)
		case "or", "xor":
			if err := resolveArgs(0, 1, 2); err != nil {
				return nil, err
			}
			alias := a.v.SniffDataSetAddr()
			if s.mnem == "xor" {
				alias = a.v.SniffDataXORAddr()
			}
			mv(ops[1], sniffP, 1, execCtrl)
			mv(ops[0], img.Abs(alias), 1, execCtrl)
			mv(sniffP, ops[2], 1, execCtrl)
		case "shl":
			if err := resolveArgs(0, 1); err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[0], nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, ops[1], 1, execCtrl)
		case "mulc":
			k, _ := parseNum(s.args[1])
			if err := resolveArgs(0, 2); err != nil {
				return nil, err
			}
			mv(zeroP, sniffP, 1, execCtrl)
			mv(ops[0], nullP, k, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, ops[1], 1, execCtrl)
		case "jump":
			p, err := resolve(operand{kind: opLit, sym: s.args[0]}, s.line)
			if err != nil {
				return nil, err
			}
			mv(p, pcP, 1, execCtrl)
		case "jumpr":
			if err := resolveArgs(0); err != nil {
				return nil, err
			}
			mv(ops[0], pcP, 1, execCtrl)
		case "jneg":
			if err := resolveArgs(0); err != nil {
				return nil, err
			}
			tramp := nextGen()
			trampP, err := resolve(tramp, s.line)
			if err != nil {
				return nil, err
			}
			posP, err := resolve(operand{kind: opLit, sym: s.args[2]}, s.line)
			if err != nil {
				return nil, err
			}
			negP, err := resolve(operand{kind: opLit, sym: s.args[1]}, s.line)
			if err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl|a.v.CtrlBswap)
			mv(litNumP(0xFFFFFFEF), img.Abs(a.v.SniffDataClrAddr()), 1, execCtrl)
			mv(trampP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, pcP, 1, execCtrl)
			mv(posP, pcP, 1, execCtrl) // trampoline slot 0: non-negative
			mv(negP, pcP, 1, execCtrl) // trampoline slot 1: negative
		case "call":
			ret := nextGen()
			retP, err := resolve(ret, s.line)
			if err != nil {
				return nil, err
			}
			fP, err := resolve(operand{kind: opLit, sym: s.args[0]}, s.line)
			if err != nil {
				return nil, err
			}
			lrP, err := symP("lr", s.line)
			if err != nil {
				return nil, err
			}
			mv(retP, lrP, 1, execCtrl)
			mv(fP, pcP, 1, execCtrl)
		case "ret":
			lrP, err := symP("lr", s.line)
			if err != nil {
				return nil, err
			}
			mv(lrP, pcP, 1, execCtrl)
		case "safepoint":
			resume := nextGen()
			resumeP, err := resolve(resume, s.line)
			if err != nil {
				return nil, err
			}
			irqResumeP, err := symP("irqresume", s.line)
			if err != nil {
				return nil, err
			}
			dispatchP, err := symP("dispatch", s.line)
			if err != nil {
				return nil, err
			}
			mv(resumeP, irqResumeP, 1, execCtrl)
			mv(dispatchP, pcP, 1, execCtrl)
		case "gpio":
			pin, _ := parseNum(s.args[0])
			word := a.v.GPIOOutCtrl(s.args[1] == "hi")
			mv(litNumP(word), img.Abs(a.v.GPIOCtrlAddr(int(pin))), 1, execCtrl)
		case "halt":
			text.Halt()
		case "nop":
			// Zero-length sequence: completes immediately and chains on —
			// a hardware-verified NOP (prompts/004-hw-calibration.md).
			mv(zeroP, nullP, 0, execCtrl)
		default:
			return nil, fmt.Errorf("line %d: unhandled instruction %q", s.line, s.mnem)
		}
	}

	entrySym := a.syms[a.entry]
	bld.Entry(text, entrySym.off)

	im, err := bld.Image()
	if err != nil {
		return nil, err
	}
	symbols := make(map[string]uint32, len(a.syms))
	for name, sym := range a.syms {
		if strings.HasPrefix(name, "__") {
			continue
		}
		base := a.opts.DataBase
		if sym.text {
			base = a.opts.TextBase
		}
		symbols[name] = base + sym.off
	}
	return &Result{Image: im, Symbols: symbols}, nil
}
