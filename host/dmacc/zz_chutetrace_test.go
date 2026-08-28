package dmacc_test

import (
	"fmt"
	"testing"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestZZChuteTrace observes Parachute FRAME BY FRAME: it fires
// volleys at multiple aim angles, and at every game-frame boundary
// reads the bullet/debris state from the arena and decodes the LCD
// panel from the captured SPI stream — a live bullet that left no ink
// on the panel that frame is a BLINK, a position step larger than the
// velocity is a JUMP. Written to reproduce the silicon report of
// blinking / vanishing / too-fast bullets (async-flush tearing).
func TestZZChuteTrace(t *testing.T) {
	m, prog := bootGame(t)
	at := runUntil(t, m, "menu up", 0, 300_000_000)
	for _, marker := range []string{"menu: LANWalk", "menu: Yacht",
		"menu: Parachute"} {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, marker, at, 100_000_000)
	}
	press(t, m, prog, pinA)
	runUntil(t, m, "chute: start", at, 100_000_000)

	// struct cst field offsets from g_arena (see chute.c)
	arena := mustSym(t, prog, "g_arena_w")
	const (
		offBX  = 32 // bx[3]
		offBY  = 44
		offBVX = 56
		offBVY = 68
		offHX  = 104 // hx[2]
		offHY  = 112
		offDX  = 296 // dx_[12]
		offDY  = 344
		offFrame = 684 // after dfx/dfy/dtl/dht joined the struct
	)
	rd := func(off, i int) int32 {
		return int32(m.Peek32(arena + uint32(off+4*i)))
	}

	// stepFrame runs the machine until the game's frame counter
	// advances by EXACTLY one, so every observation lands once per
	// frame; a skipped frame (counter +2 in one chunk) resets the
	// jump tracking instead of reporting a phantom jump.
	skipped := false
	stepFrame := func() {
		f0 := m.Peek32(arena + offFrame)
		for spent := 0; spent < 800; spent++ {
			f := m.Peek32(arena + offFrame)
			if f != f0 {
				skipped = f != f0+1
				return
			}
			if _, err := m.Run(emu.RunConfig{MaxCycles: 250_000}); err != nil {
				t.Fatal(err)
			}
		}
		t.Fatalf("frame counter stuck at %d", f0)
	}

	ink := rgb565(24, 28, 26)
	type prev struct{ x, y int32 }
	last := map[int]prev{}
	blinks, jumps, checked := 0, 0, 0

	observe := func(tag string) {
		p := decodeLCD(m, 16)
		for b := 0; b < 3; b++ {
			bx, by := rd(offBX, b), rd(offBY, b)
			if bx == -999 {
				delete(last, b)
				continue
			}
			// jump check: one frame moves at most 4 px per axis, and
			// the sampler may catch a state pre- or post-march — so
			// two samples can legitimately differ by up to two
			// marches (8 px); more is a real teleport
			if pr, ok := last[b]; ok && !skipped {
				ddx, ddy := bx-pr.x, by-pr.y
				if ddx > 8 || ddx < -8 || ddy > 8 || ddy < -8 {
					jumps++
					t.Errorf("%s: bullet %d JUMPED (%d,%d)->(%d,%d)",
						tag, b, pr.x, pr.y, bx, by)
				}
			}
			last[b] = prev{bx, by}
			// visibility check, only where nothing else can pollute:
			// clear of the HUD strip, the ground, the gun column, any
			// live helicopter and any debris rect
			if by < 24 || by > 200 || (bx > 96 && bx < 144) {
				continue
			}
			clear := true
			for h := 0; h < 2 && clear; h++ {
				hx, hy := rd(offHX, h), rd(offHY, h)
				if hx != -999 && bx > hx-20 && bx < hx+20 &&
					by > hy-8 && by < hy+18 {
					clear = false
				}
			}
			for d := 0; d < 12 && clear; d++ {
				dx, dy := rd(offDX, d), rd(offDY, d)
				if dx != -999 && bx > dx-9 && bx < dx+9 &&
					by > dy-9 && by < dy+9 {
					clear = false
				}
			}
			if !clear {
				continue
			}
			checked++
			// the panel shows the last PRESENTED frame; the sampled
			// state may be one march ahead — accept ink anywhere
			// within one march of the sampled position
			if n := p.countColor(int(bx)-8, int(by)-3, int(bx)+8,
				int(by)+8, ink); n < 6 {
				blinks++
				t.Errorf("%s: bullet %d at (%d,%d) INVISIBLE (%d ink px)",
					tag, b, bx, by, n)
			}
		}
	}

	// volleys: center, far left, far right, then mixed re-fires —
	// multiple bullets, multiple times, multiple angles
	volley := func(tag string, aims ...int) {
		for _, mvs := range aims {
			pin := pinLeft
			if mvs > 0 {
				pin = pinRight
			} else {
				mvs = -mvs
			}
			for i := 0; i < mvs; i++ {
				press(t, m, prog, pin)
			}
			press(t, m, prog, pinA) // fire
			// presses consume unobserved frames: a slot may die and
			// be re-fired meanwhile — restart the jump tracking
			last = map[int]prev{}
			for f := 0; f < 30; f++ {
				stepFrame()
				observe(tag)
			}
		}
	}
	volley("v1", 0)      // straight up from the default aim
	volley("v2", -4, +8) // far left, then sweep to far right
	volley("v3", -4, -2, +3)
	fmt.Printf("TRACE: %d frame-checks, %d blinks, %d jumps\n",
		checked, blinks, jumps)
	if checked < 40 {
		t.Errorf("only %d clear-air checks — tighten the script", checked)
	}
}
