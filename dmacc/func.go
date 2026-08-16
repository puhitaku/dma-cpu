package dmacc

import (
	"fmt"
	"strings"

	"github.com/puhitaku/dma-cpu/llir"
)

type addrC struct {
	sym string
	off uint32
}

type funcCtx struct {
	g *gen
	f *llir.Func

	declared  map[string]bool  // value words already declared
	allocas   map[string]string // alloca result -> data symbol
	constAddr map[string]addrC  // GEP result folded to a static address
	uses      map[string]int
	defs      map[string]*llir.Instr
	defBlock  map[string]int
	fused     map[string]bool   // icmp results emitted at their branch
	fwd       map[string]string // pure-copy results forwarded to their source operand
	blockIdx  map[string]int
	directPhi map[string]bool // blocks whose phis are written directly on edges
	hasCalls  bool
	curBlock  int
	cat       string // size-report attribution for emitted code
}

func (g *gen) emitFunc(f *llir.Func) error {
	fc := &funcCtx{
		g: g, f: f,
		declared:  map[string]bool{},
		allocas:   map[string]string{},
		constAddr: map[string]addrC{},
		uses:      map[string]int{},
		defs:      map[string]*llir.Instr{},
		defBlock:  map[string]int{},
		fused:     map[string]bool{},
		fwd:       map[string]string{},
		blockIdx:  map[string]int{},
		directPhi: map[string]bool{},
	}
	if err := fc.prepass(); err != nil {
		return err
	}
	return fc.emit()
}

func (fc *funcCtx) word(local string) string {
	return "v_" + sanitize(fc.f.Name) + "_" + sanitize(local)
}
func (fc *funcCtx) shadow(local string) string {
	return "s_" + sanitize(fc.f.Name) + "_" + sanitize(local)
}
func (fc *funcCtx) blockLabel(name string) string {
	return "B_" + sanitize(fc.f.Name) + "_" + sanitize(name)
}
func (fc *funcCtx) lrsWord() string { return "lrs_" + sanitize(fc.f.Name) }

func (fc *funcCtx) declWord(sym string) {
	if !fc.declared[sym] {
		fc.declared[sym] = true
		fmt.Fprintf(&fc.g.data, "%s: .word 0\n", sym)
	}
}

func (fc *funcCtx) ins(format string, args ...any) {
	if s := fc.g.opts.Stats; s != nil {
		mnem := format
		if i := strings.IndexByte(mnem, ' '); i >= 0 {
			mnem = mnem[:i]
		}
		s.record(fc.f.Name, fc.cat, mnem)
	}
	fmt.Fprintf(&fc.g.text, "    "+format+"\n", args...)
}
func (fc *funcCtx) label(l string) {
	fmt.Fprintf(&fc.g.text, "%s:\n", l)
}
func (fc *funcCtx) stub(prefix string) string {
	fc.g.stubN++
	return fmt.Sprintf("%s%d_%s", prefix, fc.g.stubN, sanitize(fc.f.Name))
}

// width returns the value width in bits, rejecting what the machine
// cannot hold in one word.
func width(t *llir.Type) (int, error) {
	switch t.Kind {
	case llir.TInt:
		if t.Bits > 32 {
			return 0, fmt.Errorf("i%d is not supported (one machine word is 32 bits)", t.Bits)
		}
		return t.Bits, nil
	case llir.TPtr:
		return 32, nil
	case llir.TArray, llir.TStruct:
		// Small aggregates (ABI-coerced values like va_list) live in one
		// word, addressed at their byte size.
		switch s := t.Size(); {
		case s <= 1:
			return 8, nil
		case s <= 2:
			return 16, nil
		case s <= 4:
			return 32, nil
		}
	}
	return 0, fmt.Errorf("value of type %s is not supported", t)
}

// --- Prepass: counts, allocas, word declarations, fusion ---

func (fc *funcCtx) prepass() error {
	f := fc.f
	for i, b := range f.Blocks {
		fc.blockIdx[b.Name] = i
	}
	countVal := func(v *llir.Value) {
		if v != nil && v.Kind == llir.VLocal {
			fc.uses[v.Name]++
		}
	}
	for i, b := range f.Blocks {
		for _, ins := range b.Instrs {
			for _, a := range ins.Args {
				countVal(a)
			}
			for _, e := range ins.Phi {
				countVal(e.Val)
			}
			if ins.Res != "" {
				fc.defs[ins.Res] = ins
				fc.defBlock[ins.Res] = i
			}
			// Conservative: ops that may lower to runtime calls count as
			// calls, so the prologue always saves lr before one happens.
			switch ins.Op {
			case "call":
				if !isNopIntrinsic(ins.Callee) {
					fc.hasCalls = true
				}
			case "mul", "shl", "lshr", "ashr", "udiv", "sdiv", "urem", "srem":
				fc.hasCalls = true
			}
		}
	}
	// Fuse icmp into a same-block conditional branch when it is the sole use.
	for i, b := range f.Blocks {
		term := b.Instrs[len(b.Instrs)-1]
		if term.Op == "br" && len(term.Args) == 1 && term.Args[0].Kind == llir.VLocal {
			n := term.Args[0].Name
			if d := fc.defs[n]; d != nil && d.Op == "icmp" && fc.uses[n] == 1 && fc.defBlock[n] == i {
				fc.fused[n] = true
			}
		}
	}
	fc.computeDirectPhis()
	// Frame: params, results, phi shadows, allocas, lr slot.
	for _, p := range f.Params {
		fc.declWord(fc.word(p.Name))
	}
	for _, b := range f.Blocks {
		for _, ins := range b.Instrs {
			if ins.Op == "alloca" {
				size := ins.Typ.Size() * ins.AllocN
				// One word of slack: .data is 4-aligned, and clang may
				// round an 8-aligned alloca's pointer up by 4 (ptrmask).
				size = (size+3)&^3 + 4
				sym := "a_" + sanitize(f.Name) + "_" + sanitize(ins.Res)
				fc.allocas[ins.Res] = sym
				fmt.Fprintf(&fc.g.data, "%s: .space %d\n", sym, size)
				continue
			}
			if ins.Res != "" {
				fc.declWord(fc.word(ins.Res))
			}
			if ins.Op == "phi" && !fc.directPhi[b.Name] {
				fc.declWord(fc.shadow(ins.Res))
			}
		}
	}
	if fc.hasCalls {
		fc.declWord(fc.lrsWord())
	}
	if f.Variadic {
		n := fc.g.maxVar[f.Name]
		if n < 1 {
			n = 1
		}
		fmt.Fprintf(&fc.g.data, "%s: .space %d\n", fc.vaArea(), 4*n)
	}
	return nil
}

func (fc *funcCtx) vaArea() string { return "va_" + sanitize(fc.f.Name) }

// computeDirectPhis decides, per block, whether its phis are written
// directly on incoming edges (no shadow words, no head latch). Edge
// copies run on the taken edge only — multi-successor predecessors
// route through per-edge stubs — so the only remaining parallel-copy
// hazard is a block whose own phi results feed its own phis (swap/
// rotation): those keep the shadow-and-latch scheme.
func (fc *funcCtx) computeDirectPhis() {
	for _, b := range fc.f.Blocks {
		phis := map[string]bool{}
		for _, ins := range b.Instrs {
			if ins.Op == "phi" {
				phis[ins.Res] = true
			}
		}
		if len(phis) == 0 {
			continue
		}
		direct := true
		for _, ins := range b.Instrs {
			if ins.Op != "phi" {
				continue
			}
			for _, e := range ins.Phi {
				if e.Val.Kind == llir.VLocal && phis[e.Val.Name] {
					direct = false
				}
			}
		}
		fc.directPhi[b.Name] = direct
	}
}

// --- Operand resolution ---

func (fc *funcCtx) globalOperand(v *llir.Value) string {
	sym := globalSym(v.Name)
	if _, isFn := fc.g.funcIdx[v.Name]; isFn {
		sym = funcSym(v.Name)
	}
	if v.Off != 0 {
		return fmt.Sprintf("%s+%d", sym, v.Off)
	}
	return sym
}

// op renders a value as a dmaasm operand (reading it yields the value).
func (fc *funcCtx) op(v *llir.Value) (string, error) {
	switch v.Kind {
	case llir.VConst:
		return fmt.Sprintf("$0x%x", uint32(v.Int)), nil
	case llir.VGlobal, llir.VFunc:
		if uartMMIO(v.Name) != "" {
			return "", fmt.Errorf("the address of %s cannot be taken (hardware register)", v.Name)
		}
		return "$" + fc.globalOperand(v), nil
	case llir.VLocal:
		if s, ok := fc.fwd[v.Name]; ok {
			return s, nil
		}
		if a, ok := fc.allocas[v.Name]; ok {
			return "$" + a, nil
		}
		if c, ok := fc.constAddr[v.Name]; ok {
			if c.off != 0 {
				return fmt.Sprintf("$%s+%d", c.sym, c.off), nil
			}
			return "$" + c.sym, nil
		}
		return fc.word(v.Name), nil
	}
	return "", fmt.Errorf("unresolvable value")
}

// forward makes res an alias of src instead of emitting a copy. Phi
// results mutate at block heads and edges, so copies of them stay real.
func (fc *funcCtx) forward(res string, src *llir.Value) error {
	s, err := fc.op(src)
	if err != nil {
		return err
	}
	if src.Kind == llir.VLocal {
		if d := fc.defs[src.Name]; d != nil && d.Op == "phi" {
			fc.ins("move %s, %s", s, fc.word(res))
			return nil
		}
	}
	fc.fwd[res] = s
	return nil
}

// directAddr renders a pointer value as a static address operand if its
// target is known at link time.
func (fc *funcCtx) directAddr(v *llir.Value) (string, bool) {
	switch v.Kind {
	case llir.VGlobal:
		if m := uartMMIO(v.Name); m != "" {
			return m, true
		}
		return fc.globalOperand(v), true
	case llir.VLocal:
		if a, ok := fc.allocas[v.Name]; ok {
			return a, true
		}
		if c, ok := fc.constAddr[v.Name]; ok {
			if c.off != 0 {
				return fmt.Sprintf("%s+%d", c.sym, c.off), true
			}
			return c.sym, true
		}
		// A value forwarded to an address literal is a static address.
		if s, ok := fc.fwd[v.Name]; ok && strings.HasPrefix(s, "$") {
			rest := s[1:]
			if rest != "" && rest[0] != '-' && (rest[0] < '0' || rest[0] > '9') {
				return rest, true
			}
		}
	}
	return "", false
}

// --- Emission ---

func (fc *funcCtx) emit() error {
	f := fc.f
	fmt.Fprintf(&fc.g.text, "\n; --- %s ---\n", f.Name)
	fc.label(funcSym(f.Name))
	fc.cat = "prologue"
	if fc.hasCalls {
		fc.ins("move lr, %s", fc.lrsWord())
	}
	for i, p := range f.Params {
		if i < 4 {
			fc.ins("move r%d, %s", i, fc.word(p.Name))
		}
	}
	for bi, b := range f.Blocks {
		fc.curBlock = bi
		fc.label(fc.blockLabel(b.Name))
		// Phi heads: latch shadows into value words (shadow-mode blocks
		// only — direct-mode blocks were written on the edges).
		fc.cat = "phi"
		if !fc.directPhi[b.Name] {
			for _, ins := range b.Instrs {
				if ins.Op == "phi" {
					fc.ins("move %s, %s", fc.shadow(ins.Res), fc.word(ins.Res))
				}
			}
		}
		for _, ins := range b.Instrs {
			fc.cat = ins.Op
			if ins.Op == "call" && strings.HasPrefix(ins.Callee, "llvm.") {
				fc.cat = "intrinsic"
			}
			if err := fc.emitInstr(b, ins); err != nil {
				return fmt.Errorf("%s (IR line %d): %v", f.Name, ins.Line, err)
			}
		}
	}
	return nil
}

func maskComplement(bits int) uint32 { return ^uint32(1<<bits - 1) }

// constOf returns the constant among two operands, if either is one.
func constOf(a, b *llir.Value) (uint32, bool) {
	if a.Kind == llir.VConst {
		return uint32(a.Int), true
	}
	if b.Kind == llir.VConst {
		return uint32(b.Int), true
	}
	return 0, false
}

// maskTo truncates a value word to the given width in place.
func (fc *funcCtx) maskTo(sym string, bits int) {
	if bits < 32 {
		fc.ins("andn %s, $0x%x, %s", sym, maskComplement(bits), sym)
	}
}

// sextInto emits sign extension of a sub-word operand into dst.
func (fc *funcCtx) sextInto(opnd string, bits int, dst string) {
	s := uint32(1) << (bits - 1)
	fc.ins("xor %s, $0x%x, %s", opnd, s, dst)
	fc.ins("sub %s, $0x%x, %s", dst, s, dst)
}

func sizeFlag(bits int) string {
	switch {
	case bits <= 8:
		return ", size8"
	case bits <= 16:
		return ", size16"
	}
	return ""
}

func (fc *funcCtx) emitInstr(b *llir.Block, ins *llir.Instr) error {
	switch ins.Op {
	case "phi", "alloca":
		return nil // handled elsewhere

	case "add", "sub", "and", "or", "xor":
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		x, y := ins.Args[0], ins.Args[1]
		// Identities: x op 0 (and 0 op x for the commutative ones) is x.
		if y.Kind == llir.VConst && uint32(y.Int) == 0 && ins.Op != "and" {
			return fc.forward(ins.Res, x)
		}
		if x.Kind == llir.VConst && uint32(x.Int) == 0 && (ins.Op == "add" || ins.Op == "or" || ins.Op == "xor") {
			return fc.forward(ins.Res, y)
		}
		a, err := fc.op(x)
		if err != nil {
			return err
		}
		bb, err := fc.op(y)
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		if ins.Op == "and" {
			// AND with a constant is the 3-block andn with the mask's
			// complement; the general and macro costs 6.
			if x.Kind == llir.VConst {
				x, a, bb = y, bb, a
			}
			if k, isC := constOf(ins.Args[0], ins.Args[1]); isC {
				if k == 0xFFFFFFFF {
					return fc.forward(ins.Res, x)
				}
				fc.ins("andn %s, $0x%x, %s", a, ^k, res)
				return nil
			}
		}
		fc.ins("%s %s, %s, %s", ins.Op, a, bb, res)
		if ins.Op == "add" || ins.Op == "sub" {
			fc.maskTo(res, w)
		}
		return nil

	case "mul":
		return fc.emitMul(ins)

	case "shl":
		return fc.emitShl(ins)

	case "lshr", "ashr", "udiv", "sdiv", "urem", "srem":
		return fc.emitRuntimeOp(ins)

	case "icmp":
		if fc.fused[ins.Res] {
			return nil // emitted at the branch
		}
		res := fc.word(ins.Res)
		t, f := fc.stub("Ct"), fc.stub("Cf")
		j := fc.stub("Cj")
		if err := fc.emitCompareBranch(ins, t, f); err != nil {
			return err
		}
		fc.label(t)
		fc.ins("move $1, %s", res)
		fc.ins("jump %s", j)
		fc.label(f)
		fc.ins("move $0, %s", res)
		fc.label(j)
		return nil

	case "select":
		res := fc.word(ins.Res)
		av, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		bv, err := fc.op(ins.Args[2])
		if err != nil {
			return err
		}
		if ins.Args[0].Kind == llir.VConst {
			if ins.Args[0].Int != 0 {
				fc.ins("move %s, %s", av, res)
			} else {
				fc.ins("move %s, %s", bv, res)
			}
			return nil
		}
		c, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		t, f, j := fc.stub("St"), fc.stub("Sf"), fc.stub("Sj")
		fc.emitBoolBranch(c, t, f)
		fc.label(t)
		fc.ins("move %s, %s", av, res)
		fc.ins("jump %s", j)
		fc.label(f)
		fc.ins("move %s, %s", bv, res)
		fc.label(j)
		return nil

	case "load":
		// i64 loads exist only to consume 8-byte varargs (%lld skip):
		// keep the low word — correct for every trunc-to-32 use, and any
		// other use of the value fails width() with a clear error.
		if ins.Typ.Kind == llir.TInt && ins.Typ.Bits == 64 {
			ins = &llir.Instr{Op: "load", Res: ins.Res, Typ: &llir.Type{Kind: llir.TInt, Bits: 32}, Args: ins.Args}
		}
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		if w < 32 {
			fc.ins("move $0, %s", res)
		}
		if addr, ok := fc.directAddr(ins.Args[0]); ok {
			fc.ins("move %s, %s%s", addr, res, sizeFlag(w))
			return nil
		}
		p, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		ld := fc.stub("Ld")
		fc.ins("move %s, %s.read", p, ld)
		fc.label(ld)
		fc.ins("move @0, %s%s", res, sizeFlag(w))
		return nil

	case "store":
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		val, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		if addr, ok := fc.directAddr(ins.Args[1]); ok {
			fc.ins("move %s, %s%s", val, addr, sizeFlag(w))
			return nil
		}
		p, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		st := fc.stub("Sd")
		fc.ins("move %s, %s.write", p, st)
		fc.label(st)
		fc.ins("move %s, @0%s", val, sizeFlag(w))
		return nil

	case "getelementptr":
		return fc.emitGEP(ins)

	case "insertvalue", "extractvalue":
		// Only the single-word aggregate case (ABI-coerced values like
		// [1 x i32] va_list): the element IS the word, so both are copies.
		if s := ins.Typ.Size(); s > 4 {
			return fmt.Errorf("%s on %d-byte aggregate is not supported", ins.Op, s)
		}
		src := ins.Args[0]
		if ins.Op == "insertvalue" {
			src = ins.Args[1]
		}
		return fc.forward(ins.Res, src)

	case "zext", "bitcast", "ptrtoint", "inttoptr", "freeze":
		return fc.forward(ins.Res, ins.Args[0])

	case "sext":
		srcW, err := width(ins.Args[0].Typ)
		if err != nil {
			return err
		}
		dstW, err := width(ins.To)
		if err != nil {
			return err
		}
		if srcW == 32 {
			return fc.forward(ins.Res, ins.Args[0])
		}
		src, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		fc.sextInto(src, srcW, res)
		fc.maskTo(res, dstW)
		return nil

	case "trunc":
		// trunc from i64 needs only the low word, which is what an i64
		// load leaves in the value word.
		dstW, err := width(ins.To)
		if err != nil {
			return err
		}
		srcW := 32
		if ins.Args[0].Typ != nil && ins.Args[0].Typ.Kind == llir.TInt && ins.Args[0].Typ.Bits <= 32 {
			srcW = ins.Args[0].Typ.Bits
		}
		if dstW >= 32 || srcW <= dstW {
			return fc.forward(ins.Res, ins.Args[0])
		}
		src, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		fc.ins("andn %s, $0x%x, %s", src, maskComplement(dstW), res)
		return nil

	case "call":
		return fc.emitCall(ins)

	case "br":
		return fc.emitBr(b, ins)

	case "switch":
		return fc.emitSwitch(b, ins)

	case "ret":
		if len(ins.Args) > 0 {
			v, err := fc.op(ins.Args[0])
			if err != nil {
				return err
			}
			fc.ins("move %s, r0", v)
		}
		if fc.hasCalls {
			fc.ins("move %s, lr", fc.lrsWord())
		}
		fc.ins("ret")
		return nil

	case "unreachable":
		fc.ins("halt")
		return nil
	}
	return fmt.Errorf("unsupported instruction %q", ins.Op)
}

// --- Multiplication and shifts ---

// emitMulConst computes res = src * k with a double-and-add chain
// (exact mod 2^32 for any k, including "negative" constants). Uses sc0.
func (fc *funcCtx) emitMulConst(src string, k uint32, res string) {
	switch {
	case k == 0:
		fc.ins("move $0, %s", res)
		return
	case k == 1:
		fc.ins("move %s, %s", src, res)
		return
	case k <= 64:
		fc.ins("mulc %s, %d, %s", src, k, res)
		return
	}
	fc.ins("move %s, sc0", src)
	first := true
	for bit := 0; bit < 32 && k>>bit != 0; bit++ {
		if k>>bit&1 == 1 {
			if first {
				if bit == 0 {
					fc.ins("move sc0, %s", res)
				} else {
					fc.ins("move sc0, %s", res)
				}
				first = false
			} else {
				fc.ins("add %s, sc0, %s", res, res)
			}
		}
		if k>>(bit+1) != 0 {
			fc.ins("shl sc0, sc0")
		}
	}
}

func (fc *funcCtx) emitMul(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	a, b := ins.Args[0], ins.Args[1]
	if b.Kind == llir.VConst || a.Kind == llir.VConst {
		if a.Kind == llir.VConst {
			a, b = b, a
		}
		src, err := fc.op(a)
		if err != nil {
			return err
		}
		fc.emitMulConst(src, uint32(b.Int), res)
		fc.maskTo(res, w)
		return nil
	}
	av, err := fc.op(a)
	if err != nil {
		return err
	}
	bv, err := fc.op(b)
	if err != nil {
		return err
	}
	fc.g.rt["mul"] = true
	fc.hasCalls = true
	fc.ins("move %s, r0", av)
	fc.ins("move %s, r1", bv)
	fc.ins("call __rt_mul")
	fc.ins("move r0, %s", res)
	fc.maskTo(res, w)
	return nil
}

func (fc *funcCtx) emitShl(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	a, sh := ins.Args[0], ins.Args[1]
	av, err := fc.op(a)
	if err != nil {
		return err
	}
	if sh.Kind == llir.VConst {
		n := int(uint32(sh.Int)) & 31
		if n == 0 {
			return fc.forward(ins.Res, a)
		} else if n <= 10 {
			fc.ins("shl %s, %s", av, res)
			for i := 1; i < n; i++ {
				fc.ins("shl %s, %s", res, res)
			}
		} else {
			fc.emitMulConst(av, uint32(1)<<n, res)
		}
		fc.maskTo(res, w)
		return nil
	}
	sv, err := fc.op(sh)
	if err != nil {
		return err
	}
	fc.g.rt["shl"] = true
	fc.hasCalls = true
	fc.ins("move %s, r0", av)
	fc.ins("move %s, r1", sv)
	fc.ins("call __rt_shl")
	fc.ins("move r0, %s", res)
	fc.maskTo(res, w)
	return nil
}

// emitRuntimeOp lowers lshr/ashr/udiv/sdiv/urem/srem via runtime calls.
func (fc *funcCtx) emitRuntimeOp(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	av, err := fc.op(ins.Args[0])
	if err != nil {
		return err
	}
	bv, err := fc.op(ins.Args[1])
	if err != nil {
		return err
	}
	signed := ins.Op == "ashr" || ins.Op == "sdiv" || ins.Op == "srem"
	if signed && w < 32 {
		fc.sextInto(av, w, "sc0")
		av = "sc0"
		if ins.Op != "ashr" {
			fc.sextInto(bv, w, "sc1")
			bv = "sc1"
		}
	}
	rt := map[string]string{
		"lshr": "lshr", "ashr": "ashr", "udiv": "udiv",
		"sdiv": "sdiv", "urem": "urem", "srem": "srem",
	}[ins.Op]
	fc.g.rt[rt] = true
	fc.hasCalls = true
	fc.ins("move %s, r0", av)
	fc.ins("move %s, r1", bv)
	fc.ins("call __rt_%s", rt)
	fc.ins("move r0, %s", res)
	if signed || ins.Op == "lshr" && w < 32 {
		fc.maskTo(res, w)
	}
	return nil
}

// --- GEP ---

func (fc *funcCtx) emitGEP(ins *llir.Instr) error {
	base := ins.Args[0]
	indices := ins.Args[1:]
	cur := ins.Typ
	constOff := int64(0)
	type varPart struct {
		v     *llir.Value
		scale int
	}
	var vars []varPart
	for j, iv := range indices {
		if j > 0 {
			switch cur.Kind {
			case llir.TArray:
				cur = cur.Elem
			case llir.TStruct:
				if iv.Kind != llir.VConst {
					return fmt.Errorf("GEP struct index must be constant")
				}
				idx := int(int32(iv.Int))
				constOff += int64(cur.FieldOffset(idx))
				cur = cur.Fields[idx]
				continue
			default:
				return fmt.Errorf("GEP walks into scalar type %s", cur)
			}
		}
		scale := cur.Size()
		if j == 0 {
			scale = ins.Typ.Size()
		}
		if iv.Kind == llir.VConst {
			constOff += int64(int32(iv.Int)) * int64(scale)
		} else {
			vars = append(vars, varPart{iv, scale})
		}
	}
	// Fully static: fold to a link-time address, no code.
	if len(vars) == 0 {
		if addr, ok := fc.directAddr(base); ok {
			sym, off := addr, uint32(0)
			if i := strings.IndexByte(addr, '+'); i >= 0 {
				sym = addr[:i]
				fmt.Sscanf(addr[i+1:], "%d", &off)
			}
			fc.constAddr[ins.Res] = addrC{sym: sym, off: off + uint32(constOff)}
			return nil
		}
	}
	res := fc.word(ins.Res)
	bv, err := fc.op(base)
	if err != nil {
		return err
	}
	fc.ins("move %s, %s", bv, res)
	if constOff != 0 {
		fc.ins("add %s, $0x%x, %s", res, uint32(int32(constOff)), res)
	}
	for _, vp := range vars {
		iv, err := fc.op(vp.v)
		if err != nil {
			return err
		}
		if vp.scale == 1 {
			fc.ins("add %s, %s, %s", res, iv, res)
			continue
		}
		fc.emitMulConst(iv, uint32(vp.scale), "sc1")
		fc.ins("add %s, sc1, %s", res, res)
	}
	return nil
}

// --- Calls ---

func isNopIntrinsic(name string) bool {
	for _, pre := range []string{"llvm.lifetime.", "llvm.assume", "llvm.dbg.", "llvm.experimental.noalias", "llvm.prefetch"} {
		if strings.HasPrefix(name, pre) {
			return true
		}
	}
	return false
}

func (fc *funcCtx) emitCall(ins *llir.Instr) error {
	name := ins.Callee
	if isNopIntrinsic(name) {
		return nil
	}
	if strings.HasPrefix(name, "llvm.") {
		return fc.emitIntrinsic(ins)
	}
	if ins.CalleeVal != nil {
		return fc.emitIndirectCall(ins)
	}
	callee, ok := fc.g.funcIdx[name]
	if !ok {
		return fmt.Errorf("call to undefined function %q (no external linkage on this target)", name)
	}
	nfix := len(callee.Params)
	if callee.Variadic && len(ins.Args) < nfix || !callee.Variadic && len(ins.Args) != nfix {
		return fmt.Errorf("call to %q: %d args, %d params", name, len(ins.Args), nfix)
	}
	ccName := sanitize(callee.Name)
	for i, av := range ins.Args {
		v, err := fc.op(av)
		if err != nil {
			return err
		}
		switch {
		case i >= nfix: // variadic tail: contiguous words in the va area
			if av.Typ != nil && av.Typ.Kind == llir.TInt && av.Typ.Bits > 32 {
				return fmt.Errorf("call to %q: long long variadic arguments are not supported", name)
			}
			if off := 4 * (i - nfix); off != 0 {
				fc.ins("move %s, va_%s+%d", v, ccName, off)
			} else {
				fc.ins("move %s, va_%s", v, ccName)
			}
		case i < 4:
			fc.ins("move %s, r%d", v, i)
		default:
			// Beyond r3, args go directly into the callee's frame.
			fc.ins("move %s, v_%s_%s", v, ccName, sanitize(callee.Params[i].Name))
		}
	}
	fc.ins("call %s", funcSym(name))
	if ins.Res != "" && ins.Typ.Kind != llir.TVoid {
		fc.ins("move r0, %s", fc.word(ins.Res))
	}
	return nil
}

// emitIndirectCall calls through a function-pointer value: store the
// return address into lr, jump through the pointer word. The callee's
// prologue saves lr like any other call. Only register args fit — the
// callee's frame is unknown at compile time.
func (fc *funcCtx) emitIndirectCall(ins *llir.Instr) error {
	if len(ins.Args) > 4 {
		return fmt.Errorf("indirect call with %d args: only 4 register args are supported", len(ins.Args))
	}
	if ins.FixedArgs >= 0 && len(ins.Args) > ins.FixedArgs {
		return fmt.Errorf("indirect variadic calls are not supported")
	}
	for i, av := range ins.Args {
		v, err := fc.op(av)
		if err != nil {
			return err
		}
		fc.ins("move %s, r%d", v, i)
	}
	ptr, err := fc.op(ins.CalleeVal)
	if err != nil {
		return err
	}
	ret := fc.stub("Ri")
	fc.ins("move $%s, lr", ret)
	fc.ins("jumpr %s", ptr)
	fc.label(ret)
	if ins.Res != "" && ins.Typ.Kind != llir.TVoid {
		fc.ins("move r0, %s", fc.word(ins.Res))
	}
	return nil
}

// storeWordTo writes the value operand `src` through pointer value p.
func (fc *funcCtx) storeWordTo(p *llir.Value, src string) error {
	if addr, ok := fc.directAddr(p); ok {
		fc.ins("move %s, %s", src, addr)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	st := fc.stub("Sv")
	fc.ins("move %s, %s.write", pv, st)
	fc.label(st)
	fc.ins("move %s, @0", src)
	return nil
}

// loadWordFrom reads a word through pointer value p into dst.
func (fc *funcCtx) loadWordFrom(p *llir.Value, dst string) error {
	if addr, ok := fc.directAddr(p); ok {
		fc.ins("move %s, %s", addr, dst)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	ld := fc.stub("Lv")
	fc.ins("move %s, %s.read", pv, ld)
	fc.label(ld)
	fc.ins("move @0, %s", dst)
	return nil
}

func (fc *funcCtx) emitIntrinsic(ins *llir.Instr) error {
	name := ins.Callee
	base := name
	if i := strings.Index(name[5:], "."); i >= 0 {
		base = name[:5+i]
	}
	switch base {
	case "llvm.va_start":
		if !fc.f.Variadic {
			return fmt.Errorf("va_start outside a variadic function")
		}
		return fc.storeWordTo(ins.Args[0], "$"+fc.vaArea())
	case "llvm.va_end":
		return nil
	case "llvm.va_copy": // *dst = *src, one pointer word
		if err := fc.loadWordFrom(ins.Args[1], "sc2"); err != nil {
			return err
		}
		return fc.storeWordTo(ins.Args[0], "sc2")
	case "llvm.memcpy":
		return fc.emitMemRT("memcpy", ins.Args[0], ins.Args[1], ins.Args[2])
	case "llvm.memset":
		return fc.emitMemRT("memset", ins.Args[0], ins.Args[1], ins.Args[2])
	case "llvm.ptrmask": // pointer & mask
		a, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		b, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		fc.ins("and %s, %s, %s", a, b, fc.word(ins.Res))
		return nil
	case "llvm.expect":
		return fc.forward(ins.Res, ins.Args[0])
	case "llvm.abs":
		v, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		neg, pos := fc.stub("An"), fc.stub("Aj")
		fc.ins("move %s, %s", v, res)
		fc.ins("jsign %s, %s, %s", res, neg, pos)
		fc.label(neg)
		fc.ins("sub zero, %s, %s", res, res)
		fc.label(pos)
		return nil
	case "llvm.smax", "llvm.smin", "llvm.umax", "llvm.umin":
		a, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		b, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		lt, ge, j := fc.stub("Mlt"), fc.stub("Mge"), fc.stub("Mj")
		cmp := "jlt"
		if base == "llvm.umax" || base == "llvm.umin" {
			cmp = "jltu"
		}
		fc.ins("%s %s, %s, %s, %s", cmp, a, b, lt, ge)
		aWins := base == "llvm.smin" || base == "llvm.umin" // a<b: min picks a
		fc.label(lt)
		if aWins {
			fc.ins("move %s, %s", a, res)
		} else {
			fc.ins("move %s, %s", b, res)
		}
		fc.ins("jump %s", j)
		fc.label(ge)
		if aWins {
			fc.ins("move %s, %s", b, res)
		} else {
			fc.ins("move %s, %s", a, res)
		}
		fc.label(j)
		return nil
	}
	return fmt.Errorf("unsupported intrinsic %q", name)
}

func (fc *funcCtx) emitMemRT(rt string, dst, src, n *llir.Value) error {
	dv, err := fc.op(dst)
	if err != nil {
		return err
	}
	sv, err := fc.op(src)
	if err != nil {
		return err
	}
	nv, err := fc.op(n)
	if err != nil {
		return err
	}
	fc.g.rt[rt] = true
	fc.hasCalls = true
	fc.ins("move %s, r0", dv)
	fc.ins("move %s, r1", sv)
	fc.ins("move %s, r2", nv)
	fc.ins("call __rt_%s", rt)
	return nil
}

// --- Branches ---

// phiCopiesFor emits the parallel copies for one edge from -> succ:
// into phi words for direct-mode successors, into shadows otherwise.
// Reports whether the successor has any phis.
func (fc *funcCtx) phiCopiesFor(from *llir.Block, succ string) (bool, error) {
	savedCat := fc.cat
	fc.cat = "phi"
	defer func() { fc.cat = savedCat }()
	idx, ok := fc.blockIdx[succ]
	if !ok {
		return false, fmt.Errorf("branch to unknown block %q", succ)
	}
	dst := fc.shadow
	if fc.directPhi[succ] {
		dst = fc.word
	}
	any := false
	for _, ins := range fc.f.Blocks[idx].Instrs {
		if ins.Op != "phi" {
			continue
		}
		any = true
		for _, e := range ins.Phi {
			if e.Pred == from.Name {
				v, err := fc.op(e.Val)
				if err != nil {
					return false, err
				}
				fc.ins("move %s, %s", v, dst(ins.Res))
			}
		}
	}
	return any, nil
}

// edgePlan routes phi-carrying edges of a multi-way branch. Shadow-mode
// successors take their copies inline before the branch (stray shadow
// writes on the untaken edge are harmless — the head latch only runs on
// entry). Direct-mode successors get a per-edge stub so their phi words
// are written on the taken edge only.
type edgePlan struct {
	from   *llir.Block
	labels map[string]string // succ -> branch target label
	stubs  []string          // direct-mode succs needing a stub, in order
}

func (fc *funcCtx) planEdge(p *edgePlan, succ string) (string, error) {
	if l, ok := p.labels[succ]; ok {
		return l, nil
	}
	idx, ok := fc.blockIdx[succ]
	if !ok {
		return "", fmt.Errorf("branch to unknown block %q", succ)
	}
	hasPhi := false
	for _, ins := range fc.f.Blocks[idx].Instrs {
		if ins.Op == "phi" {
			hasPhi = true
			break
		}
	}
	lbl := fc.blockLabel(succ)
	switch {
	case !hasPhi:
	case !fc.directPhi[succ]:
		if _, err := fc.phiCopiesFor(p.from, succ); err != nil {
			return "", err
		}
	default:
		lbl = fc.stub("Pe")
		p.stubs = append(p.stubs, succ)
		p.labels[succ] = lbl
		return lbl, nil
	}
	p.labels[succ] = lbl
	return lbl, nil
}

func (fc *funcCtx) flushEdgeStubs(p *edgePlan) error {
	for _, succ := range p.stubs {
		fc.label(p.labels[succ])
		if _, err := fc.phiCopiesFor(p.from, succ); err != nil {
			return err
		}
		fc.cat = "phi"
		fc.ins("jump %s", fc.blockLabel(succ))
	}
	return nil
}

func (fc *funcCtx) backward(targets ...string) bool {
	for _, t := range targets {
		if idx, ok := fc.blockIdx[t]; ok && idx <= fc.curBlock {
			return true
		}
	}
	return false
}

func (fc *funcCtx) maybeSafepoint(targets ...string) {
	if !fc.g.opts.NoSafepoints && fc.backward(targets...) {
		fc.ins("safepoint")
	}
}

func (fc *funcCtx) emitBr(b *llir.Block, ins *llir.Instr) error {
	if len(ins.Labels) == 1 {
		// Single successor: copies go inline regardless of mode.
		if _, err := fc.phiCopiesFor(b, ins.Labels[0]); err != nil {
			return err
		}
		fc.maybeSafepoint(ins.Labels[0])
		fc.ins("jump %s", fc.blockLabel(ins.Labels[0]))
		return nil
	}
	tl, fl := ins.Labels[0], ins.Labels[1]
	fc.maybeSafepoint(tl, fl)
	cond := ins.Args[0]
	if cond.Kind == llir.VConst {
		tgt := fl
		if cond.Int != 0 {
			tgt = tl
		}
		if _, err := fc.phiCopiesFor(b, tgt); err != nil {
			return err
		}
		fc.ins("jump %s", fc.blockLabel(tgt))
		return nil
	}
	p := &edgePlan{from: b, labels: map[string]string{}}
	tLbl, err := fc.planEdge(p, tl)
	if err != nil {
		return err
	}
	fLbl, err := fc.planEdge(p, fl)
	if err != nil {
		return err
	}
	if d := fc.defs[cond.Name]; d != nil && fc.fused[cond.Name] {
		if err := fc.emitCompareBranch(d, tLbl, fLbl); err != nil {
			return err
		}
		return fc.flushEdgeStubs(p)
	}
	c, err := fc.op(cond)
	if err != nil {
		return err
	}
	fc.emitBoolBranch(c, tLbl, fLbl)
	return fc.flushEdgeStubs(p)
}

func (fc *funcCtx) emitSwitch(b *llir.Block, ins *llir.Instr) error {
	succs := []string{ins.Labels[0]}
	for _, c := range ins.Cases {
		succs = append(succs, c.Label)
	}
	fc.maybeSafepoint(succs...)
	v, err := fc.op(ins.Args[0])
	if err != nil {
		return err
	}
	p := &edgePlan{from: b, labels: map[string]string{}}
	def, err := fc.planEdge(p, ins.Labels[0])
	if err != nil {
		return err
	}
	caseLbl := make([]string, len(ins.Cases))
	for i, c := range ins.Cases {
		if caseLbl[i], err = fc.planEdge(p, c.Label); err != nil {
			return err
		}
	}

	// Dense value sets dispatch through a jump table: bounds-check,
	// scale by 16 (one block per slot), add the table base, jump.
	minV, maxV := uint32(ins.Cases[0].Val), uint32(ins.Cases[0].Val)
	for _, c := range ins.Cases {
		if uint32(c.Val) < minV {
			minV = uint32(c.Val)
		}
		if uint32(c.Val) > maxV {
			maxV = uint32(c.Val)
		}
	}
	span := int(maxV-minV) + 1
	if len(ins.Cases) >= 4 && span <= 2*len(ins.Cases)+8 && !fc.g.opts.InlineCompares {
		idx := v
		if minV != 0 {
			fc.ins("sub %s, $0x%x, sc0", v, minV)
			idx = "sc0"
		}
		in, tbl := fc.stub("Swi"), fc.stub("Swt")
		fc.emitCmpSite("ltu", idx, fmt.Sprintf("$0x%x", uint32(span)), in, def)
		fc.label(in)
		// The slot scale is the encoding's instruction size: 16-byte
		// blocks classic, 8-byte records compact.
		fc.ins(".ifcompact")
		fc.ins("mulc %s, 8, sc1", idx)
		fc.ins(".else")
		fc.ins("mulc %s, 16, sc1", idx)
		fc.ins(".endif")
		fc.ins("add sc1, $%s, sc1", tbl)
		fc.ins("jumpr sc1")
		fc.label(tbl)
		slots := make([]string, span)
		for i := range slots {
			slots[i] = def
		}
		for i, c := range ins.Cases {
			slots[uint32(c.Val)-minV] = caseLbl[i]
		}
		for _, s := range slots {
			fc.ins("jump %s", s)
		}
		return fc.flushEdgeStubs(p)
	}

	for i, c := range ins.Cases {
		next := fc.stub("Sw")
		if fc.g.opts.InlineCompares {
			fc.ins("jeq %s, $0x%x, %s, %s", v, uint32(c.Val), caseLbl[i], next)
		} else {
			fc.emitCmpSite("eq", v, fmt.Sprintf("$0x%x", uint32(c.Val)), caseLbl[i], next)
		}
		fc.label(next)
	}
	fc.ins("jump %s", def)
	return fc.flushEdgeStubs(p)
}
