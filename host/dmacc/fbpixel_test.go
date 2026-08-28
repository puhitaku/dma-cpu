package dmacc_test

// TestXv6FbconPixels is fbcon's pixel oracle. TestXv6Fbcon checks the
// SHAPE of what lands in the framebuffer (a z,q,z,q cell run, a blank
// screen after `clear`); this one pins the bytes. Each phase drives a
// different corner of the renderer — plain glyphs, the line editor's
// backspace echo, a colour change through SGR, a cursor move, a
// scroll burst, a clear — and the whole 640x480 framebuffer is
// digested and compared against a golden captured from the renderer
// before the per-byte path was reworked. Rendering is the contract:
// kfbcon may get faster, it may not draw a different screen.
//
// Re-record with FBCON_PIXEL_RECORD=1, and only after reading why:
// a changed golden is a changed display.

import (
	"fmt"
	"hash/fnv"
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/emu"
)

var fbPixelPhases = []struct{ name, feed string }{
	// Glyphs, a newline, and the cursor left parked at the prompt.
	{"echo", "echo hello world\r"},
	// The line editor's backspace echo ("\b \b"): BS, the space
	// glyph, BS again — and a tab through the same path.
	{"edit", "echo ab\x08\x08cd\tef\r"},
	// SGR and an explicit cursor move, rendered by the console echo
	// before the shell ever sees the line. CSI m (colours, which
	// rebuild both LUTs), CSI C (cursor right), CSI K (erase to end
	// of line).
	{"escapes", "\x1b[31mR\x1b[42mG\x1b[0mN\x1b[5CX\x1b[K\r"},
	// Many lines: the screen fills and every newline past the bottom
	// scrolls (the ch11 row move plus the blanked bottom row).
	{"scroll", strings.Repeat("ls /dev\r", 12)},
	// CSI 2J + CSI H through the tee.
	{"clear", "clear\r"},
	// Glyphs onto the freshly cleared screen, at a known place.
	{"after clear", "echo zqzq\r"},
}

func TestXv6FbconPixels(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, _ := bootXshBoard(t, nil, bd)
	m.TXPace = 0

	settle := func(feed string, budget uint64) {
		m.FeedConsole(feed)
		var spent uint64
		quiet := 0
		last := len(m.ConsoleOut)
		for spent < budget && quiet < 40 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000})
			if err != nil {
				t.Fatalf("%v\nconsole tail: %q", err, tailB(m.ConsoleOut, 300))
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
	// digest folds the whole framebuffer into one value. Peek32 walks
	// it a word at a time; 640x480 RGB332 is 76,800 words.
	digest := func() string {
		h := fnv.New64a()
		var b [4]byte
		for off := uint32(0); off < 640*480; off += 4 {
			w := m.Peek32(bd.FbBuf + off)
			b[0], b[1], b[2], b[3] = byte(w), byte(w>>8), byte(w>>16), byte(w>>24)
			h.Write(b[:])
		}
		return fmt.Sprintf("%016x", h.Sum64())
	}

	var got []string
	for _, p := range fbPixelPhases {
		settle(p.feed, 3_000_000_000)
		got = append(got, digest())
	}
	if os.Getenv("FBCON_PIXEL_RECORD") != "" {
		var sb strings.Builder
		sb.WriteString("var fbPixelGolden = []string{\n")
		for i, g := range got {
			fmt.Fprintf(&sb, "\t%q, // %s\n", g, fbPixelPhases[i].name)
		}
		sb.WriteString("}\n")
		fmt.Print(sb.String())
		return
	}
	if len(fbPixelGolden) != len(got) {
		t.Fatalf("golden has %d phases, session produced %d", len(fbPixelGolden), len(got))
	}
	for i, g := range got {
		if g != fbPixelGolden[i] {
			t.Errorf("phase %q renders different pixels: golden %s, got %s",
				fbPixelPhases[i].name, fbPixelGolden[i], g)
		}
	}
	// A digest that never changes would pass vacuously: every phase
	// must actually move the screen.
	for i := 1; i < len(got); i++ {
		if got[i] == got[i-1] {
			t.Errorf("phase %q left the framebuffer untouched", fbPixelPhases[i].name)
		}
	}
}

// fbPixelGolden is what the session above renders, captured from
// kfbcon.c as it stood before the per-byte path was reworked.
var fbPixelGolden = []string{
	"7c7fba23aa612909", // echo
	"f307d4d68b5b228d", // edit
	"d8ff3ec04b7679bd", // escapes
	"4f13cb23697277dd", // scroll
	"61f3584764f48f15", // clear
	"af897c4b882ea0fd", // after clear
}
