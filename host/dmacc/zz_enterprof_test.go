package dmacc_test

// TestProfileEnter: flash-read histogram of the interactive prompt
// path — the display-killer workload (prompts/036: every machine
// flash read parks the shared DMA read master ~500 ns against the
// HSTX FIFO's ~1.26 us of slack; sync survives sparse reads but not
// storms). Counts machine reads over the kernel XIP text (+ its
// trailing cold literal pool / rodata) and the sh XIP text while
// Enter is pressed 20 times at the prompt, then attributes the
// kernel's share per function. The output ranks the RAMTextFuncs /
// hot-literal candidates.

import (
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
)

func TestProfileEnter(t *testing.T) {
	bd := boards.Feather
	const enters = 20
	run := func(name string, lo, hi uint32) []uint32 {
		m, _ := bootXshBoard(t, nil, bd)
		m.Profile(lo, hi)
		for i := 0; i < enters; i++ {
			m.FeedConsole("\r")
			runScript(t, m, 200_000_000)
		}
		if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
			t.Fatalf("%s: prompt lost; tail %q", name, tailB(m.ConsoleOut, 200))
		}
		counts := append([]uint32(nil), m.ProfileCounts()...)
		m.Profile(0, 0)
		return counts
	}

	total := func(counts []uint32) uint64 {
		var tot uint64
		for _, c := range counts {
			tot += uint64(c)
		}
		return tot
	}

	_, kernC := bootXshBoard(t, nil, bd)
	ktLen := uint32(300000)
	kc := run("kerntext", bd.KernTextXIP, bd.KernTextXIP+ktLen)
	sc := run("shtext", bd.ShTextXIP, bd.ShTextXIP+0x20000)
	kt, st := total(kc), total(sc)
	fmt.Printf("ENTERPROF flash reads over %d enters: kernel=%d sh=%d  (per enter: kernel=%d sh=%d)\n",
		enters, kt, st, kt/enters, st/enters)

	// Attribute the kernel share per function (same collapsing as
	// TestProfileShow).
	type sym struct {
		name string
		addr uint32
	}
	var ss []sym
	for n, a := range kernC.Symbols {
		if a >= bd.KernTextXIP && a < bd.KernTextXIP+ktLen {
			ss = append(ss, sym{n, a})
		}
	}
	sort.Slice(ss, func(i, j int) bool { return ss[i].addr < ss[j].addr })
	agg := map[string]uint64{}
	si := 0
	for w, c := range kc {
		if c == 0 {
			continue
		}
		a := bd.KernTextXIP + uint32(w)*4
		for si+1 < len(ss) && ss[si+1].addr <= a {
			si++
		}
		nm := "??"
		if si < len(ss) && ss[si].addr <= a {
			nm = ss[si].name
		}
		for _, pre := range []string{"B_", "Ct", "Cf", "Cj", "Pe", "Sw", "St", "Sf", "Sj", "Xr", "Ld", "Sd", "Swi", "Swt", "Fok", "Fha", "Fhb", "Rv"} {
			if strings.HasPrefix(nm, pre) {
				if i := strings.Index(nm, "_"); i > 0 {
					nm = "f_" + nm[i+1:]
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
				nm = nm[:i]
			}
		}
		agg[nm] += uint64(c)
	}
	type item struct {
		name string
		n    uint64
	}
	var items []item
	for n, c := range agg {
		items = append(items, item{n, c})
	}
	sort.Slice(items, func(i, j int) bool { return items[i].n > items[j].n })
	for i := 0; i < len(items) && i < 20; i++ {
		fmt.Printf("ENTERPROF   %-34s %10d (%4.1f%%)\n", items[i].name, items[i].n,
			100*float64(items[i].n)/float64(kt))
	}
}
