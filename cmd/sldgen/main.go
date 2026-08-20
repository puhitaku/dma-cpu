/*
 * sldgen converts images into slides for the `show` viewer.
 *
 * A slide (.sld) is a raw framebuffer image: 640x480 bytes of RGB332
 * (RRRGGGBB), 307200 bytes exactly — square pixels since the 480p
 * squeeze (prompts/039). Sources of ANY size are fitted (letterboxed,
 * aspect preserved). The viewer row-doubles old 640x240 slides.
 *
 * Usage: sldgen [-o dir] [-deck name] [-nodither] image...
 *
 * Inputs keep their command-line order; per-image outputs are named
 * NN-<stem>.sld so a plain name sort (what the viewer does) replays
 * that order.
 *
 * The deck (default deck.sldk) is the single-file form the viewer
 * pages with seek(): a small header, a series table, and fixed-size
 * slides back to back. It carries TWO series of every image:
 *
 *   43    the normal fit — for displays that show 4:3 as 4:3
 *   169   pre-squeezed horizontally by 3/4 — for projectors that
 *         stretch the 4:3 frame to 16:9; the stretch then restores
 *         the original aspect (`show deck.sldk 169`)
 *
 * Layout (little-endian u32):
 *   0x00  "SLDK"        0x04  version (1)
 *   0x08  series count  0x0C  bytes per slide (153600)
 *   0x10  series entries, 24 bytes each:
 *         name[12] (NUL-padded), count, offset, reserved
 *   then the slides, contiguous per series.
 */
package main

import (
	"bytes"
	"encoding/binary"
	"flag"
	"fmt"
	"image"
	"image/draw"
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
	"math"
	"os"
	"path/filepath"
	"strings"
)

const (
	fbW        = 640
	fbH        = 480
	dispH      = fbH // square pixels: the fb is the display canvas
	slideBytes = fbW * fbH
	maxSlides  = 32 // the viewer's directory cap
	stemMax    = 32 // keep "/sd/NN-stem.sld" well under the 63-char path cap

	// A 4:3 frame stretched onto a 16:9 panel widens by 4/3; the 169
	// series pre-squeezes content by the reciprocal so the stretch
	// cancels out.
	squeeze169 = 3.0 / 4.0

	deckMagic = "SLDK"
)

// A deck series: a name the viewer selects by, and one slide per
// input image.
type series struct {
	name   string
	slides [][]byte
}

// writeDeck serializes the container: header, series table, slides.
func writeDeck(path string, all []series) error {
	var hdr bytes.Buffer
	hdr.WriteString(deckMagic)
	u32 := func(v uint32) { _ = binary.Write(&hdr, binary.LittleEndian, v) }
	u32(1)
	u32(uint32(len(all)))
	u32(slideBytes)
	off := uint32(16 + 24*len(all))
	var body bytes.Buffer
	for _, se := range all {
		var name [12]byte
		copy(name[:], se.name)
		hdr.Write(name[:])
		u32(uint32(len(se.slides)))
		u32(off)
		u32(0)
		for _, sl := range se.slides {
			body.Write(sl)
			off += uint32(len(sl))
		}
	}
	return os.WriteFile(path, append(hdr.Bytes(), body.Bytes()...), 0o644)
}

func main() {
	outdir := flag.String("o", ".", "output directory")
	deckName := flag.String("deck", "deck.sldk", "multi-series deck output (empty to skip)")
	nodither := flag.Bool("nodither", false, "plain quantization instead of Floyd-Steinberg")
	flag.Parse()
	if flag.NArg() == 0 {
		fmt.Fprintln(os.Stderr, "usage: sldgen [-o dir] [-deck name] [-nodither] image...")
		os.Exit(2)
	}
	if flag.NArg() > maxSlides {
		fmt.Fprintf(os.Stderr, "sldgen: warning: %d slides, the viewer lists at most %d per directory\n",
			flag.NArg(), maxSlides)
	}
	if err := os.MkdirAll(*outdir, 0o755); err != nil {
		fatal(err)
	}
	deck := []series{{name: "43"}, {name: "169"}}
	for i, path := range flag.Args() {
		src, err := load(path)
		if err != nil {
			fatal(fmt.Errorf("%s: %w", path, err))
		}
		sld := render(src, 1, !*nodither)
		name := fmt.Sprintf("%02d-%s.sld", i+1, stem(path))
		if err := os.WriteFile(filepath.Join(*outdir, name), sld, 0o644); err != nil {
			fatal(err)
		}
		fmt.Printf("  %s -> %s\n", path, name)
		deck[0].slides = append(deck[0].slides, sld)
		deck[1].slides = append(deck[1].slides, render(src, squeeze169, !*nodither))
	}
	if *deckName != "" {
		p := filepath.Join(*outdir, *deckName)
		if err := writeDeck(p, deck); err != nil {
			fatal(err)
		}
		fmt.Printf("  %d slides x {43, 169} -> %s\n", flag.NArg(), p)
	}
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, "sldgen:", err)
	os.Exit(1)
}

// stem is the input's base name sans extension, trimmed to what a
// slide path on the card can carry, lowercased for stable sorting on
// case-insensitive vfat.
func stem(path string) string {
	s := filepath.Base(path)
	s = strings.TrimSuffix(s, filepath.Ext(s))
	if len(s) > stemMax {
		s = s[:stemMax]
	}
	return strings.ToLower(s)
}

func load(path string) (*image.NRGBA, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	img, _, err := image.Decode(f)
	if err != nil {
		return nil, err
	}
	src := image.NewNRGBA(image.Rect(0, 0, img.Bounds().Dx(), img.Bounds().Dy()))
	draw.Draw(src, src.Bounds(), img, img.Bounds().Min, draw.Src)
	return src, nil
}

// render produces one slide: fit, optional horizontal pre-squeeze,
// resample, quantize.
func render(src *image.NRGBA, hsqueeze float64, dither bool) []byte {
	r, g, b := resample(src, hsqueeze)
	return quantize(r, g, b, dither)
}

// convert is the single-image path the tests exercise.
func convert(path string, dither bool) ([]byte, error) {
	src, err := load(path)
	if err != nil {
		return nil, err
	}
	return render(src, 1, dither), nil
}

// resample letterbox-fits src onto the 640x480 framebuffer (square
// pixels). hsqueeze < 1 additionally narrows
// the content horizontally (anamorphic pre-compensation for displays
// that stretch the frame). Returns per-channel planes in [0,255];
// the letterbox stays exactly 0.
func resample(src *image.NRGBA, hsqueeze float64) (r, g, b []float64) {
	w, h := src.Bounds().Dx(), src.Bounds().Dy()
	r = make([]float64, fbW*fbH)
	g = make([]float64, fbW*fbH)
	b = make([]float64, fbW*fbH)

	scale := math.Min(fbW/float64(w), dispH/float64(h))
	hscale := scale * hsqueeze
	cw, ch := float64(w)*hscale, float64(h)*scale // content size on the canvas
	ox, oy := (fbW-cw)/2, (dispH-ch)/2            // letterbox origin

	for y := 0; y < fbH; y++ {
		// the fb row's canvas span, mapped into source rows
		sy0 := (float64(y) - oy) / scale
		sy1 := (float64(y+1) - oy) / scale
		for x := 0; x < fbW; x++ {
			sx0 := (float64(x) - ox) / hscale
			sx1 := (float64(x+1) - ox) / hscale
			rr, gg, bb, cov := boxAvg(src, sx0, sy0, sx1, sy1)
			i := y*fbW + x
			// partial coverage at the letterbox edge blends with black
			r[i], g[i], b[i] = rr*cov, gg*cov, bb*cov
		}
	}
	return
}

// boxAvg integrates src over the box [x0,x1)x[y0,y1) with fractional
// pixel coverage. Returns the average color of the covered part and
// the fraction of the box that lies inside the image.
func boxAvg(src *image.NRGBA, x0, y0, x1, y1 float64) (r, g, b, cov float64) {
	w, h := src.Bounds().Dx(), src.Bounds().Dy()
	area := (x1 - x0) * (y1 - y0)
	cx0, cy0 := math.Max(x0, 0), math.Max(y0, 0)
	cx1, cy1 := math.Min(x1, float64(w)), math.Min(y1, float64(h))
	if cx0 >= cx1 || cy0 >= cy1 {
		return 0, 0, 0, 0
	}
	var sw float64
	for iy := int(cy0); iy < int(math.Ceil(cy1)); iy++ {
		wy := math.Min(float64(iy+1), cy1) - math.Max(float64(iy), cy0)
		row := src.Pix[iy*src.Stride:]
		for ix := int(cx0); ix < int(math.Ceil(cx1)); ix++ {
			wx := math.Min(float64(ix+1), cx1) - math.Max(float64(ix), cx0)
			wt := wx * wy
			p := row[ix*4:]
			r += wt * float64(p[0])
			g += wt * float64(p[1])
			b += wt * float64(p[2])
			sw += wt
		}
	}
	if sw == 0 {
		return 0, 0, 0, 0
	}
	return r / sw, g / sw, b / sw, sw / area
}

// display returns the color the Feather's HSTX actually shows for a
// framebuffer byte: each TMDS lane takes the FULL rotated pixel byte
// (firmware feather_video_init), so a lane's low bits come from the
// pixel's other channels — 0xFF displays as exact white, and bright
// channels bleed additively into the others. The dither loop diffuses
// error against THESE values, compensating where the palette allows.
func display(p byte) (r, g, b float64) {
	return float64(p),
		float64((p << 3) | (p >> 5)),
		float64((p << 6) | (p >> 2))
}

// quantize packs the planes into RGB332 (RRRGGGBB), optionally with
// Floyd-Steinberg error diffusion — on 256 colors dithering is the
// difference between gradients and bands.
func quantize(r, g, b []float64, dither bool) []byte {
	out := make([]byte, slideBytes)
	for y := 0; y < fbH; y++ {
		for x := 0; x < fbW; x++ {
			i := y*fbW + x
			qr, _ := quant(r[i], 7)
			qg, _ := quant(g[i], 7)
			qb, _ := quant(b[i], 3)
			p := byte(qr<<5 | qg<<2 | qb)
			out[i] = p
			if !dither {
				continue
			}
			dr, dg, db := display(p)
			er, eg, eb := r[i]-dr, g[i]-dg, b[i]-db
			spread := func(p []float64, e float64) {
				if x+1 < fbW {
					p[i+1] += e * 7 / 16
				}
				if y+1 < fbH {
					if x > 0 {
						p[i+fbW-1] += e * 3 / 16
					}
					p[i+fbW] += e * 5 / 16
					if x+1 < fbW {
						p[i+fbW+1] += e * 1 / 16
					}
				}
			}
			spread(r, er)
			spread(g, eg)
			spread(b, eb)
		}
	}
	return out
}

// quant maps v in [0,255] to the nearest of levels+1 evenly spaced
// codes and returns the code and the reconstruction error.
func quant(v float64, levels int) (int, float64) {
	c := math.Round(clamp(v) * float64(levels) / 255)
	return int(c), v - c*255/float64(levels)
}

func clamp(v float64) float64 {
	return math.Min(math.Max(v, 0), 255)
}
