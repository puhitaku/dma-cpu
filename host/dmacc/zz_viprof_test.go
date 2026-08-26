package dmacc_test

// TestProfileVi: flash-read histogram of vi cursor motion — the
// silicon torture case (one hjkl keypress runs magnitudes more code
// than a shell echo, and vi's text is XIP BY DESIGN, prompts/041's
// pre-relocation). Counts machine flash reads over vi's XIP text,
// the kernel XIP text and sh's XIP text while hjkl is pressed 24
// times in an open file on the feather.

import (
	"os"
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

func TestProfileVi(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (~1 min of emulation): set RADIO_PROBES=1")
	}
	bd := boards.Feather
	const keys = 24
	settle := func(m *emu.Machine, feed string, budget uint64) {
		m.FeedConsole(feed)
		var spent uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 25 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
				t.Fatalf("%v (tail %q)", err, tailB(m.ConsoleOut, 200))
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) == last {
				quiet++
			} else {
				quiet = 0
				last = len(m.ConsoleOut)
			}
		}
	}
	run := func(name string, lo, hi uint32) uint64 {
		m, kernC := bootXshBoard(t, nil, bd)
		registerVi(t, m, kernC, bd)
		m.TXPace = 0
		settle(m, "vi README\r", 4_000_000_000)
		t.Logf("%s after-vi tail: %q", name, tailB(m.ConsoleOut, 300))
		m.Profile(lo, hi)
		for i := 0; i < keys; i++ {
			settle(m, string("hjkl"[i%4]), 400_000_000)
		}
		counts := m.ProfileCounts()
		var tot uint64
		for _, c := range counts {
			tot += uint64(c)
		}
		m.Profile(0, 0)
		return tot
	}
	vi := run("vitext", bd.ViHome, bd.ViEnd)
	kt := run("kerntext", bd.KernTextXIP, bd.KernTextXIP+300000)
	fmt.Printf("VIPROF flash reads over %d hjkl: vi=%d kernel=%d  (per key: vi=%d kernel=%d)\n",
		keys, vi, kt, vi/keys, kt/keys)
}
