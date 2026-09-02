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
	"bytes"
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
//
// The first three phases were re-recorded for prompts/044: the boot
// banner is still on screen under them, and one of its klogts()
// stamps is now the honest [0.004] the framebuffer bring-up takes
// instead of the [0.000] a stopped tick counter used to report. Three
// glyphs of a kernel log line, and nothing about the renderer.
//
// "scroll" was re-recorded when `ps` and `nyancat` joined the app set:
// the phase is twelve `ls /dev`, /dev/apps is the registry rendered as
// text, and two more names took it from 98 bytes to 109 — one more
// digit in a size column, twelve times over. Also not the renderer.
//
// And re-recorded again when lut_build moved onto the DMA copier: the
// stamp on the same line reads [0.003] now, because the bring-up it
// times is a millisecond shorter. The last three phases — the ones
// that scroll or clear the banner off the screen — are byte-identical
// across that change, which is the evidence that the renderer draws
// exactly what it drew before.
var fbPixelGolden = []string{
	"5b5ef22631ecb9e1", // echo
	"93835f9f154627a5", // edit
	"2b38bc282bcc7015", // escapes
	"0c96f66b41c21189", // scroll
	"61f3584764f48f15", // clear
	"af897c4b882ea0fd", // after clear
}

// The RGB332 bytes kfbcon paints for the ANSI colors nyancat uses
// (kfbcon.c fbpal, quantized from the SimpleTerminal colormap). Named
// here so the assertions below read as colors and not as hex.
const (
	fbBrightBlue    = 0x03 // 104: the sky the whole frame sits on
	fbBrightMagenta = 0xE3 // 105: the poptart body and the cheeks
	fbGray          = 0x92 // 100: the cat
	fbBrightRed     = 0xE0 // 101: the rainbow's top stripe
	fbBrightYellow  = 0xFC // 103: the rainbow's yellow stripe
	fbBrightGreen   = 0x1C // 102: the rainbow's green stripe
	fbDarkBlue      = 0x02 // 44:  the rainbow's bottom stripe
	fbBlack         = 0x00 // 40:  the sprite outline, and a clear screen
)

// TestXv6Nyancat runs the nyancat port on the feather's framebuffer
// console and looks at the pixels it leaves. There is no golden digest
// here on purpose: the frame the run happens to stop on is a property
// of the cycle budget, while what the port has to get right is that
// the 16-color background escapes it emits reach kfbcon's palette at
// all — so the assertion is a color census, which every frame of the
// animation satisfies and a broken color table cannot.
//
// The exit path is the other half: nyancat parks in select() on the
// console, so one keystroke has to end it, put the console back in
// cooked mode, reset the colors and hand the shell a live prompt.
func TestXv6Nyancat(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, _ := bootXshBoard(t, nil, bd)
	m.TXPace = 0
	census := func() map[byte]int {
		h := map[byte]int{}
		for off := uint32(0); off < 640*480; off += 4 {
			w := m.Peek32(bd.FbBuf + off)
			for k := 0; k < 4; k++ {
				h[byte(w>>(8*k))]++
			}
		}
		return h
	}
	// A fixed budget, which the deterministic emulator turns into a
	// fixed number of frames: ~5 at the port's 90 ms pacing.
	spin := func(budget uint64) {
		var spent uint64
		for spent < budget {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 20_000_000})
			if err != nil {
				t.Fatalf("%v\nconsole tail: %q", err, tailB(m.ConsoleOut, 300))
			}
			spent += rr.Cycles
		}
	}
	m.FeedConsole("nyancat\r")
	spin(300_000_000)

	h := census()
	for _, want := range []struct {
		px   byte
		name string
		min  int
	}{
		{fbBrightBlue, "sky", 100_000},
		{fbBrightMagenta, "poptart pink", 10_000},
		{fbGray, "cat", 10_000},
		{fbBlack, "sprite outline", 10_000},
		{fbBrightRed, "rainbow red", 2_000},
		{fbBrightYellow, "rainbow yellow", 2_000},
		{fbBrightGreen, "rainbow green", 2_000},
		{fbDarkBlue, "rainbow dark blue", 2_000},
	} {
		if h[want.px] < want.min {
			t.Errorf("framebuffer has %d px of %s (rgb332 %#02x), want >= %d",
				h[want.px], want.name, want.px, want.min)
		}
	}
	// 640x480 is 307200 px and the animation fills all of it: an
	// unpainted gutter or a half-drawn frame shows up here.
	if h[fbBlack] > 60_000 {
		t.Errorf("%d px still black: the frame did not cover the screen", h[fbBlack])
	}

	// One keystroke, and the port must land back at a prompt.
	m.FeedConsole("q")
	var quit uint64
	for quit < 200_000_000 && !bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 5_000_000})
		if err != nil {
			t.Fatal(err)
		}
		quit += rr.Cycles
	}
	if !bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
		t.Fatalf("no prompt after the keypress\nconsole tail: %q", tailB(m.ConsoleOut, 300))
	}
	// Colors reset AND the screen given back: SGR 0 put the console's
	// background at palette 0, so the clear that follows paints black
	// and the only lit pixels left are the prompt's own glyph.
	h = census()
	if h[fbBlack] < 640*480-2_000 {
		t.Errorf("%d px black after exit: the screen was not cleared to the "+
			"default background (colors not reset?)", h[fbBlack])
	}
	// And the shell is really alive, not just echoing a stale prompt.
	before := len(m.ConsoleOut)
	m.FeedConsole("echo alive\r")
	runScript(t, m, 200_000_000)
	if !strings.Contains(string(m.ConsoleOut[before:]), "alive") {
		t.Errorf("shell not alive after nyancat: %q", string(m.ConsoleOut[before:]))
	}
}

// TestXv6NyancatDelta is the frame diff's oracle. After the first
// frame the port stops redrawing and emits only the cells whose color
// changed, addressed absolutely (user/nyancat.c delta_frame), which
// means every frame from the second on is built by TRUSTING what is
// already on the screen. One stale byte of that bookkeeping and the
// cat grows a seam no color census would notice.
//
// The animation is twelve frames and then it repeats, so the port's
// thirteenth frame draws animation frame 0 for the second time — the
// first time as a full redraw, this time as a diff against the twelve
// frames in between. The two screens have to be pixel-identical over
// the whole crop, gutter included; frame 2 is captured as well, so a
// delta path that emitted NOTHING could not pass by standing still.
func TestXv6NyancatDelta(t *testing.T) {
	t.Parallel()
	bd := boards.Feather
	m, _ := bootXshBoard(t, nil, bd)
	m.TXPace = 0
	// The crop's 29 cell rows of 16 px. The counter line below them is
	// left out on purpose: its second count is meant to differ.
	const cropPx = 29 * 16 * 640
	shot := func() []byte {
		b := make([]byte, 0, cropPx)
		for off := uint32(0); off < cropPx; off += 4 {
			w := m.Peek32(bd.FbBuf + off)
			b = append(b, byte(w), byte(w>>8), byte(w>>16), byte(w>>24))
		}
		return b
	}
	// Advance to the point where n frames have been emitted AND the
	// port has gone back to sleep, so the screen holds a whole frame.
	// Every frame ends with the counter line, which is the only place
	// the word appears.
	frames := func(n int) {
		t.Helper()
		var spent uint64
		quiet, last := 0, len(m.ConsoleOut)
		for spent < 2_000_000_000 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000})
			if err != nil {
				t.Fatalf("%v\nconsole tail: %q", err, tailB(m.ConsoleOut, 300))
			}
			spent += rr.Cycles
			if len(m.ConsoleOut) != last {
				last, quiet = len(m.ConsoleOut), 0
				continue
			}
			quiet++
			if quiet >= 4 && bytes.Count(m.ConsoleOut, []byte("seconds!")) >= n {
				return
			}
		}
		t.Fatalf("frame %d never arrived (saw %d)\nconsole tail: %q", n,
			bytes.Count(m.ConsoleOut, []byte("seconds!")), tailB(m.ConsoleOut, 300))
	}
	m.FeedConsole("nyancat\r")
	frames(1)
	full := shot()
	frames(2)
	moved := shot()
	frames(13)
	delta := shot()

	if bytes.Equal(moved, full) {
		t.Fatal("frame 2 left the crop untouched: the diff emitted nothing")
	}
	if !bytes.Equal(delta, full) {
		n, first := 0, -1
		for i := range delta {
			if delta[i] != full[i] {
				if first < 0 {
					first = i
				}
				n++
			}
		}
		t.Errorf("frame 13 differs from the full redraw of the same animation "+
			"frame in %d px (first at row %d, col %d): the diff lost track of "+
			"the screen", n, first/640, first%640)
	}

	// And the exit path still ends the run and hands the shell back.
	m.FeedConsole("q")
	var quit uint64
	for quit < 200_000_000 && !bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 5_000_000})
		if err != nil {
			t.Fatal(err)
		}
		quit += rr.Cycles
	}
	if !bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
		t.Fatalf("no prompt after the keypress\nconsole tail: %q", tailB(m.ConsoleOut, 300))
	}
}
