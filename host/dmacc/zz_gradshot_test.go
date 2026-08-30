package dmacc_test

import (
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestZZGradShots: the Gradient scene's screenshot probe. It drives the
// scene the way the panel investigation does — the full-range view
// first, then zoomed and panned onto the dark end where the luminance
// step is reported to live — and writes both frames out through the LCD
// decoder. The emulator is bit-true on RGB565 and models no panel, so
// what these prove is the INSTRUMENT: the bands, the numerals and the
// window readout are what the eye on silicon will be reading.
//
// Gated on GAME_LCD_PNG (the directory dumpPNG writes into), so it
// costs an ordinary `go test` run nothing:
//
//	GAME_LCD_PNG=/tmp go test ./host/dmacc -run TestZZGradShots
func TestZZGradShots(t *testing.T) {
	if os.Getenv("GAME_LCD_PNG") == "" {
		t.Skip("screenshot probe: set GAME_LCD_PNG to an output directory")
	}
	m, prog := bootGame(t)
	at := gradEnter(t, m, prog)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 40_000_000}); err != nil {
		t.Fatal(err) // let the default view finish its flush
	}
	dumpPNG(t, decodeLCD(m, 16), "grad-default.png")

	// Three zooms close the window on its center (0..255 -> 112..143),
	// then fourteen LEFT steps of a quarter-view each slide it down onto
	// 0..31 — the dark end, with R and B numbered every 8 codes and G
	// every 4, which is the view the panel hunt actually uses.
	for i := 0; i < 3; i++ {
		press(t, m, prog, pinUp)
		at = runUntil(t, m, "grad: view ", at, 100_000_000)
	}
	for i := 0; i < 14; i++ {
		press(t, m, prog, pinLeft)
		at = runUntil(t, m, "grad: view ", at, 100_000_000)
	}
	if !strings.Contains(string(m.ConsoleOut), "grad: view 000-031") {
		t.Fatalf("the pan did not reach 000-031")
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 40_000_000}); err != nil {
		t.Fatal(err)
	}
	dumpPNG(t, decodeLCD(m, 16), "grad-zoomed.png")
	_ = at
}
