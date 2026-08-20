package main

import (
	"encoding/binary"
	"image"
	"image/color"
	"image/draw"
	"image/png"
	"os"
	"path/filepath"
	"testing"
)

func writePNG(t *testing.T, path string, img image.Image) {
	t.Helper()
	f, err := os.Create(path)
	if err != nil {
		t.Fatal(err)
	}
	if err := png.Encode(f, img); err != nil {
		t.Fatal(err)
	}
	f.Close()
}

// A solid 4:3 source must fill the framebuffer edge to edge with the
// exact RGB332 code — no letterbox, no dither noise on an exact color.
func TestSolidFill(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 320, 240))
	// Pure white: the one color the display model renders exactly
	// (0xFF -> 255,255,255), so the dither has zero error to diffuse.
	draw.Draw(img, img.Bounds(), &image.Uniform{color.NRGBA{255, 255, 255, 255}}, image.Point{}, draw.Src)
	p := filepath.Join(t.TempDir(), "solid.png")
	writePNG(t, p, img)

	sld, err := convert(p, true)
	if err != nil {
		t.Fatal(err)
	}
	if len(sld) != slideBytes {
		t.Fatalf("size %d, want %d", len(sld), slideBytes)
	}
	for i, b := range sld {
		if b != 0xFF {
			t.Fatalf("pixel %d = %#02x, want 0xff", i, b)
		}
	}
}

// A 1:1 source letterboxes left and right: black pillars, white
// center, and the content width matches the aspect math (480 canvas
// px wide -> 80-px pillars).
func TestPillarbox(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 200, 200))
	draw.Draw(img, img.Bounds(), image.White, image.Point{}, draw.Src)
	p := filepath.Join(t.TempDir(), "sq.png")
	writePNG(t, p, img)

	sld, err := convert(p, true)
	if err != nil {
		t.Fatal(err)
	}
	row := sld[120*fbW : 121*fbW]
	for x := 0; x < 79; x++ {
		if row[x] != 0 || row[fbW-1-x] != 0 {
			t.Fatalf("pillar not black at x=%d/%d", x, fbW-1-x)
		}
	}
	for x := 81; x < fbW-81; x++ {
		if row[x] != 0xFF {
			t.Fatalf("content not white at x=%d: %#02x", x, row[x])
		}
	}
}

// A horizontal gray ramp must dither: adjacent-code mixtures, and the
// row average must track the source ramp (no banding-style bias).
func TestDitherRamp(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 640, 480))
	for x := 0; x < 640; x++ {
		v := uint8(x * 255 / 639)
		draw.Draw(img, image.Rect(x, 0, x+1, 480), &image.Uniform{color.NRGBA{v, v, v, 255}}, image.Point{}, draw.Src)
	}
	p := filepath.Join(t.TempDir(), "ramp.png")
	writePNG(t, p, img)

	sld, err := convert(p, true)
	if err != nil {
		t.Fatal(err)
	}
	// average the DISPLAYED green over a band and compare to the
	// source (the dither targets the display model, not raw codes)
	for _, x := range []int{100, 300, 500} {
		var sum, n float64
		for y := 0; y < fbH; y++ {
			for dx := -8; dx <= 8; dx++ {
				_, dg, _ := display(sld[y*fbW+x+dx])
				sum += dg
				n++
			}
		}
		want := float64(x) * 255 / 639
		if got := sum / n; got < want-8 || got > want+8 {
			t.Fatalf("ramp at x=%d: mean %.1f, want ~%.1f", x, got, want)
		}
	}
}

// The 169 series pre-squeezes horizontally by 3/4: the same square
// source spans 480 columns in the 43 render and 360 in the 169 one,
// with the vertical extent unchanged.
func TestSqueeze169(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 200, 200))
	draw.Draw(img, img.Bounds(), image.White, image.Point{}, draw.Src)

	span := func(sld []byte) int {
		row := sld[120*fbW : 121*fbW]
		n := 0
		for _, p := range row {
			if p != 0 {
				n++
			}
		}
		return n
	}
	normal := render(img, 1, 1, false)
	wide := render(img, squeeze169, 1, false)
	if got := span(normal); got < 478 || got > 482 {
		t.Errorf("43 content span %d, want ~480", got)
	}
	if got := span(wide); got < 358 || got > 362 {
		t.Errorf("169 content span %d, want ~360", got)
	}
	// vertical extent identical: both fill the full 240 rows
	for _, sld := range [][]byte{normal, wide} {
		if sld[0*fbW+320] == 0 || sld[(fbH-1)*fbW+320] == 0 {
			t.Errorf("square source should span the full height")
		}
	}
}

// Arbitrary input sizes fit with aspect preserved: a 1000x3000 (1:3)
// source letterboxes to 160 columns wide, full height.
func TestOddSizeFit(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 1000, 3000))
	draw.Draw(img, img.Bounds(), image.White, image.Point{}, draw.Src)
	sld := render(img, 1, 1, false)
	row := sld[120*fbW : 121*fbW]
	n := 0
	for _, p := range row {
		if p != 0 {
			n++
		}
	}
	if n < 158 || n > 162 {
		t.Errorf("1:3 source content span %d, want ~160 (480/3)", n)
	}
}

// The deck container round-trips: magic, table geometry, and each
// slide recoverable at its recorded offset.
func TestDeckLayout(t *testing.T) {
	mk := func(fill byte) []byte {
		b := make([]byte, slideBytes)
		for i := range b {
			b[i] = fill
		}
		return b
	}
	p := filepath.Join(t.TempDir(), "deck.sldk")
	if err := writeDeck(p, []series{
		{name: "43", slides: [][]byte{mk(1), mk(2)}},
		{name: "169", slides: [][]byte{mk(3), mk(4)}},
	}); err != nil {
		t.Fatal(err)
	}
	d, err := os.ReadFile(p)
	if err != nil {
		t.Fatal(err)
	}
	if string(d[:4]) != deckMagic {
		t.Fatalf("magic %q", d[:4])
	}
	u32 := func(off int) uint32 { return binary.LittleEndian.Uint32(d[off:]) }
	if u32(4) != 1 || u32(8) != 2 || u32(12) != slideBytes {
		t.Fatalf("header: ver %d nseries %d slidebytes %d", u32(4), u32(8), u32(12))
	}
	if len(d) != 16+24*2+4*slideBytes {
		t.Fatalf("total size %d", len(d))
	}
	for si, want := range [][2]byte{{'4', 1}, {'1', 3}} {
		e := 16 + 24*si
		if d[e] != want[0] {
			t.Errorf("series %d name starts %q", si, d[e])
		}
		count, off := u32(e+12), u32(e+16)
		if count != 2 {
			t.Errorf("series %d count %d", si, count)
		}
		if d[off] != want[1] || d[off+slideBytes] != want[1]+1 {
			t.Errorf("series %d slides misplaced (first byte %d)", si, d[off])
		}
	}
}

// The under flavor shrinks both dimensions inside a black frame: a
// 4:3 source that fills the frame at 43 spans ~576 columns and ~432
// rows at 0.9, with black on all four edges.
func TestUnderscan(t *testing.T) {
	img := image.NewNRGBA(image.Rect(0, 0, 320, 240))
	draw.Draw(img, img.Bounds(), image.White, image.Point{}, draw.Src)
	sld := render(img, 1, 0.9, false)
	span := 0
	for _, p := range sld[240*fbW : 241*fbW] {
		if p != 0 {
			span++
		}
	}
	if span < 574 || span > 578 {
		t.Errorf("under content width %d, want ~576", span)
	}
	rows := 0
	for y := 0; y < fbH; y++ {
		if sld[y*fbW+320] != 0 {
			rows++
		}
	}
	if rows < 430 || rows > 434 {
		t.Errorf("under content height %d, want ~432", rows)
	}
	if sld[0] != 0 || sld[fbW*fbH-1] != 0 {
		t.Errorf("under corners should be black")
	}
}
