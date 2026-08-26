package dmacc_test

// Silicon-report diagnostics (2026-08, not part of the regular suite's
// assertions beyond their own): the feather showed (1) display sync
// loss during ls/show since the SD speed round and (2) a whole-machine
// stall after ~10 keypresses. These tests hunt both in the emulator:
// slow single-keystroke typing around SD traffic, and a write-trample
// probe over the scanout descriptor table region.

import (
	"fmt"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// chDump formats one DMA channel's registers for a stall report.
func chDump(m *emu.Machine, ch int) string {
	base := uint32(0x50000000 + ch*0x40)
	return fmt.Sprintf("ch%-2d rd=%08x wr=%08x cnt=%d ctrl=%08x",
		ch, m.Peek32(base), m.Peek32(base+4), m.Peek32(base+8), m.Peek32(base+0x10))
}

func stallReport(m *emu.Machine) string {
	var b strings.Builder
	for _, ch := range []int{7, 9, 10, 11, 12, 13} {
		b.WriteString(chDump(m, ch))
		b.WriteByte('\n')
	}
	return b.String()
}

// typeSlow feeds s one keystroke at a time, requiring the console echo
// to grow after each key. Returns an error naming the key that stalled.
func typeSlow(t *testing.T, m *emu.Machine, s string, gap uint64) error {
	t.Helper()
	for i := 0; i < len(s); i++ {
		before := len(m.ConsoleOut)
		m.FeedConsole(s[i : i+1])
		var spent uint64
		for spent < 600_000_000 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
				return fmt.Errorf("key %d (%q): %v", i, s[i], err)
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) > before {
				break
			}
		}
		if len(m.ConsoleOut) == before {
			return fmt.Errorf("key %d of %d (%q): no echo after %d cycles\n%s",
				i, len(s), s[i], uint64(600_000_000), stallReport(m))
		}
		// Inter-key gap: the machine runs on (ticks, drawing, SD).
		for spent = 0; spent < gap; {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
				return fmt.Errorf("gap after key %d: %v", i, err)
			}
			spent += rr.Cycles
		}
	}
	return nil
}

// TestDiagKeyFreeze: slow typing at the prompt, around SD commands and
// while a foreground program runs — the silicon freeze scenario.
func TestDiagKeyFreeze(t *testing.T) {
	m, _ := bootXshBoard(t, nil, boards.Feather)
	m.SDImage = sdCardImage(t)
	// Joystick pins idle high, or the viewer sees phantom presses.
	v := m.Variant()
	for _, pin := range []int{24, 26, 27, 28, 29} {
		m.Poke32(v.GPIOCtrlAddr(pin), v.GPIOOutCtrl(true))
	}

	// Phase 1: plain typing at the prompt (no SD ever touched).
	if err := typeSlow(t, m, "echo aa\recho bb\recho cc\recho dd\recho ee\r", 4_000_000); err != nil {
		t.Fatalf("phase1 (plain typing): %v\nconsole tail:\n%s", err, tailB(m.ConsoleOut, 400))
	}

	// Phase 2: mount + ls typed slowly (keys interleave with SD reads).
	if err := typeSlow(t, m, "mkdir sd\rmount /dev/sd0 sd\rls sd\rls sd\r", 4_000_000); err != nil {
		t.Fatalf("phase2 (SD typing): %v\nconsole tail:\n%s", err, tailB(m.ConsoleOut, 400))
	}
	if !strings.Contains(string(m.ConsoleOut), "a.sld") {
		t.Fatalf("phase2: ls never listed a.sld\nconsole tail:\n%s", tailB(m.ConsoleOut, 400))
	}

	// Phase 3: keys WHILE show draws off the card (wake aimed at a
	// running process mid-SD-burst).
	m.FeedConsole("show sd\r")
	var spent uint64
	for spent < 3_000_000_000 && !strings.Contains(string(m.ConsoleOut), "Start drawing") {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
		if err != nil {
			t.Fatalf("phase3 start: %v", err)
		}
		spent += rr.Cycles
	}
	for k := 0; k < 30; k++ { // keys the viewer ignores, mid-draw
		m.FeedConsole("x")
		for spent = 0; spent < 30_000_000; {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
			if err != nil {
				t.Fatalf("phase3 key %d: %v", k, err)
			}
			spent += rr.Cycles
		}
	}
	m.FeedConsole("q\r") /* \r clears the line if show already quit */
	for spent = 0; spent < 3_000_000_000 && !strings.HasSuffix(string(m.ConsoleOut), "$ "); {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000})
		if err != nil {
			t.Fatalf("phase3 quit: %v", err)
		}
		spent += rr.Cycles
	}
	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		t.Fatalf("phase3: no prompt after quitting show — machine stalled?\n%s\nconsole tail:\n%s",
			stallReport(m), tailB(m.ConsoleOut, 400))
	}

	// Phase 4: more plain typing after the SD workout.
	if err := typeSlow(t, m, "echo ff\recho gg\recho hh\r", 4_000_000); err != nil {
		t.Fatalf("phase4 (post-SD typing): %v\nconsole tail:\n%s", err, tailB(m.ConsoleOut, 400))
	}
}

// TestDiagDtabTrample: the scanout descriptor table lives at
// [DTabRAM, ConsRings) with the arena's top-down heaps ending exactly
// at its base. Paint the region, run the SD workload, and report any
// machine-side write — the sync-loss-on-ls/show hypothesis.
func TestDiagDtabTrample(t *testing.T) {
	bd := boards.Feather
	m, _ := bootXshBoard(t, nil, bd)
	m.SDImage = sdCardImage(t)

	lo, hi := bd.DTabRAM, bd.ConsRings
	paint := func() {
		for a := lo; a < hi; a += 4 {
			m.Poke32(a, 0xD7AB0000|(a&0xFFFF))
		}
	}
	check := func(phase string) {
		t.Helper()
		var hits []string
		for a := lo; a < hi; a += 4 {
			if got := m.Peek32(a); got != 0xD7AB0000|(a&0xFFFF) {
				hits = append(hits, fmt.Sprintf("%08x=%08x", a, got))
				if len(hits) >= 8 {
					break
				}
			}
		}
		if len(hits) > 0 {
			t.Fatalf("%s: scanout table region written: %s\nconsole tail:\n%s",
				phase, strings.Join(hits, " "), tailB(m.ConsoleOut, 400))
		}
	}

	paint()
	m.FeedConsole("mkdir sd\rmount /dev/sd0 sd\r")
	runScript(t, m, 2_000_000_000)
	check("mount")
	m.FeedConsole("ls sd\r")
	runScript(t, m, 1_000_000_000)
	check("ls")
	m.FeedConsole("show sd\r")
	var spent uint64
	for spent < 4_000_000_000 && !strings.Contains(string(m.ConsoleOut), "Done drawing") {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 4_000_000})
		if err != nil {
			t.Fatalf("show: %v", err)
		}
		spent += rr.Cycles
	}
	if !strings.Contains(string(m.ConsoleOut), "Done drawing") {
		t.Fatalf("show never drew\nconsole tail:\n%s", tailB(m.ConsoleOut, 400))
	}
	check("show slide")
	m.FeedConsole("q")
	runScript(t, m, 1_000_000_000)
	check("show quit")
}
