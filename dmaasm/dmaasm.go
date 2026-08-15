// Package dmaasm assembles DMA-machine assembly (".dasm") into DMX
// executables. The language and its lowering are defined by ABI v0
// (doc/abi.md); the instruction set mirrors the macro table in
// prompts/overview.md §2.
//
// Source is SKU-portable: MMIO names (%sniff, %pc, …), control words, and
// GPIO encodings resolve against the target Variant at assembly time, so
// the same .dasm produces a different (non-portable) binary per SKU.
//
// A program has two segments: .text (control blocks, 16 bytes per block)
// and .data (words). Every constant operand ($imm, $label) is interned
// into a literal pool appended to .data — this machine has no immediates,
// only addresses. Cross-segment references carry DMX relocations, so the
// output is placeable anywhere (Tier 2).
package dmaasm

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

// Options configures one assembly.
type Options struct {
	Variant  *emu.Variant
	TextBase uint32 // default 0x20000000
	DataBase uint32 // default 0x20010000
	// Machine channels (ABI v0 defaults: 0/1/2). The scratch word is the
	// loader's concern, not the image's.
	Fetch, Exec, Fix int
}

// Result is the assembled program.
type Result struct {
	Image *img.Image
	// Symbols maps every label to its link-time address (data and text).
	Symbols map[string]uint32
}

func (r *Result) Symbol(name string) (uint32, error) {
	a, ok := r.Symbols[name]
	if !ok {
		return 0, fmt.Errorf("no such symbol %q", name)
	}
	return a, nil
}

// ABI v0 register file, laid out by the .regs directive (doc/abi.md).
var abiRegs = func() []string {
	regs := make([]string, 0, 32)
	for i := 0; i < 16; i++ {
		regs = append(regs, fmt.Sprintf("r%d", i))
	}
	regs = append(regs, "lr", "sp", "zero", "null", "at", "dispatch", "irqresume")
	for len(regs) < 32 {
		regs = append(regs, fmt.Sprintf("__abi_rsvd%d", len(regs)))
	}
	return regs
}()

// --- Operands ---

type opKind int

const (
	opSym  opKind = iota // label reference, optional .field offset
	opLit                // $number or $label: address of an interned pool word
	opMMIO               // %name: SKU-resolved hardware address
	opAbs                // @0x...: absolute address
)

type operand struct {
	kind  opKind
	sym   string // opSym/opLit(symbol)
	field uint32 // opSym: byte offset for .read/.write/.count/.ctrl
	num   uint32 // opLit(value)/opAbs
	isNum bool   // opLit: literal is a number, not a symbol
}

var blockFields = map[string]uint32{"read": 0, "write": 4, "count": 8, "ctrl": 12}

// --- Statements ---

type stmt struct {
	line  int
	label string   // set for label definitions
	dir   string   // set for directives (leading '.')
	mnem  string   // set for instructions
	args  []string // raw comma-separated arguments
}

type asm struct {
	opts Options
	v    *emu.Variant
	cfg  emu.FetchExecConfig

	stmts []stmt

	// Layout (pass 1).
	textOff  uint32
	dataOff  uint32
	syms     map[string]symbol
	litOrder []string           // pool emission order (first use)
	lits     map[string]operand // pool key -> value operand
	litOffs  map[string]uint32  // pool key -> data offset
	hasRegs  bool
	entry    string
	noSniff  bool
	writes   []writeStmt
	genLabel int
}

type symbol struct {
	text bool // text segment (else data)
	off  uint32
	line int
}

type writeStmt struct {
	line     int
	addr     uint32
	valNum   uint32
	valSym   string // if set, value is this symbol's address (relocated)
}

// Assemble compiles one source file.
func Assemble(src string, opts Options) (*Result, error) {
	if opts.Variant == nil {
		return nil, fmt.Errorf("dmaasm: Options.Variant is required")
	}
	if opts.TextBase == 0 {
		opts.TextBase = 0x20000000
	}
	if opts.DataBase == 0 {
		opts.DataBase = 0x20010000
	}
	if opts.Fetch == 0 && opts.Exec == 0 && opts.Fix == 0 {
		opts.Fetch, opts.Exec, opts.Fix = 0, 1, 2
	}
	a := &asm{
		opts:    opts,
		v:       opts.Variant,
		cfg:     emu.FetchExecConfig{Fetch: opts.Fetch, Exec: opts.Exec, Fix: opts.Fix},
		syms:    map[string]symbol{},
		lits:    map[string]operand{},
		litOffs: map[string]uint32{},
	}
	if err := a.parse(src); err != nil {
		return nil, err
	}
	if err := a.layout(); err != nil {
		return nil, err
	}
	return a.emit()
}

// --- Parsing ---

func (a *asm) parse(src string) error {
	for i, raw := range strings.Split(src, "\n") {
		line := i + 1
		text := raw
		if idx := strings.IndexAny(text, ";"); idx >= 0 {
			text = text[:idx]
		}
		if idx := strings.Index(text, "//"); idx >= 0 {
			text = text[:idx]
		}
		text = strings.TrimSpace(text)
		if text == "" {
			continue
		}
		// Labels: one or more "name:" prefixes.
		for {
			fields := strings.Fields(text)
			if len(fields) == 0 {
				break
			}
			if name, ok := strings.CutSuffix(fields[0], ":"); ok && name != "" && !strings.ContainsAny(name, " \t") {
				a.stmts = append(a.stmts, stmt{line: line, label: name})
				text = strings.TrimSpace(text[len(fields[0]):])
				continue
			}
			break
		}
		if text == "" {
			continue
		}
		fields := strings.SplitN(text, " ", 2)
		head := fields[0]
		var args []string
		if len(fields) == 2 {
			for _, p := range strings.Split(fields[1], ",") {
				args = append(args, strings.TrimSpace(p))
			}
		}
		if strings.HasPrefix(head, ".") {
			a.stmts = append(a.stmts, stmt{line: line, dir: head[1:], args: args})
		} else {
			a.stmts = append(a.stmts, stmt{line: line, mnem: head, args: args})
		}
	}
	return nil
}

func parseNum(s string) (uint32, error) {
	neg := strings.HasPrefix(s, "-")
	v, err := strconv.ParseUint(strings.TrimPrefix(s, "-"), 0, 32)
	if err != nil {
		return 0, err
	}
	if neg {
		return -uint32(v), nil
	}
	return uint32(v), nil
}

func validName(s string) bool {
	if s == "" {
		return false
	}
	for i, r := range s {
		switch {
		case r == '_', r >= 'a' && r <= 'z', r >= 'A' && r <= 'Z':
		case r >= '0' && r <= '9':
			if i == 0 {
				return false
			}
		default:
			return false
		}
	}
	return true
}

// mmioAddr resolves a %name to a hardware address for the target SKU.
func (a *asm) mmioAddr(name string) (uint32, bool) {
	switch name {
	case "sniff":
		return a.v.SniffDataAddr(), true
	case "sniffctrl":
		return a.v.SniffCtrlAddr(), true
	case "sniffset":
		return a.v.SniffDataSetAddr(), true
	case "sniffclr":
		return a.v.SniffDataClrAddr(), true
	case "sniffxor":
		return a.v.SniffDataXORAddr(), true
	case "pc":
		return emu.ChanRegAddr(a.cfg.Fetch, emu.OffReadAddr), true
	case "intr":
		return a.v.IntrAddr(), true
	}
	return 0, false
}

func (a *asm) parseOperand(s string, line int) (operand, error) {
	switch {
	case strings.HasPrefix(s, "%"):
		addr, ok := a.mmioAddr(s[1:])
		if !ok {
			return operand{}, fmt.Errorf("line %d: unknown MMIO register %q", line, s)
		}
		return operand{kind: opMMIO, num: addr}, nil
	case strings.HasPrefix(s, "@"):
		v, err := parseNum(s[1:])
		if err != nil {
			return operand{}, fmt.Errorf("line %d: bad absolute address %q", line, s)
		}
		return operand{kind: opAbs, num: v}, nil
	case strings.HasPrefix(s, "$"):
		body := s[1:]
		if v, err := parseNum(body); err == nil {
			a.internLit(operand{kind: opLit, num: v, isNum: true})
			return operand{kind: opLit, num: v, isNum: true}, nil
		}
		if !validName(body) {
			return operand{}, fmt.Errorf("line %d: bad literal %q", line, s)
		}
		op := operand{kind: opLit, sym: body}
		a.internLit(op)
		return op, nil
	default:
		name, field := s, uint32(0)
		if idx := strings.LastIndex(s, "."); idx > 0 {
			f, ok := blockFields[s[idx+1:]]
			if !ok {
				return operand{}, fmt.Errorf("line %d: unknown block field in %q (want .read/.write/.count/.ctrl)", line, s)
			}
			name, field = s[:idx], f
		}
		if !validName(name) {
			return operand{}, fmt.Errorf("line %d: bad operand %q", line, s)
		}
		return operand{kind: opSym, sym: name, field: field}, nil
	}
}

func litKey(op operand) string {
	if op.isNum {
		return fmt.Sprintf("#%08x", op.num)
	}
	return "&" + op.sym
}

func (a *asm) internLit(op operand) {
	k := litKey(op)
	if _, ok := a.lits[k]; !ok {
		a.lits[k] = op
		a.litOrder = append(a.litOrder, k)
	}
}

// genTextLabel creates an assembler-internal text label at the given
// offset and returns a literal operand referencing it.
func (a *asm) genTextLabel(off uint32) operand {
	a.genLabel++
	name := fmt.Sprintf("__L%d", a.genLabel)
	a.syms[name] = symbol{text: true, off: off}
	op := operand{kind: opLit, sym: name}
	a.internLit(op)
	return op
}

// --- Instruction set ---

// instrDef describes lowering: block count may depend on flags (mulc).
type instrSpec struct {
	minArgs, maxArgs int
	blocks           func(args []string) (uint32, error) // block count
}

var instrs = map[string]instrSpec{
	"move":  {2, 6, nil}, // move src, dst [, flags...]
	"add":   {3, 3, fixed(3)},
	"sub":   {3, 3, fixed(5)},
	"or":    {3, 3, fixed(3)},
	"xor":   {3, 3, fixed(3)},
	"shl":   {2, 2, fixed(3)},
	"mulc":  {3, 3, fixed(3)},
	"jump":  {1, 1, fixed(1)},
	"jumpr": {1, 1, fixed(1)},
	"jneg":  {3, 3, fixed(6)},
	"call":  {1, 1, fixed(2)},
	"ret":   {0, 0, fixed(1)},
	"gpio":  {2, 2, fixed(1)},
	"halt":  {0, 0, fixed(1)},
	"nop":   {0, 0, fixed(1)},
}

func fixed(n uint32) func([]string) (uint32, error) {
	return func([]string) (uint32, error) { return n, nil }
}

// moveFlags parses trailing flag arguments of a move.
type moveFlags struct {
	ctrlExtra uint32
	size      uint32 // CtrlSize*
	count     uint32
}

func (a *asm) parseMoveFlags(args []string, line int) (moveFlags, error) {
	f := moveFlags{size: emu.CtrlSize32, count: 1}
	for _, s := range args {
		switch {
		case s == "sniff":
			f.ctrlExtra |= a.v.CtrlSniffEn
		case s == "bswap":
			f.ctrlExtra |= a.v.CtrlBswap
		case s == "size8":
			f.size = emu.CtrlSize8
		case s == "size16":
			f.size = emu.CtrlSize16
		case strings.HasPrefix(s, "count="):
			v, err := parseNum(strings.TrimPrefix(s, "count="))
			if err != nil || v == 0 {
				return f, fmt.Errorf("line %d: bad count in %q", line, s)
			}
			f.count = v
		default:
			return f, fmt.Errorf("line %d: unknown move flag %q", line, s)
		}
	}
	return f, nil
}

// --- Pass 1: layout ---

func (a *asm) layout() error {
	seg := "text" // current segment
	defineLabel := func(name string, line int) error {
		if _, dup := a.syms[name]; dup {
			return fmt.Errorf("line %d: duplicate label %q", line, name)
		}
		if seg == "text" {
			a.syms[name] = symbol{text: true, off: a.textOff, line: line}
		} else {
			a.syms[name] = symbol{off: a.dataOff, line: line}
		}
		return nil
	}
	for si := range a.stmts {
		s := &a.stmts[si]
		switch {
		case s.label != "":
			if err := defineLabel(s.label, s.line); err != nil {
				return err
			}
		case s.dir != "":
			switch s.dir {
			case "text":
				seg = "text"
			case "data":
				seg = "data"
			case "entry":
				if len(s.args) != 1 {
					return fmt.Errorf("line %d: .entry takes one label", s.line)
				}
				a.entry = s.args[0]
			case "word":
				if seg != "data" {
					return fmt.Errorf("line %d: .word outside .data", s.line)
				}
				if len(s.args) == 0 {
					return fmt.Errorf("line %d: .word needs values", s.line)
				}
				a.dataOff += uint32(4 * len(s.args))
			case "space":
				if seg != "data" || len(s.args) != 1 {
					return fmt.Errorf("line %d: .space <bytes> in .data only", s.line)
				}
				n, err := parseNum(s.args[0])
				if err != nil || n%4 != 0 {
					return fmt.Errorf("line %d: .space needs a multiple of 4", s.line)
				}
				a.dataOff += n
			case "regs":
				if seg != "data" {
					return fmt.Errorf("line %d: .regs outside .data", s.line)
				}
				if a.hasRegs {
					return fmt.Errorf("line %d: duplicate .regs", s.line)
				}
				a.hasRegs = true
				for _, r := range abiRegs {
					a.syms[r] = symbol{off: a.dataOff, line: s.line}
					a.dataOff += 4
				}
			case "write":
				if len(s.args) != 2 {
					return fmt.Errorf("line %d: .write <addr>, <value>", s.line)
				}
				w := writeStmt{line: s.line}
				addrOp, err := a.parseOperand(s.args[0], s.line)
				if err != nil {
					return err
				}
				if addrOp.kind != opMMIO && addrOp.kind != opAbs {
					return fmt.Errorf("line %d: .write address must be %%mmio or @absolute", s.line)
				}
				w.addr = addrOp.num
				if v, err := parseNum(s.args[1]); err == nil {
					w.valNum = v
				} else if validName(s.args[1]) {
					w.valSym = s.args[1]
				} else {
					return fmt.Errorf("line %d: bad .write value %q", s.line, s.args[1])
				}
				a.writes = append(a.writes, w)
			case "nosniffinit":
				a.noSniff = true
			default:
				return fmt.Errorf("line %d: unknown directive .%s", s.line, s.dir)
			}
		case s.mnem != "":
			if seg != "text" {
				return fmt.Errorf("line %d: instruction outside .text", s.line)
			}
			spec, ok := instrs[s.mnem]
			if !ok {
				return fmt.Errorf("line %d: unknown instruction %q", s.line, s.mnem)
			}
			if len(s.args) < spec.minArgs || len(s.args) > spec.maxArgs {
				return fmt.Errorf("line %d: %s takes %d..%d args, got %d",
					s.line, s.mnem, spec.minArgs, spec.maxArgs, len(s.args))
			}
			n := uint32(1)
			if spec.blocks != nil {
				var err error
				if n, err = spec.blocks(s.args); err != nil {
					return fmt.Errorf("line %d: %v", s.line, err)
				}
			}
			// Operand scan interns literals; macros with internal labels
			// and generated literals handle them here so the pool is
			// complete before data layout finishes.
			if err := a.scanInstr(s, n); err != nil {
				return err
			}
			a.textOff += 16 * n
		}
	}
	if a.entry == "" {
		return fmt.Errorf("missing .entry directive")
	}
	// Literal pool goes after all explicit data.
	for _, k := range a.litOrder {
		a.litOffs[k] = a.dataOff
		a.dataOff += 4
	}
	if sym, ok := a.syms[a.entry]; !ok || !sym.text {
		return fmt.Errorf(".entry %q is not a text label", a.entry)
	} else if sym.off%16 != 0 {
		return fmt.Errorf(".entry %q is not block-aligned", a.entry)
	}
	return nil
}

// scanInstr interns operand literals and macro-internal generated labels /
// literals during layout. Generated labels for an instruction starting at
// a.textOff are deterministic, so pass 2 regenerates the same names.
func (a *asm) scanInstr(s *stmt, nblocks uint32) error {
	scan := func(args ...string) error {
		for _, arg := range args {
			if _, err := a.parseOperand(arg, s.line); err != nil {
				return err
			}
		}
		return nil
	}
	needRegs := func(what string) error {
		if !a.hasRegs {
			return fmt.Errorf("line %d: %s requires the .regs directive (uses the null/zero registers)", s.line, what)
		}
		return nil
	}
	switch s.mnem {
	case "move":
		if _, err := a.parseMoveFlags(s.args[2:], s.line); err != nil {
			return err
		}
		return scan(s.args[0], s.args[1])
	case "add", "or", "xor":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		return scan(s.args...)
	case "shl":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		return scan(s.args...)
	case "sub":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		a.internLit(operand{kind: opLit, num: 0xFFFFFFFF, isNum: true})
		a.internLit(operand{kind: opLit, num: 1, isNum: true})
		return scan(s.args...)
	case "mulc":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		if _, err := parseNum(s.args[1]); err != nil {
			return fmt.Errorf("line %d: mulc constant %q must be a number", s.line, s.args[1])
		}
		return scan(s.args[0], s.args[2])
	case "jump":
		a.internLit(operand{kind: opLit, sym: s.args[0]})
		return nil
	case "jumpr":
		return scan(s.args[0])
	case "jneg":
		if err := needRegs("jneg"); err != nil {
			return err
		}
		a.internLit(operand{kind: opLit, num: 0xFFFFFFEF, isNum: true})
		// Trampoline slots are blocks 4 and 5 of the sequence.
		a.genTextLabel(a.textOff + 4*16)
		a.internLit(operand{kind: opLit, sym: s.args[1]})
		a.internLit(operand{kind: opLit, sym: s.args[2]})
		return scan(s.args[0])
	case "call":
		if err := needRegs("call"); err != nil {
			return err
		}
		// Return address: the block after the 2-block sequence.
		a.genTextLabel(a.textOff + 2*16)
		a.internLit(operand{kind: opLit, sym: s.args[0]})
		return nil
	case "ret":
		return needRegs("ret")
	case "gpio":
		pin, err := parseNum(s.args[0])
		if err != nil || pin >= uint32(a.v.GPIOPins) {
			return fmt.Errorf("line %d: bad gpio pin %q", s.line, s.args[0])
		}
		switch s.args[1] {
		case "hi":
			a.internLit(operand{kind: opLit, num: a.v.GPIOOutCtrl(true), isNum: true})
		case "lo":
			a.internLit(operand{kind: opLit, num: a.v.GPIOOutCtrl(false), isNum: true})
		default:
			return fmt.Errorf("line %d: gpio wants hi or lo, got %q", s.line, s.args[1])
		}
		return nil
	case "nop":
		return needRegs("nop")
	case "halt":
		return nil
	}
	return fmt.Errorf("line %d: unhandled instruction %q", s.line, s.mnem)
}
