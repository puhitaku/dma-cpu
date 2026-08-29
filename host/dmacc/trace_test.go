package dmacc_test

// The §1-style question — "where do this workload's XIP text reads
// (= instruction fetches = flash reads) go, by function?" — asked
// through host/trace instead of a hand-rolled symbol scan, and checked
// against the PGO driver's own funcCounts on the SAME emulator run.
//
// Two things are being pinned here (prompts/042 §8):
//
//   - the port is faithful. The driver's whole map is REBUILT from the
//     trace table — every span dmaasm's default symbol table cannot
//     see pushed onto the last `f_` label ahead of it, which is what a
//     nearest-preceding-symbol scan does — and the reconstruction is
//     exact, key for key. So the engine explains the numbers the tree
//     has already reported instead of quietly disagreeing with them.
//   - and it says where they are wrong. The gap is the outliner's
//     return stubs (`__olr_*`), which sit inline between the functions
//     that jump to them: 1% of the kernel's text reads and 8.5% of
//     sh's are credited to the wrong function by the old scan, and a
//     function whose own body went cold can be left holding a
//     four-figure bill for the stub behind it.
//
// The .ramtext half is the part that scan could not see AT ALL: under
// XIPText the runtime and the comparison millicode live there, every
// label is `__`-prefixed, and funcCounts finds no owner for any of it.

import (
	"os"
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

	kTbl, err := trace.Symbolize(compileKernelXsh(t, bd.FbBuf != 0), dmaasm.Options{
		Variant: m.Variant(), Compact: true, TextBase: bd.KernTextXIP,
		DataBase: bd.KernCData, RAMTextBase: bd.KernCRText,
		PoolText: true, HotLits: pgo.KernelLits}, kernC)
	if err != nil {
		t.Fatal(err)
	}
	sTbl, err := trace.Symbolize(compileShDasm(t, bd), dmaasm.Options{
		Variant: m.Variant(), Compact: true, TextBase: bd.ShTextXIP,
		DataBase: bd.ShData, RAMTextBase: bd.ShRText,
		PoolText: true, HotLits: pgo.ShLits}, shRes)
	if err != nil {
		t.Fatal(err)
	}

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
		want, wantTot := funcCounts(img.res, win, litSet(img.res))
		h := img.tbl.Attribute(trace.Region{Name: "xip text", Lo: img.w[0],
			Counts: win.counts, Flash: true})
		if h.Pool == 0 {
			t.Errorf("%s: the cold literal pool rides this window and read nothing",
				img.name)
		}
		if h.Unowned != 0 {
			t.Errorf("%s: %d reads land on no label at all", img.name, h.Unowned)
		}

		// The two attributions differ by exactly one thing: the labels
		// dmaasm's default symbol table drops. Rebuild the driver's
		// numbers from trace's — every orphan span's reads pushed onto
		// the last `f_` label ahead of it, which is what a
		// nearest-preceding-symbol scan does — and the reconstruction
		// has to be exact, key for key.
		//
		// Functions that share an address (a body-less one sitting in
		// front of the next) are compared as one bucket: which of them
		// a nearest-preceding scan picks is undefined, and dmaasm gives
		// them the same address to begin with.
		reads := map[string]uint64{}
		for _, e := range h.By(trace.ByLabel) {
			reads[e.Name] = e.Reads
		}
		rebuilt := map[string]uint64{}
		var funcTot, leaked uint64
		last, orphans := "(pre-first-function)", 0
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
		for _, l := range img.tbl.Labels() {
			if l.Addr < img.w[0] || l.Addr >= img.w[1] {
				continue
			}
			if l.Kind == trace.KindFunc {
				last = alias[l.Func]
			}
			rebuilt[last] += reads[l.Name]
			if l.Func == "" && l.Kind != trace.KindFunc {
				leaked += reads[l.Name]
				if reads[l.Name] > 0 {
					orphans++
				}
			}
		}
		for _, e := range h.By(trace.ByFunction) {
			if e.Kind == trace.KindFunc {
				funcTot += e.Reads
			}
		}
		folded := map[string]uint64{}
		for n, c := range want {
			key, ok := alias[n]
			if !ok {
				key = n
			}
			folded[key] += c
		}
		for n, c := range rebuilt {
			if folded[n] != c {
				t.Errorf("%s: rebuilding the PGO driver's %s gives %d, it says %d",
					img.name, n, c, folded[n])
			}
			delete(folded, n)
		}
		for n, c := range folded {
			if c != 0 {
				t.Errorf("%s: PGO driver has %s at %d reads, the rebuild has none",
					img.name, n, c)
			}
		}
		if funcTot == 0 {
			t.Fatalf("%s: no text reads attributed", img.name)
		}
		if funcTot+leaked != wantTot {
			t.Errorf("%s: %d function + %d orphan reads do not add up to the driver's %d",
				img.name, funcTot, leaked, wantTot)
		}
		if leaked == 0 || orphans == 0 {
			t.Errorf("%s: nothing leaked — this image no longer shows the bug", img.name)
		}
		t.Logf("%s XIP text: %d reads over %d functions; %d of them (%.2f%%) "+
			"belong to %d unnamed spans a Symbols-only scan credits to the "+
			"function ahead of them",
			img.name, wantTot, len(h.By(trace.ByFunction)), leaked,
			100*float64(leaked)/float64(wantTot), orphans)
		if os.Getenv("TRACE_REPORT") != "" {
			if err := h.Report(os.Stdout, img.name+" XIP text", trace.ByFunction, 20); err != nil {
				t.Fatal(err)
			}
		}
	}

	// The .ramtext half is the part the hand-rolled scans could not
	// reach: every symbol there is `__`-prefixed, so funcCounts finds
	// no owner at all and the millicode's cost stayed invisible.
	rh := kTbl.Attribute(trace.Region{Name: ".ramtext", Lo: kRam[0],
		Counts: m.ProfileCountsAt(2)})
	rfns, _ := funcCounts(kernC, window{kRam, m.ProfileCountsAt(2)}, litSet(kernC))
	helpers := rh.By(trace.ByHelper)
	if len(helpers) == 0 || helpers[0].Reads == 0 {
		t.Fatal(".ramtext: no helper heat")
	}
	for _, e := range helpers {
		if _, ok := rfns[e.Name]; ok {
			t.Errorf("%s is in the PGO driver's map after all", e.Name)
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
