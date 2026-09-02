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
// use the full 32-bit range; most do not, and facts.go proves it — per
// value, and per BLOCK where a dominating branch narrowed the value
// further than its definition did. Sites therefore ask for the facts at
// their own block (facts.at, fc.curBlock), not for the function-wide
// ones. Where the proof holds the site routes to a shorter helper — the
// predicate math is in references/design_docs/abi.md:
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
//
// Options.InlineSites is the same lowering asked for one site at a
// time, off the same profile that fills HotSites (prompts/042 §1, "per-
// site compare inlining"). It is safe under approach-B interrupts for the
// reason it always was: an inline macro is ONE dmaasm statement, dmacc
// never emits a safepoint inside one, and the sign-dispatch trampoline
// pair the macro jumps through is assembler-private — so the sequence
// is as atomic against an ISR as the outlined helpers, which is why the
// inline lowering was legal before the helpers existed and still is.
// See siteInline for the precedence and emitInlineSite for the mapping.
//
// Size-directed variants. Under Options.OptSize a site can shrink from
// four moves and a jump to two records by handing the helper a constant
// descriptor instead (cmpDescHelpers), at roughly twice the per-branch
// cost. Which sites pay that is a measurement, not a guess: every site
// carries a stable label and the PGO driver ranks them by executions
// (prompts/042 §10c) — see siteFourMove for the rule and cmpSiteLabel
// for the naming.

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

// cmpSiteLabel names the site about to be emitted. The name is the
// function plus a per-function ordinal in EMISSION order, which is what
// makes it a stable identity across builds: the ordinal counts calls to
// emitCmpSite, and the form a site takes (four-move or descriptor) does
// not change how many sites there are or in what order they come — so a
// profile collected from one build still names the same sites in the
// next. The label costs zero bytes; it exists so the PGO driver can
// attribute text reads to a SITE and not just to its function
// (zz_pgogen_test.go, siteCounts).
//
// The `cws_` spelling matters twice over: it is not `__`-prefixed (the
// assembler drops those from Result.Symbols, which is where the driver
// reads site addresses from), and it is not `f_`-prefixed (the driver's
// function attribution keys on that).
func (fc *funcCtx) cmpSiteLabel() string {
	fc.cmpN++
	return fc.cmpSiteName(fc.cmpN)
}

// cmpSiteName spells the n'th site of the function being lowered, and
// peekCmpSite names the one the next emitCmpSite will take without
// consuming it — emitBoolBranch has to know a site's identity BEFORE it
// picks a lowering, because only it knows the tested word is an i1 and
// so may take jbool instead of a zero test.
func (fc *funcCtx) cmpSiteName(n int) string {
	return fmt.Sprintf("cws_%s_%d", sanitize(fc.f.Name), n)
}

func (fc *funcCtx) peekCmpSite() string { return fc.cmpSiteName(fc.cmpN + 1) }

// siteFourMove decides one OUTLINED site's form: true for the fast
// four-move protocol, false to try the descriptor form (which still
// needs static word addresses for both operands — emitCmpSite falls
// back). Sites that took the inline macro never reach here (siteInline
// is asked first).
//
// The order of the tests is the policy:
//
//	balanced   without OptSize nothing pays descriptors, profile or no
//	           profile. HotSites is a way to spend size on speed, and a
//	           balanced build has already spent it everywhere.
//	.ramtext   RAMTextFuncs code runs while the XIP window is down and
//	           its descriptors would live in flash text, so those sites
//	           stay four-move whatever the profile says. The plain
//	           helpers and their operand cells are RAM-resident.
//	per-site   with a profile for this image, the measurement decides
//	           each site on its own reads: a hot site keeps four moves
//	           even in a function nobody calls often, and a cold site
//	           pays descriptors even inside a hot function. This is what
//	           per-function granularity could not express — most of a
//	           hot function's sites are its error paths.
//	per-func   with no profile, today's rule: hot functions keep the
//	           four-move protocol, everything else shrinks (fc.optSize
//	           is OptSize minus HotFuncs).
func (fc *funcCtx) siteFourMove(site string) bool {
	switch {
	case !fc.g.opts.OptSize:
		return true
	case fc.inRAM:
		return true
	case len(fc.g.opts.HotSites) != 0:
		return fc.g.opts.HotSites[site]
	default:
		return !fc.optSize
	}
}

// siteInline decides whether one site skips the outlined forms
// altogether for the fully inline macro (Options.InlineSites). It is
// asked FIRST, ahead of siteFourMove: the inline form is the top of the
// same ladder, and a site the profile put at the top of the image is
// worth its 12-18 records whether or not the image is built for size —
// which is why, unlike the four-move/descriptor question, this one is
// not gated on OptSize.
//
// .ramtext used to be excluded here, on the grounds that the window is
// scarce and an inline site costs three times a four-move one in it.
// That is a fit argument, and fits belong to the trim that prices them
// (zz_pgogen_test.go, inlineFit), not to a blanket rule in the code
// generator: the driver profiles .ramtext now, so the resident sites
// are ranked with the rest and the board's window decides how many
// survive. Where the argument came from is a measurement that was never
// taken — the site scan only covered XIP text, so no resident site
// could ever be named and the exclusion never had to be right.
//
// What the exclusion WAS covering for, and siteFourMove still does, is
// the descriptor form: a resident site's descriptor would live in flash
// text and be loaded with the XIP window down. An inline site has no
// descriptor and no helper call. Its only indirection is the
// sign-dispatch trampoline pair, which is assembler-private and, for a
// split image, lands in .ramtext with the arena — so an inline site is
// if anything the more flash-independent of the three forms.
func (fc *funcCtx) siteInline(site string) bool {
	if len(fc.g.opts.InlineSites) == 0 {
		return false
	}
	return fc.g.opts.InlineSites[site]
}

// emitInlineSite is the InlineSites lowering of an already-normalized
// site: emitCmpSite has put the operands and the two targets in the
// order the predicate wants, so all that is left is the helper's own
// predicate. It goes through emitInlineCompare, the one lowering
// Options.InlineCompares uses, so the two paths cannot drift.
//
// There is no restricted-range macro to route to, so the fact-directed
// helpers collapse back onto full-range predicates and an inline site
// buys nothing from facts.go — the same way Options.InlineCompares
// never did. eqzp folds into jeq-against-zero, which is full-range
// anyway; ltp folds into jlt, which is the answer ltu would give too,
// since the only thing that ever selects ltp is a proof that both
// operands are nonneg and signed and unsigned agree there.
func (fc *funcCtx) emitInlineSite(helper, a, b, t, f string) {
	pred := map[string]string{
		"eq": "eq", "eqz": "eq", "eqzp": "eq",
		"lt": "slt", "ltp": "slt", "ltu": "ult",
	}[helper]
	if b == "" {
		b = "$0x0" // the zero tests: a == 0 is a == $0
	}
	// The predicate comes from a closed set emitInlineCompare handles;
	// its error cannot fire here.
	_ = fc.emitInlineCompare(pred, a, b, t, f)
}

// emitCmpSite emits one comparison site: the inline macro, the
// four-move protocol, or the two-record descriptor form. The choice is
// per SITE where a profile names one (Options.InlineSites, then
// Options.HotSites) and per FUNCTION otherwise (Options.OptSize minus
// Options.HotFuncs — fc.optSize); siteInline and siteFourMove spell the
// rule out.
func (fc *funcCtx) emitCmpSite(helper, a, b, t, f string) {
	site := fc.cmpSiteLabel()
	fc.label(site)
	if fc.siteInline(site) {
		fc.emitInlineSite(helper, a, b, t, f)
		return
	}
	fc.g.cmpUsed[helper] = true
	if pa, ok := fc.wordAddr(a); ok && !fc.siteFourMove(site) {
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
	fa, fb := fc.facts.at(fc.curBlock, ins.Args[0]), fc.facts.at(fc.curBlock, ins.Args[1])
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
// allow, or jbool under Options.InlineCompares — and, for a site the
// profile named in Options.InlineSites, jbool again, which is why this
// is the one lowering that has to look up its site label itself.
//
// jbool is 6 records against jeq's 12, so it is the inline form worth
// having here, but it is only DEFINED for a word that is 0 or 1. The
// all-or-nothing flag asserts that of every i1; a per-site build does
// not have to, so it asks facts.go and lets an unproven i1 fall through
// to the zero test — which, for a named site, emitCmpSite still inlines
// as a full-range jeq against zero.
func (fc *funcCtx) emitBoolBranch(cond *llir.Value, ifTrue, ifFalse string) error {
	c, err := fc.op(cond)
	if err != nil {
		return err
	}
	if fc.g.opts.InlineCompares {
		fc.ins("jbool %s, %s, %s", c, ifFalse, ifTrue)
		return nil
	}
	cf := fc.facts.at(fc.curBlock, cond)
	if cf&factBool != 0 && fc.siteInline(fc.peekCmpSite()) {
		fc.label(fc.cmpSiteLabel())
		fc.ins("jbool %s, %s, %s", c, ifFalse, ifTrue)
		return nil
	}
	fc.emitZeroTest(c, cf, ifFalse, ifTrue)
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
