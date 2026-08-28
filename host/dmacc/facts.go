package dmacc

import "github.com/puhitaku/dma-cpu/host/llir"

// Value facts: a monotone lattice over the SSA values of one function,
// read by the comparison lowering (compare.go) to pick a cheaper helper.
//
//	0  ⊑  factNonNeg  ⊑  factNonNeg|factBool
//
//	factNonNeg — bit 31 of the value's machine word is provably clear.
//	factBool   — the word is provably 0 or 1 (implies factNonNeg).
//
// The facts describe the WORD dmacc stores, not the abstract C value.
// A narrow (i1/i8/i16) value lives zero-extended in its word — the
// invariant every lowering maintains (maskTo after add/sub/mul/shift,
// size8/size16 loads, andn on trunc, width-canonicalized constants in
// op()) and the one `zext` already forwards on — so any value of a
// narrow integer type is factNonNeg by construction. The sign-extended
// operands a signed sub-word compare builds are NOT covered by that:
// sextInto writes a full-range word, and the site drops the facts.
//
// factBool is granted by ops that provably write a 0 or a 1, never by
// an i1 type alone: a byte in memory typed i1 is 0/1 only as far as its
// writers are trusted, and jbool miscompiles on anything else.
//
// Soundness: the facts are computed by iterating to a fixed point from
// the bottom (nothing known). Every rule is monotone in its operands
// and facts are only ever added, so a phi cycle converges without
// minting a fact that no acyclic path supports. When a rule is unclear
// the value simply gets no fact and the site keeps the general helper.
const (
	factNonNeg uint8 = 1 << iota
	factBool
)

const factAll = factNonNeg | factBool

// factSet holds the derived facts of one function's local values.
type factSet map[string]uint8

// typeFact is what a value's type alone grants.
func typeFact(t *llir.Type) uint8 {
	if t != nil && t.Kind == llir.TInt && t.Bits < 32 {
		return factNonNeg
	}
	return 0
}

// resTypeFact is typeFact of an instruction's RESULT. Instr.Typ means
// the result type for most ops but the operand type for icmp, the
// element type for getelementptr/alloca (whose results are pointers,
// and a pointer into the SIO/MMIO aperture has bit 31 set), and the
// aggregate type for insert/extractvalue.
func resTypeFact(ins *llir.Instr) uint8 {
	switch ins.Op {
	case "icmp", "getelementptr", "alloca", "insertvalue", "extractvalue":
		return 0
	}
	return typeFact(ins.Typ)
}

// of returns the facts of an operand.
func (fs factSet) of(v *llir.Value) uint8 {
	if v == nil {
		return 0
	}
	switch v.Kind {
	case llir.VConst:
		// Constants render at the operand's width (op()), so an i8 -1
		// is the word 0x000000FF, not 0xFFFFFFFF.
		c := uint32(v.Int)
		if v.Typ != nil && v.Typ.Kind == llir.TInt && v.Typ.Bits < 32 {
			c &= 1<<uint(v.Typ.Bits) - 1
		}
		switch {
		case c <= 1:
			return factAll
		case c&0x80000000 == 0:
			return factNonNeg
		}
	case llir.VLocal:
		return fs[v.Name] | typeFact(v.Typ)
	}
	return 0
}

// factsOf derives the value facts of one function.
func factsOf(f *llir.Func) factSet {
	fs := factSet{}
	both := func(a, b *llir.Value) uint8 { return fs.of(a) & fs.of(b) }
	for changed := true; changed; {
		changed = false
		for _, blk := range f.Blocks {
			for _, ins := range blk.Instrs {
				if ins.Res == "" {
					continue
				}
				var k uint8
				switch ins.Op {
				case "icmp":
					// Materialized as a literal 0 or 1 (func.go).
					k = factAll
				case "and":
					// AND can only clear bits: one nonneg (or bool)
					// operand decides the result.
					k = fs.of(ins.Args[0]) | fs.of(ins.Args[1])
				case "or", "xor":
					k = both(ins.Args[0], ins.Args[1])
				case "select":
					k = both(ins.Args[1], ins.Args[2])
				case "phi":
					k = factAll
					for _, e := range ins.Phi {
						k &= fs.of(e.Val)
					}
					if len(ins.Phi) == 0 {
						k = 0
					}
				case "zext", "bitcast", "ptrtoint", "inttoptr", "freeze":
					// The same word, forwarded unchanged.
					k = fs.of(ins.Args[0])
				case "trunc":
					k = fs.of(ins.Args[0])
					if w, err := width(ins.Typ); err == nil && w == 1 {
						if aw, aerr := width(ins.Args[0].Typ); aerr != nil || aw > 1 {
							k |= factAll // masked down to one bit
						}
					}
				case "lshr":
					// A nonzero constant count shifts a zero into bit 31.
					if s := ins.Args[1]; s.Kind == llir.VConst && uint32(s.Int)&31 != 0 {
						k = factNonNeg
					}
				}
				k |= resTypeFact(ins)
				if k&^fs[ins.Res] != 0 {
					fs[ins.Res] = fs[ins.Res] | k
					changed = true
				}
			}
		}
	}
	return fs
}
