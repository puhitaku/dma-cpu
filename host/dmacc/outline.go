package dmacc

import (
	"fmt"
	"sort"
	"strings"

	"github.com/puhitaku/dma-cpu/host/llir"
)

// The record-level outliner (prompts/042 §4), plus its ICF warm-up.
// The outliner is a text pass over the finished program (olOutline);
// ICF runs earlier, on the IR, and is documented at foldIdentical.
//
// MECHANISM. The comparison millicode is hand-made outlining: a site
// parks what the helper needs in shared cells and jumps into a body that
// never returns through a call protocol. This pass generalizes that to
// arbitrary repeated code. It runs post-lowering over the finished .dasm
// text — the same layer as foldCopies and elideFallthroughJumps — and
// works on INSTRUCTIONS, not raw records, because the instruction is the
// machine's safe boundary: the compact planner canonicalizes state
// (plain bank, all counts 1) at every one of them, so a helper entered
// by a jump and left by a jump behaves exactly like any other code.
//
// Two site forms, both without an lr chain:
//
//	tail   the run ends in a control transfer (jump/jumpr/ret/halt) that
//	       is the same at every occurrence, so the helper IS the branch.
//	       The site is one record: `jump __ol_N`. Nothing is parked.
//	open   the run continues after the outlined part. The site parks its
//	       resume label in the shared word __ol_ret (1 record) and jumps
//	       (1 record); the helper ends `jumpr __ol_ret`.
//
// SAFETY CONDITIONS, all enforced when candidate runs are built:
//
//   - No label inside a run. A label is the only way control can enter
//     the middle of a straight-line stretch, and it is also how a record
//     is named as a patch target — so "no labels" covers both re-entry
//     and self-modifying code in one test.
//   - No block-field reference (`X.read`, `X.write`, `.count`, `.ctrl`)
//     and no unresolved `@`-placeholder operand. Those instructions
//     write into another instruction's records; the pass does not
//     reason about that, so it does not move them.
//   - No `call` and no `safepoint`. Both would keep __ol_ret live across
//     code that can re-enter the outliner's cell or take an interrupt.
//     With them excluded, the window from the park to the helper's
//     `jumpr` contains no safepoint at all, which is what makes one
//     shared cell enough — the same argument compare.go makes for
//     cw_t/cw_f under approach-B interrupts.
//   - Only whitelisted mnemonics; anything unrecognized ends the run.
//   - A control transfer may only be a run's LAST instruction, and then
//     the run is a tail candidate.
//   - Runs never cross a section boundary, so a .ramtext site never
//     jumps into a .text helper: RAMTextFuncs code runs while the XIP
//     window is down and must not fetch from flash.
//   - Only code owned by a compiled function is eligible. The crt0, the
//     rt_/__cw_ bodies and the shared-runtime vector page are entered
//     from other images at frozen addresses, so they are left alone.
//
// COSTING. dmacc emits SKU- and encoding-portable .dasm; it does not
// know whether dmaasm will assemble classic 16-byte blocks or compact
// 8-byte records. olRecs therefore holds the CLASSIC record count of
// each instruction, which is <= the compact one for every mnemonic
// (measured), and the byte arithmetic uses the compact record width of
// 8 — so a candidate that pays under this model pays under both
// encodings. Literal-pool words (4 bytes) are counted too: a tail site
// adds one pooled address, an open site adds one per site.
//
// GATE. Outlining trades one or two executed records per site for its
// bytes, so hot code must not pay it. Three filters, one measured:
//
//	LOOPS     a block that lies on a CFG cycle is not outlined
//	          (loopBlocks). Ungated, the pass cost 2.0% of the xsh
//	          five-command warm sum and 2.3% of the vi burst; the loop
//	          filter takes both back to nothing, because what repeats
//	          most — the `shl sc0, sc0` chains of a constant multiply —
//	          is exactly what loops re-execute.
//	COLD      …unless the profile MEASURED that block cold. A loop that
//	          never iterated once during its image's workload re-executes
//	          nothing, so its exemption buys nothing and costs bytes:
//	          Options.ColdBlocks (the same set that drives block layout)
//	          hands the exemption back. See outlineHot.
//	FUNCTIONS Options.HotFuncs is never outlined, unioned with
//	          Options.ResidentFuncs (the hand-picked hot set). HotFuncs
//	          is the measured set from prompts/042 §1; since §10 (c)
//	          moved the compare decision onto Options.HotSites, gating
//	          this pass is the only job it still has.
//
// PIPELINE ORDER, because two transforms now read Options.ColdBlocks.
// funcCtx.layoutOrder reads it over the IR and decides where a block's
// finished text is PLACED; this pass reads it over the finished .dasm,
// after layoutOrder, elideFallthroughJumps and foldCopies have all run.
// So layout sees blocks, the outliner sees placed text — the two cannot
// fight over the same decision. They do not interact through position
// either: olRuns flushes at every `B_` label, so a candidate run never
// spans two blocks whatever order they were placed in, and matching is
// by content, not by adjacency. What sinking does for this pass is
// second-order and in its favour: the cold blocks it just unlocked end
// up contiguous at the function tail, so the helper calls that replace
// them sit out of the hot prefetch path too.

// olMaxK bounds the length of an outlined sequence, in instructions.
const olMaxK = 40

// olRecs is the CLASSIC record count per instruction (see COSTING).
var olRecs = map[string]int{
	"move": 1, "add": 3, "sub": 5, "or": 3, "xor": 3, "and": 6,
	"andn": 3, "shl": 3, "mulc": 3, "nop": 1,
	"jump": 1, "jumpr": 1, "ret": 1, "halt": 1,
}

// olTerm are the instructions after which control does not fall
// through: a run may end on one, and then the helper needs no return.
var olTerm = map[string]bool{"jump": true, "jumpr": true, "ret": true, "halt": true}

// olRetCell is the shared word an open site parks its resume label in.
const olRetCell = "__ol_ret"

const (
	olSecNone = iota
	olSecData
	olSecText
	olSecRam
)

const (
	olOther = iota
	olLabelLine
	olInstrLine
	olDirLine
	olCommentLine
)

type olLine struct {
	raw  string
	kind int
	sec  int
	text string // instruction: trimmed, comment-free
	mnem string
	lbl  string
}

// olParse splits the program into classified lines. dmacc's own output
// is the only input, so the grammar it has to cover is small: section
// directives, bare labels, indented instructions, and `.word`/`.space`
// data (which always carries a `:` or a leading `.`).
func olParse(src string) []olLine {
	raw := strings.Split(src, "\n")
	out := make([]olLine, len(raw))
	sec := olSecNone
	for i, r := range raw {
		l := olLine{raw: r}
		t := r
		if j := strings.IndexByte(t, ';'); j >= 0 {
			t = t[:j]
		}
		t = strings.TrimSpace(t)
		switch {
		case t == "":
			if strings.Contains(r, ";") {
				l.kind = olCommentLine
			}
		case strings.HasPrefix(t, "."):
			l.kind = olDirLine
			switch t {
			case ".data":
				sec = olSecData
			case ".text":
				sec = olSecText
			case ".ramtext":
				sec = olSecRam
			}
		case strings.HasSuffix(t, ":") && !strings.ContainsAny(t, " \t"):
			l.kind = olLabelLine
			l.lbl = t[:len(t)-1]
		case (sec == olSecText || sec == olSecRam) && !strings.Contains(t, ":"):
			l.kind = olInstrLine
			l.text = t
			l.mnem = t
			if j := strings.IndexByte(l.mnem, ' '); j >= 0 {
				l.mnem = l.mnem[:j]
			}
		}
		l.sec = sec
		out[i] = l
	}
	return out
}

// olMovable reports whether an instruction may be relocated into a
// helper: a known mnemonic that neither addresses another instruction's
// record fields nor carries an unresolved placeholder operand.
func olMovable(l *olLine) bool {
	if olRecs[l.mnem] == 0 {
		return false
	}
	for _, f := range []string{".read", ".write", ".count", ".ctrl"} {
		if strings.Contains(l.text, f) {
			return false
		}
	}
	// `@0x1234` is an ordinary absolute operand (guest images address the
	// host's register file that way); any other `@` is a patch
	// placeholder or a record-relative operand.
	for i := strings.IndexByte(l.text, '@'); i >= 0; {
		if !strings.HasPrefix(l.text[i:], "@0x") {
			return false
		}
		j := strings.IndexByte(l.text[i+1:], '@')
		if j < 0 {
			break
		}
		i += 1 + j
	}
	return true
}

type olRun struct {
	sec  int
	at   []int // line indices, contiguous and in order
	term bool  // the last instruction is a control transfer
}

// outlineHot is the pass's block-level gate: the emitted labels whose
// code stays inline. That is gen.loopLabels — every block on a CFG
// cycle (funcCtx.emit fills it through blockLabel, the same spelling
// Options.ColdBlocks is keyed in) — MINUS the blocks the profile
// measured cold.
//
// Why the subtraction is sound. The loop exemption is a proxy, and the
// thing it proxies for is "this code re-executes, so the round-trip
// through __ol_ret is paid per iteration". A block the workload fetched
// zero words of executed zero iterations, so the proxy is answering for
// a loop that did not run: the exemption buys no cycles and costs the
// bytes the outliner would otherwise have taken. The measurement wins
// over the structure wherever it exists.
//
// The fail-safe direction is the mirror of layout's, and deliberately
// so. For layout an unlisted block is left where it is, so a stale set
// costs a lost optimization; here an unlisted block keeps its
// exemption, so a stale set costs the same lost optimization. What a
// stale set can do is name a block that has since become hot, and then
// its loop pays one or two extra records per iteration — cycles, never
// correctness. Nothing here can move a safepoint (those are decided
// during IR-order lowering, funcCtx.backward) and nothing here relaxes
// a safety condition in olRuns: a cold block's code still has to be
// relocatable to be moved at all.
//
// Blocks of functions the workload never ENTERED are not in ColdBlocks
// — the generator lists only blocks inside functions it saw execute —
// so those loops keep the structural exemption. That is measured and
// left alone on purpose; prompts/042 §1 has the numbers and the reason.
//
// An empty ColdBlocks (no profile) subtracts nothing, so the gate is
// exactly today's and the output is byte-identical: TestOutlineColdOff.
func (g *gen) outlineHot() map[string]bool {
	if len(g.opts.ColdBlocks) == 0 {
		return g.loopLabels
	}
	hot := make(map[string]bool, len(g.loopLabels))
	for l := range g.loopLabels {
		if !g.opts.ColdBlocks[l] {
			hot[l] = true
		}
	}
	return hot
}

// loopBlocks names the blocks of f that lie on a CFG cycle — the
// machine's loop bodies, and the outliner's hot-code proxy. A block is
// on a cycle exactly when it can reach itself through its successors.
func loopBlocks(f *llir.Func) map[string]bool {
	succ := map[string][]string{}
	for _, b := range f.Blocks {
		var out []string
		for _, ins := range b.Instrs {
			out = append(out, ins.Labels...)
			for _, c := range ins.Cases {
				out = append(out, c.Label)
			}
		}
		succ[b.Name] = out
	}
	loop := map[string]bool{}
	for _, b := range f.Blocks {
		seen := map[string]bool{}
		var walk func(string) bool
		walk = func(n string) bool {
			if n == b.Name {
				return true
			}
			if seen[n] {
				return false
			}
			seen[n] = true
			for _, s := range succ[n] {
				if walk(s) {
					return true
				}
			}
			return false
		}
		for _, s := range succ[b.Name] {
			if walk(s) {
				loop[b.Name] = true
				break
			}
		}
	}
	return loop
}

// olRuns collects the maximal straight-line stretches that satisfy every
// safety condition in the file comment. eligible names the function
// entry labels whose code may be outlined; hot names the block labels
// (loop bodies) that end eligibility until the next block starts.
func olRuns(lines []olLine, eligible, hot map[string]bool) []olRun {
	var runs []olRun
	var cur []int
	sec := olSecNone
	next := -1 // line a run's next instruction must occupy to extend it
	inFunc, owned := false, false
	flush := func(term bool) {
		if len(cur) >= 2 {
			runs = append(runs, olRun{sec: sec, at: cur, term: term})
		}
		cur = nil
	}
	for i := range lines {
		l := &lines[i]
		switch l.kind {
		case olInstrLine:
			if !owned || !olMovable(l) {
				flush(false)
				continue
			}
			if len(cur) > 0 && i != next {
				flush(false)
			}
			sec = l.sec
			cur = append(cur, i)
			next = i + 1
			if olTerm[l.mnem] {
				flush(true)
			}
		case olLabelLine:
			// Compare-site labels (compare.go, cmpSiteLabel) are profile
			// markers: nothing jumps to them and nothing addresses their
			// records, so they are not the re-entry the "no label inside
			// a run" rule guards against. Stepping over one keeps the
			// site's moves in the same candidate run as the code that
			// computed its operands — without this the marker would cost
			// text by splitting runs that used to be whole. An outlined
			// range swallows the marker with the instructions around it,
			// so the site loses its name in the profile; that is the
			// right outcome, since outlined code is cold code by
			// construction and a name it cannot use would only tempt the
			// driver to promote it.
			if strings.HasPrefix(l.lbl, "cws_") {
				if i == next {
					next = i + 1
				}
				continue
			}
			flush(false)
			switch {
			case strings.HasPrefix(l.lbl, "f_"):
				inFunc = eligible[l.lbl]
				owned = inFunc
			case strings.HasPrefix(l.lbl, "__"):
				inFunc, owned = false, false
			case strings.HasPrefix(l.lbl, "B_"):
				owned = inFunc && !hot[l.lbl]
			}
		case olDirLine, olCommentLine:
			flush(false)
			inFunc, owned = false, false
		}
	}
	flush(false)
	return runs
}

// --- candidate mining ---

type olCand struct {
	k    int
	pos  []int // slot indices of the occurrences, ascending
	recs int   // classic records of one copy
	term bool
	save int // bytes saved if every occurrence is taken
}

// olSave prices a candidate: n occurrences of a body worth recs classic
// records, at 8 bytes per record plus 4 bytes per literal-pool word.
func olSave(n, recs int, term bool) int {
	if n < 2 {
		return 0
	}
	if term {
		// site: `jump __ol_N`; helper: the body itself.
		return 8*(n*recs-n-recs) - 4
	}
	// site: park + jump; helper: the body plus `jumpr __ol_ret`.
	return 8*(n*recs-2*n-recs-1) - 4*n - 4
}

// olOutline is the pass. It returns the rewritten program and the
// number of bytes it expects to have saved.
func olOutline(src string, eligible, hot map[string]bool) (string, int) {
	lines := olParse(src)
	runs := olRuns(lines, eligible, hot)
	if len(runs) == 0 {
		return src, 0
	}

	// Flatten every run into one slot array; a candidate is a repeated
	// id sequence that never crosses a run boundary.
	type slot struct{ run, line int }
	var slots []slot
	var runEnd []int
	ids := map[string]int{}
	var seq []int
	for ri, r := range runs {
		for _, li := range r.at {
			t := lines[li].text
			id, ok := ids[t]
			if !ok {
				id = len(ids)
				ids[t] = id
			}
			slots = append(slots, slot{ri, li})
			seq = append(seq, id)
		}
		runEnd = append(runEnd, len(slots))
	}
	end := func(i int) int { return runEnd[slots[i].run] }

	// Sort suffixes (bounded by olMaxK and by the run end), then read
	// repeats off the adjacent-suffix common prefixes.
	order := make([]int, len(slots))
	for i := range order {
		order[i] = i
	}
	common := func(a, b int) int {
		ea, eb := end(a), end(b)
		for d := 0; d < olMaxK; d++ {
			if a+d >= ea || b+d >= eb || seq[a+d] != seq[b+d] {
				return d
			}
		}
		return olMaxK
	}
	sort.Slice(order, func(x, y int) bool {
		a, b := order[x], order[y]
		ea, eb := end(a), end(b)
		for d := 0; d < olMaxK; d++ {
			ta, tb := a+d >= ea, b+d >= eb
			if ta || tb {
				if ta != tb {
					return ta // a prefix sorts before its extension
				}
				break
			}
			if seq[a+d] != seq[b+d] {
				return seq[a+d] < seq[b+d]
			}
		}
		return a < b
	})
	lcp := make([]int, len(order))
	for t := 1; t < len(order); t++ {
		lcp[t] = common(order[t-1], order[t])
	}

	var cands []olCand
	for k := 2; k <= olMaxK; k++ {
		for s := 0; s < len(order); {
			e := s
			for e+1 < len(order) && lcp[e+1] >= k {
				e++
			}
			if e > s {
				p := order[s]
				recs := 0
				for d := 0; d < k; d++ {
					recs += olRecs[lines[slots[p+d].line].mnem]
				}
				term := olTerm[lines[slots[p+k-1].line].mnem]
				n := e - s + 1
				if sv := olSave(n, recs, term); sv > 0 {
					pos := append([]int(nil), order[s:e+1]...)
					sort.Ints(pos)
					cands = append(cands, olCand{k, pos, recs, term, sv})
				}
			}
			s = e + 1
		}
	}
	if len(cands) == 0 {
		return src, 0
	}
	// Best-first, deterministic: biggest saving, then longest body, then
	// earliest occurrence.
	sort.Slice(cands, func(i, j int) bool {
		a, b := cands[i], cands[j]
		if a.save != b.save {
			return a.save > b.save
		}
		if a.k != b.k {
			return a.k > b.k
		}
		return a.pos[0] < b.pos[0]
	})

	used := make([]bool, len(slots))
	type site struct {
		last   int    // last line index of the replaced range
		helper string // helper label
		ret    string // resume label ("" for the tail form)
	}
	sites := map[int]*site{}
	type helper struct {
		name string
		sec  int
		body []int // slot indices of one copy
		term bool
	}
	var helpers []helper
	saved, retN := 0, 0
	for _, c := range cands {
		var take []int
		for _, p := range c.pos {
			free := true
			for d := 0; d < c.k; d++ {
				if used[p+d] {
					free = false
					break
				}
			}
			if free {
				for d := 0; d < c.k; d++ {
					used[p+d] = true
				}
				take = append(take, p)
			}
		}
		sv := olSave(len(take), c.recs, c.term)
		if sv <= 0 {
			for _, p := range take {
				for d := 0; d < c.k; d++ {
					used[p+d] = false
				}
			}
			continue
		}
		h := helper{name: fmt.Sprintf("__ol_%d", len(helpers)+1),
			sec: runs[slots[take[0]].run].sec, body: nil, term: c.term}
		for d := 0; d < c.k; d++ {
			h.body = append(h.body, take[0]+d)
		}
		helpers = append(helpers, h)
		for _, p := range take {
			s := &site{last: slots[p+c.k-1].line, helper: h.name}
			if !c.term {
				retN++
				s.ret = fmt.Sprintf("__olr_%d", retN)
			}
			sites[slots[p].line] = s
		}
		saved += sv
	}
	if len(helpers) == 0 {
		return src, 0
	}

	// Rewrite the sites.
	out := make([]string, 0, len(lines)+64)
	for i := 0; i < len(lines); i++ {
		s := sites[i]
		if s == nil {
			out = append(out, lines[i].raw)
			continue
		}
		if s.ret != "" {
			out = append(out, fmt.Sprintf("    move $%s, %s", s.ret, olRetCell))
		}
		out = append(out, "    jump "+s.helper)
		if s.ret != "" {
			out = append(out, s.ret+":")
		}
		i = s.last
	}

	// Helper bodies, per section: a .ramtext site must never jump into
	// flash text.
	bodies := map[int][]string{}
	needCell := false
	for _, h := range helpers {
		b := bodies[h.sec]
		b = append(b, h.name+":")
		for _, si := range h.body {
			b = append(b, "    "+lines[slots[si].line].text)
		}
		if !h.term {
			b = append(b, "    jumpr "+olRetCell)
			needCell = true
		}
		bodies[h.sec] = b
	}
	res := olParse(strings.Join(out, "\n"))
	for _, sec := range []int{olSecText, olSecRam} {
		if len(bodies[sec]) == 0 {
			continue
		}
		blk := append([]string{"", "; --- outlined instruction sequences (outline.go) ---"}, bodies[sec]...)
		out = olInsert(out, res, sec, blk, true)
		res = olParse(strings.Join(out, "\n"))
	}
	if needCell {
		out = olInsert(out, res, olSecData, []string{olRetCell + ": .word 0 ; outliner resume cell"}, false)
	}
	return strings.Join(out, "\n"), saved
}

// olInsert appends block at the end of the last chunk of section sec.
// guard adds a halt when the preceding instruction would otherwise fall
// through into the block.
func olInsert(out []string, lines []olLine, sec int, block []string, guard bool) []string {
	last := -1
	for i := range lines {
		if lines[i].sec == sec && lines[i].kind != olCommentLine &&
			strings.TrimSpace(lines[i].raw) != "" {
			last = i
		}
	}
	if last < 0 {
		return out
	}
	if guard && lines[last].kind == olInstrLine && !olTerm[lines[last].mnem] {
		block = append([]string{"    halt ; no fall-through into the helpers"}, block...)
	}
	res := make([]string, 0, len(out)+len(block))
	res = append(res, out[:last+1]...)
	res = append(res, block...)
	return append(res, out[last+1:]...)
}

// --- ICF: identical code folding ---

// icfKey renders a function in a form that two functions share exactly
// when they lower to the same records: local names and block labels are
// numbered by first appearance, everything else — opcodes, types,
// constants, globals, callees — is spelled out. Codegen reads nothing
// else, so equal keys mean interchangeable bodies.
func icfKey(f *llir.Func) string {
	var b strings.Builder
	loc := map[string]int{}
	blk := map[string]int{}
	for i, bb := range f.Blocks {
		blk[bb.Name] = i
	}
	name := func(n string) string {
		i, ok := loc[n]
		if !ok {
			i = len(loc)
			loc[n] = i
		}
		return fmt.Sprintf("%%%d", i)
	}
	typ := func(t *llir.Type) string {
		if t == nil {
			return "-"
		}
		return t.String()
	}
	lbl := func(l string) string {
		if i, ok := blk[l]; ok {
			return fmt.Sprintf("L%d", i)
		}
		return "L?" + l
	}
	val := func(v *llir.Value) string {
		if v == nil {
			return "-"
		}
		switch v.Kind {
		case llir.VLocal:
			return name(v.Name) + ":" + typ(v.Typ)
		case llir.VGlobal:
			return fmt.Sprintf("@%s+%d:%s", v.Name, v.Off, typ(v.Typ))
		case llir.VFunc:
			return "&" + v.Name
		}
		return fmt.Sprintf("#%d:%s", v.Int, typ(v.Typ))
	}
	fmt.Fprintf(&b, "ret %s var %v\n", typ(f.Ret), f.Variadic)
	for _, p := range f.Params {
		fmt.Fprintf(&b, "p %s %s\n", name(p.Name), typ(p.Typ))
	}
	for _, bb := range f.Blocks {
		fmt.Fprintf(&b, "block %d\n", blk[bb.Name])
		for _, ins := range bb.Instrs {
			fmt.Fprintf(&b, " %s", ins.Op)
			if ins.Res != "" {
				fmt.Fprintf(&b, " =%s", name(ins.Res))
			}
			fmt.Fprintf(&b, " t=%s pred=%s to=%s callee=%s cv=%s fixed=%d alloc=%d",
				typ(ins.Typ), ins.Pred, typ(ins.To), ins.Callee, val(ins.CalleeVal),
				ins.FixedArgs, ins.AllocN)
			for _, a := range ins.Args {
				fmt.Fprintf(&b, " %s", val(a))
			}
			for _, l := range ins.Labels {
				fmt.Fprintf(&b, " %s", lbl(l))
			}
			for _, c := range ins.Cases {
				fmt.Fprintf(&b, " c%d:%s", c.Val, lbl(c.Label))
			}
			for _, e := range ins.Phi {
				fmt.Fprintf(&b, " phi[%s from %s]", val(e.Val), lbl(e.Pred))
			}
			b.WriteByte('\n')
		}
	}
	return b.String()
}

// foldIdentical groups functions that lower identically. The group's
// representative keeps the body; the others contribute only their entry
// label, emitted immediately above it — so every symbol still resolves
// at its own name and nothing outside dmacc can tell the difference.
//
// Three things pin a function out of the folding:
//
//   - its address is taken. C gives distinct functions distinct
//     addresses, and a shared body cannot;
//   - it is variadic. The caller fills the callee's static va area, so
//     the two would have to share that too;
//   - it can reach fork(). Sharing a body means sharing its value
//     words, and the whole point of the fork-spanning half of
//     computeRecursion is that two activations of the same code can be
//     live at once there — a vfork child runs on the shared image while
//     the parent is suspended inside its own activation. Folding the
//     depth clones back together is exactly the aliasing the cloning
//     was built to prevent (measured: sh's `echo one; echo two` ran the
//     second command twice);
//   - it differs from the representative in recursion-frame or
//     .ramtext membership. Those are properties of the NAME, decided
//     before emission, and codegen reads them.
func (g *gen) foldIdentical() map[string][]string {
	taken := map[string]bool{}
	for _, f := range g.m.Funcs {
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				for _, a := range ins.Args {
					if a != nil && (a.Kind == llir.VFunc || a.Kind == llir.VGlobal) {
						taken[a.Name] = true
					}
				}
				if v := ins.CalleeVal; v != nil {
					taken[v.Name] = true
				}
				for _, e := range ins.Phi {
					if e.Val != nil && (e.Val.Kind == llir.VFunc || e.Val.Kind == llir.VGlobal) {
						taken[e.Val.Name] = true
					}
				}
			}
		}
	}
	for _, gl := range g.m.Globals {
		var walk func(*llir.Init)
		walk = func(in *llir.Init) {
			if in == nil {
				return
			}
			if in.Sym != "" {
				taken[in.Sym] = true
			}
			for _, e := range in.Elems {
				walk(e)
			}
		}
		walk(gl.Init)
	}
	pinned := map[string]bool{g.opts.Entry: true, recOverflowName: true}
	for _, n := range g.opts.RAMTextFuncs {
		pinned[n] = true
	}
	for _, n := range g.opts.ResidentFuncs {
		pinned[n] = true
	}
	rep := map[string]string{}
	alias := map[string][]string{}
	for _, f := range g.m.Funcs {
		if f.Variadic || taken[f.Name] || pinned[f.Name] ||
			g.forkSet[f.Name] || len(f.Blocks) == 0 {
			continue
		}
		key := fmt.Sprintf("%v|%v|%s", g.recSet[f.Name], g.ramSet[f.Name], icfKey(f))
		if r, ok := rep[key]; ok {
			alias[r] = append(alias[r], f.Name)
			continue
		}
		rep[key] = f.Name
	}
	return alias
}
