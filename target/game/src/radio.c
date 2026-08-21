/* radio.c: progressive radiosity in the classic red/green light box,
 * rendered live — now with the two interior boxes (a tall cuboid and
 * a cube, both rotated about the vertical axis) that give the scene
 * its soft shadows. Five walls are split into 8x8 patches, each box
 * face into 2x2; a 2x2 ceiling light carries the initial energy.
 * Each step "shoots" the brightest patch's unshot energy at every
 * other patch and repaints what changed, so the room brightens and
 * color-bleeds in front of you — the whole point is WATCHING the
 * light bounce.
 *
 * Everything is integer. The tricks that make that work:
 *  - the receiver update is brightness-normalized (area-free), and
 *    only the SHOOTER scales its energy by its patch-area ratio, so
 *    unequal box/wall patch areas cost one Q8 multiply;
 *  - normals are Q8 constants (the boxes rotate only about Y, so
 *    their corner positions and normals are compile-time numbers,
 *    and vertical edges stay vertical on screen);
 *  - occlusion is 5 stratified samples along the pair segment tested
 *    point-in-rotated-box (4 muls each) behind an AABB precheck;
 *    the sample fraction scales the form factor, which is also what
 *    softens the shadow edges;
 *  - the form factor F = dp*dq*A / (pi*r2*r2) is staged as two
 *    guarded divisions so u32 never overflows (see shoot());
 *  - the camera sits at the box opening (z in [200,440], focal 200):
 *    the opening projects EXACTLY to the 240x240 screen — no
 *    clipping anywhere;
 *  - every hot right shift is < 16 to stay on the runtime's OUT_REV
 *    fast path.
 *
 * Patch state lives in the free SRAM window at 0x2003D100 (shared
 * with the benchmark's buffers — the two apps never run together). */
#include "g.h"

#define C_BG RGB(8, 8, 16)

#define N 8            /* patches per wall edge */
#define NPW (N * N)    /* 64 per wall */
#define NWALL (5 * NPW)
#define NBF 10         /* box faces: 2 boxes x (4 sides + top) */
#define NPBF 4         /* 2x2 patches per box face */
#define NP (NWALL + NBF * NPBF) /* 360 patches */
#define HALF 120       /* box half-width in scene units */
#define ZNEAR 200      /* opening (camera at z=0, focal ZNEAR) */
#define PSIZE 30       /* wall patch edge: 240/8 */
#define AREA (PSIZE * PSIZE)

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

/* --- state in free SRAM (see bench.c for the region's story) ---
 * ten NP-sized arrays at a 720-byte stride, then the projected wall
 * corner grid (5 walls x 9x9 x (sx,sy)), then the box face corners
 * (10 faces x 3x3 x (sx,sy)); ~9.2 KiB of the 11.5 KiB window. */
#define RAD_RAM 0x2003D100u
#define pcx ((short *)RAD_RAM)
#define pcy ((short *)(RAD_RAM + 720))
#define pcz ((short *)(RAD_RAM + 1440))
#define bR ((ushort *)(RAD_RAM + 2160))
#define bG ((ushort *)(RAD_RAM + 2880))
#define bB ((ushort *)(RAD_RAM + 3600))
#define uR ((ushort *)(RAD_RAM + 4320))
#define uG ((ushort *)(RAD_RAM + 5040))
#define uB ((ushort *)(RAD_RAM + 5760))
#define shown ((ushort *)(RAD_RAM + 6480))
#define corn ((short *)(RAD_RAM + 7200))  /* walls: 1620 B */
#define bcorn ((short *)(RAD_RAM + 8880)) /* boxes: 360 B */
#define CI(w, i, k) ((w) * 162 + ((k) * 9 + (i)) * 2)
#define BCI(f, i, k) ((f) * 18 + ((k) * 3 + (i)) * 2)

/* per-face normals (Q8) and shooter area ratios (Q8 vs a wall patch),
 * filled by setup(); +10 visibility flags */
#define nrm ((short *)(RAD_RAM + 9240))   /* 10 x 3 */
#define areaq ((short *)(RAD_RAM + 9300)) /* 10 */
#define fvis ((short *)(RAD_RAM + 9320))  /* 10 */

/* reflectance per wall group, Q8; box faces are warm white */
static const ushort rho[6][3] = {
    {192, 192, 192}, {192, 192, 192}, {192, 192, 192},
    {230, 45, 45},   /* left wall: red */
    {45, 230, 45},   /* right wall: green */
    {200, 195, 185}, /* the boxes */
};

static int
is_light(int p)
{
  if (p / NPW != W_CEIL || p >= NWALL)
    return 0;
  int i = p % N, k = p % NPW / N;
  return (i == 3 || i == 4) && (k == 3 || k == 4);
}

/* patch group: 0..4 walls, 5 boxes (for reflectance) */
static int
group(int p)
{
  return p < NWALL ? p / NPW : 5;
}

/* tone map a radiosity channel to 0..255 (soft linear, <16 shift) */
static uint
tone(uint v)
{
  uint c = v >> 3;
  if (c > 255)
    c = 255;
  return c;
}

static ushort
patch_color(int p)
{
  if (is_light(p))
    return RGB(255, 255, 240);
  return (ushort)RGB(tone(bR[p]), tone(bG[p]), tone(bB[p]));
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
 * 3 -lz, 4 top). Grid point (i,k) 0..2 in local face coords. */
static void
face_point(int f, int i, int k, int *wx, int *wy, int *wz)
{
  int b = f / 5, s = f % 5;
  int h = b == 0 ? B0_H : B1_H;
  int top = b == 0 ? B0_TOP : B1_TOP;
  int u = -h + h * i;            /* -h, 0, +h */
  int v = top + (HALF - top) * k / 2; /* top..floor for sides */
  int lx, lz;
  switch (s) {
  case 0: lx = h; lz = u; break;
  case 1: lx = -h; lz = u; break;
  case 2: lx = u; lz = h; break;
  case 3: lx = u; lz = -h; break;
  default: /* top: u across x, second axis across z */
    lx = u;
    lz = -h + h * k;
    break;
  }
  box_world(b, lx, lz, wx, wz);
  *wy = s == 4 ? top : v;
}

/* --- projection --- */

static void
project(void)
{
  int recip[9];
  for (int g = 0; g < 9; g++)
    recip[g] = (int)((uint)(ZNEAR << 12) / (uint)(ZNEAR + PSIZE * g));
  for (int w = 0; w < 5; w++) {
    for (int k = 0; k < 9; k++) {
      for (int i = 0; i < 9; i++) {
        int gx = -HALF + PSIZE * i, gy, r;
        int sx, sy;
        switch (w) {
        case W_BACK:
          gy = -HALF + PSIZE * k;
          r = recip[8];
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
        corn[CI(w, i, k)] = (short)sx;
        corn[CI(w, i, k) + 1] = (short)sy;
      }
    }
  }
  /* box face corners: one true perspective divide per corner */
  for (int f = 0; f < NBF; f++) {
    for (int k = 0; k < 3; k++) {
      for (int i = 0; i < 3; i++) {
        int wx, wy, wz;
        face_point(f, i, k, &wx, &wy, &wz);
        int rz = (int)((uint)(ZNEAR << 12) / (uint)wz);
        bcorn[BCI(f, i, k)] = (short)(120 + ((wx * rz) >> 12));
        bcorn[BCI(f, i, k) + 1] = (short)(120 + ((wy * rz) >> 12));
      }
    }
  }
}

static void
setup(void)
{
  for (int p = 0; p < NWALL; p++) {
    int w = p / NPW, i = p % N, k = p % NPW / N;
    int a = -HALF + PSIZE / 2 + PSIZE * i;
    int d = ZNEAR + PSIZE / 2 + PSIZE * k;
    switch (w) {
    case W_BACK:
      pcx[p] = (short)a;
      pcy[p] = (short)(-HALF + PSIZE / 2 + PSIZE * k);
      pcz[p] = ZNEAR + 8 * PSIZE;
      break;
    case W_FLOOR: pcx[p] = (short)a; pcy[p] = HALF; pcz[p] = (short)d; break;
    case W_CEIL: pcx[p] = (short)a; pcy[p] = -HALF; pcz[p] = (short)d; break;
    case W_LEFT: pcx[p] = -HALF; pcy[p] = (short)a; pcz[p] = (short)d; break;
    default: pcx[p] = HALF; pcy[p] = (short)a; pcz[p] = (short)d; break;
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
    nrm[f * 3] = (short)nx;
    nrm[f * 3 + 1] = (short)ny;
    nrm[f * 3 + 2] = (short)nz;
    int h = b == 0 ? B0_H : B1_H, top = b == 0 ? B0_TOP : B1_TOP;
    int aq = s == 4 ? h * h : h * (HALF - top) / 2; /* patch area */
    areaq[f] = (short)(aq * 256 / AREA);
    for (int pb = 0; pb < NPBF; pb++) {
      int p = NWALL + f * NPBF + pb;
      int i = pb & 1, k = pb >> 1; /* cell (i,k) of the 2x2 */
      int x0, y0, z0, x1, y1, z1;
      face_point(f, i, k, &x0, &y0, &z0);
      face_point(f, i + 1, k + 1, &x1, &y1, &z1);
      pcx[p] = (short)((x0 + x1) / 2);
      pcy[p] = (short)((y0 + y1) / 2);
      pcz[p] = (short)((z0 + z1) / 2);
    }
    /* visible from the camera at the origin? n . center < 0 */
    int cx, cy, cz2;
    face_point(f, 1, 1, &cx, &cy, &cz2);
    fvis[f] = (short)((nx * cx + ny * cy + nz * cz2) < 0);
  }
  for (int p = 0; p < NP; p++) {
    bR[p] = bG[p] = bB[p] = 0;
    uR[p] = uG[p] = uB[p] = 0;
    shown[p] = 0xFFFF;
    if (is_light(p)) {
      uR[p] = 60000;
      uG[p] = 60000;
      uB[p] = 54000;
    }
  }
}

/* --- painting --- */

static void
fill_htrap(int y0, int y1, int xl0, int xl1, int xr0, int xr1, ushort c)
{
  int h = y1 - y0;
  if (h <= 0)
    return;
  int l = xl0 << 12, r = xr0 << 12;
  int dl = ((xl1 - xl0) << 12) / h, dr = ((xr1 - xr0) << 12) / h;
  for (int y = y0; y < y1; y++) {
    int a = l >> 12, b = r >> 12;
    if (b > a)
      gfx_fill(a, y, b - a, 1, c);
    l += dl;
    r += dr;
  }
}

static void
fill_vtrap(int x0, int x1, int yt0, int yt1, int yb0, int yb1, ushort c)
{
  int wd = x1 - x0;
  if (wd <= 0)
    return;
  int t = yt0 << 12, b = yb0 << 12;
  int dt = ((yt1 - yt0) << 12) / wd, db = ((yb1 - yb0) << 12) / wd;
  for (int x = x0; x < x1; x++) {
    int a = t >> 12, e = b >> 12;
    if (e > a)
      gfx_fill(x, a, 1, e - a, c);
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
fill_quad(const int *qx, const int *qy, ushort c)
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
      gfx_fill(x, lo, 1, hi - lo, c);
  }
}

static void
draw_wall_patch(int p, ushort c)
{
  int w = p / NPW, i = p % N, k = p % NPW / N;
  const short *c00 = corn + CI(w, i, k);
  const short *c10 = corn + CI(w, i + 1, k);
  const short *c01 = corn + CI(w, i, k + 1);
  const short *c11 = corn + CI(w, i + 1, k + 1);
  switch (w) {
  case W_BACK:
    gfx_fill(c00[0], c00[1], c11[0] - c00[0], c11[1] - c00[1], c);
    break;
  case W_FLOOR:
    fill_htrap(c01[1], c00[1], c01[0], c00[0], c11[0], c10[0], c);
    break;
  case W_CEIL:
    fill_htrap(c00[1], c01[1], c00[0], c01[0], c10[0], c11[0], c);
    break;
  case W_LEFT:
    fill_vtrap(c00[0], c01[0], c00[1], c01[1], c10[1], c11[1], c);
    break;
  default:
    fill_vtrap(c01[0], c00[0], c01[1], c00[1], c11[1], c10[1], c);
    break;
  }
}

static void
draw_box_patch(int p, ushort c)
{
  int rel = p - NWALL, f = rel / NPBF, pb = rel % NPBF;
  if (!fvis[f])
    return;
  int i = pb & 1, k = pb >> 1;
  int qx[4], qy[4];
  const short *a = bcorn + BCI(f, i, k);
  const short *b = bcorn + BCI(f, i + 1, k);
  const short *d = bcorn + BCI(f, i + 1, k + 1);
  const short *e = bcorn + BCI(f, i, k + 1);
  qx[0] = a[0]; qy[0] = a[1];
  qx[1] = b[0]; qy[1] = b[1];
  qx[2] = d[0]; qy[2] = d[1];
  qx[3] = e[0]; qy[3] = e[1];
  fill_quad(qx, qy, c);
}

/* boxes paint over walls, so any wall repaint under them must be
 * followed by the boxes — cheapest correct rule: if anything wall-side
 * changed, repaint every visible box patch too (they are small). */
static void
repaint(int all)
{
  int wallchanged = 0;
  for (int p = 0; p < NWALL; p++) {
    ushort c = patch_color(p);
    if (!all && c == shown[p])
      continue;
    shown[p] = c;
    draw_wall_patch(p, c);
    wallchanged = 1;
  }
  for (int p = NWALL; p < NP; p++) {
    ushort c = patch_color(p);
    if (!all && !wallchanged && c == shown[p])
      continue;
    shown[p] = c;
    draw_box_patch(p, c);
  }
  gfx_present();
}

/* --- occlusion: 5 samples along the segment vs both boxes --- */

static int
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
  int lx = (dx * c + dz * sn) >> 8;   /* R^T */
  int lz = (dz * c - dx * sn) >> 8;
  return lx > -h && lx < h && lz > -h && lz < h;
}

/* fraction 0..5 of the p->q segment that clears both boxes */
static int
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
  int ok = 0;
  for (int s = 1; s <= 5; s++) {
    /* t = s/6 via *43>>8 (43/256 = 0.168 ~ 1/5.95) */
    int t = s * 43;
    int x = px + ((dx * t) >> 8);
    int y = py + ((dy * t) >> 8);
    int z = pz + ((dz * t) >> 8);
    if ((t0 && in_box(0, x, y, z)) || (t1 && in_box(1, x, y, z)))
      continue;
    ok++;
  }
  return ok;
}

/* --- the shooter --- */

static void
normal_of(int p, int *nx, int *ny, int *nz)
{
  if (p >= NWALL) {
    int f = (p - NWALL) / NPBF;
    *nx = nrm[f * 3];
    *ny = nrm[f * 3 + 1];
    *nz = nrm[f * 3 + 2];
    return;
  }
  switch (p / NPW) {
  case W_BACK: *nx = 0; *ny = 0; *nz = -256; break;
  case W_FLOOR: *nx = 0; *ny = -256; *nz = 0; break;
  case W_CEIL: *nx = 0; *ny = 256; *nz = 0; break;
  case W_LEFT: *nx = 256; *ny = 0; *nz = 0; break;
  default: *nx = -256; *ny = 0; *nz = 0; break;
  }
}

static int
shooter_scale(int p) /* Q8 area ratio vs a wall patch */
{
  if (p < NWALL)
    return 256;
  return areaq[(p - NWALL) / NPBF];
}

static uint
shoot(int p)
{
  uint sc = (uint)shooter_scale(p);
  uint upr = uR[p] * sc >> 8, upg = uG[p] * sc >> 8, upb = uB[p] * sc >> 8;
  uR[p] = uG[p] = uB[p] = 0;
  int px = pcx[p], py = pcy[p], pz = pcz[p];
  int pnx, pny, pnz;
  normal_of(p, &pnx, &pny, &pnz);
  for (int q = 0; q < NP; q++) {
    if (q == p)
      continue;
    int dx = pcx[q] - px, dy = pcy[q] - py, dz = pcz[q] - pz;
    int dp = (dx * pnx + dy * pny + dz * pnz) >> 8;
    if (dp <= 0)
      continue;
    int qnx, qny, qnz;
    normal_of(q, &qnx, &qny, &qnz);
    int dq = -((dx * qnx + dy * qny + dz * qnz) >> 8);
    if (dq <= 0)
      continue;
    uint r2 = (uint)(dx * dx) + (uint)(dy * dy) + (uint)(dz * dz);
    if (r2 < 64)
      continue; /* touching patches: geometry degenerates */
    int vis = clearance(p, q);
    if (vis == 0)
      continue;
    /* F = dp*dq*AREA / (pi*r2*r2), staged so u32 never overflows:
     * a <= 1024 (dp*dq <= r2), b <= (900<<10)/64, and the fold to a
     * Q12 form factor is a*b*41 >> 15 (41/32768 ~ 1/(256*pi)). The
     * receiver term is area-free by design — see the header. */
    uint a = ((uint)(dp * dq) << 10) / r2;
    uint b = ((uint)AREA << 10) / r2;
    if (b > 4096)
      b = 4096; /* clamp the closest pairs; keeps a*b*41 in u32 */
    uint f = a * b * 41 >> 15;
    f = f * (uint)(vis * 51) >> 8; /* x vis/5 (51/256 ~ 1/5.02) */
    if (f == 0)
      continue;
    const ushort *rq = rho[group(q)];
    uint dr = (upr * f >> 12) * rq[0] >> 8;
    uint dg = (upg * f >> 12) * rq[1] >> 8;
    uint db = (upb * f >> 12) * rq[2] >> 8;
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

static int
brightest(void)
{
  uint best = 0;
  int bi = -1;
  for (int p = 0; p < NP; p++) {
    uint e = ((uint)uR[p] + uG[p] + uB[p]) * (uint)shooter_scale(p) >> 8;
    if (e > best) {
      best = e;
      bi = p;
    }
  }
  return best >= 96 ? bi : -1;
}

void
radio_run(void)
{
  uputs("radio: up\n");
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
