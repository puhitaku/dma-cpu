package dmacc_test

import (
	"image"
	"image/color"
	"image/png"
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/boards"
	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
)

// The joystick pins (GP2..GP6 = up/down/left/right/press; second
// stick GP7..GP11 mirrors them).
const (
	pinUp    = 2
	pinDown  = 3
	pinLeft  = 4
	pinRight = 5
	pinA     = 6
)

// bootGame compiles and boots the gamepico bare-metal image exactly
// as dmxgen ships it (XIP text, SRAM data+ramtext, baked ctrl words).
// All ten joystick pins start high: pulled up means released.
func bootGame(t *testing.T) (*emu.Machine, *dmaasm.Result) {
	t.Helper()
	bd := boards.GamePico
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}
	var mods []*llir.Module
	for _, p := range []string{"gmain", "menu", "dino", "lanwalk", "yacht",
		"input", "fx", "gfx", "lcd", "grt"} {
		mods = append(mods, parseLL(t, "../game/ll/"+p+".ll"))
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{
		Entry: "gmain", NoSafepoints: true, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	prog, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true, CompactScratch: bd.Scratch,
		TextBase: bd.GameTextXIP, DataBase: bd.GameData,
		RAMTextBase: bd.GameRAMText})
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	m.Flash = make([]byte, bd.FlashSize)
	for pin := pinUp; pin <= pinUp+9; pin++ {
		m.SetPadIn(pin, true)
	}
	entry, err := prog.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	memctrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		emu.CtrlIncrRead | v.CtrlIncrWrite | v.CtrlChainTo(11) |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlIRQQuiet
	spictrl := emu.CtrlEN | emu.CtrlSize16 | emu.CtrlIncrRead |
		v.CtrlChainTo(11) | v.CtrlTreq(v.DreqSPI0TX) | v.CtrlIRQQuiet
	sndctrl := emu.CtrlEN | emu.CtrlSize32 | emu.CtrlIncrRead |
		v.CtrlRingSize(12) | v.CtrlChainTo(9) | v.CtrlTreq(0) |
		v.CtrlIRQQuiet
	m.Poke32(mustSym(t, prog, "g_memctrl"), memctrl)
	m.Poke32(mustSym(t, prog, "g_spictrl"), spictrl)
	m.Poke32(mustSym(t, prog, "g_sndctrl"), sndctrl)
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entry, Scratch: bd.Scratch,
	}); err != nil {
		t.Fatal(err)
	}
	return m, prog
}

// runUntil advances the machine in slices until the console contains
// marker (counted from offset from0) or the cycle budget runs out.
// Returns the offset just past the marker for chaining.
func runUntil(t *testing.T, m *emu.Machine, marker string, from0 int,
	budget uint64) int {
	t.Helper()
	spent := uint64(0)
	for spent < budget {
		if i := strings.Index(string(m.ConsoleOut[from0:]), marker); i >= 0 {
			return from0 + i + len(marker)
		}
		if _, err := m.Run(emu.RunConfig{MaxCycles: 10_000_000}); err != nil {
			t.Fatalf("run: %v\nconsole:\n%s", err, m.ConsoleOut)
		}
		spent += 10_000_000
	}
	t.Fatalf("marker %q not seen in %d cycles; console:\n%s",
		marker, budget, m.ConsoleOut)
	return 0
}

// press taps a button adaptively: hold the pin low until the game's
// input state (g_in_down) observes it, then release until it clears.
// Fixed-length presses get swallowed when they start during a long
// draw (in_prev still holds the previous press across a 16M-cycle
// flush), and overstayed holds trip hold-to-quit gestures.
func press(t *testing.T, m *emu.Machine, prog *dmaasm.Result, pin int) {
	t.Helper()
	bit := uint32(1) << ((pin - 2) % 5)
	down := mustSym(t, prog, "g_in_down")
	wait := func(want bool) {
		for spent := 0; spent < 400; spent++ {
			if (m.Peek32(down)&bit != 0) == want {
				return
			}
			if _, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000}); err != nil {
				t.Fatal(err)
			}
		}
		t.Fatalf("pin %d: in_down bit %#x never became %v", pin, bit, want)
	}
	m.SetPadIn(pin, false)
	wait(true)
	m.SetPadIn(pin, true)
	wait(false)
}

// lcdPanel reconstructs the ST7789's GRAM from the captured SPI
// stream: 8-bit frames with D/C low are commands, D/C high are
// parameters; 16-bit frames are pixels landing in the CASET/RASET
// window with the driver's autoincrement.
type lcdPanel struct {
	px             [240 * 240]uint16
	x0, y0, x1, y1 int
	cx, cy         int
	cmd            byte
	np             int
	par            [4]byte
	sawSlpout      bool
	sawDispon      bool
	sawInvon       bool
	colmod         byte
}

func decodeLCD(m *emu.Machine, dcPin int) *lcdPanel {
	p := &lcdPanel{x1: 239, y1: 239}
	// D/C level timeline from GPIOEvents
	type edge struct {
		cyc  uint64
		high bool
	}
	var dc []edge
	for _, e := range m.GPIOEvents {
		if e.Pin == dcPin {
			dc = append(dc, edge{e.Cycle, e.High})
		}
	}
	dcAt := func(cyc uint64) bool {
		hi := true
		for _, e := range dc {
			if e.cyc > cyc {
				break
			}
			hi = e.high
		}
		return hi
	}
	for _, w := range m.SPIOut {
		if w.Size == 2 { // pixel frame
			if p.cmd == 0x2C {
				if p.cy <= p.y1 && p.cx <= p.x1 && p.cy < 240 && p.cx < 240 {
					p.px[p.cy*240+p.cx] = uint16(w.Val)
				}
				p.cx++
				if p.cx > p.x1 {
					p.cx = p.x0
					p.cy++
				}
			}
			continue
		}
		b := byte(w.Val)
		if !dcAt(w.Cycle) { // command
			p.cmd = b
			p.np = 0
			switch b {
			case 0x11:
				p.sawSlpout = true
			case 0x21:
				p.sawInvon = true
			case 0x29:
				p.sawDispon = true
			case 0x2C:
				p.cx, p.cy = p.x0, p.y0
			}
			continue
		}
		// parameter
		if p.np < 4 {
			p.par[p.np] = b
		}
		p.np++
		switch p.cmd {
		case 0x3A:
			p.colmod = b
		case 0x2A:
			if p.np == 4 {
				p.x0 = int(p.par[0])<<8 | int(p.par[1])
				p.x1 = int(p.par[2])<<8 | int(p.par[3])
			}
		case 0x2B:
			if p.np == 4 {
				p.y0 = int(p.par[0])<<8 | int(p.par[1])
				p.y1 = int(p.par[2])<<8 | int(p.par[3])
			}
		}
	}
	return p
}

func dumpPNG(t *testing.T, p *lcdPanel, name string) {
	dir := os.Getenv("GAME_LCD_PNG")
	if dir == "" {
		return
	}
	img := image.NewNRGBA(image.Rect(0, 0, 240, 240))
	for y := 0; y < 240; y++ {
		for x := 0; x < 240; x++ {
			c := p.px[y*240+x]
			r := uint8((c >> 11) << 3)
			g := uint8(((c >> 5) & 0x3F) << 2)
			b := uint8((c & 0x1F) << 3)
			img.Set(x, y, color.NRGBA{r, g, b, 255})
		}
	}
	f, err := os.Create(dir + "/" + name)
	if err != nil {
		t.Fatal(err)
	}
	_ = png.Encode(f, img)
	f.Close()
	t.Logf("wrote %s/%s", dir, name)
}

func rgb565(r, g, b int) uint16 {
	return uint16(((r & 0xF8) << 8) | ((g & 0xFC) << 3) | ((b & 0xF8) >> 3))
}

// countColor counts pixels of exactly c inside the inclusive rect.
func (p *lcdPanel) countColor(x0, y0, x1, y1 int, c uint16) int {
	n := 0
	for y := y0; y <= y1; y++ {
		for x := x0; x <= x1; x++ {
			if p.px[y*240+x] == c {
				n++
			}
		}
	}
	return n
}

func TestGameMenu(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	out := string(m.ConsoleOut)
	for _, want := range []string{"GAMEPICO: boot", "GAMEPICO: lcd up"} {
		if !strings.Contains(out, want) {
			t.Errorf("missing %q", want)
		}
	}
	p := decodeLCD(m, 16 /* PIN_LCD_DC */)
	if !p.sawSlpout || !p.sawDispon || !p.sawInvon || p.colmod != 0x55 {
		t.Fatalf("init sequence: slpout=%v dispon=%v invon=%v colmod=%#x",
			p.sawSlpout, p.sawDispon, p.sawInvon, p.colmod)
	}
	title := rgb565(255, 210, 60)
	if n := p.countColor(56, 44, 183, 45, title); n < 200 {
		t.Errorf("title underline: %d pixels of %#04x", n, title)
	}
	selbg := rgb565(40, 70, 140)
	if n := p.countColor(32, 92, 207, 115, selbg); n < 500 {
		t.Errorf("selected item background: %d pixels", n)
	}
	// fx: the machine armed the audio streamer at boot — silence is
	// zeros flowing into TXF0 — and lit both LEDs dim blue.
	if !strings.Contains(out, "GAMEPICO: fx up") {
		t.Errorf("missing fx up marker")
	}
	if len(m.PIO0TX[0]) == 0 {
		t.Errorf("no audio frames streamed to TXF0")
	}
	for _, w := range m.PIO0TX[0] {
		if w != 0 {
			t.Errorf("audio not silent at boot: frame %#x", w)
			break
		}
	}
	if n := len(m.PIO0TX[1]); n != 2 {
		t.Errorf("LED words = %d, want 2", n)
	} else {
		want := uint32(0x04<<16|0x00<<8|0x18) << 8 // GRB of 0x000418
		if m.PIO0TX[1][0] != want || m.PIO0TX[1][1] != want {
			t.Errorf("LED frames %#x,%#x want %#x",
				m.PIO0TX[1][0], m.PIO0TX[1][1], want)
		}
	}
	// cursor moves narrate — and blip: nonzero samples appear, then
	// the tone times out back to silence.
	audio0 := len(m.PIO0TX[0])
	press(t, m, prog, pinDown)
	at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
	press(t, m, prog, pinDown)
	runUntil(t, m, "menu: Yacht", at, 100_000_000)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 60_000_000}); err != nil {
		t.Fatal(err)
	}
	loud := 0
	for _, w := range m.PIO0TX[0][audio0:] {
		if w != 0 {
			loud++
		}
	}
	if loud == 0 {
		t.Errorf("menu blip made no sound")
	}
	tail := m.PIO0TX[0][len(m.PIO0TX[0])-8:]
	for _, w := range tail {
		if w != 0 {
			t.Errorf("tone did not decay to silence: tail %#x", tail)
			break
		}
	}
	dumpPNG(t, decodeLCD(m, 16), "menu.png")
}

func TestGameDino(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	press(t, m, prog, pinA) // Dinosaur is the default selection
	at = runUntil(t, m, "dino: start", at, 100_000_000)
	// one jump, then let the first cactus win
	press(t, m, prog, pinUp)
	at = runUntil(t, m, "dino: over score=", at, 2_000_000_000)
	p := decodeLCD(m, 16)
	over := rgb565(200, 40, 40)
	if n := p.countColor(48, 130, 192, 146, over); n < 100 {
		t.Errorf("GAME OVER text: %d red pixels", n)
	}
	dumpPNG(t, p, "dino.png")
	// press restarts
	press(t, m, prog, pinA)
	runUntil(t, m, "dino: start", at, 100_000_000)
	// down exits to the menu... after the restart dies again someday;
	// just verify the restart marker arrived (above).
}

func TestGameLANWalk(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	press(t, m, prog, pinDown)
	at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
	press(t, m, prog, pinA)
	at = runUntil(t, m, "lanwalk: start", at, 100_000_000)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 30_000_000}); err != nil {
		t.Fatal(err) // let the board draw
	}

	// The board is a spanning tree: every cell reachable in the
	// solved orientation. Verify the generated masks are sane and
	// that four rotations of the cursor tile return it to its start.
	maskAddr := mustSym(t, prog, "g_mask")
	readMask := func() []byte {
		mk := make([]byte, 49)
		for i := 0; i < 49; i++ {
			w := m.Peek32(maskAddr + uint32(i&^3))
			mk[i] = byte(w >> ((uint(i) & 3) * 8))
		}
		return mk
	}
	before := readMask()
	nonzero := 0
	for _, v := range before {
		if v != 0 {
			nonzero++
		}
	}
	if nonzero < 40 {
		t.Fatalf("board looks empty: %d wired cells of 49", nonzero)
	}
	for i := 0; i < 4; i++ {
		press(t, m, prog, pinA)
	}
	after := readMask()
	if string(before) != string(after) {
		t.Errorf("four rotations did not return the tile: %v -> %v",
			before[24], after[24])
	}
	p := decodeLCD(m, 16)
	server := rgb565(255, 170, 40)
	if n := p.countColor(15+3*30, 8+3*30, 15+4*30-1, 8+4*30-1, server); n < 100 {
		t.Errorf("server tile: %d orange pixels", n)
	}
	dumpPNG(t, p, "lanwalk.png")
	_ = at
}

func TestGameYacht(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	press(t, m, prog, pinUp) // wraps to Yacht
	at = runUntil(t, m, "menu: Yacht", at, 100_000_000)
	press(t, m, prog, pinA)
	at = runUntil(t, m, "yacht: start", at, 100_000_000)
	// the cursor starts on ROLL: reroll once, then book Aces
	press(t, m, prog, pinA) // ROLL
	at = runUntil(t, m, "yacht: roll", at, 100_000_000)
	press(t, m, prog, pinDown) // into the sheet
	press(t, m, prog, pinA)    // book
	at = runUntil(t, m, "yacht: cat=0 score=", at, 100_000_000)
	p := decodeLCD(m, 16)
	die := rgb565(245, 245, 235)
	if n := p.countColor(6, 18, 173, 45, die); n < 1000 {
		t.Errorf("dice row: %d white pixels", n)
	}
	dumpPNG(t, p, "yacht.png")
	_ = at
}
