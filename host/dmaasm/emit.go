package dmaasm

import (
	"fmt"
	"strings"

	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
)

// emit is pass 2: with the layout fixed, walk the statements again and
// materialize segments, blocks, relocations, init writes, and the symbol
// table. Generated labels are re-derived deterministically (same counter,
// same statement order as pass 1).
func (a *asm) emit() (*Result, error) {
	bld := img.NewBuilder()
	text := bld.Seg(a.opts.TextBase)
	data := bld.Seg(a.opts.DataBase)
	var rtext *img.Seg
	if a.split {
		rtext = bld.Seg(a.opts.RAMTextBase)
	}

	// symLoc maps a symbol plus byte offset to its segment and offset
	// within it. Text offsets are one continuous pass-1 counter; symbols
	// at or past the .ramtext split live in the third segment.
	symLoc := func(sym symbol, extra uint32) (*img.Seg, uint32) {
		if !sym.text {
			return data, sym.off + extra
		}
		off := sym.off + extra
		if a.split && off >= a.splitOff {
			return rtext, off - a.splitOff
		}
		return text, off
	}

	// resolve turns an operand into a pointer for a block field.
	resolve := func(op operand, line int) (img.Ptr, error) {
		switch op.kind {
		case opMMIO, opAbs:
			return img.Abs(op.num), nil
		case opLit:
			if off, ok := a.litText[litKey(op)]; ok {
				return img.In(text, off), nil
			}
			return img.In(data, a.litOffs[litKey(op)]), nil
		default:
			sym, ok := a.syms[op.sym]
			if !ok {
				return img.Ptr{}, fmt.Errorf("line %d: undefined symbol %q", line, op.sym)
			}
			if op.blockField && !sym.text {
				return img.Ptr{}, fmt.Errorf("line %d: block field on data symbol %q", line, op.sym)
			}
			extra := op.field
			if op.blockField && a.opts.Compact {
				// Block fields address the instruction's payload record,
				// past any planner-inserted switch/count records.
				extra += a.payloadDelta[sym.off]
			}
			seg, off := symLoc(sym, extra)
			return img.In(seg, off), nil
		}
	}

	// --- Data segment, in layout order ---
	for _, s := range a.stmts {
		if s.dir == "" {
			continue
		}
		switch s.dir {
		case "word":
			if s.inText {
				continue // emitted in the text pass, in stream order
			}
			for _, arg := range s.args {
				if v, err := parseNum(arg); err == nil {
					data.Word(v)
				} else {
					sym, ok := a.syms[arg]
					if !ok {
						return nil, fmt.Errorf("line %d: .word of undefined symbol %q", s.line, arg)
					}
					data.WordRef(symLoc(sym, 0))
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
	// Literal pool (resident half; the flash half lands after the text
	// pass so its words follow the last instruction).
	for _, k := range a.litOrder {
		if _, cold := a.litText[k]; cold {
			continue
		}
		op := a.lits[k]
		if op.isNum {
			data.Word(op.num)
			continue
		}
		sym, ok := a.syms[op.sym]
		if !ok {
			return nil, fmt.Errorf("undefined symbol %q (used as $%s)", op.sym, op.sym)
		}
		data.WordRef(symLoc(sym, op.field))
	}

	// --- Init writes: sniffer first (ABI default), then machine config
	// (compact banks + cleanup), then user writes ---
	if !a.noSniff {
		bld.AddWrite(a.v.SniffCtrlAddr(),
			emu.SniffCtrlEN|emu.SniffCtrlDmach(a.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
		bld.AddWrite(a.v.SniffDataAddr(), 0)
	}
	if a.opts.Compact {
		for ch := 0; ch < emu.CompactNumBanks; ch++ {
			bld.AddWrite(emu.ChanRegAddr(ch, emu.OffAl1Ctrl), emu.CompactBankCtrl(a.v, ch))
			bld.AddWrite(emu.ChanRegAddr(ch, emu.OffAl2TransCount), 1)
		}
		// Cleanup: one transfer restoring fetch's write pointer to the
		// plain window; the destination is the trigger alias, so the
		// restore also fires the next fetch (auto-return for the
		// bswap/size banks).
		winPOff := a.litOffs[litKey(operand{kind: opLit, num: emu.CompactWindow(emu.CompactPlain), isNum: true})]
		bld.AddWriteRef(emu.ChanRegAddr(emu.CompactCleanup, emu.OffAl1ReadAddr), data, winPOff)
		bld.AddWrite(emu.ChanRegAddr(emu.CompactCleanup, emu.OffAl1WriteAddr),
			emu.ChanRegAddr(emu.CompactFetch, emu.OffAl2WriteAddrTrig))
		bld.AddWrite(emu.ChanRegAddr(emu.CompactCleanup, emu.OffAl2TransCount), 1)
		bld.AddWrite(emu.ChanRegAddr(emu.CompactCleanup, emu.OffAl1Ctrl), emu.CompactCleanupCtrl(a.v))
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
		wseg, woff := symLoc(sym, 0)
		bld.AddWriteRef(w.addr, wseg, woff)
	}

	// --- Text segment ---
	a.genLabel = 0 // regenerate the same internal label names as pass 1
	a.jpairIdx = 0 // arena pairs are consumed in pass-1 order
	nextGen := func() operand {
		a.genLabel++
		return operand{kind: opLit, sym: fmt.Sprintf("__L%d", a.genLabel)}
	}
	execCtrl := a.cfg.ExecCtrl(a.v)
	sniffP := img.Abs(a.v.SniffDataAddr())
	xorP := img.Abs(a.v.SniffDataXORAddr())
	setP := img.Abs(a.v.SniffDataSetAddr())
	clrP := img.Abs(a.v.SniffDataClrAddr())
	pcP := img.Abs(emu.ChanRegAddr(a.cfg.Fetch, emu.OffReadAddr))
	symP := func(name string, line int) (img.Ptr, error) {
		return resolve(operand{kind: opSym, sym: name}, line)
	}
	litNumP := func(v uint32) img.Ptr {
		k := litKey(operand{kind: opLit, num: v, isNum: true})
		if off, ok := a.litText[k]; ok {
			return img.In(text, off)
		}
		return img.In(data, a.litOffs[k])
	}
	a.dataSeg = data
	a.textSeg = text
	// out is the segment instruction records land in: text until the
	// .ramtext directive, rtext after it.
	out := text
	// Compact: route blocks through the record emitter (compact.go).
	var ce *cemit
	var mvErr error
	if a.opts.Compact {
		atSym, ok := a.syms["at"]
		if !ok {
			return nil, fmt.Errorf("compact mode requires the .regs directive")
		}
		// The current-window state is fetch's own WRITE_ADDR register;
		// switch records rewrite it through the AL3 (non-trigger) alias
		// and the bank's chain back to fetch does the actual trigger.
		ce = &cemit{
			a: a, text: text, st: newCstate(),
			scrP: img.Abs(emu.ChanRegAddr(emu.CompactFetch, emu.OffAl3WriteAddr)),
			atP:  img.In(data, atSym.off),
		}
	}
	mvFull := func(src, dst img.Ptr, count, ctrl uint32, dyn bool, cntAfter uint32) {
		if ce != nil {
			if err := ce.block(src, dst, count, ctrl, dyn, cntAfter); err != nil && mvErr == nil {
				mvErr = err
			}
			return
		}
		out.BlockP(src, dst, count, ctrl)
	}
	mvd := func(src, dst img.Ptr, count, ctrl uint32, dyn bool) {
		mvFull(src, dst, count, ctrl, dyn, 0)
	}
	mv := func(src, dst img.Ptr, count, ctrl uint32) {
		mvFull(src, dst, count, ctrl, false, 0)
	}
	// signTail: with the tested word already byte-swapped in the
	// accumulator, isolate the true sign bit (bit 7 after bswap), add the
	// trampoline-pair base, and dispatch (+0 sign clear, +128 sign set).
	signTail := func(line int) error {
		pairP, err := resolve(operand{kind: opLit, sym: jpairName(a.jpairIdx)}, line)
		if err != nil {
			return err
		}
		a.jpairIdx++
		nullP, err := symP("null", line)
		if err != nil {
			return err
		}
		mv(litNumP(0xFFFFFF7F), clrP, 1, execCtrl)
		mv(pairP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
		mv(sniffP, pcP, 1, execCtrl)
		return nil
	}
	// subIntoSniff: accumulator = *aP - *bP (4 blocks; two's complement,
	// exact mod 2^32 — unlike the sign trick this has no range caveat).
	subIntoSniff := func(aP, bP, nullP img.Ptr) {
		mv(bP, sniffP, 1, execCtrl)
		mv(litNumP(0xFFFFFFFF), xorP, 1, execCtrl)
		mv(litNumP(1), nullP, 1, execCtrl|a.v.CtrlSniffEn)
		mv(aP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
	}
	// signTailC: compact-mode dispatch tail — the tested word sits in
	// `at` (staged there by a bswap-bank read), gets masked to its true
	// sign bit, offset by the trampoline pair, and pushed to %pc.
	signTailC := func(atP img.Ptr, line int) error {
		pairP, err := resolve(operand{kind: opLit, sym: jpairName(a.jpairIdx)}, line)
		if err != nil {
			return err
		}
		a.jpairIdx++
		nullP, err := symP("null", line)
		if err != nil {
			return err
		}
		mv(atP, sniffP, 1, execCtrl)
		mv(litNumP(0xFFFFFF7F), clrP, 1, execCtrl)
		mv(pairP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
		mv(sniffP, pcP, 1, execCtrl)
		return nil
	}

	for _, s := range a.stmts {
		if s.dir == "ramtext" {
			out = rtext
			if ce != nil {
				ce.text = rtext
			}
			continue
		}
		if s.dir == "word" && s.inText {
			for _, arg := range s.args {
				if v, err := parseNum(arg); err == nil {
					out.Word(v)
				} else if sym, ok := a.syms[arg]; ok {
					out.WordRef(symLoc(sym, 0))
				} else {
					return nil, fmt.Errorf("line %d: .word of undefined symbol %q", s.line, arg)
				}
			}
			continue
		}
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
			mvd(ops[0], ops[1], f.count, ctrl, f.dyn)
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
		case "and":
			if err := resolveArgs(0, 1, 2); err != nil {
				return nil, err
			}
			atP, err := symP("at", s.line)
			if err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(litNumP(0xFFFFFFFF), xorP, 1, execCtrl) // sniff = ~a
			mv(sniffP, atP, 1, execCtrl)
			mv(ops[1], sniffP, 1, execCtrl)
			mv(atP, clrP, 1, execCtrl) // sniff = b & ~(~a) = a & b
			mv(sniffP, ops[2], 1, execCtrl)
		case "andn":
			if err := resolveArgs(0, 1, 2); err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[1], clrP, 1, execCtrl) // sniff = a & ~b
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
			if a.opts.Compact {
				// Binary-method multiply on the accumulator, count-1
				// records only: S = 0; per bit of k (MSB first) S += S
				// (the sniff bank reading SNIFF_DATA doubles it), plus
				// S += v on set bits. The bank count never leaves 1, so
				// the sniff read stays on the deferred fast path — and
				// the old in-bank count restore (the sniff channel
				// writing its own AL2_TRANS_COUNT mid-transfer) is gone:
				// that write wedges the channel on RP2040 silicon.
				// RP2350 latches it as reload only.
				mv(zeroP, sniffP, 1, execCtrl)
				for started, bit := false, 31; bit >= 0; bit-- {
					if started {
						mv(sniffP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
					}
					if k&(1<<uint(bit)) != 0 {
						mv(ops[0], nullP, 1, execCtrl|a.v.CtrlSniffEn)
						started = true
					}
				}
				mv(sniffP, ops[1], 1, execCtrl)
				break
			}
			mv(zeroP, sniffP, 1, execCtrl)
			mv(ops[0], nullP, k, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, ops[1], 1, execCtrl)
		case "jump":
			tgt := operand{kind: opLit, sym: s.args[0]}
			if v, err := parseNum(s.args[0]); err == nil {
				tgt = operand{kind: opLit, num: v, isNum: true}
			}
			p, err := resolve(tgt, s.line)
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
			jnegMask := uint32(0xFFFFFFEF) // bit 4: 16-byte blocks
			if a.opts.Compact {
				jnegMask = 0xFFFFFFF7 // bit 3: 8-byte records
			}
			mv(ops[0], sniffP, 1, execCtrl|a.v.CtrlBswap)
			mv(litNumP(jnegMask), img.Abs(a.v.SniffDataClrAddr()), 1, execCtrl)
			mv(trampP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, pcP, 1, execCtrl)
			mv(posP, pcP, 1, execCtrl) // trampoline slot 0: non-negative
			mv(negP, pcP, 1, execCtrl) // trampoline slot 1: negative
		case "jsign":
			if err := resolveArgs(0); err != nil {
				return nil, err
			}
			mv(ops[0], sniffP, 1, execCtrl|a.v.CtrlBswap)
			if err := signTail(s.line); err != nil {
				return nil, err
			}
		case "jeq":
			if err := resolveArgs(0, 1); err != nil {
				return nil, err
			}
			atP, err := symP("at", s.line)
			if err != nil {
				return nil, err
			}
			if a.opts.Compact {
				// Restructured so the sniff bank is only left through
				// reads (mode-domain rules, compact.go).
				at2P, err := symP("at2", s.line)
				if err != nil {
					return nil, err
				}
				subIntoSniff(ops[0], ops[1], nullP) // d = a - b
				mv(sniffP, atP, 1, execCtrl)        // at = d (read on sniff)
				mv(atP, sniffP, 1, execCtrl)
				mv(litNumP(0xFFFFFFFF), xorP, 1, execCtrl)         // ~d
				mv(litNumP(1), nullP, 1, execCtrl|a.v.CtrlSniffEn) // -d
				mv(sniffP, at2P, 1, execCtrl)                      // at2 = -d
				mv(at2P, sniffP, 1, execCtrl)
				mv(atP, setP, 1, execCtrl)                 // -d | d
				mv(sniffP, atP, 1, execCtrl|a.v.CtrlBswap) // at = bswap(d | -d)
				if err := signTailC(atP, s.line); err != nil {
					return nil, err
				}
				break
			}
			subIntoSniff(ops[0], ops[1], nullP) // d = a - b
			mv(sniffP, atP, 1, execCtrl)
			mv(litNumP(0xFFFFFFFF), xorP, 1, execCtrl)         // ~d
			mv(litNumP(1), nullP, 1, execCtrl|a.v.CtrlSniffEn) // -d
			mv(atP, setP, 1, execCtrl)                         // -d | d: sign set iff d != 0
			mv(sniffP, sniffP, 1, execCtrl|a.v.CtrlBswap)
			if err := signTail(s.line); err != nil {
				return nil, err
			}
		case "jlt":
			// Signed a < b for full-range operands:
			// sign((a & ~b) | (~(a ^ b) & (a - b))).
			if err := resolveArgs(0, 1); err != nil {
				return nil, err
			}
			atP, err := symP("at", s.line)
			if err != nil {
				return nil, err
			}
			at2P, err := symP("at2", s.line)
			if err != nil {
				return nil, err
			}
			if a.opts.Compact {
				mv(ops[0], sniffP, 1, execCtrl)
				mv(ops[1], xorP, 1, execCtrl) // a ^ b
				mv(sniffP, atP, 1, execCtrl)
				subIntoSniff(ops[0], ops[1], nullP) // d = a - b
				mv(sniffP, at2P, 1, execCtrl)       // at2 = d (read on sniff)
				mv(at2P, sniffP, 1, execCtrl)       // reseed d unsniffed
				mv(atP, clrP, 1, execCtrl)          // d & ~(a ^ b)
				mv(sniffP, at2P, 1, execCtrl)
				mv(ops[0], sniffP, 1, execCtrl)
				mv(ops[1], clrP, 1, execCtrl) // a & ~b
				mv(at2P, setP, 1, execCtrl)
				mv(sniffP, atP, 1, execCtrl|a.v.CtrlBswap)
				if err := signTailC(atP, s.line); err != nil {
					return nil, err
				}
				break
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[1], xorP, 1, execCtrl) // a ^ b
			mv(sniffP, atP, 1, execCtrl)
			subIntoSniff(ops[0], ops[1], nullP) // d = a - b
			mv(atP, clrP, 1, execCtrl)          // d & ~(a ^ b)
			mv(sniffP, at2P, 1, execCtrl)
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[1], clrP, 1, execCtrl) // a & ~b
			mv(at2P, setP, 1, execCtrl)
			mv(sniffP, sniffP, 1, execCtrl|a.v.CtrlBswap)
			if err := signTail(s.line); err != nil {
				return nil, err
			}
		case "jltu":
			// Unsigned a < b (borrow of a - b):
			// sign((~a & b) | ((~a | b) & (a - b))).
			if err := resolveArgs(0, 1); err != nil {
				return nil, err
			}
			atP, err := symP("at", s.line)
			if err != nil {
				return nil, err
			}
			at2P, err := symP("at2", s.line)
			if err != nil {
				return nil, err
			}
			if a.opts.Compact {
				mv(ops[0], sniffP, 1, execCtrl)
				mv(ops[1], clrP, 1, execCtrl) // a & ~b
				mv(sniffP, atP, 1, execCtrl)
				subIntoSniff(ops[0], ops[1], nullP) // d = a - b
				mv(sniffP, at2P, 1, execCtrl)       // at2 = d (read on sniff)
				mv(at2P, sniffP, 1, execCtrl)       // reseed d unsniffed
				mv(atP, clrP, 1, execCtrl)          // d & ~(a & ~b) = d & (~a | b)
				mv(sniffP, at2P, 1, execCtrl)
				mv(ops[1], sniffP, 1, execCtrl)
				mv(ops[0], clrP, 1, execCtrl) // b & ~a
				mv(at2P, setP, 1, execCtrl)
				mv(sniffP, atP, 1, execCtrl|a.v.CtrlBswap)
				if err := signTailC(atP, s.line); err != nil {
					return nil, err
				}
				break
			}
			mv(ops[0], sniffP, 1, execCtrl)
			mv(ops[1], clrP, 1, execCtrl) // a & ~b
			mv(sniffP, atP, 1, execCtrl)
			subIntoSniff(ops[0], ops[1], nullP) // d = a - b
			mv(atP, clrP, 1, execCtrl)          // d & ~(a & ~b) = d & (~a | b)
			mv(sniffP, at2P, 1, execCtrl)
			mv(ops[1], sniffP, 1, execCtrl)
			mv(ops[0], clrP, 1, execCtrl) // b & ~a
			mv(at2P, setP, 1, execCtrl)
			mv(sniffP, sniffP, 1, execCtrl|a.v.CtrlBswap)
			if err := signTail(s.line); err != nil {
				return nil, err
			}
		case "jbool":
			if err := resolveArgs(0); err != nil {
				return nil, err
			}
			tramp := nextGen()
			trampP, err := resolve(tramp, s.line)
			if err != nil {
				return nil, err
			}
			zeroLP, err := resolve(operand{kind: opLit, sym: s.args[1]}, s.line)
			if err != nil {
				return nil, err
			}
			oneLP, err := resolve(operand{kind: opLit, sym: s.args[2]}, s.line)
			if err != nil {
				return nil, err
			}
			if a.opts.Compact {
				// 8-byte slots: sniff = 8*v + pair base, all count-1
				// records — v, three doublings (the sniff bank reading
				// SNIFF_DATA), the pair base, dispatch. See mulc on the
				// RP2040 self-TRANS_COUNT wedge.
				mv(zeroP, sniffP, 1, execCtrl)
				mv(ops[0], nullP, 1, execCtrl|a.v.CtrlSniffEn)
				mv(sniffP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
				mv(sniffP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
				mv(sniffP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
				mv(trampP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
				mv(sniffP, pcP, 1, execCtrl)
				mv(zeroLP, pcP, 1, execCtrl) // trampoline slot 0: v == 0
				mv(oneLP, pcP, 1, execCtrl)  // trampoline slot 1: v == 1
				break
			}
			mv(zeroP, sniffP, 1, execCtrl)
			mv(ops[0], nullP, 16, execCtrl|a.v.CtrlSniffEn) // sniff = 16*v
			mv(trampP, nullP, 1, execCtrl|a.v.CtrlSniffEn)
			mv(sniffP, pcP, 1, execCtrl)
			mv(zeroLP, pcP, 1, execCtrl) // trampoline slot 0: v == 0
			mv(oneLP, pcP, 1, execCtrl)  // trampoline slot 1: v == 1
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
			if ce != nil {
				ce.halt()
			} else {
				out.Halt()
			}
		case "nop":
			// Zero-length sequence: completes immediately and chains on —
			// a hardware-verified NOP (prompts/004-hw-calibration.md).
			mv(zeroP, nullP, 0, execCtrl)
		default:
			return nil, fmt.Errorf("line %d: unhandled instruction %q", s.line, s.mnem)
		}
		if ce != nil {
			if mvErr != nil {
				return nil, fmt.Errorf("line %d: %v", s.line, mvErr)
			}
			if err := ce.endInstr(s.line, s.crecs); err != nil {
				return nil, err
			}
		}
	}

	// Sign-dispatch arena: per 256-byte bank, the sign-clear slot row and
	// then the sign-set row 128 bytes later (layout fixed in pass 1).
	// Unused slots halt. Compact slots are single records.
	pairsPerBank := 8
	if a.opts.Compact {
		pairsPerBank = 16
	}
	for b := 0; b*pairsPerBank < len(a.jpairs); b++ {
		for _, negRow := range []bool{false, true} {
			for slot := 0; slot < pairsPerBank; slot++ {
				p := b*pairsPerBank + slot
				if p >= len(a.jpairs) {
					if ce != nil {
						ce.halt()
						if err := ce.endInstr(0, 1); err != nil {
							return nil, err
						}
					} else {
						out.Halt()
					}
					continue
				}
				tgt := a.jpairs[p].nonneg
				if negRow {
					tgt = a.jpairs[p].neg
				}
				tp, err := resolve(operand{kind: opLit, sym: tgt}, a.jpairs[p].line)
				if err != nil {
					return nil, err
				}
				mv(tp, pcP, 1, execCtrl)
				if ce != nil {
					if mvErr != nil {
						return nil, mvErr
					}
					if err := ce.endInstr(a.jpairs[p].line, 1); err != nil {
						return nil, err
					}
				}
			}
		}
	}

	// Flash half of the literal pool: appended to the main text
	// segment, past the last instruction (and past the ramtext split
	// point — these offsets never route through symLoc).
	for _, k := range a.litOrder {
		if _, cold := a.litText[k]; !cold {
			continue
		}
		op := a.lits[k]
		if op.isNum {
			text.Word(op.num)
			continue
		}
		sym, ok := a.syms[op.sym]
		if !ok {
			return nil, fmt.Errorf("undefined symbol %q (used as $%s)", op.sym, op.sym)
		}
		text.WordRef(symLoc(sym, op.field))
	}

	bld.Entry(symLoc(a.syms[a.entry], 0))

	im, err := bld.Image()
	if err != nil {
		return nil, err
	}
	symbols := make(map[string]uint32, len(a.syms))
	for name, sym := range a.syms {
		if !a.opts.InternalSyms && strings.HasPrefix(name, "__") {
			continue
		}
		seg, off := symLoc(sym, 0)
		symbols[name] = seg.LinkAddrOf(off)
	}
	litAddrs := make(map[string]uint32, len(a.litOrder))
	for _, k := range a.litOrder {
		if off, cold := a.litText[k]; cold {
			litAddrs[k] = a.opts.TextBase + off
		} else {
			litAddrs[k] = a.opts.DataBase + a.litOffs[k]
		}
	}
	return &Result{Image: im, Symbols: symbols, LitAddrs: litAddrs}, nil
}
