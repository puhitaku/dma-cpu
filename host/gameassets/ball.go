// Package gameassets renders build-time assets for the gamepico
// console, shared by cmd/dmxgen (which bakes them into the flash
// blob) and the emulator test harness (which stages the same bytes).
package gameassets

import "math"

// BallBlob renders the Boing demo's ball: the software 3D runs
// HERE, offline — a checkered sphere ray-cast per pixel for each
// rotation phase — and the machine only ever span-blits the result
// (the Amiga original was precomputed too; palette cycling stood in
// for the spin). Layout, shared with boing.c: 88 x {x0, w} span
// bytes (even, so every row blit stays on the word-DMA fast path),
// then NPH phases of 88x88 RGB565. Phase NPH wraps to phase 0: the
// per-phase longitude step spans the checker's 90-degree color
// period (eight 88 px phases keep the blob under the flash window). Colors
// must match boing.c's C_BG (span slack pixels erase as background).
func BallBlob() []byte {
	const bw, nph = 88, 8
	const r = 43.0
	rgb := func(rr, g, b int) uint16 {
		return uint16((rr&0xF8)<<8 | (g&0xFC)<<3 | (b&0xF8)>>3)
	}
	red, white, bg := rgb(216, 40, 40), rgb(255, 255, 255), rgb(170, 170, 170)
	tilt := 17 * math.Pi / 180
	blob := make([]byte, 2*bw)
	for y := 0; y < bw; y++ {
		dy := (float64(y) + 0.5 - 44) / r
		if dy*dy >= 1 {
			continue
		}
		half := math.Sqrt(1-dy*dy) * r
		x0 := int(44-half) &^ 1
		if x0 < 0 {
			x0 = 0
		}
		x1 := int(math.Ceil(44 + half))
		w := (x1 - x0 + 1) &^ 1
		if x0+w > bw {
			w = bw - x0
		}
		blob[2*y], blob[2*y+1] = byte(x0), byte(w)
	}
	for ph := 0; ph < nph; ph++ {
		// the checker's TRUE period is 90 degrees (two 45-degree cells:
		// parity flips per cell), so the phases span 90 — a 45-degree
		// wrap swapped red and white and the ball visibly restarted
		lonoff := float64(ph) * (90.0 / nph) * math.Pi / 180
		for y := 0; y < bw; y++ {
			for x := 0; x < bw; x++ {
				px := (float64(x) + 0.5 - 44) / r
				py := -(float64(y) + 0.5 - 44) / r
				c := bg
				if d2 := px*px + py*py; d2 < 1 {
					z := math.Sqrt(1 - d2)
					x1 := px*math.Cos(tilt) - py*math.Sin(tilt)
					y1 := px*math.Sin(tilt) + py*math.Cos(tilt)
					if y1 > 1 {
						y1 = 1
					}
					if y1 < -1 {
						y1 = -1
					}
					lat := math.Asin(y1)
					lon := math.Atan2(z, x1) + lonoff
					lo := int(math.Floor(lon / (45 * math.Pi / 180)))
					la := int(math.Floor((lat + math.Pi/2) / (30 * math.Pi / 180)))
					if (lo+la)&1 == 0 {
						c = red
					} else {
						c = white
					}
				}
				blob = append(blob, byte(c), byte(c>>8))
			}
		}
	}
	return blob
}
