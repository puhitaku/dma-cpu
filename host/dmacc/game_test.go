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
	"github.com/puhitaku/dma-cpu/host/gameassets"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/pgo"
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

// compileGameDasm compiles the gamepico bare-metal image. It mirrors
// dmxgen's buildGame exactly: the harness must share the shipped
// layout, or the data tail lands differently against the fixed audio
// region (a divergence found as a PC of 0x23282328 — replayed drum
// samples — in TestGameSeq).
func compileGameDasm(t *testing.T, tweak ...func(*dmacc.Options)) string {
	t.Helper()
	var mods []*llir.Module
	for _, p := range []string{"gmain", "menu", "dino", "lanwalk", "yacht",
		"input", "fx", "seq", "grad", "cpumon", "bench", "radio", "gfx",
		"boing", "chute", "puni", "lcd", "grt"} {
		mods = append(mods, parseLL(t, "../../target/game/ll/"+p+".ll"))
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	opts := dmacc.Options{
		Entry: "gmain", NoSafepoints: true, XIPText: true,
		ResidentFuncs: []string{"shoot", "clearance", "in_box"},
		OptSize:       true, HotFuncs: pgo.GameHotFuncs, HotSites: pgo.GameHotSites,
		InlineSites: pgo.GameInlineSites,
		ColdBlocks:  pgo.GameColdBlocks}
	// The PGO driver's inline-site trim compiles candidate sets through
	// here, so the search prices the shipped image shape.
	for _, f := range tweak {
		f(&opts)
	}
	dasm, err := dmacc.Compile(mod, opts)
	if err != nil {
		t.Fatal(err)
	}
	return dasm
}

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
	prog, err := dmaasm.Assemble(compileGameDasm(t), dmaasm.Options{
		Variant: v, Compact: true,
		TextBase: bd.GameTextXIP, DataBase: bd.GameData,
		RAMTextBase: bd.GameRAMText,
		PoolText:    true, HotLits: pgo.GameLits})
	if err != nil {
		t.Fatal(err)
	}
	return bootGameImage(t, prog), prog
}

// bootGameImage loads an assembled game image into a fresh machine and
// applies the boot-time pokes the loader does on silicon: the helper
// channel CTRL words, the staged PCM table and the ball blob's home.
func bootGameImage(t *testing.T, prog *dmaasm.Result) *emu.Machine {
	t.Helper()
	bd := boards.GamePico
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(v)
	m.Flash = make([]byte, bd.FlashSize)
	sfx, drums, ballHome := stageSFX(t, m)
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
	m.Poke32(mustSym(t, prog, "g_ball_home"), ballHome)
	da := mustSym(t, prog, "g_daddr")
	for i, a := range drums {
		m.Poke32(da+uint32(4+4*i), a)
	}
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entry, Scratch: bd.Scratch,
	}); err != nil {
		t.Fatal(err)
	}
	return m
}

// sfxClip is one staged PCM clip: flash address and sample count.
type sfxClip struct {
	addr, samples uint32
}

// stageSFX loads the game's WAV clips into the emulated flash at the
// same home dmxgen uses, returning the table the loader would poke.
func stageSFX(t *testing.T, m *emu.Machine) ([]sfxClip, []uint32, uint32) {
	t.Helper()
	const home = 0x10143000 // dmxgen's gameSFXHome
	off := uint32(0)
	var clips []sfxClip
	var drums []uint32
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
	// the drum kit and the Boing ball ride the same blob (mirrors
	// dmxgen buildGame). Everything returns by value: tests run in
	// parallel, and package-level staging state raced.
	for _, clip := range gameassets.DrumPCM() {
		copy(m.Flash[home-0x10000000+off:], clip)
		drums = append(drums, home+off)
		off += uint32(len(clip))
	}
	ball := gameassets.BallBlob()
	copy(m.Flash[home-0x10000000+off:], ball)
	return clips, drums, home + off
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
//
// The hold ends at the frame that observes it, not at a cycle count:
// in_poll writes g_in_down once per frame, so watching that word stops
// the run on the frame boundary itself. A plain cycle step overshoots
// by however many frames fit in it — enough to hand a 45-frame
// hold-to-quit gesture a whole press at any frame rate the codegen
// happens to reach.
func press(t *testing.T, m *emu.Machine, prog *dmaasm.Result, pin int) {
	t.Helper()
	bit := btnBit[pin]
	down := mustSym(t, prog, "g_in_down")
	wait := func(want bool) {
		for spent := 0; spent < 4000; spent++ {
			if (m.Peek32(down)&bit != 0) == want {
				return
			}
			if _, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000,
				WatchWrites: []uint32{down}}); err != nil {
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
	// mask sits at arena offset 0 by lanwalk.c's contract
	maskAddr := mustSym(t, prog, "g_arena_w")
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
	press(t, m, prog, pinUp) // wraps up: Dino -> Arm Info
	at = runUntil(t, m, "menu: Arm Info", at, 100_000_000)
	press(t, m, prog, pinUp) // -> Benchmark
	at = runUntil(t, m, "menu: Benchmark", at, 100_000_000)
	press(t, m, prog, pinUp) // -> Gradient
	at = runUntil(t, m, "menu: Gradient", at, 100_000_000)
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
	press(t, m, prog, pinUp) // wraps up: Dino -> Arm Info (scrolls)
	at = runUntil(t, m, "menu: Arm Info", at, 100_000_000)
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
		"menu: Parachute", "menu: Puni Puni", "menu: Boing",
		"menu: Radiosity"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "radio: up", at, 100_000_000)
	// The scene claims fx.c's ring the moment it starts: ch9 must be
	// stopped BEFORE the first patch store, or the arrays are audible.
	if ctrl := m.Peek32(0x50000240 + 0x10); ctrl&emu.CtrlEN != 0 {
		t.Errorf("audio ch9 still enabled inside radio: CTRL %#x", ctrl)
	}
	// Let the lamp finish shooting and a first bounce land: the ceiling
	// light must have lit the floor, and the red/green walls must be
	// bleeding their colors.
	at = runUntil(t, m, "radio: shot 48", at, 40_000_000_000)

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
	at = runUntil(t, m, "radio: back", at, 400_000_000)
	// ...and the ring goes back the way it was found. A scene that
	// handed the channel back over its own patch words would play them
	// as the menu's first sound, which is exactly what aud_release
	// exists to prevent: the ring must be silent and ch9 must be
	// streaming it again.
	for a := uint32(0x20038000); a < 0x2003C000; a += 4 {
		if v := m.Peek32(a); v != 0 {
			t.Fatalf("audio ring not zeroed on exit: %#x = %#x", a, v)
		}
	}
	if ctrl := m.Peek32(0x50000240 + 0x10); ctrl&emu.CtrlEN == 0 {
		t.Errorf("audio ch9 left paused after radio: CTRL %#x", ctrl)
	}
	// The menu is live again: it draws, and it answers the stick.
	at = runUntil(t, m, "menu up", at, 200_000_000)
	press(t, m, prog, pinDown) // the selection reset to the top row
	runUntil(t, m, "menu: LANWalk", at, 200_000_000)
}

// gradEnter walks the menu down to Gradient and starts it, returning
// the console offset just past the scene's "up" marker.
func gradEnter(t *testing.T, m *emu.Machine, prog *dmaasm.Result) int {
	t.Helper()
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute", "menu: Puni Puni", "menu: Boing",
		"menu: Radiosity", "menu: Sequencer", "menu: Gradient"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	return runUntil(t, m, "grad: up", at, 100_000_000)
}

// gradLabels counts the label box's grey inside one bar's numeral
// band — zero until a channel band is wider than its numeral.
func gradLabels(p *lcdPanel, ybar int) int {
	return p.countColor(0, ybar+44, 239, ybar+51, rgb565(216, 200, 184))
}

// TestGameGrad: the panel gradient probe. The scene is an instrument,
// so the test checks what the instrument claims — four ramps in the
// right channels, each running dark to bright with no reversal, the
// window responding to the stick, and the numerals appearing only once
// a band is wide enough to hold one.
func TestGameGrad(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := gradEnter(t, m, prog)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 40_000_000}); err != nil {
		t.Fatal(err) // let the default view finish its flush
	}
	p := decodeLCD(m, 16)
	// The four bars start below the 16-px header; sample a row well
	// clear of the numeral band at the bottom of each.
	lev := func(y, x int) (int, int, int) {
		c := p.px[y*240+x]
		return int(c >> 11), int((c >> 5) & 0x3F), int(c & 0x1F)
	}
	bars := []struct {
		name string
		y    int
		ch   int // 0=r 1=g 2=b, 3=grey
	}{{"R", 30, 0}, {"G", 90, 1}, {"B", 145, 2}, {"W", 200, 3}}
	for _, b := range bars {
		r0, g0, b0 := lev(b.y, 8)
		r1, g1, b1 := lev(b.y, 230)
		var lo, hi int
		switch b.ch {
		case 0:
			lo, hi = r0, r1
			if g0|b0|g1|b1 != 0 {
				t.Errorf("R bar is not pure red: %d,%d,%d .. %d,%d,%d",
					r0, g0, b0, r1, g1, b1)
			}
		case 1:
			lo, hi = g0, g1
			if r0|b0|r1|b1 != 0 {
				t.Errorf("G bar is not pure green: %d,%d,%d .. %d,%d,%d",
					r0, g0, b0, r1, g1, b1)
			}
		case 2:
			lo, hi = b0, b1
			if r0|g0|r1|g1 != 0 {
				t.Errorf("B bar is not pure blue: %d,%d,%d .. %d,%d,%d",
					r0, g0, b0, r1, g1, b1)
			}
		default:
			lo, hi = r0, r1
			// grey: the 6-bit green carries one extra bit of the
			// same code, so g>>1 is r and b exactly
			if r0 != b0 || r1 != b1 || g0>>1 != r0 || g1>>1 != r1 {
				t.Errorf("W bar is not grey: %d,%d,%d .. %d,%d,%d",
					r0, g0, b0, r1, g1, b1)
			}
		}
		// green counts in 6-bit codes, the rest in 5-bit
		want := 28
		if b.ch == 1 {
			want = 56
		}
		if lo > 4 || hi < want {
			t.Errorf("%s bar ramp: level %d at x=8, %d at x=230 (want <=4 .. >=%d)",
				b.name, lo, hi, want)
		}
		// and it never runs backwards across the width
		prev := 0
		for x := 0; x < 240; x++ {
			r, g, bl := lev(b.y, x)
			v := r
			if b.ch == 1 {
				v = g
			} else if b.ch == 2 {
				v = bl
			}
			if v < prev {
				t.Fatalf("%s bar falls at x=%d: %d after %d", b.name, x, v, prev)
			}
			prev = v
		}
	}
	// full range: a band is 7.5 px wide (3.75 for green), far too
	// narrow for a numeral, so no label boxes are painted at all
	for _, ybar := range []int{16, 72, 128, 184} {
		if n := gradLabels(p, ybar); n != 0 {
			t.Errorf("bar at y=%d: %d label pixels at full range", ybar, n)
		}
	}
	dumpPNG(t, p, "grad.png")

	// Zoom in three times: the window closes on its center (0..255 ->
	// 112..143), so the left edge brightens and the R and B bands grow
	// wide enough to carry their numerals.
	for i := 0; i < 3; i++ {
		press(t, m, prog, pinUp)
		at = runUntil(t, m, "grad: view ", at, 100_000_000)
	}
	if _, err := m.Run(emu.RunConfig{MaxCycles: 40_000_000}); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(m.ConsoleOut), "grad: view 112-143") {
		t.Errorf("zoom did not land on 112-143; console tail:\n%s",
			tailLines(string(m.ConsoleOut), 6))
	}
	p = decodeLCD(m, 16)
	if r, _, _ := lev(30, 4); r < 12 {
		t.Errorf("zoomed R bar starts at level %d, want >=12", r)
	}
	for _, ybar := range []int{16, 72, 128} {
		if n := gradLabels(p, ybar); n < 200 {
			t.Errorf("bar at y=%d: only %d label pixels when zoomed", ybar, n)
		}
	}
	// ...but W stays a clean reference ramp, at every zoom
	if n := gradLabels(p, 184); n != 0 {
		t.Errorf("W bar carries %d label pixels; it must stay bare", n)
	}

	// press goes back, and the menu is live again
	press(t, m, prog, pinA)
	at = runUntil(t, m, "grad: back", at, 200_000_000)
	at = runUntil(t, m, "menu up", at, 200_000_000)
	press(t, m, prog, pinDown)
	runUntil(t, m, "menu: LANWalk", at, 200_000_000)
}

// tailLines returns the last n lines of s, for failure messages that
// want the console's end and not all of it.
func tailLines(s string, n int) string {
	ls := strings.Split(strings.TrimRight(s, "\n"), "\n")
	if len(ls) > n {
		ls = ls[len(ls)-n:]
	}
	return strings.Join(ls, "\n")
}

func TestGameBench(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: Arm Info", "menu: Benchmark"} {
		press(t, m, prog, pinUp) // wraps up past the chip page
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

	// The composite score is recomputed host-side with the same
	// integer arithmetic bench.c uses: per-kernel rate from the
	// printed ops/us, then the seven compute rates in k-ops/s plus
	// the memory stream per 100k words/s.
	var rates []uint64
	pin := map[string]uint64{}
	for _, name := range []string{"bogo ", "sieve", "sort ", "mul  ",
		"div  ", "rand ", "shr1 ", "mem  "} {
		re := regexp.MustCompile(`BENCH ` + name + `\s+ops=(\d+) us=(\d+)`)
		mm := re.FindStringSubmatch(out)
		if mm == nil {
			t.Fatalf("%s: no BENCH line for the score check", name)
		}
		ops, _ := strconv.ParseUint(mm[1], 10, 32)
		us, _ := strconv.ParseUint(mm[2], 10, 32)
		pin["game/us/"+strings.TrimSpace(name)] = us
		ms := us / 1000
		if ms == 0 {
			ms = 1
		}
		rates = append(rates, ops/ms*1000+ops%ms*1000/ms)
	}
	var sum uint64
	for _, r := range rates[:7] {
		sum += r
	}
	wantScore := sum/1000 + rates[7]/100000
	sm := regexp.MustCompile(`BENCH score=(\d+)`).FindStringSubmatch(out)
	if sm == nil {
		t.Errorf("missing score line")
	} else if got, _ := strconv.ParseUint(sm[1], 10, 32); got != wantScore {
		t.Errorf("score=%d, want %d", got, wantScore)
	}
	// The per-kernel times are the game's performance ratchet: they
	// come from the emulator's scaled cycle counter, so they are
	// deterministic and they move when codegen does. (The score and
	// mips100 lines are not pinned — at emulated time scale every
	// kernel's rate rounds to zero, so both print 0 whatever the
	// compiler does.) Checked only when DMACC_BENCH runs the other
	// heavy benches, so an ordinary `make test` still costs what it
	// did (prompts/042 §8).
	if heavyRatchet() {
		pinSet(t, "game/", pin)
	}

	// the headline score figure renders in live green, right of the
	// SCORE label
	p := decodeLCD(m, 16)
	live := rgb565(90, 240, 140)
	if n := p.countColor(112, 160, 231, 176, live); n < 60 {
		t.Errorf("score headline: %d live-green pixels", n)
	}
	dumpPNG(t, p, "bench.png")
	_ = at
}

func TestGameBoing(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute", "menu: Puni Puni", "menu: Boing"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "boing: start", at, 100_000_000)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 120_000_000}); err != nil {
		t.Fatal(err) // ~a dozen frames: the ball is on screen and moving
	}
	p := decodeLCD(m, 16)
	bg := rgb565(170, 170, 170)
	red := rgb565(216, 40, 40)
	white := rgb565(255, 255, 255)
	if n := p.countColor(0, 0, 239, 239, bg); n < 20000 {
		t.Errorf("background: %d gray pixels", n)
	}
	nr := p.countColor(0, 0, 239, 239, red)
	nw := p.countColor(0, 0, 239, 239, white)
	if nr < 1000 || nw < 1000 {
		t.Errorf("ball: %d red + %d white pixels", nr, nw)
	}
	// the checkered ball is roughly half red, half white
	if nr+nw < 5000 || nr+nw > 9000 {
		t.Errorf("ball area: %d checker pixels (want ~7000)", nr+nw)
	}
	dumpPNG(t, p, "boing.png")
	_ = at
}

func TestGameChute(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "chute: start", at, 100_000_000)
	// a helicopter spawns on the very first frame; let it fly in and
	// drop, then fire a few rounds across the sky
	if _, err := m.Run(emu.RunConfig{MaxCycles: 100_000_000}); err != nil {
		t.Fatal(err)
	}
	press(t, m, prog, pinA) // fire
	press(t, m, prog, pinLeft)
	press(t, m, prog, pinA)
	// Short, because the scene is CPU-paced: chute.c renders as fast as
	// frame_sync lets it, so every codegen speedup advances the scene
	// further per cycle. The sample has to land while the gun is still
	// standing — a trooper that reaches it ends the round, and the
	// screen the assertions below describe becomes "Destroyed!". At the
	// 2026-08-29 inline-compare wave the round survived to 30M cycles
	// here and was over by 40M; before it, to past 60M.
	if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000_000}); err != nil {
		t.Fatal(err)
	}
	p := decodeLCD(m, 16)
	sky := rgb565(164, 184, 172)
	ink := rgb565(24, 28, 26)
	if n := p.countColor(0, 0, 239, 225, sky); n < 30000 {
		t.Errorf("sky: %d pale pixels", n)
	}
	if n := p.countColor(104, 210, 135, 227, ink); n < 80 {
		t.Errorf("gun dome: %d ink pixels", n)
	}
	if n := p.countColor(0, 226, 239, 239, rgb565(60, 64, 54)); n < 2000 {
		t.Errorf("ground: %d pixels", n)
	}
	dumpPNG(t, p, "chute.png")
	_ = at
}

func TestGamePuni(t *testing.T) {
	t.Parallel()
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute", "menu: Puni Puni"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	at = runUntil(t, m, "puni: start", at, 100_000_000)
	// soft-drop three pairs to the floor: hold DOWN through each fall
	for pair := 0; pair < 3; pair++ {
		m.SetPadIn(pinDown, false)
		at = runUntil(t, m, "puni: lock", at, 600_000_000)
		m.SetPadIn(pinDown, true)
		if _, err := m.Run(emu.RunConfig{MaxCycles: 20_000_000}); err != nil {
			t.Fatal(err)
		}
	}
	p := decodeLCD(m, 16)
	// six stacked blobs on the floor: some of the four colors present
	colors := []uint16{rgb565(235, 70, 80), rgb565(60, 200, 90),
		rgb565(70, 120, 240), rgb565(240, 200, 60)}
	total := 0
	for _, c := range colors {
		total += p.countColor(12, 12, 119, 227, c)
	}
	if total < 800 {
		t.Errorf("field: only %d blob pixels after three locked pairs", total)
	}
	if n := p.countColor(8, 8, 123, 231, rgb565(70, 76, 110)); n < 500 {
		t.Errorf("well wall: %d pixels", n)
	}
	dumpPNG(t, p, "puni.png")
	_ = at
}
