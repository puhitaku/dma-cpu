package dmacc

import (
	"fmt"

	"github.com/puhitaku/dma-cpu/llir"
)

// Outlined comparisons ("millicode"). Inline full-range compares cost
// 14–18 blocks per site and dominate real programs; the outlined form
// costs 4–5 blocks per site: store the two branch-target addresses and
// the operands into shared words, then jump into a helper that computes
// the sign predicate once and dispatches through `jumpr cw_t`/`jumpr
// cw_f`. No lr, no return — the helper IS the branch. Safe under
// approach-B interrupts: safepoints never occur inside the sequence,
// and ISRs use their own register bank.
//
// Options.InlineCompares restores the inline lowering (faster by a few
// blocks per branch, much larger).

type cmpHelper struct {
	name string
	text string
}

// The helper bodies. Predicate math is identical to the dmaasm inline
// macros (doc/abi.md); `jsign` slots: negative sign first.
var cmpHelpers = []cmpHelper{
	{"eqz", `; a == 0 ? -> cw_t : cw_f  (sign of a | -a)
__cw_eqz:
    sub zero, cw_a, at
    or at, cw_a, at
    jsign at, __cw_eqz_n, __cw_eqz_z
__cw_eqz_z:
    jumpr cw_t
__cw_eqz_n:
    jumpr cw_f
`},
	{"eq", `; a == b ? -> cw_t : cw_f  (sign of d | -d, d = a-b)
__cw_eq:
    sub cw_a, cw_b, at
    sub zero, at, at2
    or at, at2, at
    jsign at, __cw_eq_n, __cw_eq_e
__cw_eq_e:
    jumpr cw_t
__cw_eq_n:
    jumpr cw_f
`},
	{"lt", `; signed a < b ? -> cw_t : cw_f
__cw_lt:
    xor cw_a, cw_b, at
    sub cw_a, cw_b, at2
    andn at2, at, at2
    andn cw_a, cw_b, at
    or at, at2, at
    jsign at, __cw_lt_t, __cw_lt_f
__cw_lt_t:
    jumpr cw_t
__cw_lt_f:
    jumpr cw_f
`},
	{"ltu", `; unsigned a < b ? -> cw_t : cw_f (borrow of a-b)
__cw_ltu:
    andn cw_a, cw_b, at
    sub cw_a, cw_b, at2
    andn at2, at, at2
    andn cw_b, cw_a, at
    or at, at2, at
    jsign at, __cw_ltu_t, __cw_ltu_f
__cw_ltu_t:
    jumpr cw_t
__cw_ltu_f:
    jumpr cw_f
`},
}

// emitCmpSite emits one outlined-comparison site.
func (fc *funcCtx) emitCmpSite(helper, a, b, t, f string) {
	fc.g.cmpUsed[helper] = true
	fc.ins("move $%s, cw_t", t)
	fc.ins("move $%s, cw_f", f)
	fc.ins("move %s, cw_a", a)
	if b != "" {
		fc.ins("move %s, cw_b", b)
	}
	fc.ins("jump __cw_%s", helper)
}

// emitCompareBranch lowers an icmp into a two-way branch to t / f.
func (fc *funcCtx) emitCompareBranch(ins *llir.Instr, t, f string) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	a, err := fc.op(ins.Args[0])
	if err != nil {
		return err
	}
	b, err := fc.op(ins.Args[1])
	if err != nil {
		return err
	}
	signed := ins.Pred == "slt" || ins.Pred == "sge" || ins.Pred == "sgt" || ins.Pred == "sle"
	if signed && w < 32 {
		fc.sextInto(a, w, "sc0")
		fc.sextInto(b, w, "sc1")
		a, b = "sc0", "sc1"
	}
	if fc.g.opts.InlineCompares {
		return fc.emitInlineCompare(ins.Pred, a, b, t, f)
	}
	// Equality against zero has a dedicated one-operand helper.
	if ins.Pred == "eq" || ins.Pred == "ne" {
		x, y := ins.Args[0], ins.Args[1]
		if y.Kind == llir.VConst && uint32(y.Int) == 0 || x.Kind == llir.VConst && uint32(x.Int) == 0 {
			v := a
			if x.Kind == llir.VConst && uint32(x.Int) == 0 {
				v = b
			}
			if ins.Pred == "eq" {
				fc.emitCmpSite("eqz", v, "", t, f)
			} else {
				fc.emitCmpSite("eqz", v, "", f, t)
			}
			return nil
		}
	}
	switch ins.Pred {
	case "eq":
		fc.emitCmpSite("eq", a, b, t, f)
	case "ne":
		fc.emitCmpSite("eq", a, b, f, t)
	case "slt":
		fc.emitCmpSite("lt", a, b, t, f)
	case "sge":
		fc.emitCmpSite("lt", a, b, f, t)
	case "sgt":
		fc.emitCmpSite("lt", b, a, t, f)
	case "sle":
		fc.emitCmpSite("lt", b, a, f, t)
	case "ult":
		fc.emitCmpSite("ltu", a, b, t, f)
	case "uge":
		fc.emitCmpSite("ltu", a, b, f, t)
	case "ugt":
		fc.emitCmpSite("ltu", b, a, t, f)
	case "ule":
		fc.emitCmpSite("ltu", b, a, f, t)
	default:
		return fmt.Errorf("unsupported icmp predicate %q", ins.Pred)
	}
	return nil
}

// emitBoolBranch branches on a 0/1 word: outlined it is a 3-block eqz
// site; inline it is jbool.
func (fc *funcCtx) emitBoolBranch(cond, ifTrue, ifFalse string) {
	if fc.g.opts.InlineCompares {
		fc.ins("jbool %s, %s, %s", cond, ifFalse, ifTrue)
		return
	}
	fc.emitCmpSite("eqz", cond, "", ifFalse, ifTrue)
}

// emitInlineCompare is the pre-outlining lowering (kept behind
// Options.InlineCompares for latency-critical code).
func (fc *funcCtx) emitInlineCompare(pred, a, b, t, f string) error {
	switch pred {
	case "eq":
		fc.ins("jeq %s, %s, %s, %s", a, b, t, f)
	case "ne":
		fc.ins("jeq %s, %s, %s, %s", a, b, f, t)
	case "slt":
		fc.ins("jlt %s, %s, %s, %s", a, b, t, f)
	case "sge":
		fc.ins("jlt %s, %s, %s, %s", a, b, f, t)
	case "sgt":
		fc.ins("jlt %s, %s, %s, %s", b, a, t, f)
	case "sle":
		fc.ins("jlt %s, %s, %s, %s", b, a, f, t)
	case "ult":
		fc.ins("jltu %s, %s, %s, %s", a, b, t, f)
	case "uge":
		fc.ins("jltu %s, %s, %s, %s", a, b, f, t)
	case "ugt":
		fc.ins("jltu %s, %s, %s, %s", b, a, t, f)
	case "ule":
		fc.ins("jltu %s, %s, %s, %s", b, a, f, t)
	default:
		return fmt.Errorf("unsupported icmp predicate %q", pred)
	}
	return nil
}

// emitCmpHelpers appends the used helper bodies and their shared words.
func (g *gen) emitCmpHelpers() {
	if len(g.cmpUsed) == 0 {
		return
	}
	fmt.Fprintf(&g.out, "\n; --- comparison millicode ---\n.data\n")
	fmt.Fprintf(&g.out, "cw_a: .word 0\ncw_b: .word 0\ncw_t: .word 0\ncw_f: .word 0\n")
	// XIPText: the millicode is shared by RAM-resident flash-session
	// code (RAMTextFuncs), so it lives in .ramtext with everything the
	// session may fetch.
	w := &g.out
	if g.opts.XIPText {
		w = &g.ram
	} else {
		fmt.Fprintf(&g.out, ".text\n")
	}
	for _, h := range cmpHelpers {
		if g.cmpUsed[h.name] {
			w.WriteString(h.text)
		}
	}
}
