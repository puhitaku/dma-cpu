package main

import (
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
	// R=255 G=0 B=85: the only exactly representable levels are
	// multiples of 255/levels — codes 7, 0, 1 -> 0xE1
	draw.Draw(img, img.Bounds(), &image.Uniform{color.NRGBA{255, 0, 85, 255}}, image.Point{}, draw.Src)
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
		if b != 0xE1 {
			t.Fatalf("pixel %d = %#02x, want 0xe1", i, b)
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
	// average the green channel over a band and compare to the source
	for _, x := range []int{100, 300, 500} {
		var sum, n float64
		for y := 0; y < fbH; y++ {
			for dx := -8; dx <= 8; dx++ {
				g := int(sld[y*fbW+x+dx]>>2) & 7
				sum += float64(g) * 255 / 7
				n++
			}
		}
		want := float64(x) * 255 / 639
		if got := sum / n; got < want-8 || got > want+8 {
			t.Fatalf("ramp at x=%d: mean %.1f, want ~%.1f", x, got, want)
		}
	}
}
