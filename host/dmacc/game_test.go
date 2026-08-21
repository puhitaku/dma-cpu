package dmacc_test

import (
	"image"
	"image/color"
	"image/png"
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// Joystick A's pins, in the as-built harness order (input.c): the
// roles are shuffled within GP2..GP6; stick B mirrors on GP7..GP11.
const (
	pinUp    = 3
	pinDown  = 4
	pinLeft  = 2
	pinRight = 5
	pinA     = 6
)

// btnBit maps a stick-A pin to its BTN_* bit in g_in_down.
var btnBit = map[int]uint32{pinUp: 0x1, pinDown: 0x2, pinLeft: 0x4,
	pinRight: 0x8, pinA: 0x10}

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
		"input", "fx", "seq", "cpumon", "bench", "radio", "gfx", "lcd", "grt"} {
		mods = append(mods, parseLL(t, "../../target/game/ll/"+p+".ll"))
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
	sfx := stageSFX(t, m)
	for pin := 2; pin <= 11; pin++ {
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
		v.CtrlRingSize(14) | v.CtrlChainTo(9) | v.CtrlTreq(0) |
		v.CtrlIRQQuiet
	m.Poke32(mustSym(t, prog, "g_memctrl"), memctrl)
	m.Poke32(mustSym(t, prog, "g_spictrl"), spictrl)
	m.Poke32(mustSym(t, prog, "g_sndctrl"), sndctrl)
	tab := mustSym(t, prog, "g_sfx_tab")
	for i, c := range sfx {
		m.Poke32(tab+uint32(i*8), c.addr)
		m.Poke32(tab+uint32(i*8+4), c.samples)
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entry, Scratch: bd.Scratch,
	}); err != nil {
		t.Fatal(err)
	}
	return m, prog
}

// sfxClip is one staged PCM clip: flash address and sample count.
type sfxClip struct {
	addr, samples uint32
}

// stageSFX loads the game's WAV clips into the emulated flash at the
// same home dmxgen uses, returning the table the loader would poke.
func stageSFX(t *testing.T, m *emu.Machine) []sfxClip {
	t.Helper()
	const home = 0x10140000
	off := uint32(0)
	var clips []sfxClip
	for _, path := range []string{"../../target/game/sfx/dino_fail.wav",
		"../../target/game/sfx/lanwalk_success.wav"} {
		raw, err := os.ReadFile(path)
		if err != nil {
			t.Fatal(err)
		}
		// minimal RIFF walk for the data chunk
		var data []byte
		for o := 12; o+8 <= len(raw); {
			id := string(raw[o : o+4])
			sz := int(uint32(raw[o+4]) | uint32(raw[o+5])<<8 |
				uint32(raw[o+6])<<16 | uint32(raw[o+7])<<24)
			body := raw[o+8:]
			if sz > len(body) {
				sz = len(body)
			}
			if id == "data" {
				data = body[:sz]
			}
			o += 8 + sz + (sz & 1)
		}
		if data == nil {
			t.Fatalf("%s: no data chunk", path)
		}
		copy(m.Flash[home-0x10000000+off:], data)
		clips = append(clips, sfxClip{home + off, uint32(len(data) / 2)})
		off += uint32(len(data)+3) &^ 3
	}
	return clips
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
	bit := btnBit[pin]
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
	if n := p.countColor(32, 76, 207, 97, selbg); n < 500 {
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
		// LED_DIM(0x0040FF) = 0x00040F, GRB on the wire
		want := uint32(0x04<<16|0x00<<8|0x0F) << 8
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
	audio0 := len(m.PIO0TX[0])
	at = runUntil(t, m, "dino: over score=", at, 2_000_000_000)
	// the fail sting streams from flash: replicated mono frames
	if _, err := m.Run(emu.RunConfig{MaxCycles: 30_000_000}); err != nil {
		t.Fatal(err)
	}
	loud, badrep := 0, 0
	for _, w := range m.PIO0TX[0][audio0:] {
		if w != 0 {
			loud++
			if w>>16 != w&0xFFFF {
				badrep++
			}
		}
	}
	if loud < 50 {
		t.Errorf("fail sting made almost no sound: %d nonzero frames", loud)
	}
	if badrep > 0 {
		t.Errorf("%d frames were not halfword-replicated", badrep)
	}
	p := decodeLCD(m, 16)
	over := rgb565(200, 40, 40)
	if n := p.countColor(48, 56, 192, 72, over); n < 100 {
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
	press(t, m, prog, pinDown) // Dino -> LANWalk
	at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
	press(t, m, prog, pinDown) // -> Yacht
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

func TestGameSeq(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	press(t, m, prog, pinUp) // wraps up: Dino -> Arm info (scrolls)
	at = runUntil(t, m, "menu: Arm info", at, 100_000_000)
	press(t, m, prog, pinUp) // -> Radiosity
	at = runUntil(t, m, "menu: Radiosity", at, 100_000_000)
	press(t, m, prog, pinUp) // -> Benchmark
	at = runUntil(t, m, "menu: Benchmark", at, 100_000_000)
	press(t, m, prog, pinUp) // -> Sequencer
	at = runUntil(t, m, "menu: Sequencer", at, 100_000_000)
	press(t, m, prog, pinA)
	at = runUntil(t, m, "seq: up", at, 100_000_000)
	// let the drums render and a few steps play: the default pattern
	// opens with a kick, so the ring must carry non-silence.
	audio0 := len(m.PIO0TX[0])
	if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000_000}); err != nil {
		t.Fatal(err)
	}
	loud := 0
	for _, w := range m.PIO0TX[0][audio0:] {
		if w != 0 {
			loud++
		}
	}
	if loud < 100 {
		t.Fatalf("sequencer made almost no sound: %d nonzero frames", loud)
	}
	// edit a step: cycle the cursor cell once
	press(t, m, prog, pinA)
	at = runUntil(t, m, "seq: step set", at, 100_000_000)
	dumpPNG(t, decodeLCD(m, 16), "seq.png")
	_ = at
}

func TestGameCPUMon(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	press(t, m, prog, pinUp) // wraps to CPU Sleep
	at = runUntil(t, m, "menu: Arm info", at, 100_000_000)
	// simulate the firmware's park stamp so the live idle clock reads
	// a nonzero MM:SS (the emulated timer is fast, so the exact value
	// is unimportant — only that the live path renders green digits)
	m.Poke32(0x2003D004, 1_000_000)
	m.Poke32(0x2003D000, 0x51EE9500)
	press(t, m, prog, pinA)
	at = runUntil(t, m, "cpumon: up", at, 100_000_000)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 40_000_000}); err != nil {
		t.Fatal(err)
	}
	p := decodeLCD(m, 16)
	// the LIVE idle clock (02:17) must render in the live-green color
	live := rgb565(90, 240, 140)
	if n := p.countColor(100, 146, 179, 161, live); n < 60 {
		t.Errorf("idle clock: %d live-green pixels (expected the MM:SS)", n)
	}
	// sleeping-chip faces present (face color)
	face := rgb565(220, 225, 245)
	if n := p.countColor(24, 52, 216, 111, face); n < 40 {
		t.Errorf("chip faces: %d face pixels", n)
	}
	dumpPNG(t, p, "cpumon.png")
	_ = at
}

// benchRef mirrors bench.c's kernels on the host: same xorshift32
// seeding, same fixed work, uint32 wraparound. The silicon-run
// checksums must match these exactly — the benchmark measures
// nothing if the kernels are miscompiled.
type benchRef struct{ xs uint32 }

func (b *benchRef) rand() uint32 {
	b.xs ^= b.xs << 13
	b.xs ^= b.xs >> 17
	b.xs ^= b.xs << 5
	return b.xs
}

func benchExpect() map[string][2]uint32 { // name -> {ops, sum}
	exp := map[string][2]uint32{}
	// seeding, in bench_run order
	b := &benchRef{xs: 0xC0FFEE01}
	scratch := make([]uint32, 1024)
	for i := 0; i < 512; i++ {
		scratch[i] = b.rand()
	}
	ma := make([]uint32, 144)
	mb := make([]uint32, 144)
	for i := 0; i < 144; i++ {
		ma[i] = b.rand() & 0xFF
		mb[i] = b.rand() & 0xFF
	}
	for i := 0; i < 192; i++ {
		scratch[640+i] = b.rand() | 1
	}
	// bogo: sum 1..65536
	exp["bogo"] = [2]uint32{65536, 65536 * 65537 / 2}
	// sieve: 4096 flags, two passes
	var marks, primes uint32
	for pass := 0; pass < 2; pass++ {
		flags := make([]bool, 4096)
		for i := range flags {
			flags[i] = true
		}
		for i := 2; i < 4096; i++ {
			if flags[i] {
				primes++
				for k := i + i; k < 4096; k += i {
					flags[k] = false
					marks++
				}
			}
		}
	}
	exp["sieve"] = [2]uint32{marks, primes}
	// sort: 4 rounds of insertion sort over the pregen data
	var cmps, ssum uint32
	for r := 0; r < 4; r++ {
		a := append([]uint32(nil), scratch[r*128:r*128+128]...)
		for i := 1; i < 128; i++ {
			v := a[i]
			j := i
			for j > 0 {
				cmps++
				if a[j-1] <= v {
					break
				}
				a[j] = a[j-1]
				j--
			}
			a[j] = v
		}
		ssum += a[0] + a[64] + a[127] + uint32(r)*a[7]
	}
	exp["sort"] = [2]uint32{cmps, ssum}
	// mul: 12x12 matmul
	mc := make([]uint32, 144)
	for i := 0; i < 12; i++ {
		for j := 0; j < 12; j++ {
			var acc uint32
			for k := 0; k < 12; k++ {
				acc += ma[i*12+k] * mb[k*12+j]
			}
			mc[i*12+j] = acc
		}
	}
	var msum uint32
	for _, v := range mc {
		msum += v
	}
	exp["mul"] = [2]uint32{12 * 12 * 12, msum}
	// div: Euclid over the pre-seeded pairs
	var steps, dsum uint32
	for i := 0; i < 96; i++ {
		a, bb := scratch[640+i*2], scratch[640+i*2+1]
		for bb != 0 {
			a, bb = bb, a%bb
			steps++
		}
		dsum += a
	}
	exp["div"] = [2]uint32{steps, dsum}
	// rand: 2048 xorshift steps from the fixed seed
	rb := &benchRef{xs: 0x1234567}
	var rsum uint32
	for i := 0; i < 2048; i++ {
		rsum += rb.rand()
	}
	exp["rand"] = [2]uint32{2048, rsum}
	// shr1: the pathological >>1, golden-ratio walk
	v, shsum := uint32(0xDEADBEEF), uint32(0)
	for i := 0; i < 1024; i++ {
		shsum += v >> 1
		v += 0x9E3779B9
	}
	exp["shr1"] = [2]uint32{1024, shsum}
	// mem: last fill value appears at both probe words (u32 wrap)
	fill := uint32(0xA5A5A5A5) + 7
	exp["mem"] = [2]uint32{8 * (1024 + 1024), fill + fill}
	return exp
}

func TestGameRadio(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Sequencer", "menu: Benchmark", "menu: Radiosity"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "radio: up", at, 100_000_000)
	// let a few dozen shots land: the ceiling light must have lit the
	// floor, and the red/green walls must be bleeding their colors
	at = runUntil(t, m, "radio: shot 32", at, 3_000_000_000)

	p := decodeLCD(m, 16)
	// the 2x2 ceiling light renders near-white in the upper middle
	lit := 0
	for y := 5; y < 60; y++ {
		for x := 90; x < 150; x++ {
			c := p.px[y*240+x]
			if c>>11 >= 28 && (c>>5)&0x3F >= 56 { // bright r and g
				lit++
			}
		}
	}
	if lit < 100 {
		t.Errorf("ceiling light: %d bright pixels", lit)
	}
	// left wall red-dominant, right wall green-dominant
	redish, greenish := 0, 0
	for y := 100; y < 140; y++ {
		for x := 5; x < 40; x++ {
			c := p.px[y*240+x]
			if c>>11 > 2*((c>>5)&0x3F)/4 && c>>11 > 0 {
				redish++
			}
		}
		for x := 200; x < 235; x++ {
			c := p.px[y*240+x]
			if (c>>5)&0x3F > 0 && (c>>5)&0x3F/2 >= c>>11 {
				greenish++
			}
		}
	}
	if redish < 200 {
		t.Errorf("left wall: %d red-dominant pixels", redish)
	}
	if greenish < 200 {
		t.Errorf("right wall: %d green-dominant pixels", greenish)
	}
	dumpPNG(t, p, "radio.png")

	// press exits back to the menu
	press(t, m, prog, pinA)
	runUntil(t, m, "radio: back", at, 200_000_000)
}

func TestGameBench(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Sequencer", "menu: Benchmark"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "bench: up", at, 100_000_000)
	at = runUntil(t, m, "bench done", at, 600_000_000)

	// every kernel line must carry the host-computed ops and checksum
	out := string(m.ConsoleOut)
	for name, want := range benchExpect() {
		re := regexp.MustCompile(`BENCH ` + name + `\s+ops=(\d+) us=\d+ sum=([0-9a-f]{8})`)
		mm := re.FindStringSubmatch(out)
		if mm == nil {
			t.Errorf("%s: no BENCH line", name)
			continue
		}
		ops, _ := strconv.ParseUint(mm[1], 10, 32)
		sum, _ := strconv.ParseUint(mm[2], 16, 32)
		if uint32(ops) != want[0] || uint32(sum) != want[1] {
			t.Errorf("%s: ops=%d sum=%08x, want ops=%d sum=%08x",
				name, ops, sum, want[0], want[1])
		}
	}
	if !strings.Contains(out, "BENCH mips100=") {
		t.Errorf("missing MIPS summary line")
	}

	// the headline MIPS figure renders in live green
	p := decodeLCD(m, 16)
	live := rgb565(90, 240, 140)
	if n := p.countColor(8, 160, 119, 176, live); n < 60 {
		t.Errorf("MIPS headline: %d live-green pixels", n)
	}
	dumpPNG(t, p, "bench.png")
	_ = at
}
