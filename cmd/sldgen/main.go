/*
 * sldgen converts images into slides for the `show` viewer.
 *
 * A slide (.sld) is a raw framebuffer image: 640x240 bytes of RGB332
 * (RRRGGGBB), 153600 bytes exactly. The framebuffer's rows are each
 * scanned twice on the wire, so the displayed picture is 640x480 with
 * 1:2 pixels: sources are fitted (letterboxed) into a virtual 640x480
 * canvas and every destination row integrates two canvas rows.
 *
 * Usage: sldgen [-o dir] [-bin name] [-nodither] image...
 *
 * Inputs keep their command-line order; outputs are named
 * NN-<stem>.sld so a plain name sort (what the viewer does) replays
 * that order. slides.bin is the concatenation, slide N at byte offset
 * N*153600 — the raw-read fast path for a future contiguous layout.
 */
package main

import (
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
	fbH        = 240
	dispH      = 2 * fbH // each fb row scans out twice
	slideBytes = fbW * fbH
	maxSlides  = 32 // the viewer's directory cap
	stemMax    = 32 // keep "/sd/NN-stem.sld" well under the 63-char path cap
)

func main() {
	outdir := flag.String("o", ".", "output directory")
	binName := flag.String("bin", "slides.bin", "concatenated output (empty to skip)")
	nodither := flag.Bool("nodither", false, "plain quantization instead of Floyd-Steinberg")
	flag.Parse()
	if flag.NArg() == 0 {
		fmt.Fprintln(os.Stderr, "usage: sldgen [-o dir] [-bin name] [-nodither] image...")
		os.Exit(2)
	}
	if flag.NArg() > maxSlides {
		fmt.Fprintf(os.Stderr, "sldgen: warning: %d slides, the viewer lists at most %d per directory\n",
			flag.NArg(), maxSlides)
	}
	if err := os.MkdirAll(*outdir, 0o755); err != nil {
		fatal(err)
	}
	var bin []byte
	for i, path := range flag.Args() {
		sld, err := convert(path, !*nodither)
		if err != nil {
			fatal(fmt.Errorf("%s: %w", path, err))
		}
		name := fmt.Sprintf("%02d-%s.sld", i+1, stem(path))
		if err := os.WriteFile(filepath.Join(*outdir, name), sld, 0o644); err != nil {
			fatal(err)
		}
		fmt.Printf("  %s -> %s\n", path, name)
		bin = append(bin, sld...)
	}
	if *binName != "" {
		p := filepath.Join(*outdir, *binName)
		if err := os.WriteFile(p, bin, 0o644); err != nil {
			fatal(err)
		}
		fmt.Printf("  %d slides -> %s\n", flag.NArg(), p)
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

func convert(path string, dither bool) ([]byte, error) {
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
	r, g, b := resample(src)
	return quantize(r, g, b, dither), nil
}

// resample letterbox-fits src onto the 640x480 display canvas and
// area-averages it down to the 640x240 framebuffer grid (each fb
// pixel covers a 1x2 canvas box). Returns per-channel planes in
// [0,255]; the letterbox stays exactly 0.
func resample(src *image.NRGBA) (r, g, b []float64) {
	w, h := src.Bounds().Dx(), src.Bounds().Dy()
	r = make([]float64, fbW*fbH)
	g = make([]float64, fbW*fbH)
	b = make([]float64, fbW*fbH)

	scale := math.Min(fbW/float64(w), dispH/float64(h))
	cw, ch := float64(w)*scale, float64(h)*scale // content size on the canvas
	ox, oy := (fbW-cw)/2, (dispH-ch)/2           // letterbox origin

	for y := 0; y < fbH; y++ {
		// the fb row's canvas span, mapped into source rows
		sy0 := (float64(2*y) - oy) / scale
		sy1 := (float64(2*y+2) - oy) / scale
		for x := 0; x < fbW; x++ {
			sx0 := (float64(x) - ox) / scale
			sx1 := (float64(x+1) - ox) / scale
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

// quantize packs the planes into RGB332 (RRRGGGBB), optionally with
// Floyd-Steinberg error diffusion — on 256 colors dithering is the
// difference between gradients and bands.
func quantize(r, g, b []float64, dither bool) []byte {
	out := make([]byte, slideBytes)
	for y := 0; y < fbH; y++ {
		for x := 0; x < fbW; x++ {
			i := y*fbW + x
			qr, er := quant(r[i], 7)
			qg, eg := quant(g[i], 7)
			qb, eb := quant(b[i], 3)
			out[i] = byte(qr<<5 | qg<<2 | qb)
			if !dither {
				continue
			}
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
