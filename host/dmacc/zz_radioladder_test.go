package dmacc_test

// TestRadioLadder: what does raising the radiosity grid actually cost?
// Walks the demo from "radio: up" through a ladder of shot milestones
// and prints the machine cycles each one took; with GAME_LCD_PNG set it
// also dumps the panel at every rung, which is how the grids were
// compared at EQUAL energy progress rather than at equal shot counts.
// The grid edge N is a compile-time constant in radio.c, so the ladder
// is walked by editing that constant and re-running this probe — the
// numbers it prints are what picked the shipped N (see the radio.c
// header for the budgets that bound it).
//
// Two things it deliberately does not do. It never waits for "radio:
// converged": that marker is thousands of shots away at every N — the
// stop test is a residual-energy floor, not a visual one — so it prices
// a state no viewer ever sits through. And it does not assume a shot is
// a shot: a patch holds FLUX, so a finer grid divides the same room
// energy into more, smaller shots, and the fair comparison is
// shots x NP, not shots. RADIO_SHOTS overrides the rungs (a
// comma-separated list of multiples of 16) so the equal-energy points
// can be sampled directly.
//
// Resolution is the runUntil chunk (10M cycles): every figure is the
// first chunk boundary at or after the marker, so read the low digits
// as noise. Wall-clock on silicon is cycles / 250e6 seconds PLUS the
// LCD flush each repaint pays on the wire, which the emulator drains
// instantly and this probe therefore cannot see.

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"testing"
)

func TestRadioLadder(t *testing.T) {
	if os.Getenv("RADIO_PROBES") == "" {
		t.Skip("diagnostic probe (long emulation): set RADIO_PROBES=1")
	}
	rungs := []int{16, 32, 64, 128, 256}
	if s := os.Getenv("RADIO_SHOTS"); s != "" {
		rungs = nil
		for _, f := range strings.Split(s, ",") {
			n, err := strconv.Atoi(strings.TrimSpace(f))
			if err != nil || n <= 0 || n%16 != 0 {
				t.Fatalf("RADIO_SHOTS: %q is not a positive multiple of 16", f)
			}
			rungs = append(rungs, n)
		}
	}
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute", "menu: Puni Puni", "menu: Boing",
		"menu: Radiosity"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "radio: up", at, 100_000_000)
	up := m.Cycle
	fmt.Printf("LADDER entry at cycle %d (project+setup+first full repaint follow)\n", up)

	prev, prevShot := up, 0
	for _, shot := range rungs {
		// CRLF: grt.c's uputc grows every LF a CR, and the terminator
		// is what keeps "shot 16" from matching "shot 160".
		at = runUntil(t, m, fmt.Sprintf("radio: shot %d\r\n", shot), at,
			200_000_000_000)
		now := m.Cycle
		per := (now - prev) / uint64(shot-prevShot)
		fmt.Printf("LADDER shot %4d: %12d cycles from entry (%6.2f s at 250 MHz), "+
			"%9d cycles/shot over the last %d\n",
			shot, now-up, float64(now-up)/250e6, per, shot-prevShot)
		prev, prevShot = now, shot
		dumpPNG(t, decodeLCD(m, 16), fmt.Sprintf("ladder%04d.png", shot))
	}
}
