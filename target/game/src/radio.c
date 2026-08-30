/* radio.c: progressive radiosity in the classic red/green light box,
 * rendered live — with the two interior boxes (a tall cuboid and a
 * cube, both rotated about the vertical axis) that give the scene its
 * soft shadows. Five walls are split into NxN patches, box faces into
 * per-visibility grids (the tall box's front at 6x12); a small block of
 * ceiling patches carries the initial energy. A sixth, INVISIBLE wall
 * closes the camera opening (never drawn): without it the opening is an
 * energy sink and the camera-facing box sides — lit only by third-bounce
 * light off the wall strips in front of them — quantize to black. The
 * closed box bounces the ceiling light straight back at them.
 * Each step "shoots" the brightest patch's unshot energy at every other
 * patch and repaints what changed, so the room brightens and color-bleeds
 * in front of you — the whole point is WATCHING the light bounce.
 *
 * Everything is integer. The tricks that make that work:
 *  - the receiver update is brightness-normalized (area-free), and
 *    only the SHOOTER's area enters the form factor, so unequal
 *    box/wall patch areas cost nothing beyond one table load;
 *  - normals are Q8 constants (the boxes rotate only about Y, so
 *    their corner positions and normals are compile-time numbers,
 *    and vertical edges stay vertical on screen);
 *  - occlusion is 5 stratified samples along the pair segment tested
 *    point-in-rotated-box (4 muls each) behind an AABB precheck; two
 *    interior samples block the pair outright, one scales the form
 *    factor to 2/5 and softens the shadow edge (see clearance());
 *  - the form factor F = dp*dq*A / (pi*r2*r2) is staged as two
 *    guarded divisions so u32 never overflows (see shoot());
 *  - the camera sits at the box opening (z in [200,440], focal 200):
 *    the opening projects EXACTLY to the 240x240 screen — no
 *    clipping anywhere;
 *  - every right shift in the shooter is UNSIGNED and < 16, so it
 *    rides the runtime's OUT_REV fast path: the Q8 dot products are
 *    signed, so they shift through asr8() rather than `>>` (the
 *    drawing path's wider Q12 shifts stay signed — they run per
 *    redraw, not per receiver);
 *  - and NOTHING in the receiver loop divides by a non-constant or by
 *    a constant the machine cannot fold. The grid edge N is a
 *    parameter now, so `p / NPW` (which recovers a patch's wall) is a
 *    general divide at every N but 16 — thousands of cycles, twice per
 *    pair. It is gone: setup() writes a per-patch GROUP byte (pgrp)
 *    and the loop reads the normal, the reflectance and the area
 *    straight out of 16-entry tables indexed by it.
 *
 * --- where the state lives -------------------------------------
 *
 * Two homes, and the split is the whole reason N could be raised:
 *
 *  (1) The twelve NP-SCALING arrays — the ten shorts/ushorts plus the
 *      group byte and the shown-fraction byte — sit at the BOTTOM of
 *      the gamepico's scene-exclusive span
 *      (boards.GameFreeBase = 0x2002E000 up to the machine's
 *      scratch word at 0x2003FE00, 73216 contiguous bytes). This scene
 *      claims the span whole, which means it claims fx.c's audio ring
 *      at 0x20038000 along with it — see radio_run's aud_borrow /
 *      aud_release pair, and fx.c for why a free-running channel makes
 *      that a protocol rather than a comment. bench.c's buffers overlap
 *      the top of the same span; the two demos never run together.
 *  (2) Every FIXED-SIZE lookup — the projected corner grids, the box
 *      cell coords and the 16-entry group tables — lives in the dead
 *      ARM window (boards.ArmScratchFree: on gamepico 0x20040000,
 *      8192 B). That memory is the firmware's own .data/.bss/stack,
 *      and core 0 is in PSM reset from dmx_start onward, so after boot
 *      it has no owner at all. RUNTIME CLAIM ONLY — the loader
 *      executes on it right up to dmx_start, so nothing linked may
 *      ever live there, and setup() must therefore write every byte it
 *      later reads.
 *
 * At N=24 the arrays want 67760 B of the 73216 and the corner grid
 * 6250 B of the 8192, so both budgets are two thirds to three quarters
 * spent. There is no next step to argue about: PSIZE and PSIZEF both
 * have to divide 240 exactly, which leaves N in {4, 8, 12, 16, 20, 24,
 * 40, ...}, and N=40 wants 165 KiB of arrays and a 16 KiB corner grid
 * — over both walls by more than double. 24 is the top of this
 * lattice, and the #error pair below says so at compile time.
 * Projected corners are uchar pairs: the camera is fixed and the
 * opening maps exactly to the 240x240 screen, so every corner is
 * 0..240. */
#include "g.h"

/* The surround behind the opening: levels 1, 2, 2, and the ONLY color
 * in the scene that does not come out of tone(). It is a flat frame
 * around the box opening, not part of the render, so it takes no
 * dither. */
#define C_BG RGB(8, 8, 16)

#define N 24        /* patches per wall edge; must divide 240 */
#define NPW (N * N) /* per wall */
#define NWALL (5 * NPW)
#define NBF 10 /* box faces: 2 boxes x (4 sides + top) */
/* Per-face patch resolution, budgeted by what the camera sees
 * (f = box*5 + side; sides 0 right, 1 left, 2 back, 3 front, 4 top):
 * the tall box's front — the demo's biggest visible surface — gets
 * 6 across x 12 down (~12-unit square patches over 72x150), the
 * short box's front 6x6, the tall left / short top 4x4, every face
 * the camera cannot see 2x2. These do NOT scale with N: pcell packs a
 * cell as i | k<<4, so a face edge can never exceed 16, and the corner
 * grids they need are what the 8 KiB lookup window has left over. */
#define NBOX 164   /* sum of NFI[f]*NFK[f] */
#define BCORNP 244 /* sum of (NFI[f]+1)*(NFK[f]+1), in uchar pairs */
#define NFRONT (NWALL + NBOX) /* first invisible front-wall patch */
/* The front wall is an energy mirror, never drawn. Its patches stay
 * FOUR wall-patch edges across at every N, which keeps the one Q8
 * ratio in the shooter (its area over a wall patch's) pinned at 16
 * instead of growing as the wall grid gets finer. */
#define NF (N / 4)
#define PSIZEF (240 / NF)
#define NP (NFRONT + NF * NF)
#define HALF 120  /* box half-width in scene units */
#define ZNEAR 200 /* opening (camera at z=0, focal ZNEAR) */
#define PSIZE (240 / N) /* wall patch edge */
#define AREA (PSIZE * PSIZE)

#if 240 % N
#error "N must divide 240: PSIZE has to be an integral number of scene units"
#endif
#if N % 4 || 240 % NF
#error "N/4 must be a divisor of 240: the front mirror needs an integral PSIZEF"
#endif

#define W_BACK 0
#define W_FLOOR 1
#define W_CEIL 2
#define W_LEFT 3
#define W_RIGHT 4

/* --- the two interior boxes (Q8 trig, all compile-time numbers) --- */
/* tall cuboid, back-left, rotated +17 deg  (cos 245, sin 75)
 * cube, front-right, rotated -18 deg       (cos 243, sin -79) */
#define B0_CX (-42)
#define B0_CZ 330
#define B0_H 36 /* half footprint */
#define B0_TOP (-30) /* height 150 off the floor at +120 */
#define B0_COS 245
#define B0_SIN 75
#define B1_CX 45
#define B1_CZ 268
#define B1_H 36
#define B1_TOP 48 /* height 72 */
#define B1_COS 243
#define B1_SIN (-79)

/* per-face patch grid edge, patch-index base, corner-grid base (in
 * uchar pairs) — all compile-time prefix sums over NFQ */
static const uchar NFI[NBF] = {2, 4, 2, 6, 2, 2, 2, 2, 6, 4};  /* across */
static const uchar NFK[NBF] = {2, 4, 2, 12, 2, 2, 2, 2, 6, 4}; /* down   */
static const uchar PBASE[NBF] = {0, 4, 20, 24, 96, 100, 104, 108, 112, 148};
static const ushort CGOFF[NBF] = {0, 9, 34, 43, 134, 143, 152, 161, 170, 219};

/* --- (1) the NP-scaling arrays, at the bottom of the span --- */
#define RAD_RAM 0x2002E000u /* == boards.GameFreeBase */
#define RAD_SPAN 73216u     /* .. up to the machine's scratch word */
#define PSTRIDE ((NP * 2 + 3) & ~3)
#define pcx ((short *)(RAD_RAM + 0 * PSTRIDE))
#define pcy ((short *)(RAD_RAM + 1 * PSTRIDE))
#define pcz ((short *)(RAD_RAM + 2 * PSTRIDE))
#define bR ((ushort *)(RAD_RAM + 3 * PSTRIDE))
#define bG ((ushort *)(RAD_RAM + 4 * PSTRIDE))
#define bB ((ushort *)(RAD_RAM + 5 * PSTRIDE))
#define uR ((ushort *)(RAD_RAM + 6 * PSTRIDE))
#define uG ((ushort *)(RAD_RAM + 7 * PSTRIDE))
#define uB ((ushort *)(RAD_RAM + 8 * PSTRIDE))
/* What the patch is currently SHOWING, and therefore what repaint
 * compares against: the levels as an RGB565 word, plus the three
 * quarter-fractions the dither is spending on top of them (two bits
 * each). Both, because two patches with the same levels and different
 * fractions are different pictures. */
#define shown ((ushort *)(RAD_RAM + 9 * PSTRIDE))
/* pgrp: 0..4 the five walls, 5+f the ten box faces, 15 the front
 * mirror — the one lookup that replaced the receiver loop's divisions */
#define pgrp ((uchar *)(RAD_RAM + 10 * PSTRIDE))
#define shfrc ((uchar *)(RAD_RAM + 10 * PSTRIDE + NP))
#define RAD_USED (10 * PSTRIDE + 2 * NP)

#if RAD_USED > RAD_SPAN
#error "radiosity arrays overflow the scene-exclusive span: lower N"
#endif

/* --- (2) the fixed-size lookups, in the dead ARM window --- */
#define RADLUT 0x20040000u /* == boards.GamePico.ArmScratchFree */
#define RADLUT_SZ 0x2000u
#define L_CORN 0u                                     /* 5 walls of pairs */
#define L_BCORN (L_CORN + 5 * (N + 1) * (N + 1) * 2)  /* box face pairs */
#define L_PCELL (L_BCORN + BCORNP * 2)                /* box cell, i|k<<4 */
#define L_GNRM (((L_PCELL + NBOX) + 3) & ~3u)         /* 16 x 3 Q8 normals */
#define L_GRHO (L_GNRM + 16 * 3 * 2)                  /* 16 x 3 Q8 rho */
#define L_GAREA (L_GRHO + 16 * 3 * 2)                 /* 16 patch areas */
#define L_FVIS (L_GAREA + 16 * 2)                     /* NBF visibility */
#define L_END (L_FVIS + NBF * 2)
#define corn ((uchar *)(RADLUT + L_CORN))
#define bcorn ((uchar *)(RADLUT + L_BCORN))
#define pcell ((uchar *)(RADLUT + L_PCELL))
#define gnrm ((short *)(RADLUT + L_GNRM))
#define grho ((ushort *)(RADLUT + L_GRHO))
#define garea ((ushort *)(RADLUT + L_GAREA))
#define fvis ((short *)(RADLUT + L_FVIS))
/* wall corner grid: (N+1)^2 pairs per wall; box grid: (NFI+1)x(NFK+1) */
#define CI(w, i, k) (((w) * (N + 1) * (N + 1) + (k) * (N + 1) + (i)) * 2)
#define BCI(f, i, k) ((CGOFF[f] + (k) * (NFI[f] + 1) + (i)) * 2)

#if L_END > RADLUT_SZ
#error "radiosity lookups overflow boards.ArmScratchFree: lower N"
#endif

/* reflectance per wall group, Q8; box faces are warm white */
static const ushort rho[6][3] = {
    {200, 150, 60}, {200, 150, 60}, {200, 150, 60},
    {240, 45, 45},  /* left wall: red */
    {45, 240, 45},  /* right wall: green */
    {200, 150, 60}, /* the boxes */
};

/* wall normals, Q8, into the room */
static const short wnrm[5][3] = {
    {0, 0, -256}, {0, -256, 0}, {0, 256, 0}, {256, 0, 0}, {-256, 0, 0},
};

/* The ceiling lamp: a centred LIGHT_N x LIGHT_N block of ceiling
 * patches, sized to stay ~48 scene units across however fine the grid
 * gets (N/5 rounded, which is the exact middle 2x2 at N=10). Keeping
 * its AREA fixed is what keeps the room's total flux — and therefore
 * the converged image tone() maps — the same at every N. */
#define LIGHT_N ((N + 2) / 5)
#define LIGHT_LO ((N - LIGHT_N) / 2)
#define LP(i, k) (W_CEIL * NPW + (k) * N + (i))

/* Repaint rides (w,i,k) along its patch scan, so the lamp test is four
 * compares on numbers already in hand — no p/NPW, no p%N. */
static int
is_light(int w, int i, int k)
{
  return w == W_CEIL && i >= LIGHT_LO && i < LIGHT_LO + LIGHT_N &&
         k >= LIGHT_LO && k < LIGHT_LO + LIGHT_N;
}

/* --- tone: the measured-panel answer -------------------------------
 *
 * What the Gradient app measured (2026-08-31): this ST7789 renders
 * luminance LINEAR in channel code. The checker-vs-solid matching
 * screen puts the black floor at 0 steps on R/B and +1 on G, so there
 * is no curve in the panel at all — it evidently ignores its gamma
 * registers, and two programming attempts changed nothing and were
 * reverted. What is left is not a curve problem but a STRUCTURAL one:
 * between level 0 (the pixel off) and level 1 there is no luminance,
 * and on a linear 5-bit ramp the dark steps are enormous contrast
 * RATIOS — 1 -> 2 is a doubling where 28 -> 29 is three percent. So
 * dark gradients band, and the 0/1 boundary is a cliff.
 *
 * Two software answers were tried on the panel and both were
 * rejected by eye:
 *
 *  - a TONE_MIN floor, mapping 0..255 onto [8, 255] so nothing the
 *    scene paints sits at code 0. It stepped over the cliff by
 *    turning every black in the room grey, which is worse than the
 *    cliff.
 *  - a gamma-encode LUT (^1/2.2) in this very slot. It cannot work,
 *    and the reason is arithmetic: a re-map of codes to codes still
 *    lands on the SAME 32 levels the panel has. It spends the code
 *    range differently but adds no luminances, so the missing ones
 *    between 0 and 1 stay missing and the banding just moves.
 *
 * The answer is not a curve at all. The panel's levels are a PALETTE,
 * and every brightness between two of them is rendered the way a GIF
 * or a halftone renders it — spatially, by mixing the two adjacent
 * levels at the right density. tone() therefore stays LINEAR and
 * stops rounding: it hands gfx_dither an 8-bit CODE per channel, and
 * gfx_dither keeps both the level that code lands on and the fraction
 * of the way to the next one, in quarters, then spends that fraction
 * as density over a 2x2 ordered (Bayer) tile — see gfx.c for the tile
 * and gfx_dfill for how a patch lays it down. Five effective
 * sub-levels per channel step, EVERYWHERE — including 0-vs-1 at the
 * bottom, which is the cliff dissolved: a quarter-density of level 1
 * on black is a luminance the panel has no code for, and the eye
 * integrates it at this pitch.
 *
 * RADIO_K is the OTHER half of the answer, and it is deliberately
 * still zero. gcomp (g.h) bends the code axis down toward black by K
 * sixteenths — the widening-gap curve a linear panel does not have,
 * and one that is only renderable BECAUSE the dither can land between
 * levels. How much bend is a judgement to be made by eye on silicon,
 * not a number to guess here, so this wave ships the solver's true
 * linear value with nothing on it but the sub-level smoothing. At
 * K = 0 gcomp is the identity and clang folds it out of the image
 * entirely; adopting whatever the bench settles on is this one
 * constant and nothing else. */
#define RADIO_K 1 /* the user's pick on the Compensate screen (2026-08-31) */

static __attribute__((noinline)) uint
tone(uint v)
{
  uint c = v >> 3;
  if (c > 255)
    c = 255;
  return gcomp(c, RADIO_K);
}

/* The three fractions the brush (gfx_tile) is currently spending,
 * packed two bits each: repaint's change key needs those as well as
 * the levels, because two patches with the same levels and different
 * fractions are different pictures. Per PATCH, not per pixel — a
 * patch is one flat color pair, so the brush is loaded once and the
 * fill machinery below just lays it down. */
static uchar dfrc;

/* Load the brush and hand back the LEVELS as an RGB565 word — the
 * color the patch would be if it were not dithered, and the other
 * half of the change key. */
static ushort
patch_tone(int p, int lit)
{
  uint rc = 248, gc = 252, bc = 240; /* the lamp: RGB(255, 255, 240) */
  if (!lit) {
    rc = tone(bR[p]);
    gc = tone(bG[p]);
    bc = tone(bB[p]);
  }
  dfrc = (uchar)gfx_dither(rc, gc, bc);
  /* tile[2] is the position whose threshold is 3, which no fraction
   * can beat: the bare levels, read back out of the brush instead of
   * packed a second time */
  return gfx_tile[2];
}

/* --- box geometry helpers (local -> world, Q8 rotation) --- */

static void
box_world(int b, int lx, int lz, int *wx, int *wz)
{
  if (b == 0) {
    *wx = B0_CX + ((lx * B0_COS - lz * B0_SIN) >> 8);
    *wz = B0_CZ + ((lx * B0_SIN + lz * B0_COS) >> 8);
  } else {
    *wx = B1_CX + ((lx * B1_COS - lz * B1_SIN) >> 8);
    *wz = B1_CZ + ((lx * B1_SIN + lz * B1_COS) >> 8);
  }
}

/* face f (0..9): box b = f/5, side s = f%5 (0 +lx, 1 -lx, 2 +lz,
 * 3 -lz, 4 top). Grid point (i,k) 0..NFQ[f] in local face coords
 * (2h = 72 divides exactly by every NFQ; B0's 150-unit sides
 * truncate fractions of a scene unit — sub-pixel). */
static void
face_point(int f, int i, int k, int *wx, int *wy, int *wz)
{
  int b = f / 5, s = f % 5;
  int h = b == 0 ? B0_H : B1_H;
  int top = b == 0 ? B0_TOP : B1_TOP;
  int u = -h + 2 * h * i / NFI[f];         /* -h .. +h across */
  int v = top + (HALF - top) * k / NFK[f]; /* top..floor for sides */
  int lx, lz;
  switch (s) {
  case 0: lx = h; lz = u; break;
  case 1: lx = -h; lz = u; break;
  case 2: lx = u; lz = h; break;
  case 3: lx = u; lz = -h; break;
  default: /* top: u across x, second axis across z */
    lx = u;
    lz = -h + 2 * h * k / NFK[f];
    break;
  }
  box_world(b, lx, lz, wx, wz);
  *wy = s == 4 ? top : v;
}

/* --- projection --- */

static void
project(void)
{
  int recip[N + 1];
  for (int g = 0; g <= N; g++)
    recip[g] = (int)((uint)(ZNEAR << 12) / (uint)(ZNEAR + PSIZE * g));
  for (int w = 0; w < 5; w++) {
    for (int k = 0; k <= N; k++) {
      for (int i = 0; i <= N; i++) {
        int gx = -HALF + PSIZE * i, gy, r;
        int sx, sy;
        switch (w) {
        case W_BACK:
          gy = -HALF + PSIZE * k;
          r = recip[N];
          sx = 120 + ((gx * r) >> 12);
          sy = 120 + ((gy * r) >> 12);
          break;
        case W_FLOOR:
          r = recip[k];
          sx = 120 + ((gx * r) >> 12);
          sy = 120 + ((HALF * r) >> 12);
          break;
        case W_CEIL:
          r = recip[k];
          sx = 120 + ((gx * r) >> 12);
          sy = 120 - ((HALF * r) >> 12);
          break;
        case W_LEFT:
          gy = -HALF + PSIZE * i;
          r = recip[k];
          sx = 120 - ((HALF * r) >> 12);
          sy = 120 + ((gy * r) >> 12);
          break;
        default:
          gy = -HALF + PSIZE * i;
          r = recip[k];
          sx = 120 + ((HALF * r) >> 12);
          sy = 120 + ((gy * r) >> 12);
          break;
        }
        corn[CI(w, i, k)] = (uchar)sx;
        corn[CI(w, i, k) + 1] = (uchar)sy;
      }
    }
  }
  /* box face corners: one true perspective divide per corner */
  for (int f = 0; f < NBF; f++) {
    for (int k = 0; k <= NFK[f]; k++) {
      for (int i = 0; i <= NFI[f]; i++) {
        int wx, wy, wz;
        face_point(f, i, k, &wx, &wy, &wz);
        int rz = (int)((uint)(ZNEAR << 12) / (uint)wz);
        bcorn[BCI(f, i, k)] = (uchar)(120 + ((wx * rz) >> 12));
        bcorn[BCI(f, i, k) + 1] = (uchar)(120 + ((wy * rz) >> 12));
      }
    }
  }
}

static void
setup(void)
{
  /* the 16 group slots: normal, reflectance and patch area, so the
   * receiver loop never recovers a patch's identity by dividing */
  for (int g = 0; g < 16; g++) {
    const ushort *r = rho[g < 5 ? g : (g < 15 ? 5 : 0)];
    grho[g * 3] = r[0];
    grho[g * 3 + 1] = r[1];
    grho[g * 3 + 2] = r[2];
  }
  for (int w = 0; w < 5; w++) {
    gnrm[w * 3] = wnrm[w][0];
    gnrm[w * 3 + 1] = wnrm[w][1];
    gnrm[w * 3 + 2] = wnrm[w][2];
    garea[w] = AREA;
  }
  gnrm[15 * 3] = 0; /* the invisible front wall: into the room */
  gnrm[15 * 3 + 1] = 0;
  gnrm[15 * 3 + 2] = 256;
  garea[15] = PSIZEF * PSIZEF;

  /* wall patch centers; (w,i,k) ride the loops, so nothing divides */
  int p = 0;
  for (int w = 0; w < 5; w++) {
    for (int k = 0; k < N; k++) {
      for (int i = 0; i < N; i++, p++) {
        int a = -HALF + PSIZE / 2 + PSIZE * i;
        int d = ZNEAR + PSIZE / 2 + PSIZE * k;
        pgrp[p] = (uchar)w;
        switch (w) {
        case W_BACK:
          pcx[p] = (short)a;
          pcy[p] = (short)(-HALF + PSIZE / 2 + PSIZE * k);
          pcz[p] = ZNEAR + N * PSIZE;
          break;
        case W_FLOOR: pcx[p] = (short)a; pcy[p] = HALF; pcz[p] = (short)d; break;
        case W_CEIL: pcx[p] = (short)a; pcy[p] = -HALF; pcz[p] = (short)d; break;
        case W_LEFT: pcx[p] = -HALF; pcy[p] = (short)a; pcz[p] = (short)d; break;
        default: pcx[p] = HALF; pcy[p] = (short)a; pcz[p] = (short)d; break;
        }
      }
    }
  }
  /* box patches: centers from the face grids' cell midpoints */
  for (int f = 0; f < NBF; f++) {
    /* world normal from the local one through the box rotation */
    int b = f / 5, s = f % 5;
    int c = b == 0 ? B0_COS : B1_COS, sn = b == 0 ? B0_SIN : B1_SIN;
    int nx, ny, nz;
    switch (s) {
    case 0: nx = c; ny = 0; nz = sn; break;
    case 1: nx = -c; ny = 0; nz = -sn; break;
    case 2: nx = -sn; ny = 0; nz = c; break;
    case 3: nx = sn; ny = 0; nz = -c; break;
    default: nx = 0; ny = -256; nz = 0; break;
    }
    gnrm[(5 + f) * 3] = (short)nx;
    gnrm[(5 + f) * 3 + 1] = (short)ny;
    gnrm[(5 + f) * 3 + 2] = (short)nz;
    int h = b == 0 ? B0_H : B1_H, top = b == 0 ? B0_TOP : B1_TOP;
    int ni = NFI[f], nk = NFK[f];
    garea[5 + f] = (ushort)((s == 4 ? 4 * h * h : 2 * h * (HALF - top)) /
                            (ni * nk));
    for (int k = 0; k < nk; k++) {
      for (int i = 0; i < ni; i++) {
        int pb = k * ni + i;
        int q = NWALL + PBASE[f] + pb;
        pgrp[q] = (uchar)(5 + f);
        pcell[PBASE[f] + pb] = (uchar)(i | (k << 4));
        int x0, y0, z0, x1, y1, z1;
        face_point(f, i, k, &x0, &y0, &z0);
        face_point(f, i + 1, k + 1, &x1, &y1, &z1);
        pcx[q] = (short)((x0 + x1) / 2);
        pcy[q] = (short)((y0 + y1) / 2);
        pcz[q] = (short)((z0 + z1) / 2);
      }
    }
    /* visible from the camera at the origin? n . center < 0 */
    int cx, cy, cz2;
    face_point(f, NFI[f] / 2, NFK[f] / 2, &cx, &cy, &cz2);
    fvis[f] = (short)((nx * cx + ny * cy + nz * cz2) < 0);
  }
  for (int k = 0; k < NF; k++) { /* the invisible front wall */
    for (int i = 0; i < NF; i++) {
      int q = NFRONT + k * NF + i;
      pgrp[q] = 15;
      pcx[q] = (short)(-HALF + PSIZEF / 2 + PSIZEF * i);
      pcy[q] = (short)(-HALF + PSIZEF / 2 + PSIZEF * k);
      pcz[q] = ZNEAR;
    }
  }
  for (int q = 0; q < NP; q++) {
    bR[q] = bG[q] = bB[q] = 0;
    uR[q] = uG[q] = uB[q] = 0;
    shown[q] = 0xFFFF;
    shfrc[q] = 0xFF; /* no fraction word can be this: forces the first
                      * repaint even where the level word matches */
  }
  /* the lamp's initial energy rides the ushort ceiling to buy flux */
  for (int k = LIGHT_LO; k < LIGHT_LO + LIGHT_N; k++) {
    for (int i = LIGHT_LO; i < LIGHT_LO + LIGHT_N; i++) {
      int q = LP(i, k);
      uR[q] = 65500;
      uG[q] = 65500;
      uB[q] = 58950;
    }
  }
}

/* --- painting --- */

/* Every fill below paints with the BRUSH (gfx_tile) rather than a
 * color argument: the brush is per patch and the caller has just
 * loaded it.
 * gfx_dfill anchors the brush's phase to the screen, so the row and
 * column parities these walks happen to land on need no bookkeeping
 * here — a span starting on an odd column continues the checker its
 * neighbour left off. */
static void
fill_htrap(int y0, int y1, int xl0, int xl1, int xr0, int xr1)
{
  int h = y1 - y0;
  if (h <= 0)
    return;
  int l = xl0 << 12, r = xr0 << 12;
  int dl = ((xl1 - xl0) << 12) / h, dr = ((xr1 - xr0) << 12) / h;
  for (int y = y0; y < y1; y++) {
    int a = l >> 12, b = r >> 12;
    if (b > a)
      gfx_dfill(a, y, b - a, 1);
    l += dl;
    r += dr;
  }
}

static void
fill_vtrap(int x0, int x1, int yt0, int yt1, int yb0, int yb1)
{
  int wd = x1 - x0;
  if (wd <= 0)
    return;
  int t = yt0 << 12, b = yb0 << 12;
  int dt = ((yt1 - yt0) << 12) / wd, db = ((yb1 - yb0) << 12) / wd;
  for (int x = x0; x < x1; x++) {
    int a = t >> 12, e = b >> 12;
    if (e > a)
      gfx_dfill(x, a, 1, e - a);
    t += dt;
    b += db;
  }
}

/* convex quad in cyclic corner order, filled by columns. Per column
 * the vertical line crosses exactly two of the four edges; their y
 * values (edge slope precomputed, one division per edge) bound the
 * fill. Inclusive x range: adjacent patches overdraw a shared 1-px
 * column, which is invisible and keeps silhouettes gap-free. */
static void
fill_quad(const int *qx, const int *qy)
{
  int minx = qx[0], maxx = qx[0];
  int slope[4];
  for (int e = 0; e < 4; e++) {
    if (qx[e] < minx)
      minx = qx[e];
    if (qx[e] > maxx)
      maxx = qx[e];
    int dx = qx[(e + 1) & 3] - qx[e];
    slope[e] = dx ? (((qy[(e + 1) & 3] - qy[e]) << 12) / dx) : 0;
  }
  for (int x = minx; x <= maxx; x++) {
    int lo = 32767, hi = -32768;
    for (int e = 0; e < 4; e++) {
      int x0 = qx[e], x1 = qx[(e + 1) & 3];
      int xm = x0 < x1 ? x0 : x1, xM = x0 < x1 ? x1 : x0;
      if (x < xm || x > xM)
        continue;
      int y;
      if (x0 == x1) { /* vertical edge: both endpoints bound */
        y = qy[e];
        int y2 = qy[(e + 1) & 3];
        if (y2 < y) {
          int sw = y;
          y = y2;
          y2 = sw;
        }
        if (y < lo)
          lo = y;
        if (y2 > hi)
          hi = y2;
        continue;
      }
      y = qy[e] + ((slope[e] * (x - x0)) >> 12);
      if (y < lo)
        lo = y;
      if (y > hi)
        hi = y;
    }
    if (hi > lo)
      gfx_dfill(x, lo, 1, hi - lo);
  }
}

static void
draw_wall_patch(int w, int i, int k)
{
  const uchar *c00 = corn + CI(w, i, k);
  const uchar *c10 = corn + CI(w, i + 1, k);
  const uchar *c01 = corn + CI(w, i, k + 1);
  const uchar *c11 = corn + CI(w, i + 1, k + 1);
  switch (w) {
  case W_BACK:
    gfx_dfill(c00[0], c00[1], c11[0] - c00[0], c11[1] - c00[1]);
    break;
  case W_FLOOR:
    fill_htrap(c01[1], c00[1], c01[0], c00[0], c11[0], c10[0]);
    break;
  case W_CEIL:
    fill_htrap(c00[1], c01[1], c00[0], c01[0], c10[0], c11[0]);
    break;
  case W_LEFT:
    fill_vtrap(c00[0], c01[0], c00[1], c01[1], c10[1], c11[1]);
    break;
  default:
    fill_vtrap(c01[0], c00[0], c01[1], c00[1], c11[1], c10[1]);
    break;
  }
}

static void
draw_box_patch(int p)
{
  int rel = p - NWALL, f = pgrp[p] - 5;
  if (!fvis[f])
    return;
  int i = pcell[rel] & 15, k = pcell[rel] >> 4;
  int qx[4], qy[4];
  const uchar *a = bcorn + BCI(f, i, k);
  const uchar *b = bcorn + BCI(f, i + 1, k);
  const uchar *d = bcorn + BCI(f, i + 1, k + 1);
  const uchar *e = bcorn + BCI(f, i, k + 1);
  qx[0] = a[0]; qy[0] = a[1];
  qx[1] = b[0]; qy[1] = b[1];
  qx[2] = d[0]; qy[2] = d[1];
  qx[3] = e[0]; qy[3] = e[1];
  fill_quad(qx, qy);
}

/* boxes paint over walls, so any wall repaint under them must be
 * followed by the boxes — cheapest correct rule: if anything wall-side
 * changed, repaint every visible box patch too (they are small). */
static void
repaint(int all)
{
  int wallchanged = 0;
  /* (w,i,k) ride along incrementally: p = w*NPW + k*N + i, and the
   * divisions that recovered them per patch were pure rt_udm tax */
  int w = 0, i = 0, k = 0;
  for (int p = 0; p < NWALL; p++) {
    ushort c = patch_tone(p, is_light(w, i, k));
    if (all || c != shown[p] || dfrc != shfrc[p]) {
      shown[p] = c;
      shfrc[p] = dfrc;
      draw_wall_patch(w, i, k);
      wallchanged = 1;
    }
    if (++i == N) {
      i = 0;
      if (++k == N) {
        k = 0;
        w++;
      }
    }
  }
  for (int p = NWALL; p < NFRONT; p++) {
    ushort c = patch_tone(p, 0);
    if (!all && !wallchanged && c == shown[p] && dfrc == shfrc[p])
      continue;
    shown[p] = c;
    shfrc[p] = dfrc;
    draw_box_patch(p);
  }
  /* NFRONT..NP: the invisible front wall — never drawn */
  gfx_present();
}

/* asr8: v >> 8 for a SIGNED v, without the signed shift. dmacc lowers
 * every >> to a runtime call; __rt_lshr fast-paths counts below 16
 * through the sniffer's bit reversal, but __rt_ashr always rebuilds
 * the word bit by bit (~30 iterations) — and the shooter's dot
 * products are signed. Biasing into non-negative territory makes the
 * shift unsigned, and floor() semantics are unchanged: for u = v + B
 * with B a power of two, (u >>u 8) - B/8ths == v >>s 8 exactly.
 * Callers here are bounded by the room (|v| < 2^20 — see the scene
 * constants), far inside the 2^27 the bias affords. */
#define ASR_BIAS (1 << 27)

static int
asr8(int v)
{
  return (int)(((uint)(v + ASR_BIAS)) >> 8) - (ASR_BIAS >> 8);
}

/* --- occlusion: 5 samples along the segment vs both boxes --- */

static __attribute__((noinline)) int
in_box(int b, int x, int y, int z)
{
  int h, top, cx, cz, c, sn;
  if (b == 0) {
    h = B0_H; top = B0_TOP; cx = B0_CX; cz = B0_CZ; c = B0_COS; sn = B0_SIN;
  } else {
    h = B1_H; top = B1_TOP; cx = B1_CX; cz = B1_CZ; c = B1_COS; sn = B1_SIN;
  }
  if (y <= top)
    return 0; /* above the box (floor is +HALF, always below) */
  int dx = x - cx, dz = z - cz;
  int lx = asr8(dx * c + dz * sn);   /* R^T */
  int lz = asr8(dz * c - dx * sn);
  return lx > -h && lx < h && lz > -h && lz < h;
}

/* fraction 0..5 of the p->q segment that clears both boxes */
static __attribute__((noinline)) int
clearance(int p, int q)
{
  int px = pcx[p], py = pcy[p], pz = pcz[p];
  int dx = pcx[q] - px, dy = pcy[q] - py, dz = pcz[q] - pz;
  /* AABB prechecks: the rotated boxes fit in +-46 of their centers */
  int lox = px < pcx[q] ? px : pcx[q], hix = px + pcx[q] - lox;
  int loz = pz < pcz[q] ? pz : pcz[q], hiz = pz + pcz[q] - loz;
  int t0 = 0, t1 = 0;
  if (hix >= B0_CX - 46 && lox <= B0_CX + 46 && hiz >= B0_CZ - 46 &&
      loz <= B0_CZ + 46)
    t0 = 1;
  if (hix >= B1_CX - 46 && lox <= B1_CX + 46 && hiz >= B1_CZ - 46 &&
      loz <= B1_CZ + 46)
    t1 = 1;
  if (!t0 && !t1)
    return 5;
  int inb = 0;
  for (int s = 1; s <= 5; s++) {
    /* t = s/6 via *43>>8 (43/256 = 0.168 ~ 1/5.95) */
    int t = s * 43;
    int x = px + asr8(dx * t);
    int y = py + asr8(dy * t);
    int z = pz + asr8(dz * t);
    if ((t0 && in_box(0, x, y, z)) || (t1 && in_box(1, x, y, z)))
      inb++;
  }
  /* Opacity, not fog: a ray solidly through a box is BLOCKED — the
   * old cleared/5 return made shadow strength equal the fraction of
   * the SEGMENT inside the blocker, so grazing paths (light to the
   * walls, or over the short box) transmitted 80-100% and cast no
   * shadow at all (measured floor/wall maps). One interior sample
   * keeps a soft 2/5 edge; two or more mean the ray runs through
   * the volume — opaque. */
  if (inb >= 2)
    return 0;
  if (inb == 1)
    return 2;
  return 5;
}

/* --- the shooter ---
 * shoot/clearance/in_box are noinline: dmxgen places them
 * (ResidentFuncs) in the game's SRAM ramtext, so the NP-receiver inner
 * loop never touches XIP flash. --- */

static __attribute__((noinline)) uint
shoot(int p)
{
  int g = pgrp[p];
  uint ap = garea[g]; /* the shooter's area, in scene units^2 */
  uint upr = uR[p], upg = uG[p], upb = uB[p];
  uR[p] = uG[p] = uB[p] = 0;
  int px = pcx[p], py = pcy[p], pz = pcz[p];
  const short *pn = gnrm + g * 3;
  int pnx = pn[0], pny = pn[1], pnz = pn[2];
  for (int q = 0; q < NP; q++) {
    if (q == p)
      continue;
    int dx = pcx[q] - px, dy = pcy[q] - py, dz = pcz[q] - pz;
    int dp = asr8(dx * pnx + dy * pny + dz * pnz);
    if (dp <= 0)
      continue;
    int gq = pgrp[q];
    const short *qn = gnrm + gq * 3;
    int dq = -asr8(dx * qn[0] + dy * qn[1] + dz * qn[2]);
    if (dq <= 0)
      continue;
    uint r2 = (uint)(dx * dx) + (uint)(dy * dy) + (uint)(dz * dz);
    if (r2 < 64)
      continue; /* touching patches: geometry degenerates */
    int vis = clearance(p, q);
    if (vis == 0)
      continue;
    /* F = dp*dq*ap / (pi*r2*r2), staged so u32 never overflows:
     * a <= 1024 (dp*dq <= r2) in Q10, b in Q14 clamped at 1.0, and
     * the fold to a Q16 form factor is a*b*41 >> 15 (the 41/2^15
     * carries the 1/pi and both Q scales). a*b*41 peaks at 6.9e8 and
     * f at 20992, so upr*f stays under 1.4e9.
     *
     * Q16, where this was Q12, and Q14 in b where it was Q10. Those
     * six bits are the whole story of raising N: the shooter's area
     * is the REAL patch area now, and a 10-unit wall patch has 5.76x
     * less of it. Every one of those bits came off the BOTTOM of f,
     * and in Q12 the far half of the room rounded to a form factor of
     * exactly zero — the light stopped crossing the box, and the
     * render came out a stop and a half dark. The wider fixed point
     * costs nothing (the same two divisions) and is measurably more
     * accurate than the 10-patch grid ever was: for a facing pair at
     * r=400 the old b truncated 3.69 to 3 and lost 19 % of the
     * transfer, where this one truncates f from 12.8 to 12 and loses
     * 6 %.
     *
     * The clamp is ap/r2 <= 1, i.e. pairs closer together than their
     * own size, where a point-to-point form factor means nothing
     * anyway (and where dp or dq has usually gone non-positive
     * already, because patches that close are nearly coplanar).
     * The receiver term stays area-free by design — see the header. */
    uint a = ((uint)(dp * dq) << 10) / r2;
    uint b = (ap << 14) / r2;
    if (b > 16384)
      b = 16384;
    uint f = a * b * 41 >> 15;
    f = f * (uint)(vis * 51) >> 8; /* x vis/5 (51/256 ~ 1/5.02) */
    if (f == 0)
      continue;
    const ushort *rq = grho + gq * 3;
    uint dr = (upr * f >> 16) * rq[0] >> 8;
    uint dg = (upg * f >> 16) * rq[1] >> 8;
    uint db = (upb * f >> 16) * rq[2] >> 8;
    uint t;
    t = bR[q] + dr; bR[q] = t > 65535 ? 65535 : (ushort)t;
    t = bG[q] + dg; bG[q] = t > 65535 ? 65535 : (ushort)t;
    t = bB[q] + db; bB[q] = t > 65535 ? 65535 : (ushort)t;
    t = uR[q] + dr; uR[q] = t > 65535 ? 65535 : (ushort)t;
    t = uG[q] + dg; uG[q] = t > 65535 ? 65535 : (ushort)t;
    t = uB[q] + db; uB[q] = t > 65535 ? 65535 : (ushort)t;
  }
  return upr + upg + upb;
}

/* The stop test is a FLUX, not a brightness: unshot radiosity times
 * the patch's own area, so a coarse box face and a fine wall patch are
 * compared on the energy each would actually deliver. The floor is
 * 96 brightness units on a WALL patch, which is where the N=10 grid
 * has always stopped — expressed against AREA it means the same
 * converged image however fine the grid gets, at the price of more
 * shots to drain the smaller patches. */
#define SHOT_MIN (96u * AREA)

static __attribute__((noinline)) int
brightest(void)
{
  uint best = 0;
  int bi = -1;
  for (int p = 0; p < NP; p++) {
    uint e = ((uint)uR[p] + uG[p] + uB[p]) * (uint)garea[pgrp[p]];
    if (e > best) {
      best = e;
      bi = p;
    }
  }
  return best >= SHOT_MIN ? bi : -1;
}

void
radio_run(void)
{
  uputs("radio: up\n");
  /* The patch arrays run straight through fx.c's 16 KiB audio ring, so
   * the ring channel has to stop before the first store lands — see
   * aud_borrow(), which also finishes off whatever the menu was
   * playing. The scene is silent by construction: it calls no snd_*,
   * and frame_sync's snd_tick has nothing left to do. */
  aud_borrow();
  led(LED_DIM(0xFF6010), LED_DIM(0xFF6010));
  gfx_clear(C_BG); /* the box owns the whole screen; press = back */
  project();
  setup();
  repaint(1);

  uint shots = 0;
  int done = 0;
  for (;;) {
    in_poll();
    if (in_edge & (BTN_A | BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)) {
      led(0, 0);
      aud_release(); /* zero the ring, then let ch9 stream it again */
      uputs("radio: back\n");
      return;
    }
    if (done) {
      frame_sync(33000);
      continue;
    }
    int p = brightest();
    if (p < 0) {
      done = 1;
      uputs("radio: converged after ");
      uputn(shots);
      uputs(" shots\n");
      led(LED_DIM(0x40FF40), LED_DIM(0x40FF40));
      continue;
    }
    shoot(p);
    shots++;
    repaint(0);
    if ((shots & 15) == 0) {
      uputs("radio: shot ");
      uputn(shots);
      uputs("\n");
    }
  }
}
