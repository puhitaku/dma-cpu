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
// Fact-directed variants. The general helpers pay for operands that may
// use the full 32-bit range; most do not, and facts.go proves it per
// value. Where the proof holds the site routes to a shorter helper —
// the predicate math is in references/design_docs/abi.md:
//
//	__cw_eqzp   a == 0, a nonneg: a-1 borrows into bit 31 only at a == 0,
//	            so one add of -1 replaces eqz's sub/or pair.
//	__cw_ltp    a < b, both nonneg: signed and unsigned agree and the
//	            difference cannot wrap, so the sign of a-b IS the answer
//	            and the four-term borrow of lt/ltu collapses to one sub.
//
// A branch on a value proven to be 0 or 1 rides eqzp as well — 0 and 1
// are nonneg — and needs no jbool of its own (emitZeroTest).
//
// Options.InlineCompares restores the inline lowering (faster by a few
// blocks per branch, much larger); it ignores the facts, since its
// macros are already full-range and unconditional.

type cmpHelper struct {
	name string
	text string
}

// The helper bodies. The eq/eqz/lt/ltu math is identical to the dmaasm
// inline macros, the eqzp/ltp math to the restricted-range predicates
// (both in references/design_docs/abi.md); `jsign` slots: negative sign
// first.
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
	{"eqzp", `; a == 0 ? -> cw_t : cw_f, a nonneg (sign of a-1)
__cw_eqzp:
    add cw_a, $0xFFFFFFFF, at
    jsign at, __cw_eqzp_z, __cw_eqzp_n
__cw_eqzp_z:
    jumpr cw_t
__cw_eqzp_n:
    jumpr cw_f
`},
	{"ltp", `; a < b ? -> cw_t : cw_f, both nonneg (sign of a-b)
__cw_ltp:
    sub cw_a, cw_b, at
    jsign at, __cw_ltp_t, __cw_ltp_f
__cw_ltp_t:
    jumpr cw_t
__cw_ltp_f:
    jumpr cw_f
`},
}

// Descriptor unpack variants: the whole site collapses to two records
// (park the descriptor address, jump). The descriptor is a constant
// data block — [&b][t][f][&a] for two-operand kinds, [t][f][&a] for the
// zero tests — that the helper copies onto the contiguous cw_pb..cw_pa cells
// with one wcount=N move (both ends are word cells, so the classic
// encoding moves whole words), then dereferences into cw_a/cw_b and
// falls into the plain helper.
var cmpDescHelpers = map[string]string{
	"eqz": `__cw_eqz_d:
    move cw_d, CWDz.read
CWDz:
    move @0, cw_t, incrr, incrw, wcount=3
    move cw_pa, CWDza.read
CWDza:
    move @0, cw_a
    jump __cw_eqz
`,
	"eq": `__cw_eq_d:
    move cw_d, CWDq.read
CWDq:
    move @0, cw_pb, incrr, incrw, wcount=4
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
    move @0, cw_pb, incrr, incrw, wcount=4
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
    move @0, cw_pb, incrr, incrw, wcount=4
    move cw_pa, CWDua.read
CWDua:
    move @0, cw_a
    move cw_pb, CWDub.read
CWDub:
    move @0, cw_b
    jump __cw_ltu
`,
	"eqzp": `__cw_eqzp_d:
    move cw_d, CWDzp.read
CWDzp:
    move @0, cw_t, incrr, incrw, wcount=3
    move cw_pa, CWDzpa.read
CWDzpa:
    move @0, cw_a
    jump __cw_eqzp
`,
	"ltp": `__cw_ltp_d:
    move cw_d, CWDp.read
CWDp:
    move @0, cw_pb, incrr, incrw, wcount=4
    move cw_pa, CWDpa.read
CWDpa:
    move @0, cw_a
    move cw_pb, CWDpb.read
CWDpb:
    move @0, cw_b
    jump __cw_ltp
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

// emitCmpSite emits one outlined-comparison site: the four-move
// protocol, or the two-record descriptor form under Options.OptSize.
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
			fc.ins("move $%s, %s", desc, fc.cw("cw_d"))
			fc.cwJump(helper + "_d")
			return
		}
	}
	fc.ins("move $%s, %s", t, fc.cw("cw_t"))
	fc.ins("move $%s, %s", f, fc.cw("cw_f"))
	fc.ins("move %s, %s", a, fc.cw("cw_a"))
	if b != "" {
		fc.ins("move %s, %s", b, fc.cw("cw_b"))
	}
	fc.cwJump(helper)
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
	fa, fb := fc.facts.of(ins.Args[0]), fc.facts.of(ins.Args[1])
	signed := ins.Pred == "slt" || ins.Pred == "sge" || ins.Pred == "sgt" || ins.Pred == "sle"
	if signed && w < 32 {
		fc.sextInto(a, w, "sc0")
		fc.sextInto(b, w, "sc1")
		a, b = "sc0", "sc1"
		// sc0/sc1 hold sign-extended words: whatever the narrow value
		// words proved, these two range over all of i32.
		fa, fb = 0, 0
	}
	if fc.g.opts.InlineCompares {
		return fc.emitInlineCompare(ins.Pred, a, b, t, f)
	}
	// Equality against zero has dedicated one-operand lowerings.
	if ins.Pred == "eq" || ins.Pred == "ne" {
		x, y := ins.Args[0], ins.Args[1]
		if y.Kind == llir.VConst && uint32(y.Int) == 0 || x.Kind == llir.VConst && uint32(x.Int) == 0 {
			v, vf := a, fa
			if x.Kind == llir.VConst && uint32(x.Int) == 0 {
				v, vf = b, fb
			}
			if ins.Pred == "eq" {
				fc.emitZeroTest(v, vf, t, f)
			} else {
				fc.emitZeroTest(v, vf, f, t)
			}
			return nil
		}
	}
	// Both operands nonneg: the difference cannot wrap, so signed and
	// unsigned "less than" are the same one-subtraction test.
	lt, ltu := "lt", "ltu"
	if fa&fb&factNonNeg != 0 {
		lt, ltu = "ltp", "ltp"
	}
	switch ins.Pred {
	case "eq":
		fc.emitCmpSite("eq", a, b, t, f)
	case "ne":
		fc.emitCmpSite("eq", a, b, f, t)
	case "slt":
		fc.emitCmpSite(lt, a, b, t, f)
	case "sge":
		fc.emitCmpSite(lt, a, b, f, t)
	case "sgt":
		fc.emitCmpSite(lt, b, a, t, f)
	case "sle":
		fc.emitCmpSite(lt, b, a, f, t)
	case "ult":
		fc.emitCmpSite(ltu, a, b, t, f)
	case "uge":
		fc.emitCmpSite(ltu, a, b, f, t)
	case "ugt":
		fc.emitCmpSite(ltu, b, a, t, f)
	case "ule":
		fc.emitCmpSite(ltu, b, a, f, t)
	default:
		return fmt.Errorf("unsupported icmp predicate %q", ins.Pred)
	}
	return nil
}

// emitZeroTest branches on whether the word v is zero, taking the
// cheapest lowering its facts allow. A proven boolean is nonneg too, so
// it lands on eqzp: jbool is a 12-record macro, and neither of its two
// placements beats that — inline it is +8 records at EVERY site (the
// xv6 kernel's .ramtext overruns its window and the compare sites stop
// being descriptor-sized), and outlined it saves one executed record
// over eqzp for another shared body and two frozen vector slots.
func (fc *funcCtx) emitZeroTest(v string, vf uint8, ifZero, ifNonzero string) {
	if vf&factNonNeg != 0 {
		fc.emitCmpSite("eqzp", v, "", ifZero, ifNonzero)
		return
	}
	fc.emitCmpSite("eqz", v, "", ifZero, ifNonzero)
}

// emitBoolBranch branches on an i1 value: the zero test its facts
// allow, or jbool under Options.InlineCompares.
func (fc *funcCtx) emitBoolBranch(cond *llir.Value, ifTrue, ifFalse string) error {
	c, err := fc.op(cond)
	if err != nil {
		return err
	}
	if fc.g.opts.InlineCompares {
		fc.ins("jbool %s, %s, %s", c, ifFalse, ifTrue)
		return nil
	}
	fc.emitZeroTest(c, fc.facts.of(cond), ifFalse, ifTrue)
	return nil
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
	if g.opts.RuntimeExtern != nil {
		return // guest image: the host carries the cells and bodies
	}
	if len(g.cmpUsed) == 0 {
		return
	}
	if !g.opts.RuntimeHost {
		fmt.Fprintf(&g.out, "\n; --- comparison millicode ---\n.data\n")
		// cw_pb..cw_pa are one contiguous run: descriptor unpack copies
		// [pb][t][f][pa] (or [t][f][pa]) onto them with a single move.
		// (A RuntimeHost build declares these at the vector page head.)
		fmt.Fprintf(&g.out, "cw_a: .word 0\ncw_b: .word 0\ncw_d: .word 0\n")
		fmt.Fprintf(&g.out, "cw_pb: .word 0\ncw_t: .word 0\ncw_f: .word 0\ncw_pa: .word 0\n")
	}
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
