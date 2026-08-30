/* grad.c: the panel gradient probe. The ST7789 carries a luminance
 * step somewhere down in its dark region that survives the gamma
 * tables, and the panel is write-only — nothing on the wire says where
 * the jump sits. So this scene is the instrument: it puts the 8-bit
 * brightness axis on screen and lets the eye name the code.
 *
 * Four ramps stacked top to bottom — R, G, B, then W as the reference
 * — share ONE view window [lo, lo+span) of that axis: left is darker,
 * and the whole window fits the 240 columns. Zooming shrinks the
 * window about its center, so a step the eye has found stays put while
 * it grows. The visible bands are the display's OWN 5/6/5
 * quantization, which is the point: R and B step every 8 codes, G
 * every 4, and a step that does not fall on one of those boundaries is
 * the panel's, not ours.
 *
 * The emulator renders all of it bit-true but models no panel, so the
 * answer this scene exists to give only appears on silicon.
 */
#include "g.h"

#define HDR_H 16 /* the window readout; the bars own everything below */
#define BAR_H 56
#define Y_R HDR_H
#define Y_G (HDR_H + BAR_H)
#define Y_B (HDR_H + 2 * BAR_H)
#define Y_W (HDR_H + 3 * BAR_H)
#define LBL_DY (BAR_H - 12) /* numerals sit low in their bar */

/* The window's width is held as Q, its SIXTEENTH: span = q*16. Every
 * width the scene derives — the span, its half, its quarter, the pan
 * step — is then a LEFT shift of q or q itself, and only zooming in
 * shifts right at all. On this machine a constant right shift that is
 * not a whole byte lane is seven instructions and a .ramtext stub, so
 * four of them per frame was worth designing away. */
#define Q_MAX 16 /* span 256: the whole axis */
#define Q_MIN 1  /* span 16: four of the finest (green) bands */

#define C_BG RGB(0, 0, 0)
#define C_HDR RGB(190, 195, 210)
/* Label ink: black on a light box, so ONE pair reads at both ends of
 * every ramp — white-on-black vanishes into a bright band and
 * black-on-white into a dark one. gfx_text paints the glyph cell's
 * background itself, so the box costs nothing extra. The box is warm,
 * not neutral: a pure grey is a color the W ramp itself produces, and
 * a label has to be something no ramp can be mistaken for. */
#define C_LFG RGB(0, 0, 0)
#define C_LBG RGB(216, 200, 184)

static int lo;      /* the window's left edge, in 8-bit codes */
static uint q;      /* ...and a sixteenth of its width (see above) */
static char lbl[3]; /* the numeral being drawn */

/* The window readout, in 8-bit units — so a report reads "the jump is
 * between 40 and 48" whatever the zoom. Fixed-width digits, so the
 * opaque text leaves nothing stale behind it, and the numbers go LAST
 * so the UART line is the tail of the same string the panel shows:
 * numstr's terminator lands on the one the string already had. */
static char hdr[] = "press: back  8bit 000-000";
#define HDR_LO 18 /* where the readout starts */

/* redraw: ONE walk of the window's 4-code quanta — the finest band
 * this panel can show — paints all four bars and numbers three of
 * them. The band is the unit of BOTH the ramp and its scale, so the
 * scene needs neither a per-column pass nor a second pass for the
 * numerals: green's 6-bit code IS the quantum index, and red and
 * blue's 5-bit code is that index halved, which is one increment every
 * other band. Nothing in the walk multiplies, and nothing shifts by a
 * count that is not a whole byte lane.
 *
 * The numerals appear only once a band is wider than two digits and
 * their padding, which lands R and B at span 64 and G — whose bands
 * are half as wide — at span 32. That asymmetry is the 5/6/5 split
 * itself, drawn. */
static void
redraw(void)
{
  uint qfp = ((uint)LCD_W << 14) / q; /* a band, in 16.16 pixels */
  uint g6 = (uint)lo >> 2;            /* the green code at the left */
  uint r5 = g6 >> 1;                  /* ...and the red/blue one */
  int lab4 = qfp >= (20u << 16), lab8 = qfp >= (10u << 16);
  uint xfp = 0;
  int x0 = 0;
  while (x0 < LCD_W) {
    xfp += qfp;
    int x1 = (int)(xfp >> 16); /* the last band runs off; gfx_fill clips */
    ushort cr = (ushort)(r5 << 11), cg = (ushort)(g6 << 5);
    ushort cb = (ushort)r5;
    int w = x1 - x0;
    gfx_fill(x0, Y_R, w, BAR_H, cr);
    gfx_fill(x0, Y_G, w, BAR_H, cg);
    gfx_fill(x0, Y_B, w, BAR_H, cb);
    gfx_fill(x0, Y_W, w, BAR_H, (ushort)(cr | cg | cb));
    if (lab8 && x0 + 18 <= LCD_W) { /* room for the numeral itself */
      if (lab4) {
        numsp(lbl, 2, g6);
        gfx_text(x0 + 2, Y_G + LBL_DY, lbl, C_LFG, C_LBG);
      }
      if (!(g6 & 1)) {
        numsp(lbl, 2, r5);
        gfx_text(x0 + 2, Y_R + LBL_DY, lbl, C_LFG, C_LBG);
        gfx_text(x0 + 2, Y_B + LBL_DY, lbl, C_LFG, C_LBG);
      }
    }
    /* nothing on W: it stays a clean reference ramp */
    x0 = x1;
    g6++;
    if (!(g6 & 1))
      r5++;
  }
  numstr(hdr + HDR_LO, 3, (uint)lo);
  hdr[HDR_LO + 3] = '-'; /* numstr NUL-terminates over the separator */
  numstr(hdr + HDR_LO + 4, 3, (uint)lo + (q << 4) - 1);
  gfx_text(4, 4, hdr, C_HDR, C_BG);
  gfx_present();
}

/* One frame's input and response. Returns nonzero to leave the scene.
 * Noinline, and outside the `for (;;)`, on purpose: a block on a CFG
 * cycle keeps its code inline (outline.go's LOOPS gate), so wrapping
 * the whole body in the loop would have pinned every move chain in it
 * — and the game's flash text window had ~5 KiB left when this scene
 * arrived. */
static __attribute__((noinline)) int
grad_frame(void)
{
  if (in_edge & BTN_A) { /* the same press-to-go-back the other
                          * non-game scenes answer */
    led(0, 0);
    uputs("grad: back\n");
    return 1;
  }
  uint act = in_edge & (BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT);
  int nlo = lo;
  uint nq = q;
  if (act & BTN_UP) { /* zoom in, the window's center held */
    if (nq > Q_MIN) {
      nlo += (int)(nq << 2); /* a quarter of the span */
      nq >>= 1;
    }
  } else if (act & BTN_DOWN) { /* zoom out likewise */
    if (nq < Q_MAX) {
      nlo -= (int)(nq << 3); /* ...and half of it */
      nq <<= 1;
    }
  } else if (act & BTN_LEFT) /* pan a QUARTER of the view per press, so
                              * the slide feels the same at every zoom.
                              * A quarter, not a sixteenth: input here
                              * is one step per press (seq.c's rule for
                              * a held stick), and it also keeps lo on a
                              * 4-code band edge, which is what lets the
                              * band walk start at x = 0 with no
                              * fractional first band to multiply out */
    nlo -= (int)(nq << 2);
  else if (act & BTN_RIGHT)
    nlo += (int)(nq << 2);
  else
    return 0;
  int top = 256 - (int)(nq << 4);
  if (nlo < 0)
    nlo = 0;
  else if (nlo > top)
    nlo = top;
  if (nlo == lo && nq == q)
    return 0; /* the step clamped away to nothing */
  lo = nlo;
  q = nq;
  redraw();
  uputs("grad: view ");
  uputs(hdr + HDR_LO); /* the readout the panel is showing */
  uputs("\n");
  return 0;
}

void
grad_run(void)
{
  uputs("grad: up\n");
  led(LED_DIM(0x0040FF), LED_DIM(0x0040FF));
  lo = 0;
  q = Q_MAX;
  gfx_clear(C_BG);
  redraw();
  for (;;) {
    frame_sync(33000);
    in_poll();
    if (grad_frame())
      return;
  }
}
