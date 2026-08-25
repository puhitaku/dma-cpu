// Package dmaasm assembles DMA-machine assembly (".dasm") into DMX
// executables. The language and its lowering are defined by ABI v0
// (references/design_docs/abi.md); the instruction set mirrors the macro table in
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

	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
)

// Options configures one assembly.
type Options struct {
	Variant  *emu.Variant
	TextBase uint32 // default 0x20000000
	DataBase uint32 // default 0x20010000
	// Machine channels (ABI v0 defaults: 0/1/2). The scratch word is the
	// loader's concern, not the image's.
	Fetch, Exec, Fix int
	// Compact emits the Tier-C 8-byte-record encoding (compact.go).
	// Channels follow the fixed emu.Compact* map (the contiguous ch0..8
	// machine); the image carries the bank/cleanup configuration as init
	// writes and loaders do fetch-only setup
	// (emu.FetchExecConfig.Compact). The current-window state lives in
	// fetch's WRITE_ADDR register, so several compact images sharing one
	// machine need no coordination word.
	Compact bool
	// RAMTextBase enables the `.ramtext` directive: text after the
	// directive links at this base as a third image segment. XIP images
	// place TextBase in flash (immutable) and keep every self-modifying
	// record — block-field patch targets — in this RAM-resident region.
	// The sign-dispatch trampoline arena follows the last instruction and
	// so lands in ramtext when the directive is used.
	RAMTextBase uint32
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

// ABI v0 register file, laid out by the .regs directive (references/design_docs/abi.md).
var abiRegs = func() []string {
	regs := make([]string, 0, 32)
	for i := 0; i < 16; i++ {
		regs = append(regs, fmt.Sprintf("r%d", i))
	}
	regs = append(regs, "lr", "sp", "zero", "null", "at", "dispatch", "irqresume", "at2")
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
	kind       opKind
	sym        string // opSym/opLit(symbol)
	field      uint32 // opSym: byte offset for .read/.write/.count/.ctrl or +N
	plusOff    bool   // field came from a +N suffix (allowed on data symbols)
	blockField bool   // field came from .read/.write/.count/.ctrl syntax
	num        uint32 // opLit(value)/opAbs
	isNum      bool   // opLit: literal is a number, not a symbol
}

var blockFields = map[string]uint32{"read": 0, "write": 4, "count": 8, "ctrl": 12}

// --- Statements ---

type stmt struct {
	line   int
	label  string   // set for label definitions
	dir    string   // set for directives (leading '.')
	mnem   string   // set for instructions
	args   []string // raw comma-separated arguments
	crecs  uint32   // compact: records this instruction occupies (pass 1)
	inText bool     // directive was laid out in a text section (.word rodata)
}

type asm struct {
	opts Options
	v    *emu.Variant
	cfg  emu.FetchExecConfig

	stmts []stmt

	// Layout (pass 1).
	textOff  uint32
	dataOff  uint32
	split    bool   // a .ramtext directive was seen
	splitOff uint32 // text offset where the ramtext region begins
	syms     map[string]symbol
	litOrder []string           // pool emission order (first use)
	lits     map[string]operand // pool key -> value operand
	litOffs  map[string]uint32  // pool key -> data offset
	hasRegs  bool
	entry    string
	noSniff  bool
	writes   []writeStmt
	genLabel int

	// Sign-dispatch trampoline arena (jsign/jeq/jlt/jltu): each use gets a
	// pair of jump slots 128 bytes apart; pairs are pooled 8 to a 256-byte
	// bank appended after the last instruction, so slots pack with no gaps.
	jpairs   []jpair
	jpairIdx int // emit-pass counter (mirrors pass-1 order)

	// payloadDelta maps a compact instruction's start offset to its
	// first payload record (block-field addressing target).
	payloadDelta map[uint32]uint32

	dataSeg *img.Seg // emit pass: the data segment (compact literal refs)
}

// litNumPtr resolves a numeric pool literal to its data-segment pointer
// (emit pass only).
func (a *asm) litNumPtr(v uint32) img.Ptr {
	return img.In(a.dataSeg, a.litOffs[litKey(operand{kind: opLit, num: v, isNum: true})])
}

// jpair is one trampoline pair: slot 0 (+0) taken when the tested word's
// sign bit is clear, slot 1 (+128) when it is set.
type jpair struct {
	neg, nonneg string // target labels
	line        int
}

func jpairName(i int) string { return fmt.Sprintf("__JP%d", i) }

type symbol struct {
	text bool // text segment (else data)
	off  uint32
	line int
}

type writeStmt struct {
	line   int
	addr   uint32
	valNum uint32
	valSym string // if set, value is this symbol's address (relocated)
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
	if opts.Compact {
		// %pc and the sniffer DMACH resolve against the compact map.
		// Fix (the classic chain target field) is fetch here: bank
		// records return straight to fetch, whose write ring holds the
		// window.
		opts.Fetch, opts.Exec, opts.Fix = emu.CompactFetch, emu.CompactSniff, emu.CompactFetch
	} else if opts.Fetch == 0 && opts.Exec == 0 && opts.Fix == 0 {
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
	// Conditional assembly: .ifcompact / .else / .endif select between
	// the two encodings at parse time (used by mode-specific runtime
	// code such as memcpy's dynamic-count idiom).
	type cond struct{ active, taken bool }
	var conds []cond
	lineActive := func() bool {
		for _, c := range conds {
			if !c.active {
				return false
			}
		}
		return true
	}
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
		switch text {
		case ".ifcompact":
			conds = append(conds, cond{active: a.opts.Compact, taken: a.opts.Compact})
			continue
		case ".else":
			if len(conds) == 0 {
				return fmt.Errorf("line %d: .else without .ifcompact", line)
			}
			c := &conds[len(conds)-1]
			c.active = !c.taken
			continue
		case ".endif":
			if len(conds) == 0 {
				return fmt.Errorf("line %d: .endif without .ifcompact", line)
			}
			conds = conds[:len(conds)-1]
			continue
		}
		if !lineActive() {
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
	case "uartdr":
		return a.v.UARTDRAddr(), true
	case "uartfr":
		return a.v.UARTFRAddr(), true
	case "cnt8w":
		if a.opts.Compact {
			return emu.ChanRegAddr(emu.CompactSize8W, emu.OffAl2TransCount), true
		}
	case "cnt8rw":
		if a.opts.Compact {
			return emu.ChanRegAddr(emu.CompactSize8RW, emu.OffAl2TransCount), true
		}
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
		name, off, err := splitPlusOff(body)
		if err != nil || !validName(name) {
			return operand{}, fmt.Errorf("line %d: bad literal %q", line, s)
		}
		op := operand{kind: opLit, sym: name, field: off, plusOff: off != 0}
		a.internLit(op)
		return op, nil
	default:
		name, field, plus, bf := s, uint32(0), false, false
		if idx := strings.LastIndex(s, "."); idx > 0 {
			fname := s[idx+1:]
			if a.opts.Compact && (fname == "count" || fname == "ctrl") {
				return operand{}, fmt.Errorf("line %d: %q: compact records have no %s field (use %%cnt8w/%%cnt8rw with the dyncount flag)", line, s, fname)
			}
			f, ok := blockFields[fname]
			if !ok {
				return operand{}, fmt.Errorf("line %d: unknown block field in %q (want .read/.write/.count/.ctrl)", line, s)
			}
			name, field, bf = s[:idx], f, true
		} else if n, off, err := splitPlusOff(s); err == nil && off != 0 {
			name, field, plus = n, off, true
		}
		if !validName(name) {
			return operand{}, fmt.Errorf("line %d: bad operand %q", line, s)
		}
		return operand{kind: opSym, sym: name, field: field, plusOff: plus, blockField: bf}, nil
	}
}

// splitPlusOff splits "name+off" (off decimal or 0x-hex) into its parts;
// a bare name returns off 0.
func splitPlusOff(s string) (string, uint32, error) {
	idx := strings.IndexByte(s, '+')
	if idx < 0 {
		return s, 0, nil
	}
	off, err := parseNum(s[idx+1:])
	if err != nil {
		return "", 0, err
	}
	return s[:idx], off, nil
}

func litKey(op operand) string {
	if op.isNum {
		return fmt.Sprintf("#%08x", op.num)
	}
	if op.field != 0 {
		return fmt.Sprintf("&%s+%d", op.sym, op.field)
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
	"and":   {3, 3, fixed(6)}, // d = a & b (clobbers at)
	"andn":  {3, 3, fixed(3)}, // d = a & ~b
	"shl":   {2, 2, fixed(3)},
	"mulc":  {3, 3, fixed(3)},
	"jump":  {1, 1, fixed(1)},
	"jumpr": {1, 1, fixed(1)},
	"jneg":  {3, 3, fixed(6)},
	// Full-range comparisons (any 32-bit operands; jneg's |v| < 2^28
	// restriction does not apply). Each consumes one trampoline pair in
	// the sign-dispatch arena (2 pooled blocks, not counted here).
	"jsign": {3, 3, fixed(4)},  // jsign v, neg, nonneg
	"jeq":   {4, 4, fixed(12)}, // jeq a, b, eq, ne (clobbers at)
	"jlt":   {4, 4, fixed(16)}, // signed a<b: jlt a, b, lt, ge (at, at2)
	"jltu":  {4, 4, fixed(16)}, // unsigned a<b: jltu a, b, lo, hs (at, at2)
	"jbool": {3, 3, fixed(6)},  // jbool v, ifzero, ifone (v must be 0 or 1)
	"call":  {1, 1, fixed(2)},
	"ret":   {0, 0, fixed(1)},
	"gpio":  {2, 2, fixed(1)},
	"halt":  {0, 0, fixed(1)},
	"nop":   {0, 0, fixed(1)},
	// safepoint: the ABI interrupt delivery point (references/design_docs/abi.md) — store
	// the resume address, then jump indirectly through `dispatch`.
	"safepoint": {0, 0, fixed(2)},
}

func fixed(n uint32) func([]string) (uint32, error) {
	return func([]string) (uint32, error) { return n, nil }
}

// moveFlags parses trailing flag arguments of a move.
type moveFlags struct {
	ctrlExtra uint32
	size      uint32 // CtrlSize*
	count     uint32
	dyn       bool // compact: TRANS_COUNT is patched at runtime
}

func (a *asm) parseMoveFlags(args []string, line int) (moveFlags, error) {
	f := moveFlags{size: emu.CtrlSize32, count: 1}
	for _, s := range args {
		switch {
		case s == "sniff":
			f.ctrlExtra |= a.v.CtrlSniffEn
		case s == "bswap":
			f.ctrlExtra |= a.v.CtrlBswap
		case s == "incrr":
			f.ctrlExtra |= emu.CtrlIncrRead
		case s == "incrw":
			f.ctrlExtra |= a.v.CtrlIncrWrite
		case s == "size8":
			f.size = emu.CtrlSize8
		case s == "size16":
			f.size = emu.CtrlSize16
		case s == "dyncount":
			if !a.opts.Compact {
				return f, fmt.Errorf("line %d: dyncount is compact-only (classic code patches .count)", line)
			}
			f.dyn = true
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

// terminators are the instructions after which execution cannot fall
// through to the next record — required right before .ramtext, where the
// link address jumps from TextBase+splitOff to RAMTextBase.
var terminators = map[string]bool{
	"jump": true, "jumpr": true, "jneg": true, "jsign": true,
	"jeq": true, "jlt": true, "jltu": true, "jbool": true,
	"ret": true, "halt": true,
}

func (a *asm) layout() error {
	seg := "text" // current segment
	lastMnem := ""
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
				if a.split {
					return fmt.Errorf("line %d: .text after .ramtext", s.line)
				}
				seg = "text"
			case "ramtext":
				if a.opts.RAMTextBase == 0 {
					return fmt.Errorf("line %d: .ramtext requires Options.RAMTextBase", s.line)
				}
				if a.split {
					return fmt.Errorf("line %d: duplicate .ramtext", s.line)
				}
				if lastMnem != "" && !terminators[lastMnem] {
					return fmt.Errorf("line %d: instruction before .ramtext falls through (%q); the link address is discontinuous here", s.line, lastMnem)
				}
				a.split = true
				a.splitOff = a.textOff
				seg = "text"
			case "data":
				seg = "data"
			case "entry":
				if len(s.args) != 1 {
					return fmt.Errorf("line %d: .entry takes one label", s.line)
				}
				a.entry = s.args[0]
			case "word":
				if len(s.args) == 0 {
					return fmt.Errorf("line %d: .word needs values", s.line)
				}
				if seg == "text" {
					// Read-only data in the text segment (XIP images keep
					// constant tables in flash). Callers must pad runs to
					// the record alignment before more instructions follow.
					s.inText = true
					a.textOff += uint32(4 * len(s.args))
				} else {
					a.dataOff += uint32(4 * len(s.args))
				}
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
			shapes, err := a.scanInstr(s, n)
			if err != nil {
				return err
			}
			if a.opts.Compact {
				s.crecs = planCount(shapes)
				a.internPlanLits(shapes)
				if a.payloadDelta == nil {
					a.payloadDelta = map[uint32]uint32{}
				}
				a.payloadDelta[a.textOff] = planPayloadDelta(shapes)
				a.textOff += 8 * s.crecs
			} else {
				a.textOff += 16 * n
			}
			lastMnem = s.mnem
		}
	}
	if a.entry == "" {
		return fmt.Errorf("missing .entry directive")
	}
	// Sign-dispatch arena: appended after the last instruction. A bank is
	// 256 bytes; pair p's slot 0 (sign clear) sits at bank*256 + slot*
	// stride, slot 1 (sign set) 128 bytes later. Compact slots are 8-byte
	// records, doubling a bank's capacity.
	slotSize, pairsPerBank := uint32(16), 8
	if a.opts.Compact {
		slotSize, pairsPerBank = 8, 16
	}
	arenaBase := a.textOff
	for i := range a.jpairs {
		off := arenaBase + uint32(i/pairsPerBank)*256 + uint32(i%pairsPerBank)*slotSize
		a.syms[jpairName(i)] = symbol{text: true, off: off}
	}
	if n := len(a.jpairs); n > 0 {
		a.textOff += uint32((n+pairsPerBank-1)/pairsPerBank) * 256
	}
	if a.opts.Compact {
		if !a.hasRegs {
			return fmt.Errorf("compact mode requires the .regs directive")
		}
		// The plain window literal always exists: the cleanup channel
		// reads it to restore fetch's write pointer.
		a.internLit(operand{kind: opLit, num: emu.CompactWindow(emu.CompactPlain), isNum: true})
	}
	// Literal pool goes after all explicit data.
	for _, k := range a.litOrder {
		a.litOffs[k] = a.dataOff
		a.dataOff += 4
	}
	align := uint32(16)
	if a.opts.Compact {
		align = 8
	}
	if sym, ok := a.syms[a.entry]; !ok || !sym.text {
		return fmt.Errorf(".entry %q is not a text label", a.entry)
	} else if sym.off%align != 0 {
		return fmt.Errorf(".entry %q is not aligned", a.entry)
	}
	return nil
}

// opIsSniff / opIsPc classify an operand for compact shape building.
func (a *asm) opIsSniff(arg string, line int) bool {
	op, err := a.parseOperand(arg, line)
	return err == nil && op.kind == opMMIO && op.num == a.v.SniffDataAddr()
}

func (a *asm) opIsPc(arg string, line int) bool {
	op, err := a.parseOperand(arg, line)
	return err == nil && op.kind == opMMIO &&
		op.num == emu.ChanRegAddr(a.cfg.Fetch, emu.OffReadAddr)
}

// planPrefix sizes a shape prefix in records (no trailing sync) — used
// for generated-label offsets inside compact macros.
func planPrefix(shapes []cshape) uint32 {
	st := newCstate()
	n := 0
	for _, s := range shapes {
		n += len(st.plan(s))
	}
	return uint32(n)
}

// scanInstr interns operand literals and macro-internal generated labels /
// literals during layout, and (compact mode) returns the instruction's
// abstract block shapes. Generated labels for an instruction starting at
// a.textOff are deterministic, so pass 2 regenerates the same names.
func (a *asm) scanInstr(s *stmt, nblocks uint32) ([]cshape, error) {
	var err error
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
	const (
		bP = emu.CompactPlain
		bS = emu.CompactSniff
		bB = emu.CompactBswap
	)
	sh := func(bank int) cshape { return cshape{bank: bank, count: 1} }
	// A plain read of SNIFF_DATA into an arbitrary destination.
	rd := func(dstArg string) cshape {
		return cshape{bank: bP, count: 1, srcSniff: true, dstPc: a.opIsPc(dstArg, s.line)}
	}
	rdPc := cshape{bank: bP, count: 1, srcSniff: true, dstPc: true}
	jmp := cshape{bank: bP, count: 1, dstPc: true}
	var shapes []cshape
	if err = a.scanShapes(s, scan, needRegs, &shapes, sh, rd, rdPc, jmp); err != nil {
		return nil, err
	}
	return shapes, nil
}

// scanShapes is scanInstr's per-mnemonic body.
func (a *asm) scanShapes(s *stmt, scan func(...string) error, needRegs func(string) error,
	shapes *[]cshape, sh func(int) cshape, rd func(string) cshape, rdPc, jmp cshape) error {
	const (
		bP = emu.CompactPlain
		bS = emu.CompactSniff
		bB = emu.CompactBswap
	)
	compact := a.opts.Compact
	switch s.mnem {
	case "move":
		f, err := a.parseMoveFlags(s.args[2:], s.line)
		if err != nil {
			return err
		}
		if compact {
			ctrl := a.cfg.ExecCtrl(a.v)&^emu.CtrlSize32 | f.size | f.ctrlExtra
			bank, err := a.classifyCtrl(ctrl)
			if err != nil {
				return fmt.Errorf("line %d: %v", s.line, err)
			}
			*shapes = append(*shapes, cshape{
				bank: bank, count: f.count, dyn: f.dyn,
				srcSniff: a.opIsSniff(s.args[0], s.line),
				dstPc:    a.opIsPc(s.args[1], s.line),
			})
		}
		return scan(s.args[0], s.args[1])
	case "add":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		*shapes = append(*shapes, sh(bP), sh(bS), rd(s.args[2]))
		return scan(s.args...)
	case "or", "xor", "andn":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		*shapes = append(*shapes, sh(bP), sh(bP), rd(s.args[2]))
		return scan(s.args...)
	case "and":
		if err := needRegs("and"); err != nil {
			return err
		}
		a.internLit(operand{kind: opLit, num: 0xFFFFFFFF, isNum: true})
		*shapes = append(*shapes, sh(bP), sh(bP), rd("at"), sh(bP), sh(bP), rd(s.args[2]))
		return scan(s.args...)
	case "shl":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		*shapes = append(*shapes, sh(bP), sh(bS), rd(s.args[1]))
		return scan(s.args...)
	case "sub":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		a.internLit(operand{kind: opLit, num: 0xFFFFFFFF, isNum: true})
		a.internLit(operand{kind: opLit, num: 1, isNum: true})
		*shapes = append(*shapes, sh(bP), sh(bP), sh(bS), sh(bS), rd(s.args[2]))
		return scan(s.args...)
	case "mulc":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		k, err := parseNum(s.args[1])
		if err != nil {
			return fmt.Errorf("line %d: mulc constant %q must be a number", s.line, s.args[1])
		}
		if compact {
			// Binary-method multiply: count-1 sniff records only — the
			// old count-k form needed an in-bank count restore, which
			// wedges RP2040 (emit.go).
			*shapes = append(*shapes, sh(bP))
			for started, bit := false, 31; bit >= 0; bit-- {
				if started {
					*shapes = append(*shapes, sh(bS))
				}
				if k&(1<<uint(bit)) != 0 {
					*shapes = append(*shapes, sh(bS))
					started = true
				}
			}
			*shapes = append(*shapes, rd(s.args[2]))
		}
		return scan(s.args[0], s.args[2])
	case "jump":
		a.internLit(operand{kind: opLit, sym: s.args[0]})
		*shapes = append(*shapes, jmp)
		return nil
	case "jumpr":
		if compact && a.opIsSniff(s.args[0], s.line) {
			if err := needRegs("jumpr %sniff"); err != nil {
				return err
			}
			*shapes = append(*shapes, rdPc)
		} else {
			*shapes = append(*shapes, cshape{bank: bP, count: 1, dstPc: true,
				srcSniff: a.opIsSniff(s.args[0], s.line)})
		}
		return scan(s.args[0])
	case "jneg":
		if err := needRegs("jneg"); err != nil {
			return err
		}
		// Compact records are 8 bytes, so the trampoline stride is bit 3
		// (mask keeps 0x08) instead of bit 4 — and the sign-copy window
		// tightens to |v| < 2^27.
		if compact {
			a.internLit(operand{kind: opLit, num: 0xFFFFFFF7, isNum: true})
			body := []cshape{
				{bank: bB, count: 1, srcSniff: a.opIsSniff(s.args[0], s.line)},
				sh(bP), sh(bS), rdPc,
			}
			a.genTextLabel(a.textOff + planPrefix(body)*8)
			*shapes = append(*shapes, body...)
			*shapes = append(*shapes, jmp, jmp)
		} else {
			a.internLit(operand{kind: opLit, num: 0xFFFFFFEF, isNum: true})
			// Trampoline slots are blocks 4 and 5 of the sequence.
			a.genTextLabel(a.textOff + 4*16)
		}
		a.internLit(operand{kind: opLit, sym: s.args[1]})
		a.internLit(operand{kind: opLit, sym: s.args[2]})
		return scan(s.args[0])
	case "jsign", "jeq", "jlt", "jltu":
		if err := needRegs(s.mnem); err != nil {
			return err
		}
		a.internLit(operand{kind: opLit, num: 0xFFFFFF7F, isNum: true})
		var p jpair
		var vals []string
		switch s.mnem {
		case "jsign": // jsign v, neg, nonneg
			p, vals = jpair{neg: s.args[1], nonneg: s.args[2]}, s.args[:1]
			*shapes = append(*shapes,
				cshape{bank: bB, count: 1, srcSniff: a.opIsSniff(s.args[0], s.line)},
				sh(bP), sh(bS), rdPc)
		case "jeq": // jeq a, b, eq, ne — sign set means a-b != 0
			p, vals = jpair{neg: s.args[3], nonneg: s.args[2]}, s.args[:2]
			a.internLit(operand{kind: opLit, num: 0xFFFFFFFF, isNum: true})
			a.internLit(operand{kind: opLit, num: 1, isNum: true})
			// Compact variant (emit.go): sniff-exit only via reads.
			*shapes = append(*shapes,
				sh(bP), sh(bP), sh(bS), sh(bS), rd("at"),
				sh(bP), sh(bP), sh(bS), rd("at"),
				sh(bP), sh(bP),
				cshape{bank: bB, count: 1, srcSniff: true},
				sh(bP), sh(bP), sh(bS), rdPc)
		case "jlt", "jltu": // j lt/ltu a, b, taken, not
			p, vals = jpair{neg: s.args[2], nonneg: s.args[3]}, s.args[:2]
			a.internLit(operand{kind: opLit, num: 0xFFFFFFFF, isNum: true})
			a.internLit(operand{kind: opLit, num: 1, isNum: true})
			*shapes = append(*shapes,
				sh(bP), sh(bP), rd("at"),
				sh(bP), sh(bP), sh(bS), sh(bS), rd("at"),
				sh(bP), sh(bP), rd("at"),
				sh(bP), sh(bP), sh(bP),
				cshape{bank: bB, count: 1, srcSniff: true},
				sh(bP), sh(bP), sh(bS), rdPc)
		}
		p.line = s.line
		a.internLit(operand{kind: opLit, sym: p.neg})
		a.internLit(operand{kind: opLit, sym: p.nonneg})
		a.internLit(operand{kind: opLit, sym: jpairName(len(a.jpairs))})
		a.jpairs = append(a.jpairs, p)
		return scan(vals...)
	case "jbool":
		if err := needRegs("jbool"); err != nil {
			return err
		}
		if compact {
			// 8-byte slots: the dispatch adds 8*v for v in {0,1} via
			// count-1 records — v, three doublings, the pair base (see
			// mulc on the RP2040 self-TRANS_COUNT wedge).
			body := []cshape{sh(bP),
				sh(bS), sh(bS), sh(bS), sh(bS),
				sh(bS), rdPc}
			a.genTextLabel(a.textOff + planPrefix(body)*8)
			*shapes = append(*shapes, body...)
			*shapes = append(*shapes, jmp, jmp)
		} else {
			// Trampoline slots are blocks 4 and 5 of the sequence (16
			// bytes apart: the dispatch adds 16*v for v in {0,1}).
			a.genTextLabel(a.textOff + 4*16)
		}
		a.internLit(operand{kind: opLit, sym: s.args[1]})
		a.internLit(operand{kind: opLit, sym: s.args[2]})
		return scan(s.args[0])
	case "call":
		if err := needRegs("call"); err != nil {
			return err
		}
		// Return address: the block after the 2-block/record sequence.
		if compact {
			a.genTextLabel(a.textOff + 2*8)
		} else {
			a.genTextLabel(a.textOff + 2*16)
		}
		*shapes = append(*shapes, sh(bP), jmp)
		a.internLit(operand{kind: opLit, sym: s.args[0]})
		return nil
	case "ret":
		*shapes = append(*shapes, jmp)
		return needRegs("ret")
	case "safepoint":
		if err := needRegs("safepoint"); err != nil {
			return err
		}
		// Resume address: the block after the 2-block/record sequence.
		if compact {
			a.genTextLabel(a.textOff + 2*8)
		} else {
			a.genTextLabel(a.textOff + 2*16)
		}
		*shapes = append(*shapes, sh(bP), jmp)
		return nil
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
		*shapes = append(*shapes, sh(bP))
		return nil
	case "nop":
		*shapes = append(*shapes, cshape{bank: bP, count: 0})
		return needRegs("nop")
	case "halt":
		*shapes = append(*shapes, cshape{halt: true})
		return nil
	}
	return fmt.Errorf("line %d: unhandled instruction %q", s.line, s.mnem)
}
