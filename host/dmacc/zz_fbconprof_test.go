package dmacc_test

// TestProfileFbcon: fetch attribution of the framebuffer console.
// Every console byte on a framebuffer board runs through kfbcon_putc
// (prompts/036), and TestZZBenchFbcon prices that at tens of millions
// of cycles per scroll burst without saying WHERE they go. This probe
// counts machine reads over the kernel's XIP text and its .ramtext
// while an fbcon workload runs, and attributes them per function.
//
// Two mechanics worth knowing. dmaasm drops every `__`-prefixed label
// from Result.Symbols (prompts/042 §8), so the shared runtime and the
// compare millicode would otherwise be credited to whatever compiled
// function precedes them: the probe assembles a TWIN of the kernel
// from the same .dasm with `__` textually renamed, checks the twin's
// image is byte-identical, and attributes through the twin's symbols.
// And the fbcon share is isolated by running the same workload on
// Pico 2 (identical kernel, kfbstub in place of kfb/kfbcon) and
// diffing the per-NAME totals — the addresses differ, the names do
// not.
//
//	RADIO_PROBES=1 go test ./dmacc/ -run TestProfileFbcon -v

import (
	"fmt"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/pgo"
)

// fbprofRename is the textual label rename that keeps the runtime and
// millicode visible in Result.Symbols. It applies to the .dasm source,
// where every `__` name came from dmacc (`__rt_*`, `__cw_*`, the
// register file, the vector table).
func fbprofRename(s string) string { return strings.ReplaceAll(s, "__", "Zq") }

// fbprofRenameLit renames a hot-literal key the same way — except for
// dmaasm's OWN generated names (`__JP<n>` jump pairs, `__L<n>` labels),
// which never appear in the source and so keep their spelling. Missing
// that exemption drops them out of the hot half and moves the layout.
func fbprofRenameLit(k string) string {
	if i := strings.Index(k, "__"); i >= 0 {
		rest := k[i+2:]
		if strings.HasPrefix(rest, "JP") {
			rest = rest[2:]
		} else if strings.HasPrefix(rest, "L") {
			rest = rest[1:]
		} else {
			return fbprofRename(k)
		}
		if len(rest) > 0 && rest[0] >= '0' && rest[0] <= '9' {
			return k
		}
	}
	return fbprofRename(k)
}

// fbprofSyms assembles a symbol twin of the fs kernel for board bd and
// returns its symbol table. The twin's image is compared against the
// real one so attribution cannot silently drift from what ran.
func fbprofSyms(t *testing.T, bd *boards.Board, real *dmaasm.Result) map[string]uint32 {
	t.Helper()
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}
	hot := map[string]bool{}
	for k, ok := range pgo.KernelLits {
		hot[fbprofRenameLit(k)] = ok
	}
	src := fbprofRename(compileKernelXsh(t, bd.FbBuf != 0))
	twin, err := dmaasm.Assemble(src, dmaasm.Options{
		Variant: v, Compact: true,
		TextBase: bd.KernTextXIP, DataBase: bd.KernCData, RAMTextBase: bd.KernCRText,
		PoolText: true, HotLits: hot})
	if err != nil {
		t.Fatalf("%s twin: %v", bd.Name, err)
	}
	if len(twin.Image.Segments) != len(real.Image.Segments) {
		t.Fatalf("%s twin: %d segments, real has %d",
			bd.Name, len(twin.Image.Segments), len(real.Image.Segments))
	}
	for i, s := range twin.Image.Segments {
		r := real.Image.Segments[i]
		if s.LinkAddr != r.LinkAddr || len(s.Data) != len(r.Data) {
			t.Fatalf("%s twin segment %d: %#x/%d vs %#x/%d",
				bd.Name, i, s.LinkAddr, len(s.Data), r.LinkAddr, len(r.Data))
		}
		for j := range s.Data {
			if s.Data[j] != r.Data[j] {
				t.Fatalf("%s twin segment %d diverges at %#x", bd.Name, i, j)
			}
		}
	}
	return twin.Symbols
}

// fbprofAttrib folds a read-count slice over [lo,hi) into per-symbol
// totals, collapsing dmacc's per-block label decorations back to the
// owning function.
func fbprofAttrib(counts []uint32, lo uint32, syms map[string]uint32, into map[string]uint64) {
	type sym struct {
		name string
		addr uint32
	}
	var ss []sym
	hi := lo + uint32(len(counts))*4
	for n, a := range syms {
		if a >= lo && a < hi {
			ss = append(ss, sym{n, a})
		}
	}
	sort.Slice(ss, func(i, j int) bool { return ss[i].addr < ss[j].addr })
	si := 0
	for w, c := range counts {
		if c == 0 {
			continue
		}
		a := lo + uint32(w)*4
		for si+1 < len(ss) && ss[si+1].addr <= a {
			si++
		}
		nm := "??"
		if si < len(ss) && ss[si].addr <= a {
			nm = fbprofCollapse(ss[si].name)
		}
		into[nm] += uint64(c)
	}
}

// fbprofCollapse maps a block label back to its function: dmacc emits
// per-block labels as <tag>_<func> and numbered clones as <name>_<n>.
func fbprofCollapse(nm string) string {
	for _, pre := range []string{"B_", "Ct", "Cf", "Cj", "Pe", "Sw", "St", "Sf", "Sj",
		"Xr", "Ld", "Sd", "Swi", "Swt", "Fok", "Fha", "Fhb", "Rv"} {
		if strings.HasPrefix(nm, pre) {
			if i := strings.Index(nm, "_"); i > 0 {
				return nm[i+1:]
			}
			break
		}
	}
	if i := strings.LastIndex(nm, "_"); i > 0 {
		allDigits := len(nm[i+1:]) > 0
		for _, ch := range nm[i+1:] {
			if ch < '0' || ch > '9' {
				allDigits = false
			}
		}
		if allDigits {
			return nm[:i]
		}
	}
	return nm
}

func TestProfileFbcon(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (~2 min of emulation): set RADIO_PROBES=1")
	}
	// The workload: one README dump plus the bench's scroll burst,
	// i.e. the two shapes TestZZBenchFbcon prices.
	work := append([]string{"cat README"}, strings.Split(strings.Repeat("ls /dev,", 12), ",")[:12]...)

	// run drives the workload once with reads counted over [lo,hi) and
	// returns the raw counts, the console bytes rendered and the cycles
	// the workload took.
	run := func(bd *boards.Board, lo, hi uint32) ([]uint32, int, uint64) {
		m, _ := bootXshBoard(t, nil, bd)
		m.TXPace = 0
		dr := m.Variant().UARTDRAddr()
		var cycles uint64
		waitPrompt := func() {
			for spent := uint64(0); spent < 3_000_000_000; {
				rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000, WatchWrites: []uint32{dr}})
				if err != nil {
					t.Fatalf("%s: %v (tail %q)", bd.Name, err, tailB(m.ConsoleOut, 200))
				}
				spent += rr.Cycles
				cycles += rr.Cycles
				if rr.Reason == emu.StopWatch && strings.HasSuffix(string(m.ConsoleOut), "$ ") {
					return
				}
				if rr.Reason == emu.StopIdle || rr.Reason == emu.StopStalled {
					return
				}
			}
		}
		// Warm the exec path before the counters go live: the first
		// `cat`/`ls` pays a disk read and a relocation the rest do not.
		for _, c := range []string{"cat README", "ls /dev"} {
			m.FeedConsole(c + "\r")
			waitPrompt()
		}
		mark := len(m.ConsoleOut)
		cycles = 0
		m.Profile(lo, hi)
		for _, c := range work {
			m.FeedConsole(c + "\r")
			waitPrompt()
		}
		counts := append([]uint32(nil), m.ProfileCounts()...)
		m.Profile(0, 0)
		return counts, len(m.ConsoleOut) - mark, cycles
	}

	// Per-board totals, folded per function name across both text
	// homes (XIP flash text and the resident .ramtext).
	board := func(bd *boards.Board) (map[string]uint64, uint64, int, uint64) {
		_, kernC := bootXshBoard(t, nil, bd)
		syms := fbprofSyms(t, bd, kernC)
		agg := map[string]uint64{}
		xipLen := uint32(0x40000)
		xc, bytes, cyc := run(bd, bd.KernTextXIP, bd.KernTextXIP+xipLen)
		fbprofAttrib(xc, bd.KernTextXIP, syms, agg)
		rc, _, _ := run(bd, bd.KernCRText, bd.KernCData)
		fbprofAttrib(rc, bd.KernCRText, syms, agg)
		var tot uint64
		for _, c := range agg {
			tot += c
		}
		return agg, tot, bytes, cyc
	}

	fe, feTot, feBytes, feCyc := board(boards.Feather)
	p2, p2Tot, _, p2Cyc := board(boards.Pico2)

	fmt.Printf("FBCONPROF workload: cat README + 12x ls /dev, %d console bytes\n", feBytes)
	fmt.Printf("FBCONPROF cycles: feather=%d pico2=%d  delta=%+d (%d/byte)\n",
		feCyc, p2Cyc, int64(feCyc)-int64(p2Cyc), (int64(feCyc)-int64(p2Cyc))/int64(feBytes))
	fmt.Printf("FBCONPROF kernel text reads: feather=%d pico2=%d  delta=%+d (%d/byte)\n",
		feTot, p2Tot, int64(feTot)-int64(p2Tot), (int64(feTot)-int64(p2Tot))/int64(feBytes))

	type item struct {
		name        string
		fe, p2, dlt int64
	}
	var items []item
	seen := map[string]bool{}
	for n := range fe {
		seen[n] = true
	}
	for n := range p2 {
		seen[n] = true
	}
	for n := range seen {
		a, b := int64(fe[n]), int64(p2[n])
		items = append(items, item{n, a, b, a - b})
	}
	sort.Slice(items, func(i, j int) bool { return items[i].dlt > items[j].dlt })
	fmt.Printf("FBCONPROF %-30s %12s %12s %12s %7s\n", "function", "feather", "pico2", "delta", "%delta")
	d := float64(int64(feTot) - int64(p2Tot))
	for i := 0; i < len(items) && i < 24; i++ {
		it := items[i]
		fmt.Printf("FBCONPROF %-30s %12d %12d %+12d %6.1f%%\n",
			it.name, it.fe, it.p2, it.dlt, 100*float64(it.dlt)/d)
	}
}
