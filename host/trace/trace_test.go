package trace_test

// End-to-end attribution over a real compiled module. The module is
// one of dmacc's differential goldens (host/dmacc/testdata/func.c):
// three compiled functions, a loop, a comparison site and a runtime
// call, which is exactly the structure the levels have to tell apart.
// It is read from there rather than copied here so it cannot drift
// away from the compiler it exercises.

import (
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/trace"
)

const (
	testTextBase = 0x20000000
	testDataBase = 0x20030000
)

// run compiles a dmacc golden, runs it to completion with the text
// segment profiled, and returns everything attribution needs.
func run(t *testing.T, name string) (string, dmaasm.Options, *dmaasm.Result, trace.Region) {
	t.Helper()
	src, err := os.ReadFile("../dmacc/testdata/" + name + ".ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatalf("compile: %v", err)
	}
	v, err := emu.VariantByName("rp2350")
	if err != nil {
		t.Fatal(err)
	}
	opts := dmaasm.Options{Variant: v, Compact: true,
		TextBase: testTextBase, DataBase: testDataBase}
	res, err := dmaasm.Assemble(dasm, opts)
	if err != nil {
		t.Fatalf("assemble: %v", err)
	}
	m := emu.NewMachine(v)
	if err := res.Image.LoadAndStart(m, nil, img.CompactMachine()); err != nil {
		t.Fatal(err)
	}
	lo := res.Image.Segments[0].LinkAddr
	hi := lo + uint32(len(res.Image.Segments[0].Data))
	m.ProfileWindows([][2]uint32{{lo, hi}})
	rr, err := m.Run(emu.RunConfig{MaxCycles: 80_000_000})
	if err != nil {
		t.Fatal(err)
	}
	if rr.Reason != emu.StopIdle {
		t.Fatalf("%s did not halt: %+v", name, rr)
	}
	return dasm, opts, res, trace.Region{Name: "text", Lo: lo,
		Counts: m.ProfileCountsAt(0), Flash: true}
}

// byName indexes a level's rows.
func byName(es []trace.Entry) map[string]trace.Entry {
	m := make(map[string]trace.Entry, len(es))
	for _, e := range es {
		m[e.Name] = e
	}
	return m
}

// naiveFuncCounts is the attribution this package exists to replace:
// nearest preceding `f_` symbol over dmaasm.Result.Symbols, which is
// what every profile driver in the tree wrote by hand. Result.Symbols
// has no `__`-prefixed names in it, so every read the runtime and the
// millicode make lands on whichever compiled function precedes them.
func naiveFuncCounts(syms map[string]uint32, r trace.Region) map[string]uint64 {
	type ent struct {
		name string
		addr uint32
	}
	var fs []ent
	hi := r.Lo + uint32(len(r.Counts))*4
	for n, a := range syms {
		if strings.HasPrefix(n, "f_") && a >= r.Lo && a < hi {
			fs = append(fs, ent{n[2:], a})
		}
	}
	sort.Slice(fs, func(i, j int) bool { return fs[i].addr < fs[j].addr })
	out := map[string]uint64{}
	si := 0
	for i, c := range r.Counts {
		if c == 0 {
			continue
		}
		a := r.Lo + uint32(i)*4
		for si+1 < len(fs) && fs[si+1].addr <= a {
			si++
		}
		if si < len(fs) && fs[si].addr <= a {
			out[fs[si].name] += uint64(c)
		}
	}
	return out
}

func TestAttributeCompiledModule(t *testing.T) {
	t.Parallel()
	dasm, opts, res, reg := run(t, "func")
	tbl, err := trace.Symbolize(dasm, opts, res)
	if err != nil {
		t.Fatal(err)
	}
	h := tbl.Attribute(reg)
	if h.Reads == 0 {
		t.Fatal("no reads attributed")
	}
	if h.Flash != h.Reads {
		t.Errorf("flash %d of %d reads, want all (the window is marked Flash)", h.Flash, h.Reads)
	}

	fns := byName(h.By(trace.ByFunction))
	for _, want := range []string{"main", "h", "g2", "__rt_mul", "__cw_lt"} {
		if e, ok := fns[want]; !ok || e.Reads == 0 {
			t.Errorf("ByFunction: %q missing or cold (%+v)", want, e)
		}
	}
	if k := fns["main"].Kind; k != trace.KindFunc {
		t.Errorf("main is kind %v, want func", k)
	}
	if k := fns["__rt_mul"].Kind; k != trace.KindRuntime {
		t.Errorf("__rt_mul is kind %v, want runtime", k)
	}
	if k := fns["__cw_lt"].Kind; k != trace.KindMillicode {
		t.Errorf("__cw_lt is kind %v, want millicode", k)
	}

	// h() calls g2() twice per iteration and each g2() multiplies, so
	// the runtime multiply has to be hotter than any single caller.
	if fns["__rt_mul"].Reads <= fns["g2"].Reads {
		t.Errorf("__rt_mul %d reads, g2 %d: the runtime should dominate its caller",
			fns["__rt_mul"].Reads, fns["g2"].Reads)
	}

	// Blocks roll up into their functions exactly.
	blks := h.By(trace.ByBlock)
	perFunc := map[string]uint64{}
	for _, e := range blks {
		if e.Func == "" {
			t.Errorf("block %q has no owning function", e.Name)
		}
		if !strings.HasPrefix(e.Name, "B_") {
			t.Errorf("ByBlock row %q is not a block label", e.Name)
		}
		perFunc[e.Func] += e.Reads
	}
	for _, fn := range []string{"main", "h", "g2"} {
		if perFunc[fn] == 0 || perFunc[fn] > fns[fn].Reads {
			t.Errorf("%s: blocks total %d, function %d", fn, perFunc[fn], fns[fn].Reads)
		}
	}

	// The comparison site is the loop's `i <= 3` test. start is -3, so
	// the body runs seven times and the test itself runs eight — the
	// exact count Entry.Execs claims to recover for a straight-line
	// owner, checked against a number the C source fixes.
	sites := h.By(trace.BySite)
	if len(sites) == 0 {
		t.Fatal("no comparison sites attributed")
	}
	for _, e := range sites {
		if !strings.HasPrefix(e.Name, "cws_") || e.Func == "" {
			t.Errorf("BySite row %+v is not a site of a function", e)
		}
	}
	if got := sites[0].Execs; got != 8 {
		t.Errorf("hottest site %s ran %d times, want 8 (the loop's trip count + 1)",
			sites[0].Name, got)
	}

	// Helpers own themselves at every level they appear at.
	helpers := byName(h.By(trace.ByHelper))
	if len(helpers) == 0 {
		t.Fatal("no helpers attributed")
	}
	for n, e := range helpers {
		if !e.Kind.Helper() {
			t.Errorf("helper row %q has kind %v", n, e.Kind)
		}
		if e.Reads != fns[n].Reads {
			t.Errorf("%s: %d reads by helper, %d by function", n, e.Reads, fns[n].Reads)
		}
	}

	// Lookup and Funcs answer from the same table.
	for _, l := range tbl.Labels() {
		if l.Kind != trace.KindFunc || l.Size < 8 {
			continue
		}
		if got, ok := tbl.Lookup(l.Addr + 4); !ok || got.Name != l.Name {
			t.Errorf("Lookup inside %s found %q (%v)", l.Name, got.Name, ok)
		}
	}
	names := tbl.Funcs()
	if len(names) < 3 || !sort.StringsAreSorted(names) {
		t.Errorf("Funcs() = %v", names)
	}
	for _, a := range res.LitAddrs {
		if !tbl.IsPoolLit(a) {
			t.Errorf("pool word %#x is not recognized as one", a)
			break
		}
	}

	// Every level shares out the same reads (ByBlock and BySite are
	// deliberately partial: they only cover labelled spans).
	funcTot, labTot := h.Total(trace.ByFunction), h.Total(trace.ByLabel)
	if funcTot != labTot {
		t.Errorf("ByFunction totals %d, ByLabel %d", funcTot, labTot)
	}
	if funcTot+h.Unowned != h.Reads {
		t.Errorf("ByFunction %d + unowned %d != %d reads", funcTot, h.Unowned, h.Reads)
	}
}

// TestSymbolsAloneMisattributes is the mutation test for the label
// stream: the SAME run attributed both ways, so the difference is the
// attribution and nothing else. dmaasm's default symbol table has no
// `__rt_mul` and no `__cw_lt` in it, so a nearest-`f_` scan hands
// their reads to whichever compiled function precedes them — here
// `main`, whose bill more than doubles.
func TestSymbolsAloneMisattributes(t *testing.T) {
	t.Parallel()
	dasm, opts, res, reg := run(t, "func")
	tbl, err := trace.Symbolize(dasm, opts, res)
	if err != nil {
		t.Fatal(err)
	}
	h := tbl.Attribute(reg)
	fns := byName(h.By(trace.ByFunction))
	naive := naiveFuncCounts(res.Symbols, reg)

	for _, n := range []string{"__rt_mul", "__cw_lt"} {
		if _, ok := naive[n]; ok {
			t.Fatalf("%s is in Result.Symbols after all — the test no longer bites", n)
		}
		if fns[n].Reads == 0 {
			t.Fatalf("%s attributed nothing; nothing to misattribute", n)
		}
	}

	// Every helper in this image is laid out past the last compiled
	// function, so the naive scan piles all of them onto `main`,
	// together with the jump-pair arena the table declines to name.
	var helperTot uint64
	for _, e := range h.By(trace.ByHelper) {
		helperTot += e.Reads
	}
	if helperTot == 0 {
		t.Fatal("no helper reads")
	}
	if got, want := naive["main"], fns["main"].Reads+helperTot+h.Unowned; got != want {
		t.Errorf("naive main = %d, want %d (= %d main + %d helpers + %d unnamed)",
			got, want, fns["main"].Reads, helperTot, h.Unowned)
	}
	if naive["main"] < 2*fns["main"].Reads {
		t.Errorf("naive main %d vs %d: the misattribution should be large here",
			naive["main"], fns["main"].Reads)
	}
	// The functions that do NOT precede a helper are attributed the
	// same either way — the error is local to the label-stream gap.
	for _, fn := range []string{"h", "g2"} {
		if naive[fn] != fns[fn].Reads {
			t.Errorf("%s: naive %d, trace %d — expected agreement away from the helpers",
				fn, naive[fn], fns[fn].Reads)
		}
	}
	t.Logf("main: %d reads attributed, %d credited by a Symbols-only scan (+%.0f%%)",
		fns["main"].Reads, naive["main"],
		100*float64(naive["main"]-fns["main"].Reads)/float64(fns["main"].Reads))
}

// TestTableDropsAssemblerNames pins the other half of the label-stream
// rule: dmaasm mints `__L<n>` and `__JP<n>` during layout, they are in
// the InternalSyms table, and they name no code anyone wrote — so they
// must not fragment their neighbour's span.
func TestTableDropsAssemblerNames(t *testing.T) {
	t.Parallel()
	dasm, opts, _, _ := run(t, "func")
	opts.InternalSyms = true
	full, err := dmaasm.Assemble(dasm, opts)
	if err != nil {
		t.Fatal(err)
	}
	var minted int
	for n := range full.Symbols {
		if strings.HasPrefix(n, "__L") || strings.HasPrefix(n, "__JP") {
			minted++
		}
	}
	if minted == 0 {
		t.Skip("this image has no assembler-minted labels")
	}
	tbl, err := trace.NewTable(dasm, full)
	if err != nil {
		t.Fatal(err)
	}
	stream := trace.LabelStream(dasm)
	for _, l := range tbl.Labels() {
		if strings.HasPrefix(l.Name, "__L") || strings.HasPrefix(l.Name, "__JP") {
			t.Errorf("assembler-minted %q is in the table", l.Name)
		}
		if strings.HasPrefix(l.Name, "__") {
			if _, ok := stream[l.Name]; !ok {
				t.Errorf("%q is `__`-prefixed and not in the .dasm label stream", l.Name)
			}
		}
	}
	// The ones the source DID write are all there.
	for n := range stream {
		if strings.HasPrefix(n, "__") {
			if _, ok := full.Symbols[n]; !ok {
				continue // a conditional label this assembly skipped
			}
			found := false
			for _, l := range tbl.Labels() {
				if l.Name == n {
					found = true
					break
				}
			}
			if !found {
				t.Errorf("source label %q is missing from the table", n)
			}
		}
	}
}

// TestSymbolizeChecksTheImage: a table that describes different bytes
// from the ones that ran is worse than no table.
func TestSymbolizeChecksTheImage(t *testing.T) {
	t.Parallel()
	dasm, opts, res, _ := run(t, "func")
	moved := opts
	moved.TextBase = opts.TextBase + 0x1000
	if _, err := trace.Symbolize(dasm, moved, res); err == nil {
		t.Fatal("Symbolize accepted a table for a differently linked image")
	}
	if _, err := trace.Symbolize(dasm, opts, res); err != nil {
		t.Fatalf("Symbolize rejected its own image: %v", err)
	}
}

// TestEmissionCategories: collatz.c lowers its `n & 1` branch and its
// select through dmacc's stub forms, so the category level has rows —
// this is the level that prices the LOWERING rather than the code.
func TestEmissionCategories(t *testing.T) {
	t.Parallel()
	dasm, opts, res, reg := run(t, "collatz")
	tbl, err := trace.Symbolize(dasm, opts, res)
	if err != nil {
		t.Fatal(err)
	}
	h := tbl.Attribute(reg)
	cats := h.By(trace.ByCategory)
	if len(cats) == 0 {
		t.Fatal("no emission categories attributed")
	}
	var tot uint64
	for _, e := range cats {
		if e.Kind != trace.KindStub || len(e.Name) > 4 {
			t.Errorf("category row %+v does not look like a stub tag", e)
		}
		tot += e.Reads
	}
	fns := byName(h.By(trace.ByFunction))
	if tot == 0 || tot >= fns["steps"].Reads+fns["main"].Reads {
		t.Errorf("stubs account for %d reads of %d+%d in the compiled code",
			tot, fns["steps"].Reads, fns["main"].Reads)
	}
	// Every stub belongs to a function that ran.
	for _, l := range tbl.Labels() {
		if l.Kind == trace.KindStub && l.Func == "" {
			t.Errorf("stub %q has no owning function", l.Name)
		}
	}
}

// TestReport exercises the writer end: a ranked report, header and
// rows, at every level.
func TestReport(t *testing.T) {
	t.Parallel()
	dasm, opts, res, reg := run(t, "collatz")
	tbl, err := trace.Symbolize(dasm, opts, res)
	if err != nil {
		t.Fatal(err)
	}
	h := tbl.Attribute(reg)
	for _, l := range []trace.Level{trace.ByFunction, trace.ByBlock, trace.BySite,
		trace.ByHelper, trace.ByCategory, trace.ByLabel} {
		var b strings.Builder
		if err := h.Report(&b, "collatz.c", l, 8); err != nil {
			t.Fatal(err)
		}
		out := b.String()
		if !strings.Contains(out, "by "+l.String()) {
			t.Errorf("%v: header missing from %q", l, out)
		}
		if n := strings.Count(out, "\n"); n < 3 {
			t.Errorf("%v: only %d lines of report", l, n)
		}
		t.Logf("\n%s", out)
	}
}
