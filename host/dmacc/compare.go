package dmacc

import (
	"fmt"
	"strings"

	"github.com/puhitaku/dma-cpu/host/llir"
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
// macros (references/design_docs/abi.md); `jsign` slots: negative sign first.
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

// Descriptor unpack variants: the whole site collapses to two records
// (park the descriptor address, jump). The descriptor is a constant
// data block — [&b][t][f][&a] for two-operand kinds, [t][f][&a] for
// eqz — that the helper copies onto the contiguous cw_pb..cw_pa cells
// with one count=N move, then dereferences into cw_a/cw_b and falls
// into the plain helper.
var cmpDescHelpers = map[string]string{
	"eqz": `__cw_eqz_d:
    move cw_d, CWDz.read
CWDz:
    move @0, cw_t, count=12, size8, incrr, incrw
    move cw_pa, CWDza.read
CWDza:
    move @0, cw_a
    jump __cw_eqz
`,
	"eq": `__cw_eq_d:
    move cw_d, CWDq.read
CWDq:
    move @0, cw_pb, count=16, size8, incrr, incrw
    move cw_pa, CWDqa.read
CWDqa:
    move @0, cw_a
    move cw_pb, CWDqb.read
CWDqb:
    move @0, cw_b
    jump __cw_eq
`,
	"lt": `__cw_lt_d:
    move cw_d, CWDl.read
CWDl:
    move @0, cw_pb, count=16, size8, incrr, incrw
    move cw_pa, CWDla.read
CWDla:
    move @0, cw_a
    move cw_pb, CWDlb.read
CWDlb:
    move @0, cw_b
    jump __cw_lt
`,
	"ltu": `__cw_ltu_d:
    move cw_d, CWDu.read
CWDu:
    move @0, cw_pb, count=16, size8, incrr, incrw
    move cw_pa, CWDua.read
CWDua:
    move @0, cw_a
    move cw_pb, CWDub.read
CWDub:
    move @0, cw_b
    jump __cw_ltu
`,
}

// wordAddr returns a symbol whose link address holds the value of
// operand op — the coin descriptor comparisons trade in. Plain value
// words are their own storage; $constants and $address literals get a
// deduplicated constant word. Compound operands ($sym+off) have no
// .word spelling and report false (the site falls back to the plain
// four-move form).
func (fc *funcCtx) wordAddr(op string) (string, bool) {
	if op == "" {
		return "", false
	}
	if op[0] != '$' {
		if strings.ContainsAny(op, "+%@.") {
			return "", false
		}
		return op, true
	}
	lit := op[1:]
	if strings.Contains(lit, "+") {
		return "", false
	}
	if sym, ok := fc.g.cmpConst[op]; ok {
		return sym, true
	}
	sym := fmt.Sprintf("cwc_%d", len(fc.g.cmpConst))
	fc.g.cmpConst[op] = sym
	fmt.Fprintf(&fc.g.desc, "%s: .word %s\n", sym, lit)
	fc.g.descWords++
	return sym, true
}

// emitCmpSite emits one outlined-comparison site, preferring the
// two-record descriptor form.
func (fc *funcCtx) emitCmpSite(helper, a, b, t, f string) {
	fc.g.cmpUsed[helper] = true
	// RAMTextFuncs code runs while XIP is down; its descriptors would
	// live in flash text, so those sites keep the all-SRAM four-move
	// protocol (the plain helpers and their operands are RAM-resident).
	if pa, ok := fc.wordAddr(a); ok && !fc.inRAM && fc.g.opts.OptSize {
		pb, ok2 := "", b == ""
		if b != "" {
			pb, ok2 = fc.wordAddr(b)
		}
		if ok2 {
			fc.g.stubN++
			desc := fmt.Sprintf("cwd_%d", fc.g.stubN)
			if b == "" {
				fmt.Fprintf(&fc.g.desc, "%s: .word %s, %s, %s\n", desc, t, f, pa)
				fc.g.descWords += 3
			} else {
				fmt.Fprintf(&fc.g.desc, "%s: .word %s, %s, %s, %s\n", desc, pb, t, f, pa)
				fc.g.descWords += 4
			}
			fc.g.cmpUsedD[helper] = true
			fc.ins("move $%s, cw_d", desc)
			fc.ins("jump __cw_%s_d", helper)
			return
		}
	}
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
	// cw_pb..cw_pa are one contiguous run: descriptor unpack copies
	// [pb][t][f][pa] (or [t][f][pa]) onto them with a single move.
	fmt.Fprintf(&g.out, "cw_a: .word 0\ncw_b: .word 0\ncw_d: .word 0\n")
	fmt.Fprintf(&g.out, "cw_pb: .word 0\ncw_t: .word 0\ncw_f: .word 0\ncw_pa: .word 0\n")
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
		if g.cmpUsedD[h.name] {
			w.WriteString(cmpDescHelpers[h.name])
		}
	}
}
