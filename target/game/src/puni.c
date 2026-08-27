/* puni.c: Puni Puni — a falling-pairs chain puzzle. Pairs of colored
 * blobs drop into a 6x12 well; four or more of a color touching pop,
 * everything above settles, and cascades chain for multiplied score.
 * The blobs are PLAIN CIRCLES on purpose (an original look): five
 * disc cells rendered into the arena once at entry, so every cell
 * repaint is one word-aligned DMA blit. Logic touches 72 cells at
 * worst — the machine's kind of workload. */
#include "g.h"

#define PW 6
#define PH 12
#define CSZ 18 /* cell edge, even: blits stay on the DMA fast path */
#define FX0 12
#define FY0 12

#define C_WALL RGB(70, 76, 110)
#define C_FBG RGB(16, 18, 34)
#define C_BG RGB(28, 32, 56)
#define C_TEXT RGB(180, 190, 210)
#define C_OVER RGB(230, 60, 60)

#define NCOL 4

struct pst {
  uchar grid[PH][PW]; /* 0 empty, 1..NCOL a blob */
  uchar vis[PH][PW];
  uchar stk[PW * PH], pop[PW * PH];
  int px, py, rot; /* falling pair: pivot cell + satellite direction */
  int c1, c2, n1, n2, n3, n4; /* current pair + TWO queued pairs */
  int ftimer, fspeed;
  int score, over, hold, drawn_score;
};
#define PS ((struct pst *)g_arena)
#define CELLB (CSZ * CSZ * 2)
/* disc cells: colors 1..NCOL at 0..3, the pop flash at 4 */
#define cellbuf(i) ((ushort *)(g_arena + 1024 + (uint)(i) * CELLB))

/* satellite offsets by rot: above, right, below, left */
static const signed char sdx[4] = {0, 1, 0, -1};
static const signed char sdy[4] = {-1, 0, 1, 0};

static void
cell_draw(int x, int y, int v)
{
  if (y < 0)
    return;
  if (v == 0)
    gfx_fill(FX0 + x * CSZ, FY0 + y * CSZ, CSZ, CSZ, C_FBG);
  else
    gfx_blit(FX0 + x * CSZ, FY0 + y * CSZ, cellbuf(v - 1), CSZ, CSZ);
}

static void
field_draw(void)
{
  for (int y = 0; y < PH; y++)
    for (int x = 0; x < PW; x++)
      cell_draw(x, y, PS->grid[y][x]);
}

static void
preview_draw(void)
{
  gfx_text(150, 62, "NEXT", C_TEXT, C_BG);
  gfx_blit(150, 74, cellbuf(PS->n2 - 1), CSZ, CSZ);
  gfx_blit(150, 74 + CSZ, cellbuf(PS->n1 - 1), CSZ, CSZ);
  gfx_blit(150, 122, cellbuf(PS->n4 - 1), CSZ, CSZ);
  gfx_blit(150, 122 + CSZ, cellbuf(PS->n3 - 1), CSZ, CSZ);
}

static void
score_draw(void)
{
  char b[7];
  numstr(b, 6, (uint)PS->score);
  gfx_text(150, 176, b, C_TEXT, C_BG);
  PS->drawn_score = PS->score;
}

static int
freeat(int x, int y)
{
  return x >= 0 && x < PW && y < PH && (y < 0 || PS->grid[y][x] == 0);
}

static void
pair_draw(int on)
{
  int sx = PS->px + sdx[PS->rot], sy = PS->py + sdy[PS->rot];
  cell_draw(PS->px, PS->py, on ? PS->c1 : 0);
  cell_draw(sx, sy, on ? PS->c2 : 0);
}

static void
pair_spawn(void)
{
  PS->px = 2;
  PS->py = 0;
  PS->rot = 0;
  PS->c1 = PS->n1;
  PS->c2 = PS->n2;
  PS->n1 = PS->n3;
  PS->n2 = PS->n4;
  PS->n3 = 1 + (int)rng_below(NCOL);
  PS->n4 = 1 + (int)rng_below(NCOL);
  PS->ftimer = 0;
  preview_draw();
  if (PS->grid[0][2] != 0) { /* the well is full */
    PS->over = 1;
    gfx_text2(48, 104, "GAME OVER", C_OVER, C_FBG);
    gfx_text(48, 128, "Press to try again", C_TEXT, C_FBG);
    uputs("puni: game over\n");
    led_blink(LED_BRIGHT(0xFF2020), 6);
    snd_play(110, 70, 20);
  }
}

/* settle: everything falls to rest, repainting what moved */
static void
settle(void)
{
  for (int x = 0; x < PW; x++) {
    int w = PH - 1;
    for (int y = PH - 1; y >= 0; y--)
      if (PS->grid[y][x]) {
        int v = PS->grid[y][x];
        if (w != y) {
          PS->grid[w][x] = (uchar)v;
          PS->grid[y][x] = 0;
          cell_draw(x, w, v);
          cell_draw(x, y, 0);
        }
        w--;
      }
  }
}

/* find every >=4 group; returns popped count (cells listed in pop[]) */
static int
groups(void)
{
  int npop = 0;
  for (int y = 0; y < PH; y++)
    for (int x = 0; x < PW; x++)
      PS->vis[y][x] = 0;
  for (int y0 = 0; y0 < PH; y0++)
    for (int x0 = 0; x0 < PW; x0++) {
      int v = PS->grid[y0][x0];
      if (!v || PS->vis[y0][x0])
        continue;
      int sp = 0, n = 0, base = npop;
      PS->stk[sp++] = (uchar)(y0 * PW + x0);
      PS->vis[y0][x0] = 1;
      while (sp) {
        int c = PS->stk[--sp];
        int cy = c / PW, cx = c - cy * PW;
        PS->pop[base + n] = (uchar)c;
        n++;
        static const signed char ddx[4] = {0, 0, 1, -1};
        static const signed char ddy[4] = {1, -1, 0, 0};
        for (int d = 0; d < 4; d++) {
          int nx = cx + ddx[d], ny = cy + ddy[d];
          if (nx < 0 || nx >= PW || ny < 0 || ny >= PH)
            continue;
          if (PS->vis[ny][nx] || PS->grid[ny][nx] != v)
            continue;
          PS->vis[ny][nx] = 1;
          PS->stk[sp++] = (uchar)(ny * PW + nx);
        }
      }
      if (n >= 4)
        npop = base + n; /* keep the group's cells */
    }
  return npop;
}

/* one wait frame that still honors the quit hold */
static int
tick(void)
{
  frame_sync(33000);
  in_poll();
  if (in_down & BTN_A)
    PS->hold++;
  else
    PS->hold = 0;
  return PS->hold > 45;
}

void
puni_run(void)
{
  uputs("puni: start\n");
  led(LED_DIM(0xFF40C0), LED_DIM(0x40FFC0));
  {
    static const ushort pc[NCOL + 1] = {
        RGB(235, 70, 80),   /* red */
        RGB(60, 200, 90),   /* green */
        RGB(70, 120, 240),  /* blue */
        RGB(240, 200, 60),  /* yellow */
        RGB(255, 255, 255), /* the pop flash */
    };
    for (int i = 0; i <= NCOL; i++)
      gfx_disc_cell(CSZ, 8, pc[i], C_FBG, cellbuf(i));
  }
restart:
  for (int y = 0; y < PH; y++)
    for (int x = 0; x < PW; x++)
      PS->grid[y][x] = 0;
  PS->score = 0;
  PS->over = 0;
  PS->hold = 0;
  PS->fspeed = 16;
  PS->n1 = 1 + (int)rng_below(NCOL);
  PS->n2 = 1 + (int)rng_below(NCOL);
  PS->n3 = 1 + (int)rng_below(NCOL);
  PS->n4 = 1 + (int)rng_below(NCOL);
  gfx_clear(C_BG);
  gfx_rect(FX0 - 4, FY0 - 4, PW * CSZ + 8, PH * CSZ + 8, 2, C_WALL);
  gfx_text2(150, 12, "PUNI", C_TEXT, C_BG);
  gfx_text2(150, 30, "PUNI", C_TEXT, C_BG);
  for (int y = 0; y < PH; y++)
    for (int x = 0; x < PW; x++)
      cell_draw(x, y, 0);
  score_draw();
  pair_spawn();
  pair_draw(1);
  gfx_present();
  for (;;) {
    if (tick()) {
      uputs("puni: quit\n");
      snd_off();
      return;
    }
    if (PS->over) {
      if (in_edge & BTN_A) {
        uputs("puni: again\n");
        goto restart;
      }
      continue;
    }
    int sx = PS->px + sdx[PS->rot], sy = PS->py + sdy[PS->rot];
    if (in_edge & BTN_LEFT) {
      if (freeat(PS->px - 1, PS->py) && freeat(sx - 1, sy)) {
        pair_draw(0);
        PS->px--;
        pair_draw(1);
        snd_play(500, 25, 1);
      }
    }
    if (in_edge & BTN_RIGHT) {
      if (freeat(PS->px + 1, PS->py) && freeat(sx + 1, sy)) {
        pair_draw(0);
        PS->px++;
        pair_draw(1);
        snd_play(500, 25, 1);
      }
    }
    if (in_edge & (BTN_UP | BTN_A)) { /* rotate CW around the pivot */
      int nr = (PS->rot + 1) & 3;
      int nx = PS->px + sdx[nr], ny = PS->py + sdy[nr];
      if (freeat(nx, ny)) {
        pair_draw(0);
        PS->rot = nr;
        pair_draw(1);
        snd_play(700, 25, 1);
      }
    }
    PS->ftimer += (in_down & BTN_DOWN) ? 8 : 1;
    if (PS->ftimer < PS->fspeed) {
      gfx_present();
      continue;
    }
    PS->ftimer = 0;
    sx = PS->px + sdx[PS->rot];
    sy = PS->py + sdy[PS->rot];
    if (freeat(PS->px, PS->py + 1) && freeat(sx, sy + 1)) {
      pair_draw(0);
      PS->py++;
      pair_draw(1);
      gfx_present();
      continue;
    }
    /* lock; a satellite still above the well ends the game */
    uputs("puni: lock\n");
    if (PS->py >= 0)
      PS->grid[PS->py][PS->px] = (uchar)PS->c1;
    if (sy >= 0)
      PS->grid[sy][sx] = (uchar)PS->c2;
    else {
      PS->over = 1;
      gfx_text2(48, 104, "GAME OVER", C_OVER, C_FBG);
      gfx_text(48, 128, "Press to try again", C_TEXT, C_FBG);
      uputs("puni: game over\n");
      continue;
    }
    /* resolve: settle, pop, chain until quiet */
    int chain = 0;
    for (;;) {
      settle();
      gfx_present();
      int npop = groups();
      if (npop == 0)
        break;
      chain++;
      PS->score += npop * 10 * chain;
      uputs("puni: pop ");
      uputn((uint)npop);
      uputs(" chain ");
      uputn((uint)chain);
      uputs("\n");
      snd_play(300u + (uint)chain * 150u, 60, 6);
      led_blink(LED_BRIGHT(0x40FF80), 2);
      for (int i = 0; i < npop; i++) { /* flash white */
        int c = PS->pop[i], cy = c / PW;
        cell_draw(c - cy * PW, cy, NCOL + 1);
      }
      gfx_present();
      for (int f = 0; f < 10; f++) /* let the flash breathe */
        if (tick()) {
          uputs("puni: quit\n");
          snd_off();
          return;
        }
      for (int i = 0; i < npop; i++) {
        int c = PS->pop[i], cy = c / PW;
        PS->grid[cy][c - cy * PW] = 0;
        cell_draw(c - cy * PW, cy, 0);
      }
      gfx_present();
      for (int f = 0; f < 6; f++) /* a beat before the fall */
        if (tick()) {
          uputs("puni: quit\n");
          snd_off();
          return;
        }
    }
    if (PS->score != PS->drawn_score) {
      score_draw();
      if (PS->fspeed > 6)
        PS->fspeed = 16 - PS->score / 400;
      if (PS->fspeed < 6)
        PS->fspeed = 6;
    }
    pair_spawn();
    pair_draw(1);
    gfx_present();
  }
}
