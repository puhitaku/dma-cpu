package dmacc_test

// The §1-style question — "where do this workload's XIP text reads
// (= instruction fetches = flash reads) go, by function?" — as the PGO
// driver now asks it, and as it used to.
//
// The driver takes its per-function heat from host/trace (funcHeat), so
// what is pinned here is the DIFFERENCE that made (prompts/042 §8), on
// one emulator run attributed both ways:
//
//   - the old rule is explained exactly. A nearest-preceding-`f_` scan
//     over dmaasm's default symbol table is rebuilt out of the trace
//     table — every span that table cannot see pushed onto the last
//     `f_` label ahead of it — and the reconstruction is exact, key for
//     key. So the engine accounts for every number the tree reported
//     before it, rather than quietly disagreeing with them.
//   - and the correction is measured. What the old scan handed to the
//     wrong function is the spans that belong to no compiled function
//     at all: the outliner's shared helper BODIES (`__ol_<n>`), the crt
//     (`crtthunk`), and the comparison descriptors (`cwc_*`/`cwd_*`),
//     which are data the millicode loads rather than instructions
//     anyone fetched. On this workload that is 0.5% of the kernel's
//     window and 7.4% of sh's, and it concentrates: the helper bodies
//     land together at the end of a section, so one function per image
//     was carrying nearly the whole bill.
//   - what is NOT a correction: the outliner's resume labels
//     (`__olr_<n>`). They look like helpers and are not — an open site
//     parks its resume label and jumps, so `__olr_<n>` marks where
//     control comes BACK, in the middle of the function that was
//     outlined, and the records behind it are that function's own. Both
//     attributions agree about them, and the test pins that they do.
//
// The .ramtext half is the part the old scan could not see AT ALL:
// under XIPText the runtime and the comparison millicode live there,
// every label is `__`-prefixed, and a Symbols-only scan finds no owner
// for any of it.

import (
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/pgo"
	"github.com/puhitaku/dma-cpu/host/trace"
)

// traceCmds is a short prefix of benchCmds: enough shell work to light
// up the kernel's syscall, filesystem and console paths and sh's own
// parser, without paying for the whole profile run (the profiler turns
// off the emulator's bulk read path).
var traceCmds = []string{"echo hi", "ls", "cat README | wc"}

// naiveFuncCounts is the attribution the PGO driver used to carry, and
// that every throwaway probe in this tree wrote by hand: nearest
// preceding `f_` symbol over dmaasm.Result.Symbols, which holds no
// `__`-prefixed name, so every span dmacc did not label with an `f_`
// lands on whichever compiled function precedes it. It lives here now,
// as the thing being measured against.
func naiveFuncCounts(res *dmaasm.Result, w window, skip map[uint32]bool) (map[string]uint64, uint64) {
	type ent struct {
		name string
		addr uint32
	}
	var fs []ent
	for n, a := range res.Symbols {
		if strings.HasPrefix(n, "f_") && a >= w.w[0] && a < w.w[1] {
			fs = append(fs, ent{n[2:], a})
		}
	}
	sort.Slice(fs, func(i, j int) bool { return fs[i].addr < fs[j].addr })
	out := map[string]uint64{}
	var tot uint64
	si := 0
	for i, c := range w.counts {
		a := w.w[0] + uint32(i)*4
		if c == 0 || skip[a] {
			continue
		}
		for si+1 < len(fs) && fs[si+1].addr <= a {
			si++
		}
		if si < len(fs) && fs[si].addr <= a {
			out[fs[si].name] += uint64(c)
		} else {
			out["(pre-first-function)"] += uint64(c)
		}
		tot += uint64(c)
	}
	return out, tot
}

func TestTraceXshFunctionHeat(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, kernC := bootXshBoard(t, nil, bd)
	m.TXPace = 0
	shRes := buildShXsh(t, m.Variant(), bd)

	kTxt := textWindow(kernC, bd.KernTextXIP)
	sTxt := textWindow(shRes, bd.ShTextXIP)
	kRam := [2]uint32{bd.KernCRText, bd.KernCData}
	m.ProfileWindows([][2]uint32{kTxt, sTxt, kRam})
	for _, c := range traceCmds {
		m.FeedConsole(c + "\r")
		runScript(t, m, 3_000_000_000)
	}
	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		t.Fatalf("workload did not return to the prompt; tail %q", tail(m.ConsoleOut, 200))
	}

	kTbl := symTable(t, compileKernelXsh(t, bd.FbBuf != 0), m.Variant(), kernC,
		pgo.KernelLits)
	sTbl := symTable(t, compileShDasm(t, bd), m.Variant(), shRes, pgo.ShLits)

	for _, img := range []struct {
		name string
		tbl  *trace.Table
		res  *dmaasm.Result
		w    [2]uint32
		idx  int
	}{
		{"kernel", kTbl, kernC, kTxt, 0},
		{"sh", sTbl, shRes, sTxt, 1},
	} {
		win := window{img.w, m.ProfileCountsAt(img.idx)}
		naive, naiveTot := naiveFuncCounts(img.res, win, litSet(img.res))
		exact, exactTot := funcHeat(img.tbl, win)
		h := img.tbl.Attribute(trace.Region{Name: "xip text", Lo: img.w[0],
			Counts: win.counts, Flash: true})
		if h.Pool == 0 {
			t.Errorf("%s: the cold literal pool rides this window and read nothing",
				img.name)
		}
		if h.Unowned != 0 {
			t.Errorf("%s: %d reads land on no label at all", img.name, h.Unowned)
		}

		// What the driver no longer credits to a compiled function: the
		// rows of the same attribution that are not one.
		leakedBy := map[string]uint64{}
		var leaked uint64
		for _, e := range h.By(trace.ByFunction) {
			if e.Kind == trace.KindFunc {
				continue
			}
			leakedBy[e.Name] = e.Reads
			leaked += e.Reads
		}
		if exactTot == 0 {
			t.Fatalf("%s: no text reads attributed to any function", img.name)
		}
		if exactTot+leaked != naiveTot {
			t.Errorf("%s: %d function + %d unowned reads do not add up to the "+
				"old scan's %d", img.name, exactTot, leaked, naiveTot)
		}
		if leaked == 0 {
			t.Errorf("%s: nothing was misattributed — this image no longer shows "+
				"the bug the exact attribution fixes", img.name)
		}
		// The outliner's RESUME labels are not part of it: they are the
		// function's own code and both attributions say so.
		olr := 0
		for _, l := range img.tbl.Labels() {
			if !strings.HasPrefix(l.Name, "__olr_") {
				continue
			}
			olr++
			if l.Func == "" {
				t.Errorf("%s: resume label %s owns itself; it belongs to the "+
					"function it returns into", img.name, l.Name)
			}
			if _, ok := leakedBy[l.Name]; ok {
				t.Errorf("%s: resume label %s is attributed as a helper", img.name, l.Name)
			}
		}
		if olr == 0 {
			t.Errorf("%s: no open outlining sites — this image cannot show the "+
				"resume-label case", img.name)
		}
		// The helper BODIES are, and they are the bulk of it.
		if leakedBy["__ol_1"] == 0 {
			t.Errorf("%s: the outliner's first helper body read nothing; the "+
				"correction this test measures is not the one it names", img.name)
		}

		// The two attributions differ by exactly that and nothing else.
		// Rebuild the OLD numbers from the trace table — every span with
		// no owning function pushed onto the last `f_` label ahead of it,
		// which is what a nearest-preceding-symbol scan does — and the
		// reconstruction has to be exact, key for key.
		//
		// Functions that share an address (a body-less one sitting in
		// front of the next) are compared as one bucket: which of them a
		// nearest-preceding scan picks is undefined, and dmaasm gives
		// them the same address to begin with.
		reads := map[string]uint64{}
		for _, e := range h.By(trace.ByLabel) {
			reads[e.Name] = e.Reads
		}
		alias := map[string]string{"(pre-first-function)": "(pre-first-function)"}
		byAddr := map[uint32]string{}
		for _, l := range img.tbl.Labels() {
			if l.Kind != trace.KindFunc {
				continue
			}
			if n, ok := byAddr[l.Addr]; ok {
				alias[l.Func] = n
			} else {
				byAddr[l.Addr], alias[l.Func] = l.Func, l.Func
			}
		}
		rebuilt := map[string]uint64{}
		last := "(pre-first-function)"
		for _, l := range img.tbl.Labels() {
			if l.Addr < img.w[0] || l.Addr >= img.w[1] {
				continue
			}
			if l.Kind == trace.KindFunc {
				last = alias[l.Func]
			}
			rebuilt[last] += reads[l.Name]
		}
		canon := func(n string) string {
			if a, ok := alias[n]; ok {
				return a
			}
			return n
		}
		foldedNaive, foldedExact := map[string]uint64{}, map[string]uint64{}
		for n, c := range naive {
			foldedNaive[canon(n)] += c
		}
		for n, c := range exact {
			foldedExact[canon(n)] += c
		}
		folded := map[string]uint64{}
		for n, c := range foldedNaive {
			folded[n] = c
		}
		for n, c := range rebuilt {
			if folded[n] != c {
				t.Errorf("%s: rebuilding the old scan's %s gives %d, it says %d",
					img.name, n, c, folded[n])
			}
			delete(folded, n)
		}
		for n, c := range folded {
			if c != 0 {
				t.Errorf("%s: the old scan has %s at %d reads, the rebuild has none",
					img.name, n, c)
			}
		}

		// The largest single correction, for the record: this is the
		// function that used to be billed for its neighbours.
		worst, worstBy := "", uint64(0)
		for n, c := range foldedNaive {
			if d := c - foldedExact[n]; c > foldedExact[n] && d > worstBy {
				worst, worstBy = n, d
			}
		}
		t.Logf("%s XIP text: %d reads, %d over %d functions after attribution; "+
			"%d of them (%.2f%%) belong to %d spans no compiled function owns, "+
			"which the old scan credited to the function ahead of them (worst: "+
			"%s, +%d reads)", img.name, naiveTot, exactTot, len(exact), leaked,
			100*float64(leaked)/float64(naiveTot), len(leakedBy), worst, worstBy)
		if os.Getenv("TRACE_REPORT") != "" {
			if err := h.Report(os.Stdout, img.name+" XIP text", trace.ByFunction, 20); err != nil {
				t.Fatal(err)
			}
		}
	}

	// The .ramtext half is the part the hand-rolled scans could not
	// reach: every symbol there is `__`-prefixed, so a Symbols-only scan
	// finds no owner at all and the millicode's cost stayed invisible.
	rh := kTbl.Attribute(trace.Region{Name: ".ramtext", Lo: kRam[0],
		Counts: m.ProfileCountsAt(2)})
	rfns, _ := naiveFuncCounts(kernC, window{kRam, m.ProfileCountsAt(2)}, litSet(kernC))
	helpers := rh.By(trace.ByHelper)
	if len(helpers) == 0 || helpers[0].Reads == 0 {
		t.Fatal(".ramtext: no helper heat")
	}
	for _, e := range helpers {
		if _, ok := rfns[e.Name]; ok {
			t.Errorf("%s is in the old scan's map after all", e.Name)
		}
	}
	if !strings.HasPrefix(helpers[0].Name, "__cw_") {
		t.Errorf("hottest .ramtext helper is %s; the comparison millicode was "+
			"measured at ~65%% of executed records (prompts/042 §10)", helpers[0].Name)
	}
	t.Logf("kernel .ramtext: %d helper reads, hottest %s at %d",
		rh.Reads, helpers[0].Name, helpers[0].Reads)
	if os.Getenv("TRACE_REPORT") != "" {
		if err := rh.Report(os.Stdout, "kernel .ramtext", trace.ByHelper, 20); err != nil {
			t.Fatal(err)
		}
	}
}
