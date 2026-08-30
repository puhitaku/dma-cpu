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
 * the panel's, not ours. The band is still the quantum, but the band
 * is now DITHERED (gfx_dither): green's quantum is the band exactly,
 * so green shows its native levels, while red and blue quantize half
 * as often and carry the half-step the band leaves over. What the
 * bands measure has not changed; what they look like has.
 *
 * Two more screens live here, each with its own block below. The
 * MATCHING screen turns the eye into a null detector and puts a
 * NUMBER on the panel's black floor instead of a code. The COMPENSATE
 * screen asks the opposite question — not what the panel does, but
 * how far the software should bend away from it — and hands its
 * answer, a strength K, to the radiosity demo. A hold of A walks the
 * three in one cycle; a tap is back.
 *
 * The emulator renders all of it bit-true but models no panel, so the
 * answers this scene exists to give only appear on silicon.
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

#define A_HOLD 24 /* ~0.8 s at the 33 ms frame: the long-press gesture */

static int lo;      /* the window's left edge, in 8-bit codes */
static uint q;      /* ...and a sixteenth of its width (see above) */
static char lbl[3]; /* the numeral being drawn */
static uint ahold;  /* frames A has been down since its own edge */

/* The window readout, in 8-bit units — so a report reads "the jump is
 * between 40 and 48" whatever the zoom. Fixed-width digits, so the
 * opaque text leaves nothing stale behind it, and the numbers go LAST
 * so the UART line is the tail of the same string the panel shows:
 * numstr's terminator lands on the one the string already had. */
static char hdr[] = "tap back hold match 000-000";
#define HDR_LO 20 /* where the readout starts */

/* --- the matching screen -------------------------------------------
 *
 * The ramps say WHERE the panel's luminance step is. They cannot say
 * how big it is, because nothing on this board measures light. The
 * eye can, though, if it is given a NULL to find rather than a
 * quantity to judge.
 *
 * Left half: a ONE-PIXEL checkerboard of level 0 and level N. At that
 * pitch the eye resolves no cells, so it integrates the half, and the
 * half reads as (L(0) + L(N))/2. Right half: a solid level M. Slide M
 * (or N) until the seam between the halves vanishes; at that point
 *
 *   (L(0) + L(N))/2 = L(M).
 *
 * Above the floor this panel is linear — the ramps show it — so write
 * L(v) = a + b*v for v >= 1, with L(0) = 0 because level 0 is the
 * pixel OFF and not a level at all. The match then reads
 * a + b*N = 2a + 2b*M, i.e.
 *
 *   a/b = N - 2M,
 *
 * the floor's height in the channel's OWN step units. A panel without
 * a floor matches at N = 2M and reads zero. The header carries N, M,
 * the channel and that difference live, so the match point is a
 * number to write down, not an arithmetic exercise at the bench.
 *
 * A CHECKERBOARD and not alternating lines, deliberately: the panel
 * inverts drive polarity on a line cadence, so a line pattern hands
 * each level one polarity for good and measures the inversion along
 * with the floor. A checker gives both levels both polarities in
 * equal measure, and the seam is then about luminance only.
 *
 * Per channel, because the floor need not be the same in all three —
 * and W (all three at once, green carrying the extra bit) is the
 * reference the ramps already use. */
#define M_X 120 /* the seam: two 120-px halves */
#define M_Y HDR_H
#define M_H (LCD_H - HDR_H)

/* 0 the ramps, 1 the matching screen, 2 Compensate (below) */
static uchar mode;
static uchar mchan; /* 0 R, 1 G, 2 B, 3 W */
static uchar mn;    /* the checker's bright level */
static uchar mm;    /* ...and the solid half's */
static uint mword;  /* gdma_rows refill word: ONE checker row */
static const char mchn[] = "RGBW";

/* Fixed-width like hdr, and for the same reason: opaque text over
 * itself leaves nothing stale behind. The floor field carries a sign
 * because the hunt walks through it — M past the match point reads
 * negative, and a reading that will not come off zero is a panel with
 * no floor to find. */
static char mhdr[] = "C  N 00  M 00  floor +000";
#define MH_CH 0
#define MH_N 5
#define MH_M 11
#define MH_SGN 21
#define MH_F 22

/* --- the Compensate screen ------------------------------------------
 *
 * The third screen, and the one that hands a NUMBER to the radiosity
 * demo. The panel is luminance-linear — that is what the matching
 * screen above established — so a picture rendered at its true linear
 * value has no perceptual room at the dark end: the eye judges
 * contrast RATIOS, and level 1 -> 2 is a doubling where 28 -> 29 is
 * three percent. The cure is to bend the curve down toward black, and
 * a bend is worthless on a 32-level palette because it just re-lands
 * on the same levels. It becomes possible only once the dither can
 * render BETWEEN two levels, which is what the fraction gfx_dither
 * spends is for.
 *
 * So: how much bend? That is a judgement, not a measurement, and it
 * is made here. The ramps run through gcomp (g.h) at strength K and
 * up/down walk K from 0 — the identity, which is what the ramp screen
 * itself shows — to 16, a gamma-2 darkening. Whatever K reads right
 * at the bench is copied into radio.c's RADIO_K, which is why every
 * step echoes to the UART as well as to the header.
 *
 * The screen is the ramp screen with the window borrowed whole
 * (lo = 0, span = 256) and given back on the way out: ONE painter,
 * because the two differ in nothing but K. */
#define KH_K 23
static char khdr[] = "tap back hold ramps  K 00/16";
static uint kk;  /* the compensation strength, 0..16 */
static int klo;  /* the ramp window, parked while this screen has it */
static uint kqs;

/* Green counts in 6-bit codes, everything else (W included, since its
 * grey is built from the 5-bit code) in 5-bit. */
static uint
mtop(void)
{
  return mchan == 1 ? 63u : 31u;
}

/* one channel level -> the 565 word that shows it alone */
static ushort
mcolor(uint v)
{
  if (mchan == 0)
    return (ushort)(v << 11);
  if (mchan == 1)
    return (ushort)(v << 5);
  if (mchan == 2)
    return (ushort)v;
  return (ushort)((v << 11) | ((v << 1) << 5) | v); /* grey: g is 2v */
}

/* Every OTHER row of the checker's half, from y down, painted from a
 * single repeated word: the halfwords pack little-endian, so a row
 * whose even columns are `a` and odd are `b` is one word a|b<<16, and
 * gdma_rows with a zero source stride and a two-row destination
 * stride lays it down 112 times. The two parities call this with a
 * and b swapped — ONE expression, so clang cannot fold the pair into
 * the 16-bit rotate it would rather emit (and which this machine has
 * no instruction for). A per-pixel loop over the same half is 26k
 * stores, and the screen repaints on every press. */
static void
mrows(int y, ushort a, ushort b, int rows)
{
  mword = (uint)a | ((uint)b << 16);
  gdma_rows((uint)&fb[y * LCD_W], (uint)&mword, M_X / 2, rows, LCD_W * 4, 0);
}

static void
mredraw(void)
{
  ushort c0 = mcolor(0), cn = mcolor(mn);
  gfx_fill(M_X, M_Y, LCD_W - M_X, M_H, mcolor(mm));
  mrows(M_Y, c0, cn, (M_H + 1) / 2);
  mrows(M_Y + 1, cn, c0, M_H / 2);
  gfx_damage(0, M_Y, M_X - 1, LCD_H - 1);

  mhdr[MH_CH] = mchn[mchan];
  numstr(mhdr + MH_N, 2, mn);
  mhdr[MH_N + 2] = ' '; /* numstr NUL-terminates over the gap */
  numstr(mhdr + MH_M, 2, mm);
  mhdr[MH_M + 2] = ' ';
  int f = (int)mn - 2 * (int)mm; /* the floor, in this channel's steps */
  mhdr[MH_SGN] = '+';
  if (f < 0) {
    mhdr[MH_SGN] = '-';
    f = -f;
  }
  numstr(mhdr + MH_F, 3, (uint)f); /* the last field: its own NUL */
  gfx_text(4, 4, mhdr, C_HDR, C_BG);
  gfx_present();
}

/* The stick inside the matching screen, one level per axis: up/down
 * walk M — the half the seam moves with, and the one the hunt spends
 * its time on — left/right walk N. A step that would leave the
 * channel's range is not taken and does not repaint, so the console
 * line means the state really changed. */
static void
mstep(uint act)
{
  uint top = mtop();
  if (act & BTN_UP) {
    if (mm >= top)
      return;
    mm++;
  } else if (act & BTN_DOWN) {
    if (mm == 0)
      return;
    mm--;
  } else if (act & BTN_RIGHT) {
    if (mn >= top)
      return;
    mn++;
  } else {
    if (mn == 0)
      return;
    mn--;
  }
  mredraw();
  uputs("grad: match ");
  uputs(mhdr);
  uputs("\n");
}

/* The compensation curve at this screen's K. Out of line so redraw's
 * band walk carries ONE copy of it and not one per band: g.h's gcomp
 * is three multiplies, and this machine pays for a multiply in code
 * bytes as well as cycles. */
static __attribute__((noinline)) uint
kcurve(uint v)
{
  return gcomp(v, kk);
}

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
    int x1 = (int)(xfp >> 16); /* the last band runs off; gfx_dfill clips */
    int w = x1 - x0;
    /* The band's own 8-bit code, through the compensation curve and
     * then through the dither. ONE paint path for both screens: the
     * ramps hold K at 0, where gcomp is the identity, green's quantum
     * IS the band so its fraction is zero and the ramp is the panel's
     * own levels exactly as it always was — while red and blue, which
     * quantize half as often, pick up the half-step the band leaves
     * over. So the ramps already show the dither at its weakest, and
     * Compensate shows the rest of it. (g6 can run past 63 on the
     * last, clipped band of a zoomed window; K is 0 there, gcomp
     * passes any v through untouched and gfx_dither clamps at the top
     * level, so nothing has to guard it.) */
    uint c = kcurve((uint)g6 << 2);
    gfx_dither(c, 0, 0);
    gfx_dfill(x0, Y_R, w, BAR_H);
    gfx_dither(0, c, 0);
    gfx_dfill(x0, Y_G, w, BAR_H);
    gfx_dither(0, 0, c);
    gfx_dfill(x0, Y_B, w, BAR_H);
    gfx_dither(c, c, c);
    gfx_dfill(x0, Y_W, w, BAR_H);
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
  if (mode == 2) {
    numstr(khdr + KH_K, 2, kk);
    khdr[KH_K + 2] = '/'; /* numstr NUL-terminates over the slash */
    gfx_text(4, 4, khdr, C_HDR, C_BG);
  } else {
    numstr(hdr + HDR_LO, 3, (uint)lo);
    hdr[HDR_LO + 3] = '-'; /* numstr NUL-terminates over the separator */
    numstr(hdr + HDR_LO + 4, 3, (uint)lo + (q << 4) - 1);
    gfx_text(4, 4, hdr, C_HDR, C_BG);
  }
  gfx_present();
}

/* The K readout, on the header line and on the UART, so the value
 * picked at the bench lands in the serial log too. */
static __attribute__((noinline)) void
kecho(void)
{
  uputs("grad: comp ");
  uputs(khdr + KH_K - 2);
  uputs("\n");
}

/* Enter one of the three screens and paint it. Out of line and NOT in
 * .ramtext on purpose: grad_frame is resident and only has to work out
 * WHICH screen the gesture asks for — the switch itself runs once per
 * press and can live in flash beside the painters it calls. */
static __attribute__((noinline)) void
gomode(uint m)
{
  if (m == 2) { /* Compensate takes the whole axis, and gives the
                 * window back exactly as it found it */
    klo = lo;
    kqs = q;
    lo = 0;
    q = Q_MAX;
  } else if (mode == 2) {
    lo = klo;
    q = kqs;
    kk = 0; /* ...and the ramps are the K=0 end of the same curve */
  }
  mode = (uchar)m;
  gfx_clear(C_BG);
  if (m == 1) {
    /* the channel walk restarts at R, and the levels come down with it
     * if green's 6-bit range was left above a 5-bit one */
    mchan = 0;
    if (mn > 31)
      mn = 31;
    if (mm > 31)
      mm = 31;
    mredraw();
    uputs("grad: match ");
    uputs(mhdr);
    uputs("\n");
    return;
  }
  redraw();
  if (m == 0) {
    uputs("grad: ramps\n");
    return;
  }
  kecho();
}

/* The stick on the Compensate screen: up/down walk K, which is the
 * only thing there is to choose here. Left and right do nothing — the
 * window is pinned to the whole axis, and that is the point of the
 * screen. A step that would leave 0..16 is not taken and does not
 * repaint, so the console line means the value really changed. */
static __attribute__((noinline)) void
kstep(uint act)
{
  if (act & BTN_UP) {
    if (kk >= 16)
      return;
    kk++;
  } else if (act & BTN_DOWN) {
    if (kk == 0)
      return;
    kk--;
  } else
    return;
  redraw();
  kecho();
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
  /* The A gesture, both screens. Stick B is NOT a second controller
   * here: in_poll ORs the two sticks into one button word (input.c),
   * so B's press arrives as BTN_A and its directions as A's — there
   * is no bit left over to spend on a mode key. So A carries two
   * meanings, told apart by how long it is held, the way seq.c's
   * hold-to-exit does:
   *
   *   ramps: tap = back to the menu (unchanged), hold = matching
   *   match: tap = back to the ramps,           hold = next channel
   *
   * Edge-armed, not level-armed: the press that STARTED this scene is
   * still down for a frame or two at entry, and a level-armed counter
   * would read it as a hold and open the matching screen on its own.
   * Firing the hold at exactly A_HOLD+1 also disarms the tap, so one
   * press never does both. */
  if (in_edge & BTN_A)
    ahold = 1;
  else if (in_down & BTN_A) {
    if (ahold)
      ahold++;
  } else if (ahold) {
    uint held = ahold;
    ahold = 0;
    if (held <= A_HOLD) {
      if (!mode) { /* the same press-to-go-back the other
                    * non-game scenes answer */
        led(0, 0);
        uputs("grad: back\n");
        return 1;
      }
      gomode(0); /* ...and from either of the others, back to the
                  * ramps, which is where back-to-the-menu lives */
      return 0;
    }
  }
  if (ahold == A_HOLD + 1) {
    /* The hold walks ONE cycle through the scene: ramps -> matching ->
     * Compensate -> ramps. The matching screen's four channels are a
     * SUB-cycle inside its stop, because the stick there is spent on N
     * and M and the hold is the only key left over: R, G, B, W in
     * turn, and the fifth hold moves on. */
    if (mode == 1 && mchan < 3) {
      mchan++;
      uint top = mtop();
      if (mn > top)
        mn = (uchar)top;
      if (mm > top)
        mm = (uchar)top;
      mredraw();
      uputs("grad: match ");
      uputs(mhdr);
      uputs("\n");
      return 0;
    }
    gomode(mode == 0 ? 1u : (mode == 1 ? 2u : 0u));
    return 0;
  }
  uint act = in_edge & (BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT);
  if (mode) {
    if (act) {
      if (mode == 1)
        mstep(act);
      else
        kstep(act);
    }
    return 0;
  }
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
  ahold = 0;
  mode = 0;
  mchan = 0;
  kk = 0;
  /* The floorless match point (N = 2M) is where the matching screen
   * opens, so the very first seam the eye sees IS the floor. */
  mn = 16;
  mm = 8;
  gfx_clear(C_BG);
  redraw();
  for (;;) {
    frame_sync(33000);
    in_poll();
    if (grad_frame())
      return;
  }
}
