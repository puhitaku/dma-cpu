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

// bootGame compiles and boots the gamepico bare-metal image exactly
// as dmxgen ships it (XIP text, SRAM data+ramtext, baked ctrl words).
func bootGame(t *testing.T) *emu.Machine {
	t.Helper()
	bd := boards.GamePico
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}
	var mods []*llir.Module
	for _, p := range []string{"gmain", "gfx", "lcd", "grt"} {
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
	entry, err := prog.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	memctrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		emu.CtrlIncrRead | v.CtrlIncrWrite | v.CtrlChainTo(11) |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlIRQQuiet
	spictrl := emu.CtrlEN | emu.CtrlSize16 | emu.CtrlIncrRead |
		v.CtrlChainTo(11) | v.CtrlTreq(v.DreqSPI0TX) | v.CtrlIRQQuiet
	m.Poke32(mustSym(t, prog, "g_memctrl"), memctrl)
	m.Poke32(mustSym(t, prog, "g_spictrl"), spictrl)
	t.Logf("entry %#x (seg %d off %#x)", entry, prog.Image.EntrySeg, prog.Image.EntryOff)
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entry, Scratch: bd.Scratch,
	}); err != nil {
		t.Fatal(err)
	}
	return m
}

func TestGameBoot(t *testing.T) {
	t.Parallel()
	m := bootGame(t)
	rr, err := m.Run(emu.RunConfig{MaxCycles: 400_000_000})
	if err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	t.Logf("stop %v after %d cycles; console %d bytes, spi %d writes",
		rr.Reason, rr.Cycles, len(m.ConsoleOut), len(m.SPIOut))
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{"GAMEPICO: boot", "GAMEPICO: lcd up",
		"GAMEPICO: test card shown"} {
		if !strings.Contains(out, want) {
			t.Errorf("missing %q", want)
		}
	}
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

func TestGameTestCard(t *testing.T) {
	t.Parallel()
	m := bootGame(t)
	if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000_000}); err != nil {
		t.Fatalf("%v", err)
	}
	p := decodeLCD(m, 16 /* PIN_LCD_DC */)
	if !p.sawSlpout || !p.sawDispon || !p.sawInvon || p.colmod != 0x55 {
		t.Fatalf("init sequence: slpout=%v dispon=%v invon=%v colmod=%#x",
			p.sawSlpout, p.sawDispon, p.sawInvon, p.colmod)
	}
	// test card: 8 bars of 30px; sample bar centers on row 90
	rgb := func(r, g, b int) uint16 {
		return uint16(((r & 0xF8) << 8) | ((g & 0xFC) << 3) | ((b & 0xF8) >> 3))
	}
	wants := []uint16{rgb(255, 255, 255), rgb(255, 255, 0), rgb(0, 255, 255),
		rgb(0, 255, 0), rgb(255, 0, 255), rgb(255, 0, 0), rgb(0, 0, 255), rgb(0, 0, 0)}
	for i, want := range wants {
		got := p.px[90*240+i*30+15]
		if got != want {
			t.Errorf("bar %d: got %#04x want %#04x", i, got, want)
		}
	}
	// footer text row has both fg and bg pixels
	if p.px[220*240+2] == 0 {
		t.Errorf("footer background missing")
	}
	// optional PNG for human eyes
	if dir := os.Getenv("GAME_LCD_PNG"); dir != "" {
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
		f, _ := os.Create(dir + "/lcd.png")
		_ = png.Encode(f, img)
		f.Close()
		t.Logf("wrote %s/lcd.png", dir)
	}
}
