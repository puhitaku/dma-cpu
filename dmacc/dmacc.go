// Package dmacc compiles LLVM IR (the clang -O1 subset parsed by llir)
// to dmaasm source. It is the back half of the Phase 4 compiler: clang
// lowers C to IR, dmacc lowers IR to the DMA machine.
//
// Model (prompts/overview.md §4.5): there is no register allocator —
// every SSA value, parameter, and phi gets its own SRAM word, because on
// this machine a spill slot costs exactly as much as a register. Frames
// are static (one per function), so v0 rejects recursion; calls follow
// ABI v0 (args r0–r3, result r0, lr saved to a frame word by non-leaf
// callees). Interruptibility: a safepoint is emitted at every backward
// branch unless Options.NoSafepoints.
//
// The output is SKU-portable .dasm; per-SKU encoding happens in dmaasm.
package dmacc

import (
	"fmt"
	"sort"
	"strings"

	"github.com/puhitaku/dma-cpu/llir"
)

// Options configures one compilation.
type Options struct {
	Entry          string // entry function, default "main"
	NoSafepoints   bool   // omit safepoints at backward branches
	InlineCompares bool   // inline comparison sequences (faster, much larger)
	Stats          *Stats // when non-nil, collect size attribution
	RecursionDepth int    // OBSOLETE: recursion now uses the frame stack
	FrameStack     int    // frame-stack bytes for recursive calls; default 4096
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
	// OptSize trades execution speed for text size, like -Os: outlined
	// comparison sites shrink to two records via constant descriptors
	// (~9% smaller text) at ~2x the per-branch cost — the unpack is a
	// byte-wise copy plus two indirections. The default (balanced)
	// build keeps the four-move protocol: TestZZBenchXsh showed the
	// descriptor form doubling whole-command cycle counts.
	OptSize bool
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
		cmpUsed: map[string]bool{}, cmpUsedD: map[string]bool{}, cmpConst: map[string]string{}}
	if err := g.run(); err != nil {
		return "", err
	}
	return foldCopies(g.out.String()), nil
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
	frameSz  map[string]int    // measured frame bytes per recSet function
	cmpUsed  map[string]bool   // comparison millicode helpers needed
	cmpUsedD map[string]bool   // descriptor-form helpers needed
	cmpConst map[string]string // $literal operand -> its constant word
	stubN    int               // generated label counter
	funcIdx  map[string]*llir.Func
	maxVar   map[string]int // variadic callee -> max variadic arg count seen
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
	for _, gl := range g.m.Globals {
		if uartMMIO(gl.Name) != "" {
			continue // hardware register, not storage
		}
		if gl.Name == "__dmacc_fsp" || gl.Name == "__dmacc_fstack" {
			continue // the frame-stack cells are compiler-emitted
		}
		if err := g.emitGlobal(gl); err != nil {
			return err
		}
	}
	for _, f := range g.m.Funcs {
		if err := g.emitFunc(f); err != nil {
			return err
		}
	}
	// Frame sizes are known only after emission: patch the prologue/
	// epilogue placeholders, then emit the frame stack itself.
	if len(g.recSet) > 0 {
		text, ram := g.text.String(), g.ram.String()
		for name, sz := range g.frameSz {
			for _, ph := range []struct {
				key, val string
			}{
				{"@FR_" + sanitize(name) + "@", fmt.Sprintf("0x%x", sz)},
				{"@FRH_" + sanitize(name) + "@", fmt.Sprintf("0x%x", sz+8)},
			} {
				text = strings.ReplaceAll(text, ph.key, ph.val)
				ram = strings.ReplaceAll(ram, ph.key, ph.val)
			}
		}
		g.text.Reset()
		g.text.WriteString(text)
		g.ram.Reset()
		g.ram.WriteString(ram)
		stack := g.frameStackSize()
		fmt.Fprintf(&g.data, "\n; recursion frame stack (push/pop per recSet function)\n")
		fmt.Fprintf(&g.data, "g___dmacc_fsp: .word g___dmacc_fstack\n")
		fmt.Fprintf(&g.data, "fs_lr: .word 0\nfs_r0: .word 0\n")
		fmt.Fprintf(&g.data, "fs_a0: .word 0\nfs_a1: .word 0\nfs_a2: .word 0\nfs_a3: .word 0\n")
		fmt.Fprintf(&g.data, "g___dmacc_fstack: .space %d\n", stack)
		// The overflow sink: a program-defined handler dies as a
		// process; otherwise HALT at a well-defined point.
		fmt.Fprintf(&g.text, "\n__fovf:\n")
		// Reclaim the whole stack before the sink runs: the dying
		// process owns every live push (see computeRecursion).
		fmt.Fprintf(&g.text, "    move $g___dmacc_fstack, g___dmacc_fsp\n")
		if _, ok := g.funcIdx[recOverflowName]; ok {
			fmt.Fprintf(&g.text, "    jump %s\n", funcSym(recOverflowName))
		} else {
			fmt.Fprintf(&g.text, "    halt\n")
		}
	} else {
		// usys links the stack cells unconditionally (fork's reset):
		// give non-recursive images inert ones.
		fmt.Fprintf(&g.data, "g___dmacc_fsp: .word 0\ng___dmacc_fstack: .word 0\n")
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
	w.WriteString(g.text.String())
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
		w.WriteString(g.ram.String())
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
	// A program-defined recursion-overflow sink is called only by the
	// depth-K rewrite, which runs after this pass: keep it as a root.
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

// computeRecursion splits recursive code between two mechanisms:
//
//   - THE FRAME STACK (g.recSet): call-graph cycle members that cannot
//     reach fork(). One copy of the code; each activation saves its
//     whole frame to a software stack on entry and restores on return
//     (emitFramePush/Pop). Depth is bounded only by Options.FrameStack.
//     sh's entire parser lands here.
//   - DEPTH CLONES (the old scheme) for everything that CAN span a
//     fork: cycle members reaching fork(), plus the vfork-reentrancy
//     extras (non-cyclic fork-reachers reachable from a cycle). A
//     vfork child RETURNS THROUGH the suspended parent's activations;
//     with a stateful stack those returns would pop frames the parent
//     still owns and the child's next pushes would destroy the saved
//     content — clones have no such state. The split is safe by
//     construction: an activation live across a fork has fork beneath
//     it, i.e. reaches fork, i.e. is in the clone set — so the frame
//     stack only ever holds activations wholly owned by one process.
//     (A child killed mid-parse can leak its pushes into the shared
//     image's stack — bounded by one parse depth, accepted.)
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
	g.frameSz = map[string]int{}
	if len(clone) == 0 {
		return nil
	}
	return g.expandClones(clone)
}

// expandClones is the depth-cloning mechanism, now applied only to the
// fork-spanning set (see computeRecursion): each member is copied
// RecursionDepth times, intra-set calls at depth d route to depth d+1,
// and depth-K calls go to the overflow sink.
func (g *gen) expandClones(clone map[string]bool) error {
	depth := g.opts.RecursionDepth
	if depth <= 0 {
		depth = 12
	}
	taken := map[string]bool{}
	seeVal := func(v *llir.Value) {
		if v != nil && (v.Kind == llir.VFunc || v.Kind == llir.VGlobal) && clone[v.Name] {
			taken[v.Name] = true
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
	rewrite := func(f *llir.Func, d int) {
		for _, b := range f.Blocks {
			for i, ins := range b.Instrs {
				if ins.Op == "call" && clone[strings.TrimSuffix(ins.Callee, recSuffix(d))] {
					base := ins.Callee
					ni := *ins
					if d >= depth {
						ni.Callee = recOverflowName
						ni.Args = nil // the sink takes no params (and never returns)
					} else {
						ni.Callee = base + recSuffix(d+1)
					}
					b.Instrs[i] = &ni
				}
			}
		}
	}
	cloneNames := make([]string, 0, len(clone))
	for n := range clone {
		cloneNames = append(cloneNames, n)
	}
	sort.Strings(cloneNames)
	for _, n := range cloneNames {
		orig := g.funcIdx[n]
		for d := 2; d <= depth; d++ {
			nf := &llir.Func{
				Name:     n + recSuffix(d),
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
			g.funcIdx[nf.Name] = nf
		}
	}
	for _, n := range cloneNames {
		rewrite(g.funcIdx[n], 1)
		for d := 2; d <= depth; d++ {
			rewrite(g.funcIdx[n+recSuffix(d)], d)
		}
	}
	return nil
}

const recOverflowName = "__dmacc_recursion_overflow"

func recSuffix(d int) string {
	if d <= 1 {
		return ""
	}
	return fmt.Sprintf("__r%d", d)
}

// checkNoRecursion rejects call-graph cycles: v0 frames are static.
func (g *gen) checkNoRecursion() error {
	const (
		white = 0
		gray  = 1
		black = 2
	)
	color := map[string]int{}
	var visit func(name string, path []string) error
	visit = func(name string, path []string) error {
		f, ok := g.funcIdx[name]
		if !ok {
			return nil // runtime/intrinsic
		}
		switch color[name] {
		case gray:
			return fmt.Errorf("dmacc: recursion is not supported (v0 static frames): %s -> %s",
				strings.Join(path, " -> "), name)
		case black:
			return nil
		}
		color[name] = gray
		for _, b := range f.Blocks {
			for _, ins := range b.Instrs {
				if ins.Op == "call" && !strings.HasPrefix(ins.Callee, "llvm.") {
					if err := visit(ins.Callee, append(path, name)); err != nil {
						return err
					}
				}
			}
		}
		color[name] = black
		return nil
	}
	names := make([]string, 0, len(g.funcIdx))
	for n := range g.funcIdx {
		names = append(names, n)
	}
	sort.Strings(names)
	for _, n := range names {
		if err := visit(n, nil); err != nil {
			return err
		}
	}
	return nil
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
func globalSym(name string) string { return "g_" + sanitize(name) }

// --- Globals ---

func (g *gen) emitGlobal(gl *llir.Global) error {
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
	fmt.Fprintf(&g.data, "%s:", sym)
	for _, w := range words {
		if w.sym != "" {
			if w.off != 0 {
				fmt.Fprintf(&g.data, " .word %s+%d\n", w.sym, w.off)
			} else {
				fmt.Fprintf(&g.data, " .word %s\n", w.sym)
			}
		} else {
			fmt.Fprintf(&g.data, " .word 0x%x\n", w.val)
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
