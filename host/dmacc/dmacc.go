// Package dmacc compiles LLVM IR (the clang -Oz subset parsed by llir)
// to dmaasm source. It is the back half of the Phase 4 compiler: clang
// lowers C to IR, dmacc lowers IR to the DMA machine.
//
// Model (prompts/overview.md §4.5): there is no register allocator —
// every SSA value, parameter, and phi gets its own SRAM word, because on
// this machine a spill slot costs exactly as much as a register (words
// whose live ranges never overlap are shared afterwards). Frames are
// static (one per function), so recursion needs a mechanism of its own:
// a software frame stack, plus shallow depth clones and a fork-site
// barrier where an activation can span a fork (computeRecursion). Calls
// follow ABI v0 (args r0–r3, result r0, lr saved to a frame word by
// non-leaf callees). Interruptibility: a safepoint is emitted at every
// backward branch unless Options.NoSafepoints.
//
// The output is SKU-portable .dasm; per-SKU encoding happens in dmaasm.
package dmacc

import (
	"fmt"
	"io"
	"sort"
	"strings"

	"github.com/puhitaku/dma-cpu/host/llir"
)

// Options configures one compilation.
type Options struct {
	Entry          string // entry function, default "main"
	NoSafepoints   bool   // omit safepoints at backward branches
	InlineCompares bool   // inline comparison sequences (faster, much larger)
	Stats          *Stats // when non-nil, collect size attribution
	// RecursionDepth is K, the number of depth CLONES a fork-spanning
	// recursive cycle keeps (default 2: the original plus __r2).
	// Intra-set calls at depth d < K route to depth d+1; at depth K
	// they route into the frame-stack tail copies, which are bounded by
	// FrameStack instead of by K. Where no tail is possible (fork's
	// address is taken — see computeRecursion) K stays a hard bound and
	// depth-K calls reach the overflow sink.
	RecursionDepth int
	FrameStack     int // frame-stack bytes for recursive calls; default 4096
	// XIPText emits flash-immutable text: every self-modified record
	// (block-field patch target) is placed in a trailing .ramtext region
	// instead of inline, so the main text can execute from the XIP window.
	// The runtime and comparison millicode move there wholesale. Assemble
	// the result with Options.RAMTextBase set.
	XIPText bool
	// RAMTextFuncs (XIPText only): these functions and every function
	// they transitively call are emitted into .ramtext. Required for any
	// code that runs while XIP is unavailable — the flash driver's
	// direct-mode session would otherwise fetch its own records through
	// the window it just tore down.
	RAMTextFuncs []string
	// ResidentFuncs (XIPText only): placement-only .ramtext residency,
	// WITHOUT the transitive-closure pull of RAMTextFuncs — callees stay
	// in flash text. For hot paths that must not thrash the XIP cache
	// while the display scans (prompts/036: every machine flash read
	// parks the shared DMA read master against the HSTX FIFO), not for
	// flash-down correctness.
	ResidentFuncs []string
	// RuntimeHost emits the shared-runtime vector page at the start of
	// .ramtext (XIPText only) and force-includes every rt_ routine and
	// __cw_ helper, so guest images built with RuntimeExtern can call
	// them. See vecpage.go for the frozen page layout and the two
	// system properties (event-driven host, safepoint-free bodies)
	// the sharing depends on.
	RuntimeHost bool
	// RuntimeExtern builds a guest image: no local rt_/__cw_ bodies or
	// cells; call sites target the host's page and register file.
	RuntimeExtern *ExternRT
	// OptSize trades execution speed for text size, like -Os: outlined
	// comparison sites shrink to two records via constant descriptors
	// (~9% smaller text) at ~2x the per-branch cost — the unpack is a
	// byte-wise copy plus two indirections. The default (balanced)
	// build keeps the four-move protocol: TestZZBenchXsh showed the
	// descriptor form doubling whole-command cycle counts. It is a
	// per-image switch; which SITES inside the image actually shrink is
	// HotSites' question (or, with no profile, HotFuncs').
	OptSize bool
	// BoundsReport, when non-nil, receives the whole-program value-range
	// report: the final bound of every function parameter and return,
	// and for each parameter the call site whose argument pinned it
	// (facts.go, ipBounds.report). That witness is the diagnosis when a
	// meet dies at one loose site.
	BoundsReport io.Writer

	// NoOutline disables the record-level outliner and its ICF warm-up
	// (outline.go). Both are on by default: text size is what they buy.
	NoOutline bool
	// HotFuncs is the measured hot-function set (host/pgo, regenerate
	// with `make pgo`), consumed twice: the outliner never outlines a
	// hot function (an outlined site pays one or two extra executed
	// records for the jump), and under OptSize a hot function keeps the
	// four-move compare protocol while everything else pays descriptor
	// sites — the latter only while HotSites is empty, since a site
	// profile decides the same question with more resolution.
	// ResidentFuncs, the hand-picked hot list, is unioned in on the
	// outliner side.
	HotFuncs map[string]bool
	// HotSites is the measured hot comparison-SITE set (host/pgo, same
	// `make pgo`), keyed by the site labels compare.go emits —
	// `cws_<function>_<ordinal in emission order>`. With OptSize on and
	// this set non-empty it REPLACES HotFuncs in the compare decision:
	// a named site takes the four-move protocol and every other site
	// takes the descriptor form, whichever function it sits in. Empty
	// means "no profile for this image" and leaves the per-function
	// rule in charge. Names are not validated: a site that no longer
	// exists is simply never asked about (siteFourMove).
	HotSites map[string]bool
	// InlineSites is the measured TOP-of-profile comparison-SITE set
	// (host/pgo, same `make pgo`), keyed exactly like HotSites. A site
	// named here takes neither outlined form: it gets the fully inline
	// jeq/jlt/jltu/jbool macro Options.InlineCompares gives every site,
	// which spends 12-18 records to save the helper jump and the cw_*
	// staging moves. That is a much bigger byte bet than HotSites', so
	// the set is the top few dozen sites of an image, not its top few
	// hundred.
	//
	// Precedence: InlineSites wins wherever an outlined form was legal
	// — over HotSites, over HotFuncs, and in a balanced (non-OptSize)
	// build as well, since the question it answers is "spend bytes for
	// speed HERE", which OptSize does not veto. The one exception is
	// .ramtext code (RAMTextFuncs), which stays outlined for the same
	// reason it stays four-move. Empty means "no profile": the output
	// is then byte-identical to passing no map at all
	// (TestCmpSiteEmptyProfileIsInert). Names are not validated.
	InlineSites map[string]bool

	// ColdBlocks is the measured cold-block set (host/pgo, regenerate
	// with `make pgo`), keyed by emitted block label (`B_<func>_<blk>`,
	// funcCtx.blockLabel). Two consumers, in this order:
	//
	// LAYOUT (funcCtx.layoutOrder). A function's listed blocks sink to
	// the end of its body; everything else keeps its IR order, entry
	// block first. A taken jump into unprefetched XIP parks the shared
	// read master, so pulling never-executed code out from between hot
	// blocks both shortens the prefetch path and turns the hot edges it
	// separated into free fallthroughs (elideFallthroughJumps).
	//
	// THE OUTLINER'S GATE (outline.go, gen.outlineHot). A listed block
	// gives up the loop exemption: code on a CFG cycle normally stays
	// inline because outlining pays a __ol_ret round-trip per iteration,
	// but a loop the workload never entered iterates nothing, so the
	// exemption buys no cycles and costs bytes.
	//
	// Unlisted means hot, so an empty or stale map is safe for both: it
	// costs the layout win and the size win. A stale ENTRY costs cycles
	// on the outliner side (a now-hot loop pays the round-trip) and
	// nothing on layout's. Neither can move a safepoint — backedges are
	// decided on IR order, not on emission order (see funcCtx.backward).
	ColdBlocks map[string]bool
}

// Compile translates a parsed module into dmaasm source. The generated
// program calls Entry from a small crt0, stores its i32 result in the
// exported `exitcode` word, and halts.
func Compile(m *llir.Module, opts Options) (string, error) {
	if opts.Entry == "" {
		opts.Entry = "main"
	}
	m.ResolveAliases()
	g := &gen{m: m, opts: opts, rt: map[string]bool{},
		cmpUsed: map[string]bool{}, cmpUsedD: map[string]bool{}, cmpConst: map[string]string{},
		loopLabels: map[string]bool{}}
	if err := g.run(); err != nil {
		return "", err
	}
	src := foldCopies(g.out.String())
	saved := 0
	if !opts.NoOutline {
		src, saved = olOutline(src, g.outlinable(), g.outlineHot())
	}
	if s := opts.Stats; s != nil {
		s.Folded, s.Outlined = g.icfN, saved
	}
	return src, nil
}

// outlinable names the function entry labels whose code the outliner
// may relocate: every compiled function except the hot set. The gate is
// Options.HotFuncs (the plug for the prompts/042 §1 profile driver)
// unioned with Options.ResidentFuncs, today's hand-picked hot list.
func (g *gen) outlinable() map[string]bool {
	hot := map[string]bool{}
	for _, n := range g.opts.ResidentFuncs {
		hot[n] = true
	}
	for n := range g.opts.HotFuncs {
		hot[n] = true
	}
	out := map[string]bool{}
	for name := range g.funcIdx {
		if !hot[name] {
			out[funcSym(name)] = true
		}
	}
	return out
}

// foldCopies is a text-level peephole over the finished program:
//
//	move A, T        (T a compiler value word, referenced nowhere else)
//	move T, B
//
// becomes `move A, B`. The pattern is the tail of nearly every
// load-then-pass-as-argument sequence; the temp exists only because
// emission is local. Safety comes from three checks: the lines are
// adjacent with no label between (no branch can observe T), both are
// plain two-operand moves (no size/incr flags), and T's whole-program
// reference count is exactly the def and the use. The then-dead
// `T: .word 0` declaration is dropped with it.
func foldCopies(src string) string {
	lines := strings.Split(src, "\n")
	refs := map[string]int{}
	for _, l := range lines {
		for _, tok := range identTokens(l) {
			refs[tok]++
		}
	}
	plainMove := func(l string) (string, string, bool) {
		t := strings.TrimSpace(l)
		if !strings.HasPrefix(t, "move ") {
			return "", "", false
		}
		parts := strings.Split(t[len("move "):], ", ")
		if len(parts) != 2 || strings.ContainsAny(parts[0]+parts[1], " \t") {
			return "", "", false
		}
		return parts[0], parts[1], true
	}
	out := lines[:0]
	for i := 0; i < len(lines); i++ {
		l := lines[i]
		// A reference count of 3 is the declaration, the def, and the
		// single use — nothing else in the program can observe T.
		if a, t, ok := plainMove(l); ok && i+1 < len(lines) &&
			strings.HasPrefix(t, "v_") && refs[t] == 3 && a != t {
			if t2, b, ok2 := plainMove(lines[i+1]); ok2 && t2 == t && b != t && a != b {
				out = append(out, "    move "+a+", "+b)
				i++
				continue
			}
		}
		// T's declaration stays: value words inside a recursion frame
		// are counted into the patched @FR_ sizes, and dropping one
		// would shift unrelated data into the pushed/popped range.
		out = append(out, l)
	}
	return strings.Join(out, "\n")
}

// identTokens yields the identifier-shaped tokens of one line, comments
// excluded.
func identTokens(l string) []string {
	if i := strings.IndexByte(l, ';'); i >= 0 {
		l = l[:i]
	}
	var toks []string
	start := -1
	isIdent := func(c byte, first bool) bool {
		switch {
		case c >= 'a' && c <= 'z', c >= 'A' && c <= 'Z', c == '_':
			return true
		case c >= '0' && c <= '9':
			return !first
		}
		return false
	}
	for i := 0; i <= len(l); i++ {
		if i < len(l) && isIdent(l[i], start < 0) {
			if start < 0 {
				start = i
			}
			continue
		}
		if start >= 0 {
			toks = append(toks, l[start:i])
			start = -1
		}
	}
	return toks
}

type gen struct {
	m    *llir.Module
	opts Options
	out  strings.Builder

	data strings.Builder // .data lines (after .regs)
	text strings.Builder // .text lines (after crt0)
	ram  strings.Builder // .ramtext lines (XIPText: RAM-resident stubs)

	desc      strings.Builder // comparison descriptors (outside frames)
	descWords int             // words in desc (alignment padding)

	rt       map[string]bool   // runtime routines needed
	ramSet   map[string]bool   // functions emitted into .ramtext (XIPText)
	recSet   map[string]bool   // functions using the recursion frame stack
	forkSet  map[string]bool   // functions that can reach fork() (no slot coloring)
	tailSet  map[string]bool   // the fork-spanning frame-stack tail copies (subset of recSet)
	saveSet  map[string]bool   // functions carrying a direct fork call site (vfork barrier)
	frameSz  map[string]int    // measured frame bytes per framed (recSet | saveSet) function
	cmpUsed  map[string]bool   // comparison millicode helpers needed
	cmpUsedD map[string]bool   // descriptor-form helpers needed
	cmpConst map[string]string // $literal operand -> its constant word
	stubN    int               // generated label counter
	funcIdx  map[string]*llir.Func
	maxVar   map[string]int     // variadic callee -> max variadic arg count seen
	facts    map[string]factSet // whole-program value bounds, one set per function

	icfAlias map[string][]string // ICF: representative -> folded-away names
	icfOf    map[string]bool     // ICF: names whose body is not emitted
	icfN     int                 // ICF: functions folded away

	// The tail block: every tail copy's frame, emitted back to back so
	// one burst saves the lot at a fork site (emitForkPush). ftailN
	// counts the tail frames emitted so far — the contiguity check.
	ftailN     int
	ftailBytes int

	// loopLabels: block labels on a CFG cycle. The outliner's hot gate is
	// this minus Options.ColdBlocks (outline.go, gen.outlineHot).
	loopLabels map[string]bool
}

// uartMMIO maps the compiler-known UART globals to dmaasm MMIO operands
// (SKU-resolved at assembly time). C declares them in <dma/mmio.h>.
func uartMMIO(name string) string {
	switch name {
	case "__dma_uart_dr":
		return "%uartdr"
	case "__dma_uart_fr":
		return "%uartfr"
	}
	return ""
}

func (g *gen) run() error {
	g.funcIdx = map[string]*llir.Func{}
	for _, f := range g.m.Funcs {
		g.funcIdx[f.Name] = f
	}
	entry, ok := g.funcIdx[g.opts.Entry]
	if !ok {
		return fmt.Errorf("dmacc: entry function %q is not defined", g.opts.Entry)
	}
	if entry.Ret.Kind != llir.TInt {
		return fmt.Errorf("dmacc: entry function %q must return an integer", g.opts.Entry)
	}
	g.collectGarbage(entry)
	if err := g.computeRecursion(); err != nil {
		return err
	}
	g.ramSet = map[string]bool{}
	if g.opts.XIPText {
		var mark func(name string)
		mark = func(name string) {
			f, ok := g.funcIdx[name]
			if !ok || g.ramSet[name] {
				return
			}
			g.ramSet[name] = true
			for _, b := range f.Blocks {
				for _, ins := range b.Instrs {
					if ins.Op == "call" && ins.Callee != "" && !strings.HasPrefix(ins.Callee, "llvm.") {
						mark(ins.Callee)
					}
				}
			}
		}
		for _, name := range g.opts.RAMTextFuncs {
			if _, ok := g.funcIdx[name]; !ok {
				return fmt.Errorf("dmacc: RAMTextFuncs: %q is not defined", name)
			}
			mark(name)
		}
		for _, name := range g.opts.ResidentFuncs {
			if _, ok := g.funcIdx[name]; !ok {
				return fmt.Errorf("dmacc: ResidentFuncs: %q is not defined", name)
			}
			g.ramSet[name] = true
		}
	}
	// ICF: group functions that lower identically, so the group emits one
	// body under all of its entry labels (outline.go). It runs here —
	// after computeRecursion and the .ramtext split — because both are
	// per-NAME properties the fold has to respect, and because the
	// recursion clones only exist once computeRecursion has made them.
	g.icfAlias = map[string][]string{}
	g.icfOf = map[string]bool{}
	if !g.opts.NoOutline {
		g.icfAlias = g.foldIdentical()
		for _, names := range g.icfAlias {
			for _, n := range names {
				g.icfOf[n] = true
				g.icfN++
			}
		}
	}
	if g.opts.RuntimeHost {
		if !g.opts.XIPText {
			return fmt.Errorf("dmacc: RuntimeHost requires XIPText (the vector page anchors to RAMTextBase)")
		}
		if g.opts.RuntimeExtern != nil {
			return fmt.Errorf("dmacc: RuntimeHost and RuntimeExtern are mutually exclusive")
		}
		g.emitVecPage()
	}
	// Variadic frames are static too: size each callee's vararg area to
	// the largest call in the whole program.
	g.maxVar = map[string]int{}
	for _, f := range g.m.Funcs {
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				if ins.Op != "call" || ins.Callee == "" {
					continue
				}
				if cf, ok := g.funcIdx[ins.Callee]; ok && cf.Variadic {
					if n := len(ins.Args) - len(cf.Params); n > g.maxVar[ins.Callee] {
						g.maxVar[ins.Callee] = n
					}
				}
			}
		}
	}
	// Globals referenced from RAMTextFuncs code must stay resident:
	// that code runs while the XIP window is down, so a flash-homed
	// constant would vanish under it. (Direct references only — the
	// flash-session code is self-contained by the same discipline.)
	ramGlob := map[string]bool{}
	for name := range g.ramSet {
		f := g.funcIdx[name]
		seeG := func(v *llir.Value) {
			if v != nil && v.Kind == llir.VGlobal {
				ramGlob[v.Name] = true
			}
		}
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				for _, a := range ins.Args {
					seeG(a)
				}
				seeG(ins.CalleeVal)
				for _, e := range ins.Phi {
					seeG(e.Val)
				}
			}
		}
	}
	for _, gl := range g.m.Globals {
		if uartMMIO(gl.Name) != "" {
			continue // hardware register, not storage
		}
		if err := g.emitGlobal(gl, g.opts.XIPText && gl.Const && !ramGlob[gl.Name]); err != nil {
			return err
		}
	}
	// The value-range analysis is whole-program (facts.go): parameter
	// seeds are the meet over call sites, so it runs once here — after
	// garbage collection has removed callers that do not exist and after
	// the depth clones are in funcIdx with their calls rerouted — and
	// every emitFunc reads its own function's finished factSet.
	g.facts, _ = g.analyzeBounds()
	for _, f := range g.m.Funcs {
		if g.icfOf[f.Name] {
			continue // folded: its entry label rides the representative
		}
		if err := g.emitFunc(f); err != nil {
			return err
		}
	}
	// Frame sizes are known only after emission: patch the prologue/
	// epilogue placeholders, then emit the frame stack itself.
	if len(g.recSet) > 0 {
		if n := len(g.tailSet); g.ftailN != n {
			return fmt.Errorf("dmacc: %d of %d recursion tail frames emitted", g.ftailN, n)
		}
		text, ram := g.text.String(), g.ram.String()
		patch := func(key string, val int) {
			v := fmt.Sprintf("0x%x", val)
			text = strings.ReplaceAll(text, key, v)
			ram = strings.ReplaceAll(ram, key, v)
		}
		for name, sz := range g.frameSz {
			// The push/pop burst moves whole words: every frame
			// contributor (declWord, alloca, va area) rounds to 4, and
			// data labels are word-aligned, so @FRW_ is exact.
			if sz <= 0 || sz%4 != 0 {
				return fmt.Errorf("dmacc: frame of %q is %d bytes, not a positive word multiple", name, sz)
			}
			patch("@FR_"+sanitize(name)+"@", sz)
			patch("@FRW_"+sanitize(name)+"@", sz/4)
			patch("@FRH_"+sanitize(name)+"@", sz+8)
			// The barrier's own push: this fork caller's frame plus the
			// whole tail block, in that order (emitForkPush).
			patch("@FRV_"+sanitize(name)+"@", sz+g.ftailBytes)
		}
		patch("@FRT@", g.ftailBytes)
		patch("@FRTW@", g.ftailBytes/4)
		g.text.Reset()
		g.text.WriteString(text)
		g.ram.Reset()
		g.ram.WriteString(ram)
		stack := g.frameStackSize()
		fmt.Fprintf(&g.data, "\n; recursion frame stack (push/pop per recSet function)\n")
		fmt.Fprintf(&g.data, "g___dmacc_fsp: .word g___dmacc_fstack\n")
		fmt.Fprintf(&g.data, "fs_lr: .word 0\nfs_r0: .word 0\n")
		fmt.Fprintf(&g.data, "g___dmacc_fstack: .space %d\n", stack)
		if len(g.tailSet) > 0 {
			// The fork-site shadow: one word of the parent's fsp per
			// outstanding vfork (computeRecursion, invariant (ii)).
			// Depth here is process nesting, not recursion depth, so a
			// handful of words is generous — but overflow still diverts
			// to the sink rather than wrapping.
			fmt.Fprintf(&g.data, "\n; vfork fsp shadow (one word per outstanding fork)\n")
			fmt.Fprintf(&g.data, "g___dmacc_fshp: .word g___dmacc_fshadow\n")
			fmt.Fprintf(&g.data, "g___dmacc_fshadow: .space %d\n", 4*forkShadowWords)
		}
		// The overflow sink: a program-defined handler dies as a
		// process; otherwise HALT at a well-defined point.
		fmt.Fprintf(&g.text, "\n__fovf:\n")
		// Reclaim the whole stack before the sink runs: the dying
		// process owns every live push (see computeRecursion). The
		// SHADOW pointer is deliberately left alone — a dying vfork
		// child's suspended parent still owns the slot beneath it, and
		// restoring fsp from that slot is how the parent survives.
		fmt.Fprintf(&g.text, "    move $g___dmacc_fstack, g___dmacc_fsp\n")
		if _, ok := g.funcIdx[recOverflowName]; ok {
			fmt.Fprintf(&g.text, "    jump %s\n", funcSym(recOverflowName))
		} else {
			fmt.Fprintf(&g.text, "    halt\n")
		}
	}

	// Assemble the file: header, data, crt0, functions, runtime.
	w := &g.out
	fmt.Fprintf(w, "; generated by dmacc — do not edit\n")
	fmt.Fprintf(w, ".data\n.regs\nexitcode: .word 0\ndone: .word 0\n")
	fmt.Fprintf(w, "sc0: .word 0\nsc1: .word 0\nsc2: .word 0\n")
	w.WriteString(g.data.String())
	// Comparison descriptors: emitted outside the per-function data so
	// they never land inside a recursion frame region (fr_*
	// contiguity). They are constant, so XIP builds keep them in flash
	// text instead of spending SRAM — appended after the last routine
	// (never reachable by fall-through) and padded to the 8-byte
	// record alignment the .ramtext split relies on.
	if !g.opts.XIPText {
		w.WriteString(g.desc.String())
	}
	fmt.Fprintf(w, "\n.text\n.entry __start\n__start:\n")
	fmt.Fprintf(w, "    move $crtthunk, dispatch\n")
	// warmstart: entry for loaders that preset dispatch themselves
	// (kernel exec, xv6/dma/kproc.c) — skipping the write above closes
	// the race where it would overwrite a just-landed tick patch.
	fmt.Fprintf(w, "warmstart:\n")
	fmt.Fprintf(w, "    call %s\n", funcSym(g.opts.Entry))
	fmt.Fprintf(w, "    move r0, exitcode\n")
	fmt.Fprintf(w, "    move $1, done\n")
	fmt.Fprintf(w, "    halt\n")
	// crtthunk is exported: kernels use it as the dispatch EOI value.
	fmt.Fprintf(w, "crtthunk:\n    jumpr irqresume\n")
	w.WriteString(elideFallthroughJumps(g.text.String()))
	g.emitCmpHelpers()
	if err := g.emitRuntime(); err != nil {
		return err
	}
	if g.opts.XIPText && g.desc.Len() > 0 {
		fmt.Fprintf(w, "\n; --- comparison descriptors (constant flash rodata) ---\n.text\n")
		w.WriteString(g.desc.String())
		if g.descWords%2 != 0 {
			fmt.Fprintf(w, "    .word 0 ; pad to record alignment\n")
		}
	}
	if g.ram.Len() > 0 {
		fmt.Fprintf(w, "\n; --- RAM-resident self-modifying records ---\n.ramtext\n")
		w.WriteString(elideFallthroughJumps(g.ram.String()))
	}
	return nil
}

// collectGarbage drops functions and globals not reachable from the
// entry point — linking libc/ll/*.ll must only cost what the program
// uses. Address-taken functions are reached through value references
// and global initializers, so indirect call targets survive.
func (g *gen) collectGarbage(entry *llir.Func) {
	globIdx := map[string]*llir.Global{}
	for _, gl := range g.m.Globals {
		globIdx[gl.Name] = gl
	}
	reached := map[string]bool{}
	var visitFunc func(*llir.Func)
	var visitSym func(string)
	visitSym = func(name string) {
		if reached["s:"+name] {
			return
		}
		reached["s:"+name] = true
		if f, ok := g.funcIdx[name]; ok {
			visitFunc(f)
		}
		if gl, ok := globIdx[name]; ok && gl.Init != nil {
			var walk func(*llir.Init)
			walk = func(in *llir.Init) {
				if in == nil {
					return
				}
				if in.Sym != "" {
					visitSym(in.Sym)
				}
				for _, e := range in.Elems {
					walk(e)
				}
			}
			walk(gl.Init)
		}
	}
	visitFunc = func(f *llir.Func) {
		if reached["f:"+f.Name] {
			return
		}
		reached["f:"+f.Name] = true
		val := func(v *llir.Value) {
			if v != nil && (v.Kind == llir.VGlobal || v.Kind == llir.VFunc) {
				visitSym(v.Name)
			}
		}
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				for _, a := range ins.Args {
					val(a)
				}
				val(ins.CalleeVal)
				for _, e := range ins.Phi {
					val(e.Val)
				}
				if ins.Op == "call" && ins.Callee != "" && !strings.HasPrefix(ins.Callee, "llvm.") {
					visitSym(ins.Callee)
				}
			}
		}
	}
	visitFunc(entry)
	// A program-defined recursion-overflow sink has no caller yet — the
	// frame-stack overflow stub and the depth-K rewrite that reach it
	// both come after this pass — so keep it as a root.
	if f, ok := g.funcIdx[recOverflowName]; ok {
		visitFunc(f)
	}
	var funcs []*llir.Func
	for _, f := range g.m.Funcs {
		if reached["f:"+f.Name] {
			funcs = append(funcs, f)
		} else {
			delete(g.funcIdx, f.Name)
		}
	}
	g.m.Funcs = funcs
	var globals []*llir.Global
	for _, gl := range g.m.Globals {
		if reached["s:"+gl.Name] {
			globals = append(globals, gl)
		}
	}
	g.m.Globals = globals
}

// computeRecursion splits recursive code three ways (prompts/042 §6).
// Frames are static, so every mechanism here exists to give a second
// activation of the same function somewhere else to keep its words.
//
//   - THE FRAME STACK (g.recSet, the cheap-in-size mechanism): cycle
//     members that cannot reach fork(). One copy of the code; each
//     activation bursts its whole frame to a software stack on entry
//     and restores it on return (emitFramePush/Pop). Depth is bounded
//     only by Options.FrameStack. sh's whole parser lands here.
//   - DEPTH CLONES (the cheap-in-cycles mechanism) for the SHALLOW
//     part of everything that can span a fork: cycle members reaching
//     fork(), plus the vfork-reentrancy extras (non-cyclic
//     fork-reachers reachable from a cycle). Each of the first K
//     depths (Options.RecursionDepth) gets its own copy with its own
//     frame words, so no activation on those depths shares state with
//     any other.
//   - THE TAIL (g.tailSet): one extra copy of each fork-spanning
//     member — minus the members that call fork() directly — compiled
//     in frame-stack mode. Depth-K intra-set calls and every intra-set
//     call inside a tail copy land here, so nesting past K costs
//     FrameStack bytes instead of a whole extra copy of the code, and
//     survives far past the old depth-K sink.
//
// SAFETY. fork() is vfork (target/xv6/PORT.md): the child runs in the
// parent's image, on the parent's frames, until it execs or exits, and
// the parent is suspended inside fork() meanwhile. Three invariants
// make a frame-stacked fork-spanner safe:
//
//	(i) A VFORK CHILD NEVER WRITES BELOW THE SUSPENDED PARENT'S fsp.
//	The child re-emerges from fork() inside fork's direct caller, and
//	direct fork callers are excluded from recSet AND from the tail —
//	they stay depth clones — so the child's return out of that caller
//	moves no frame pointer. Past that point the program's vfork
//	discipline (the same one the pure-clone scheme always relied on)
//	says the child recurses DEEPER and then execs or exits; it never
//	returns out of an activation the parent still owns. So every write
//	the child makes to the frame stack is at or above the parent's fsp,
//	and the parent's saved frames are untouched.
//
//	(ii) THE FORK-SITE BARRIER RESTORES fsp AND THE LIVE TAIL FRAMES
//	REGARDLESS OF WHAT THE CHILD DID. fsp itself is the one piece of
//	hidden compiler state a child can leak upward (it pushes and then
//	execs without popping), and the tail copies' STATIC cells hold the
//	parent's innermost activation of each of them. emitForkPush and
//	emitForkPop bracket every direct fork call with an inline save of
//	both — the fork caller's own frame and the whole tail block onto
//	the frame stack, fsp onto a small shadow stack — restored on the
//	nonzero (parent resume, or fork failure) return and deliberately
//	NOT on the zero (child) return. Nesting works out because a child's
//	own fork sites push and pop above the parent's slot.
//
//	(iii) THE CURRENT ACTIVATION'S CELLS ARE THE PROGRAM'S PROBLEM.
//	Between fork() returning 0 and the child's exec/exit the child runs
//	forward through the callers' live activations, writing their words.
//	That is the vfork contract as written, unchanged by this scheme and
//	identical under pure depth clones.
//
// A child killed mid-flight (SIGINT, the recursion sink) leaks its
// barrier slots on the shadow stack — the same accepted-leak class as
// the parse-depth leak the frame stack has always had.
func (g *gen) computeRecursion() error {
	callees := func(f *llir.Func) []string {
		var out []string
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				if ins.Op == "call" && ins.Callee != "" && !strings.HasPrefix(ins.Callee, "llvm.") {
					if _, ok := g.funcIdx[ins.Callee]; ok {
						out = append(out, ins.Callee)
					}
				}
			}
		}
		return out
	}
	reaches := func(from, target string) bool {
		seen := map[string]bool{}
		var walk func(n string) bool
		walk = func(n string) bool {
			if seen[n] {
				return false
			}
			seen[n] = true
			if n == target {
				return true
			}
			for _, c := range callees(g.funcIdx[n]) {
				if c == target || walk(c) {
					return true
				}
			}
			return false
		}
		for _, c := range callees(g.funcIdx[from]) {
			if c == target || walk(c) {
				return true
			}
		}
		return false
	}
	cyclic := map[string]bool{}
	names := make([]string, 0, len(g.funcIdx))
	for n := range g.funcIdx {
		names = append(names, n)
	}
	sort.Strings(names)
	for _, n := range names {
		if reaches(n, n) {
			cyclic[n] = true
		}
	}
	clone := map[string]bool{}
	_, hasFork := g.funcIdx["fork"]
	if hasFork && len(cyclic) > 0 {
		fromCyclic := map[string]bool{}
		var mark func(n string)
		mark = func(n string) {
			if fromCyclic[n] {
				return
			}
			fromCyclic[n] = true
			for _, c := range callees(g.funcIdx[n]) {
				mark(c)
			}
		}
		for n := range cyclic {
			mark(n)
		}
		for _, n := range names {
			if cyclic[n] && reaches(n, "fork") {
				clone[n] = true
			}
			if !cyclic[n] && fromCyclic[n] && reaches(n, "fork") {
				clone[n] = true
			}
		}
	}
	g.recSet = map[string]bool{}
	for n := range cyclic {
		if !clone[n] {
			g.recSet[n] = true
		}
	}
	// Slot coloring is unsafe in any function that can experience
	// fork()'s double return: the vfork child executes the pid==0
	// path on the SHARED image, writing slots that SSA liveness calls
	// dead on the parent's path, then the parent resumes with them
	// clobbered. Same reachability rule as the clone set.
	g.forkSet = map[string]bool{}
	if hasFork {
		for _, n := range names {
			if reaches(n, "fork") {
				g.forkSet[n] = true
			}
		}
	}
	// Direct fork callers: the functions a vfork child re-emerges
	// inside. Invariant (i) keeps them off both stateful mechanisms —
	// the child returns out of them, and a frame pop there would drop
	// fsp below the suspended parent's and hand the parent a restored
	// lr belonging to the child. They are the barrier sites instead.
	g.saveSet = map[string]bool{}
	if hasFork {
		for _, n := range names {
			for _, c := range callees(g.funcIdx[n]) {
				if c == "fork" {
					g.saveSet[n] = true
				}
			}
		}
		for n := range g.saveSet {
			if g.recSet[n] {
				return fmt.Errorf("dmacc: %q both calls fork() and is frame-stacked "+
					"(a vfork child would pop below the parent's frame pointer)", n)
			}
		}
	}
	g.frameSz = map[string]int{}
	g.tailSet = map[string]bool{}
	if len(clone) == 0 {
		g.saveSet = map[string]bool{} // no fork-spanning frame stack: nothing to protect
		return nil
	}
	return g.expandClones(clone, cyclic)
}

// expandClones builds the shallow clones and the frame-stack tail for
// the fork-spanning set (see computeRecursion): each member is copied
// to depth K = Options.RecursionDepth, intra-set calls at depth d < K
// route to depth d+1, and depth-K calls route into the tail copies
// (suffix __rt), which are compiled in frame-stack mode and route
// intra-set calls to each other. Members that call fork() directly get
// no tail copy — invariant (i) — so a depth-K call to one of them stays
// on the depth-K clone, which the fork-site barrier makes reentrant.
//
// Without a tail — fork's address is taken somewhere, so an indirect
// call could reach it from code the barrier was never emitted into —
// the whole image falls back to pure depth clones with K as a hard
// bound and depth-K calls lowered to the overflow sink.
func (g *gen) expandClones(clone, cyclic map[string]bool) error {
	depth := g.opts.RecursionDepth
	if depth <= 0 {
		depth = 2
	}
	taken := map[string]bool{}
	forkTaken := false
	seeVal := func(v *llir.Value) {
		if v == nil || v.Kind != llir.VFunc && v.Kind != llir.VGlobal {
			return
		}
		if clone[v.Name] {
			taken[v.Name] = true
		}
		if v.Name == "fork" {
			forkTaken = true
		}
	}
	for _, f := range g.m.Funcs {
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				for _, a := range ins.Args {
					seeVal(a)
				}
				for _, e := range ins.Phi {
					seeVal(e.Val)
				}
				seeVal(ins.CalleeVal)
			}
		}
	}
	for n := range taken {
		return fmt.Errorf("dmacc: fork-spanning recursive function %q has its address taken (depth cloning cannot route it)", n)
	}
	cloneNames := make([]string, 0, len(clone))
	for n := range clone {
		cloneNames = append(cloneNames, n)
	}
	sort.Strings(cloneNames)
	// The tail set: fork-spanning members that do not call fork
	// themselves. A member that both calls fork and recurses would need
	// a barrier around a call site whose own frame the barrier is
	// saving, so it disqualifies the tail for the whole image.
	var tailNames []string
	if !forkTaken {
		for _, n := range cloneNames {
			if g.saveSet[n] {
				if cyclic[n] {
					tailNames = nil
					break
				}
				continue
			}
			tailNames = append(tailNames, n)
		}
	}
	if len(tailNames) == 0 {
		g.saveSet = map[string]bool{} // nothing frame-stacked spans a fork
	}
	for _, n := range tailNames {
		g.tailSet[n+recTailSuffix] = true
	}
	// route names the copy an intra-set call to base takes from a copy
	// at depth d (d == depth for the tail copies themselves).
	route := func(base string, d int) string {
		if d < depth {
			return base + recSuffix(d+1)
		}
		if g.tailSet[base+recTailSuffix] {
			return base + recTailSuffix
		}
		if len(g.tailSet) == 0 {
			return "" // no tail: the sink
		}
		return base + recSuffix(depth) // a barrier site, reentrant by save
	}
	rewrite := func(f *llir.Func, d int) {
		for _, b := range f.Blocks {
			for i, ins := range b.Instrs {
				if ins.Op != "call" || !clone[ins.Callee] {
					continue
				}
				ni := *ins
				if to := route(ins.Callee, d); to != "" {
					ni.Callee = to
				} else {
					ni.Callee = recOverflowName
					ni.Args = nil // the sink takes no params (and never returns)
				}
				b.Instrs[i] = &ni
			}
		}
	}
	copyOf := func(orig *llir.Func, name string) *llir.Func {
		nf := &llir.Func{
			Name:     name,
			Ret:      orig.Ret,
			Params:   orig.Params,
			Variadic: orig.Variadic,
			Internal: orig.Internal,
		}
		for _, b := range orig.Blocks {
			nb := &llir.Block{Name: b.Name}
			for _, ins := range b.Instrs {
				ni := *ins
				nb.Instrs = append(nb.Instrs, &ni)
			}
			nf.Blocks = append(nf.Blocks, nb)
		}
		g.m.Funcs = append(g.m.Funcs, nf)
		g.funcIdx[name] = nf
		g.forkSet[name] = true // every copy spans forks by construction
		if g.saveSet[orig.Name] {
			g.saveSet[name] = true // it copied the fork call site too
		}
		return nf
	}
	for _, n := range cloneNames {
		for d := 2; d <= depth; d++ {
			copyOf(g.funcIdx[n], n+recSuffix(d))
		}
	}
	// The tail copies go last and together: their frames must land back
	// to back in .data so one burst saves the whole block (emitFunc
	// checks the contiguity it depends on).
	for _, n := range tailNames {
		tf := copyOf(g.funcIdx[n], n+recTailSuffix)
		g.recSet[tf.Name] = true // frame stack: push on entry, pop on return
	}
	for _, n := range cloneNames {
		for d := 1; d <= depth; d++ {
			rewrite(g.funcIdx[n+recSuffix(d)], d)
		}
	}
	for _, n := range tailNames {
		rewrite(g.funcIdx[n+recTailSuffix], depth)
	}
	return nil
}

const recOverflowName = "__dmacc_recursion_overflow"

// recTailSuffix names the frame-stack tail copy of a fork-spanning
// recursive function (computeRecursion's third mechanism).
const recTailSuffix = "__rt"

func recSuffix(d int) string {
	if d <= 1 {
		return ""
	}
	return fmt.Sprintf("__r%d", d)
}

// --- Naming ---

func sanitize(s string) string {
	var b strings.Builder
	for _, r := range s {
		switch {
		case r == '_' || r >= 'a' && r <= 'z' || r >= 'A' && r <= 'Z' || r >= '0' && r <= '9':
			b.WriteRune(r)
		default:
			b.WriteByte('_')
		}
	}
	return b.String()
}

func funcSym(name string) string { return "f_" + sanitize(name) }

func (g *gen) frameStackSize() int {
	if g.opts.FrameStack > 0 {
		return g.opts.FrameStack
	}
	return 4096
}

// forkShadowWords sizes the fork-site fsp shadow: one word per vfork
// outstanding in this image, which is process nesting depth, bounded in
// practice by the kernel's process table.
const forkShadowWords = 64

func globalSym(name string) string { return "g_" + sanitize(name) }

// --- Globals ---

func (g *gen) emitGlobal(gl *llir.Global, rodata bool) error {
	sym := globalSym(gl.Name)
	size := gl.Typ.Size()
	if size == 0 {
		size = 4
	}
	size = (size + 3) &^ 3
	if gl.Init == nil || gl.Init.Zero {
		fmt.Fprintf(&g.data, "%s: .space %d\n", sym, size)
		return nil
	}
	words, err := g.flattenInit(gl.Init)
	if err != nil {
		return fmt.Errorf("global %s: %v", gl.Name, err)
	}
	// LLVM `constant` globals on an XIP image are flash rodata: they
	// ride the descriptor stream into the text segment (fonts, string
	// tables — read-only by language rule, so SRAM owes them nothing).
	out := &g.data
	if rodata {
		out = &g.desc
		g.descWords += len(words)
	}
	fmt.Fprintf(out, "%s:", sym)
	for _, w := range words {
		if w.sym != "" {
			if w.off != 0 {
				fmt.Fprintf(out, " .word %s+%d\n", w.sym, w.off)
			} else {
				fmt.Fprintf(out, " .word %s\n", w.sym)
			}
		} else {
			fmt.Fprintf(out, " .word 0x%x\n", w.val)
		}
	}
	return nil
}

type wordSpec struct {
	val uint32
	sym string
	off uint32
}

// flattenInit lays an initializer tree out as little-endian words.
func (g *gen) flattenInit(in *llir.Init) ([]wordSpec, error) {
	var bytes []byte
	var refs map[int]wordSpec // byte offset -> reference word
	refs = map[int]wordSpec{}
	var walk func(in *llir.Init, off int) error
	walk = func(in *llir.Init, off int) error {
		t := in.Typ
		grow := func(n int) {
			for len(bytes) < off+n {
				bytes = append(bytes, 0)
			}
		}
		switch {
		case in.Zero:
			grow(t.Size())
		case in.Str != nil:
			grow(len(in.Str))
			copy(bytes[off:], in.Str)
		case in.Sym != "":
			if off%4 != 0 {
				return fmt.Errorf("pointer initializer at unaligned offset %d", off)
			}
			grow(4)
			sym := globalSym(in.Sym)
			if _, isFn := g.funcIdx[in.Sym]; isFn {
				sym = funcSym(in.Sym)
			}
			refs[off] = wordSpec{sym: sym, off: in.SymOff}
		case in.Elems != nil:
			switch t.Kind {
			case llir.TArray:
				es := t.Elem.Size()
				for i, e := range in.Elems {
					if err := walk(e, off+i*es); err != nil {
						return err
					}
				}
			case llir.TStruct:
				for i, e := range in.Elems {
					if err := walk(e, off+t.FieldOffset(i)); err != nil {
						return err
					}
				}
			default:
				return fmt.Errorf("aggregate initializer for non-aggregate")
			}
			grow(t.Size())
		default: // scalar
			n := t.Size()
			if n > 4 {
				return fmt.Errorf("i64 initializers are not supported")
			}
			grow(n)
			v := in.Int
			for i := 0; i < n; i++ {
				bytes[off+i] = byte(v >> (8 * i))
			}
		}
		return nil
	}
	if err := walk(in, 0); err != nil {
		return nil, err
	}
	for len(bytes)%4 != 0 {
		bytes = append(bytes, 0)
	}
	var out []wordSpec
	for i := 0; i < len(bytes); i += 4 {
		if r, ok := refs[i]; ok {
			out = append(out, r)
			continue
		}
		v := uint32(bytes[i]) | uint32(bytes[i+1])<<8 | uint32(bytes[i+2])<<16 | uint32(bytes[i+3])<<24
		out = append(out, wordSpec{val: v})
	}
	return out, nil
}

// elideFallthroughJumps drops `jump L` instructions whose target label
// is the very next line: the branch census found ~10% of all plain
// jumps land on their own successor (if/else joins, loop exits), and
// each costs a record, a pool word, and three transfer beats for
// nothing. Any label naming the elided jump simply aliases L — same
// destination, so other jumpers are unaffected. The one hazard is a
// block-field reference (`X.read` etc.) to a label whose first record
// was the jump: those labels are left alone.
func elideFallthroughJumps(text string) string {
	lines := strings.Split(text, "\n")
	// labels referenced with a block-field suffix anywhere
	fieldRef := map[string]bool{}
	for _, l := range lines {
		for _, f := range []string{".read", ".write", ".count", ".ctrl"} {
			for i := strings.Index(l, f); i >= 0; {
				j := i
				for j > 0 && (isSymChar(l[j-1])) {
					j--
				}
				if j < i {
					fieldRef[l[j:i]] = true
				}
				next := strings.Index(l[i+1:], f)
				if next < 0 {
					break
				}
				i += 1 + next
			}
		}
	}
	out := make([]string, 0, len(lines))
	for i := 0; i < len(lines); i++ {
		l := strings.TrimSpace(lines[i])
		if strings.HasPrefix(l, "jump ") && !strings.Contains(l, ",") {
			tgt := strings.TrimSpace(strings.TrimPrefix(l, "jump "))
			// next non-empty line must be exactly the target label
			k := i + 1
			for k < len(lines) && strings.TrimSpace(lines[k]) == "" {
				k++
			}
			if k < len(lines) && strings.TrimSpace(lines[k]) == tgt+":" {
				// a label immediately above the jump would alias the
				// target — safe, unless block-field-addressed
				safe := true
				if len(out) > 0 {
					prev := strings.TrimSpace(out[len(out)-1])
					if strings.HasSuffix(prev, ":") && fieldRef[strings.TrimSuffix(prev, ":")] {
						safe = false
					}
				}
				if safe {
					continue // drop the jump
				}
			}
		}
		out = append(out, lines[i])
	}
	return strings.Join(out, "\n")
}

func isSymChar(c byte) bool {
	return c == '_' || c == '.' && false ||
		c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9'
}
