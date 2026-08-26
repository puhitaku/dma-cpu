package dmacc_test

import (
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/fsimg"
)

// sdCardImage: a card with one FULL-SIZE slide (640x480 = 307200 B) —
// the silicon workload, not the SD test's 4K miniatures.
func sdCardImage(t *testing.T) []byte {
	t.Helper()
	slide := make([]byte, 640*480)
	for i := range slide {
		slide[i] = byte(i*7 + 3)
	}
	fatb := fsimg.NewFAT32(2048)
	fatb.AddFile("A.SLD", slide)
	return fatb.Bytes()
}

// TestProfileShow: execution histogram of `show /sd` drawing one slide
// off the machine-driven SD — fetch-read counts per function over the
// kernel XIP text, the kernel ramtext (millicode/runtime/stubs), and
// the arena (the show app itself).
func TestProfileShow(t *testing.T) {
	bd := boards.Feather
	run := func(name string, lo, hi uint32) []uint32 {
		m, kernC := bootXshBoard(t, nil, boards.Feather)
		_ = kernC
		sd := sdCardImage(t)
		m.SDImage = sd
		m.TXPace = 0
		m.FeedConsole("mkdir sd\rmount /dev/sd0 sd\r")
		runScript(t, m, 2_000_000_000)
		if !strings.Contains(string(m.ConsoleOut), "devfs") &&
			!strings.HasSuffix(string(m.ConsoleOut), "$ ") {
			t.Fatalf("%s: mount flow odd; tail %q", name, tailB(m.ConsoleOut, 200))
		}
		m.Profile(lo, hi)
		m.FeedConsole("show /sd\r")
		for spent := uint64(0); spent < 4_000_000_000 &&
			!strings.Contains(string(m.ConsoleOut), "Done drawing"); {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 4_000_000})
			if err != nil {
				t.Fatalf("%s: %v", name, err)
			}
			spent += rr.Cycles
		}
		if !strings.Contains(string(m.ConsoleOut), "Done drawing") {
			t.Fatalf("%s: no slide drawn; tail %q", name, tailB(m.ConsoleOut, 300))
		}
		counts := append([]uint32(nil), m.ProfileCounts()...)
		m.Profile(0, 0)
		return counts
	}
	// Kernel XIP text.
	m0, kernC := bootXshBoard(t, nil, boards.Feather)
	_ = m0
	ktLen := uint32(300000) // generous; counts beyond text are zero
	counts := run("kerntext", bd.KernTextXIP, bd.KernTextXIP+ktLen)
	type item struct {
		name string
		n    uint64
	}
	attribute := func(counts []uint32, base uint32, syms map[string]uint32, tag string) {
		type sym struct {
			name string
			addr uint32
		}
		var ss []sym
		for n, a := range syms {
			if a >= base && a < base+uint32(len(counts))*4 {
				ss = append(ss, sym{n, a})
			}
		}
		sort.Slice(ss, func(i, j int) bool { return ss[i].addr < ss[j].addr })
		agg := map[string]uint64{}
		var total uint64
		si := 0
		for w, c := range counts {
			if c == 0 {
				continue
			}
			a := base + uint32(w)*4
			for si+1 < len(ss) && ss[si+1].addr <= a {
				si++
			}
			nm := "??"
			if si < len(ss) && ss[si].addr <= a {
				nm = ss[si].name
			}
			// strip block/label suffixes to the owning function
			for _, pre := range []string{"B_", "Ct", "Cf", "Cj", "Pe", "Sw", "St", "Sf", "Sj", "Xr", "Ld", "Sd", "Swi", "Swt", "Fok", "Fha", "Fhb", "Rv"} {
				if strings.HasPrefix(nm, pre) {
					if i := strings.Index(nm, "_"); i > 0 {
						nm = "f_" + nm[i+1:]
					}
					break
				}
			}
			// collapse trailing block numbers
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
			total += uint64(c)
		}
		var items []item
		for n, c := range agg {
			items = append(items, item{n, c})
		}
		sort.Slice(items, func(i, j int) bool { return items[i].n > items[j].n })
		fmt.Printf("PROF %s total=%d\n", tag, total)
		for i := 0; i < len(items) && i < 14; i++ {
			fmt.Printf("PROF   %-34s %10d (%4.1f%%)\n", items[i].name, items[i].n,
				100*float64(items[i].n)/float64(total))
		}
	}
	attribute(counts, bd.KernTextXIP, kernC.Symbols, "kernel-xip-text")
	counts = run("ramtext", bd.KernCRText, bd.KernCData)
	attribute(counts, bd.KernCRText, kernC.Symbols, "kernel-ramtext")
	counts = run("arena", bd.Arena, bd.ArenaEnd)
	var tot uint64
	for _, c := range counts {
		tot += uint64(c)
	}
	fmt.Printf("PROF arena(app) total=%d\n", tot)
}
