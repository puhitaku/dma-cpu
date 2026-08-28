/* chute.c: Parachute — the click-wheel classic, styled after the
 * original: pale sky, dark-ink silhouettes, a domed cannon with a
 * stub barrel. Helicopters cross the sky dropping paratroopers who
 * freefall half a second before the canopy opens; shoot the chute
 * and the soldier drops. A soldier landing ON the gun destroys it
 * instantly; four landed soldiers lay siege with grenades, and a
 * hit blows the gun into tumbling debris. Downed helicopters also
 * burst into debris that destroys whatever it touches — including
 * other helicopters, in chains. Sprites are 1bpp art rendered into
 * arena cells and drawn through exact-silhouette run tables. */
#include "g.h"

/* art_heli_la: 28x12 */
static const uint art_heli_la[12] = {
  0x02000000,
  0xfffc0000,
  0x02000000,
  0x1fe00c00,
  0x3ff01c00,
  0x7ffff980,
  0xdfffffc0,
  0x7ff80c80,
  0x3ff00000,
  0x08400000,
  0x3ff80000,
  0x00000000,
};
/* art_heli_lb: 28x12 */
static const uint art_heli_lb[12] = {
  0x02000000,
  0x1fc00000,
  0x02000000,
  0x1fe00c00,
  0x3ff01c00,
  0x7ffff980,
  0xdfffffc0,
  0x7ff80c80,
  0x3ff00000,
  0x08400000,
  0x3ff80000,
  0x00000000,
};
/* art_heli_ra: 28x12 */
static const uint art_heli_ra[12] = {
  0x00000400,
  0x0003fff0,
  0x00000400,
  0x03007f80,
  0x0380ffc0,
  0x19ffffe0,
  0x3fffffb0,
  0x1301ffe0,
  0x0000ffc0,
  0x00002100,
  0x0001ffc0,
  0x00000000,
};
/* art_heli_rb: 28x12 */
static const uint art_heli_rb[12] = {
  0x00000400,
  0x00003f80,
  0x00000400,
  0x03007f80,
  0x0380ffc0,
  0x19ffffe0,
  0x3fffffb0,
  0x1301ffe0,
  0x0000ffc0,
  0x00002100,
  0x0001ffc0,
  0x00000000,
};
/* art_para: 20x20 */
static const uint art_para[20] = {
  0x03fc0000,
  0x0fff0000,
  0x1fff8000,
  0x3fffc000,
  0x33334000,
  0x11228000,
  0x10a48000,
  0x08a50000,
  0x08f60000,
  0x04f40000,
  0x06f60000,
  0x03fc0000,
  0x01f80000,
  0x01f80000,
  0x01f80000,
  0x00f00000,
  0x01980000,
  0x01980000,
  0x030c0000,
  0x00000000,
};
/* art_fall: 10x10 */
static const uint art_fall[10] = {
  0x0c000000,
  0x0c000000,
  0x9e400000,
  0xffc00000,
  0x3f000000,
  0x3f000000,
  0x33000000,
  0x61800000,
  0xc0c00000,
  0x00000000,
};
/* art_stand: 10x12 */
static const uint art_stand[12] = {
  0x8c400000,
  0x9e400000,
  0xdec00000,
  0x7f800000,
  0x3f000000,
  0x3f000000,
  0x3f000000,
  0x3f000000,
  0x1e000000,
  0x33000000,
  0x33000000,
  0x61800000,
};
/* art_gun: 26x12 */
static const uint art_gun[12] = {
  0x007f8000,
  0x01ffe000,
  0x07fff800,
  0x0ffffc00,
  0x1ffffe00,
  0x3fffff00,
  0x3fffff00,
  0x7fffff80,
  0x7fffff80,
  0xffffffc0,
  0xffffffc0,
  0x6db6db00,
};

#define C_SKY RGB(164, 184, 172)
#define C_INK RGB(24, 28, 26)
#define C_GROUND RGB(60, 64, 54)
#define C_DEAD RGB(150, 36, 26)
#define C_TEXT C_INK
#define C_OVER RGB(180, 26, 16)
#define C_MOFF RGB(120, 136, 126)

#define GROUND_Y 226
#define TUR_X 120
#define GUN_Y 214 /* gun cell top; the dome's base sits on the ground */

#define NB 3  /* bullets */
#define NH 2  /* helicopters */
#define NT 6  /* paratroopers */
#define NG 4  /* grenades */
#define ND 12 /* debris rects */

/* thirteen aim steps, -78..+78 degrees off vertical in 13-degree
 * notches — sin/cos baked at build time, no trig, no division.
 * avx/avy: bullet velocity in 16ths of a pixel per frame (a constant
 * 3.75 px/frame at every angle); mdx/mdy: the muzzle tip, 15 px from
 * the pivot along the SAME angle, so the drawn barrel and the flying
 * bullet can never disagree. */
#define NA 13
static const signed char avx[NA] = {-59, -54, -47, -38, -26, -13, 0,
                                    13,  26,  38,  47,  54,  59};
static const signed char avy[NA] = {-12, -25, -37, -47, -54, -58, -60,
                                    -58, -54, -47, -37, -25, -12};
static const signed char mdx[NA] = {-15, -14, -12, -9, -7, -3, 0,
                                    3,   7,   9,   12, 14, 15};
static const signed char mdy[NA] = {3,  6,  9,  12, 13, 15, 15,
                                    15, 13, 12, 9,  6,  3};

/* trooper states */
#define T_FREE 0
#define T_FALL 1  /* freefall: 0.5 s before the canopy opens */
#define T_CHUTE 2 /* drifting down */
#define T_SHOT 3  /* chute hit: falling to a thud */
#define T_LAND 4  /* on the ground; four of these throw grenades */

struct cst {
  int aim, score, landed, over, hold, drawn_score;
  int gunon, gunfx; /* gun alive; destruction countdown to the over screen */
  /* bullets and debris move in 16ths of a pixel EVERY frame (slow
   * speeds stay smooth at 30 fps), but positions stay whole pixels:
   * each velocity feeds through a fractional accumulator (subpx())
   * because px = v >> 4 would be a ~30-iteration runtime call per
   * read on this machine — rt_lshr once ate 75% of a frame. */
  int bx[NB], by[NB], bvx[NB], bvy[NB]; /* bx == -999: free */
  int bfx[NB], bfy[NB];                 /* subpixel accumulators */
  int hx[NH], hy[NH], hvx[NH], hdrop[NH]; /* hdrop: drop x; -1 done */
  int tx[NT], ty[NT], tst[NT], ttm[NT]; /* ttm: freefall / grenade timer */
  int gx[NG], gy[NG], gvx[NG], gvy[NG]; /* gx == -999: free */
  int dx_[ND], dy_[ND], dvx[ND], dvy[ND]; /* debris; dx_ == -999: free */
  int dfx[ND], dfy[ND]; /* subpixel accumulators */
  int dtl[ND];          /* frames to live; 0 = until the ground */
  int dht[ND];          /* 1 = lethal to troopers (heli wreckage) */
  uint spawn, frame;
};
#define CS_ ((struct cst *)g_arena)

/* arena cells (rendered at entry) and their run tables */
#define cell_heli(i) ((ushort *)(g_arena + 768 + (uint)(i) * 672))
#define cell_para ((ushort *)(g_arena + 3456)) /* 20x20 */
#define cell_fall ((ushort *)(g_arena + 4256)) /* 10x10 */
#define cell_shot ((ushort *)(g_arena + 4456)) /* 10x10, red */
#define cell_stand ((ushort *)(g_arena + 4656)) /* 10x12 */
#define cell_gun ((ushort *)(g_arena + 4896))  /* 26x12 */
#define rt_heli(i) (g_arena + 5520 + (uint)(i) * 160)
#define rt_para (g_arena + 6160) /* cap 224 */
#define rt_fall (g_arena + 6384)
#define rt_shot (g_arena + 6448)
#define rt_stand (g_arena + 6512)
#define rt_gun (g_arena + 6576) /* ends 6672 */

/* render 1bpp art into a cell (sky background inside the box) */
static void
art_cell(const uint *rows, int w, int h, ushort fg, ushort *dst)
{
  for (int i = 0; i < w * h; i++)
    dst[i] = C_SKY;
  for (int r = 0; r < h; r++) {
    uint bits = rows[r];
    uint mask = 1u << (32 - w);
    ushort *p = dst + r * w;
    for (int c = w - 1; c >= 0; c--, mask <<= 1)
      if (bits & mask)
        p[c] = fg;
  }
}

static void
sky(int x, int y, int w, int h)
{
  if (y + h > GROUND_Y)
    h = GROUND_Y - y;
  if (h > 0)
    gfx_fill(x, y, w, h, C_SKY);
}

/* gun: dome cell + a barrel drawn as a REAL line along the aim */
static void
turret_erase(void)
{
  /* the whole reachable barrel fan: muzzle +-15 px, 3 px thick */
  gfx_fill(TUR_X - 17, GUN_Y - 19, 34, 18, C_SKY);
  gfx_damage(TUR_X - 17, GUN_Y - 19, TUR_X + 16, GUN_Y - 2);
}

/* line3: Bresenham with a 3x3 pen — pure adds and compares, the
 * machine's kind of line. At most 16 steps for the barrel. */
static void
line3(int x0, int y0, int x1, int y1)
{
  int dx = x1 > x0 ? x1 - x0 : x0 - x1;
  int dy = y1 > y0 ? y1 - y0 : y0 - y1;
  int sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1;
  int err = dx - dy;
  for (;;) {
    gfx_fill(x0 - 1, y0 - 1, 3, 3, C_INK);
    if (x0 == x1 && y0 == y1)
      break;
    int e2 = err + err;
    if (e2 > -dy) {
      err -= dy;
      x0 += sx;
    }
    if (e2 < dx) {
      err += dx;
      y0 += sy;
    }
  }
}

static void
draw_gun(void)
{
  gfx_blit_runs(TUR_X - 14, GUN_Y, cell_gun, 26, 12, rt_gun);
  int a = CS_->aim;
  line3(TUR_X, GUN_Y - 2, TUR_X + (int)mdx[a], GUN_Y - 2 - (int)mdy[a]);
  gfx_damage(TUR_X - 17, GUN_Y - 19, TUR_X + 16, GUN_Y + 11);
}

static void
draw_score(void)
{
  char b[6];
  numstr(b, 5, (uint)CS_->score);
  gfx_text(4, 4, b, C_TEXT, C_SKY);
  for (int i = 0; i < 4; i++) /* the four-invader doom meter */
    gfx_fill(220 - i * 10, 6, 6, 6, i < CS_->landed ? C_OVER : C_MOFF);
  gfx_damage(180, 4, 233, 13);
  CS_->drawn_score = CS_->score;
}

static void
troop_erase(int i)
{
  sky(CS_->tx[i] - 10, CS_->ty[i] - 12, 20, 24);
}

static void
troop_draw(int i)
{
  int x = CS_->tx[i], y = CS_->ty[i], st = CS_->tst[i];
  if (st == T_CHUTE)
    gfx_blit_runs(x - 10, y - 10, cell_para, 20, 20, rt_para);
  else if (st == T_FALL)
    gfx_blit_runs(x - 4, y, cell_fall, 10, 10, rt_fall);
  else if (st == T_SHOT)
    gfx_blit_runs(x - 4, y, cell_shot, 10, 10, rt_shot);
  else /* T_LAND */
    gfx_blit_runs(x - 4, GROUND_Y - 12, cell_stand, 10, 12, rt_stand);
}

static void
heli_draw(int i, int erase)
{
  int x = CS_->hx[i], y = CS_->hy[i];
  if (erase) {
    sky(x - 14, y, 28, 12);
    return;
  }
  int cell = (CS_->hvx[i] > 0 ? 2 : 0) + ((CS_->frame & 4) ? 1 : 0);
  gfx_blit_runs(x - 14, y, cell_heli(cell), 28, 12, rt_heli(cell));
}

static void
bullet_draw(int i)
{
  int x = CS_->bx[i], y = CS_->by[i]; /* a round-ish ball */
  gfx_fill(x - 2, y - 1, 4, 2, C_INK);
  gfx_fill(x - 1, y - 2, 2, 4, C_INK);
  gfx_damage(x - 2, y - 2, x + 2, y + 2);
}

static int
tfree(void)
{
  for (int i = 0; i < NT; i++)
    if (CS_->tst[i] == T_FREE)
      return i;
  return -1;
}

/* advance *p (whole pixels) by v 16ths of a pixel, carrying through
 * the fractional accumulator *f — pure adds, because any >> here
 * would be the ~30-iteration rt_lshr loop, per frame, per mover.
 * |v| < 80, so the carry loops run at most a handful of times. */
static void
subpx(int *p, int *f, int v)
{
  int a = *f + v;
  while (a >= 16) {
    a -= 16;
    (*p)++;
  }
  while (a < 0) {
    a += 16;
    (*p)--;
  }
  *f = a;
}

/* spawn one debris rect (silently drops when the pool is full).
 * x/y in pixels; vx/vy in 16ths of a pixel per frame; ttl in frames
 * (0 = lives until the ground); hurt = lethal to troopers. */
static void
debris_spawn(int x, int y, int vx, int vy, int ttl, int hurt)
{
  for (int i = 0; i < ND; i++)
    if (CS_->dx_[i] == -999) {
      CS_->dx_[i] = x;
      CS_->dy_[i] = y;
      CS_->dvx[i] = vx;
      CS_->dvy[i] = vy;
      CS_->dfx[i] = 0;
      CS_->dfy[i] = 0;
      CS_->dtl[i] = ttl;
      CS_->dht[i] = hurt;
      return;
    }
}

/* a helicopter dies: burst into four tumbling rects */
static void
heli_kill(int i)
{
  int x = CS_->hx[i], y = CS_->hy[i];
  heli_draw(i, 1);
  CS_->hx[i] = -999;
  /* wreckage rains DOWN, gently, lethal, and burns out in 1 s */
  debris_spawn(x - 8, y + 2, -12, 4, 30, 1);
  debris_spawn(x - 2, y + 4, -5, 9, 30, 1);
  debris_spawn(x + 2, y + 2, 5, 7, 30, 1);
  debris_spawn(x + 8, y + 4, 12, 2, 30, 1);
  CS_->score += 20;
  snd_play(220, 70, 5);
  led_blink(LED_BRIGHT(0xFF6000), 2);
}

/* the gun dies: erase it, scatter its remains away from the spot */
static void
gun_destroy(void)
{
  if (!CS_->gunon)
    return;
  CS_->gunon = 0;
  CS_->gunfx = 45; /* the remains tumble, then the over screen */
  turret_erase();
  sky(TUR_X - 14, GUN_Y, 28, 12);
  /* the gun's own remains: energetic arcs, harmless to troopers */
  debris_spawn(TUR_X - 10, GUN_Y + 2, -64, -96, 0, 0);
  debris_spawn(TUR_X - 4, GUN_Y, -32, -128, 0, 0);
  debris_spawn(TUR_X + 2, GUN_Y, 32, -112, 0, 0);
  debris_spawn(TUR_X + 8, GUN_Y + 2, 64, -80, 0, 0);
  debris_spawn(TUR_X, GUN_Y + 4, 96, -64, 0, 0);
  uputs("chute: gun destroyed\n");
  snd_noise(70, 30); /* the low crunch, fading over the second */
  led_blink(LED_BRIGHT(0xFF2020), 6);
}

/* a trooper dies to debris: vanish, and free the meter if landed */
static void
troop_kill(int i)
{
  if (CS_->tst[i] == T_LAND) {
    sky(CS_->tx[i] - 10, GROUND_Y - 12, 20, 12);
    CS_->landed--;
    draw_score();
  } else
    troop_erase(i);
  CS_->tst[i] = T_FREE;
}

void
chute_run(void)
{
  uputs("chute: start\n");
  led(LED_DIM(0x4060FF), LED_DIM(0x4060FF));
  art_cell(art_heli_la, 28, 12, C_INK, cell_heli(0));
  art_cell(art_heli_lb, 28, 12, C_INK, cell_heli(1));
  art_cell(art_heli_ra, 28, 12, C_INK, cell_heli(2));
  art_cell(art_heli_rb, 28, 12, C_INK, cell_heli(3));
  art_cell(art_para, 20, 20, C_INK, cell_para);
  art_cell(art_fall, 10, 10, C_INK, cell_fall);
  art_cell(art_fall, 10, 10, C_DEAD, cell_shot);
  art_cell(art_stand, 10, 12, C_INK, cell_stand);
  art_cell(art_gun, 26, 12, C_INK, cell_gun);
  int rterr = 0;
  for (int i = 0; i < 4; i++)
    rterr |= gfx_cell_runs(cell_heli(i), 28, 12, C_SKY, rt_heli(i), 160) < 0;
  rterr |= gfx_cell_runs(cell_para, 20, 20, C_SKY, rt_para, 224) < 0;
  rterr |= gfx_cell_runs(cell_fall, 10, 10, C_SKY, rt_fall, 64) < 0;
  rterr |= gfx_cell_runs(cell_shot, 10, 10, C_SKY, rt_shot, 64) < 0;
  rterr |= gfx_cell_runs(cell_stand, 10, 12, C_SKY, rt_stand, 64) < 0;
  rterr |= gfx_cell_runs(cell_gun, 26, 12, C_SKY, rt_gun, 96) < 0;
  if (rterr)
    uputs("chute: run table overflow\n");
restart: /* no recursion on this machine: dmacc frames are static */
  gfx_clear(C_SKY);
  gfx_fill(0, GROUND_Y, LCD_W, LCD_H - GROUND_Y, C_GROUND);
  for (int i = 0; i < NB; i++)
    CS_->bx[i] = -999;
  for (int i = 0; i < NH; i++)
    CS_->hx[i] = -999;
  for (int i = 0; i < NT; i++)
    CS_->tst[i] = T_FREE;
  for (int i = 0; i < NG; i++)
    CS_->gx[i] = -999;
  for (int i = 0; i < ND; i++)
    CS_->dx_[i] = -999;
  CS_->aim = NA / 2; /* straight up */
  CS_->score = 0;
  CS_->landed = 0;
  CS_->over = 0;
  CS_->hold = 0;
  CS_->gunon = 1;
  CS_->gunfx = 0;
  CS_->spawn = 1;
  CS_->frame = 0;
  draw_gun();
  draw_score();
  gfx_text(60, 110, "shoot the chutes!", C_TEXT, C_SKY);
  gfx_present();
  for (;;) {
    frame_sync(33000);
    in_poll();
    CS_->frame++;
    if (CS_->frame == 60)
      gfx_fill(60, 110, 136, 8, C_SKY); /* the hint fades */
    if (in_down & BTN_A)
      CS_->hold++;
    else
      CS_->hold = 0;
    if (CS_->hold > 45) {
      uputs("chute: quit\n");
      snd_off();
      return;
    }
    if (CS_->over) { /* frozen field; press restarts, down leaves */
      if (in_edge & BTN_A) {
        uputs("chute: again\n");
        goto restart;
      }
      if (in_edge & BTN_DOWN) {
        uputs("chute: quit\n");
        snd_off();
        led(0, 0);
        return;
      }
      continue;
    }

    /* --- TWO-PHASE FRAME: erase every mover at its old spot, run
     * the whole update (moves, spawns, hits — a victim freed here
     * simply isn't drawn), then draw back-to-front. */

    /* phase 1: erase */
    int hudtouch = 0; /* a bullet crossed the score strip: repaint it */
    for (int i = 0; i < NB; i++)
      if (CS_->bx[i] != -999) {
        if (CS_->by[i] < 20)
          hudtouch = 1;
        sky(CS_->bx[i] - 3, CS_->by[i] - 3, 6, 6);
      }
    for (int i = 0; i < NH; i++)
      if (CS_->hx[i] != -999)
        heli_draw(i, 1);
    for (int i = 0; i < NT; i++)
      if (CS_->tst[i] != T_FREE && CS_->tst[i] != T_LAND)
        troop_erase(i);
    for (int i = 0; i < NG; i++)
      if (CS_->gx[i] != -999)
        sky(CS_->gx[i] - 2, CS_->gy[i] - 2, 6, 6);
    for (int i = 0; i < ND; i++)
      if (CS_->dx_[i] != -999)
        sky(CS_->dx_[i] - 1, CS_->dy_[i] - 1, 6, 5);

    /* phase 2: update — aim and fire (while the gun stands) */
    if (CS_->gunon) {
      if ((in_edge & BTN_LEFT) && CS_->aim > 0) {
        CS_->aim--;
        turret_erase();
      }
      if ((in_edge & BTN_RIGHT) && CS_->aim < NA - 1) {
        CS_->aim++;
        turret_erase();
      }
      if (in_edge & (BTN_A | BTN_UP)) {
        for (int i = 0; i < NB; i++)
          if (CS_->bx[i] == -999) {
            /* born at the muzzle tip, flying the muzzle's angle */
            CS_->bx[i] = TUR_X + (int)mdx[CS_->aim];
            CS_->by[i] = GUN_Y - 2 - (int)mdy[CS_->aim];
            CS_->bvx[i] = (int)avx[CS_->aim];
            CS_->bvy[i] = (int)avy[CS_->aim];
            CS_->bfx[i] = 0;
            CS_->bfy[i] = 0;
            snd_sweep(260, 45, 5, 25); /* short low pew, easing down */
            break;
          }
      }
    }
    /* bullets march */
    for (int i = 0; i < NB; i++) {
      if (CS_->bx[i] == -999)
        continue;
      subpx(&CS_->bx[i], &CS_->bfx[i], CS_->bvx[i]);
      subpx(&CS_->by[i], &CS_->bfy[i], CS_->bvy[i]);
      if (CS_->by[i] < 2 || CS_->bx[i] < 3 || CS_->bx[i] > 236)
        CS_->bx[i] = -999;
    }
    /* helicopters: spawn, fly, drop */
    if (--CS_->spawn == 0) {
      CS_->spawn = 90 + rng_below(90) - (uint)(CS_->score / 20 > 50 ? 50 : CS_->score / 20);
      for (int i = 0; i < NH; i++)
        if (CS_->hx[i] == -999) {
          int fromleft = (int)(rng() & 1);
          CS_->hx[i] = fromleft ? -14 : 254;
          CS_->hvx[i] = fromleft ? 2 : -2;
          CS_->hy[i] = 18 + (int)rng_below(2) * 16;
          /* pick the drop X uniformly across the field — the old
           * countdown timer bunched landings near the entry side */
          CS_->hdrop[i] = 34 + (int)rng_below(172);
          break;
        }
    }
    for (int i = 0; i < NH; i++) {
      if (CS_->hx[i] == -999)
        continue;
      CS_->hx[i] += CS_->hvx[i];
      if (CS_->hx[i] < -15 || CS_->hx[i] > 255) {
        CS_->hx[i] = -999;
        continue;
      }
      if (CS_->hdrop[i] >= 0 &&
          ((CS_->hvx[i] > 0 && CS_->hx[i] >= CS_->hdrop[i]) ||
           (CS_->hvx[i] < 0 && CS_->hx[i] <= CS_->hdrop[i]))) {
        CS_->hdrop[i] = -1;
        int t = tfree();
        if (t >= 0) {
          CS_->tst[t] = T_FALL;
          CS_->ttm[t] = 15; /* 0.5 s of freefall at 30 fps */
          CS_->tx[t] = CS_->hx[i] & ~1;
          CS_->ty[t] = CS_->hy[i] + 12;
        }
      }
    }
    /* paratroopers descend */
    for (int i = 0; i < NT; i++) {
      int st = CS_->tst[i];
      if (st == T_FREE)
        continue;
      if (st == T_LAND) { /* four besiegers lob grenades at the gun */
        if (CS_->landed >= 4 && CS_->gunon && --CS_->ttm[i] <= 0) {
          CS_->ttm[i] = 70 + (int)rng_below(50);
          for (int g = 0; g < NG; g++)
            if (CS_->gx[g] == -999) {
              CS_->gx[g] = CS_->tx[i];
              CS_->gy[g] = GROUND_Y - 14;
              CS_->gvx[g] = (TUR_X - CS_->tx[i]) / 22;
              if (CS_->gvx[g] == 0)
                CS_->gvx[g] = CS_->tx[i] < TUR_X ? 1 : -1;
              CS_->gvy[g] = -6;
              snd_sweep(700, 35, 5, 60); /* the gun's pew, pitched up */
              break;
            }
        }
        continue;
      }
      if (st == T_FALL) {
        CS_->ty[i] += 2;
        if (--CS_->ttm[i] <= 0)
          CS_->tst[i] = T_CHUTE; /* the canopy opens */
      } else if (st == T_CHUTE) {
        CS_->ty[i] += 1;
        if ((CS_->frame & 7) == 0) /* gentle wind, even steps */
          CS_->tx[i] += ((CS_->frame & 8) ? 2 : -2);
      } else {
        CS_->ty[i] += 5;
      }
      /* landing on the GUN destroys it instantly */
      if (CS_->gunon && CS_->ty[i] + 10 >= GUN_Y + 4 &&
          CS_->tx[i] > TUR_X - 16 && CS_->tx[i] < TUR_X + 16) {
        troop_erase(i);
        CS_->tst[i] = T_FREE;
        gun_destroy();
        continue;
      }
      if (CS_->ty[i] + 10 >= GROUND_Y) { /* touchdown */
        CS_->ty[i] = GROUND_Y - 10;
        if (st == T_SHOT) { /* a thud, no invader */
          CS_->tst[i] = T_FREE;
          CS_->score += 2;
          snd_play(90, 60, 3);
          continue;
        }
        CS_->tst[i] = T_LAND;
        CS_->ttm[i] = 40 + (int)rng_below(40);
        CS_->landed++;
        snd_play(150, 50, 4);
        draw_score();
        continue;
      }
    }
    /* grenades arc toward the gun */
    for (int i = 0; i < NG; i++) {
      if (CS_->gx[i] == -999)
        continue;
      CS_->gx[i] += CS_->gvx[i];
      CS_->gy[i] += CS_->gvy[i];
      if (CS_->frame & 1)
        CS_->gvy[i]++;
      if (CS_->gunon && CS_->gy[i] >= GUN_Y - 2 &&
          CS_->gx[i] > TUR_X - 15 && CS_->gx[i] < TUR_X + 15) {
        CS_->gx[i] = -999;
        gun_destroy();
        continue;
      }
      if (CS_->gy[i] >= GROUND_Y - 2 || CS_->gx[i] < 3 || CS_->gx[i] > 236)
        CS_->gx[i] = -999;
    }
    /* debris tumbles — subpixel, every frame (slow but SMOOTH; the
     * old half-rate stepping read as 15 fps), with a lazy terminal
     * velocity so heli wreckage rains instead of plummeting — and
     * destroys whatever it touches */
    for (int i = 0; i < ND; i++) {
      if (CS_->dx_[i] == -999)
        continue;
      subpx(&CS_->dx_[i], &CS_->dfx[i], CS_->dvx[i]);
      subpx(&CS_->dy_[i], &CS_->dfy[i], CS_->dvy[i]);
      CS_->dvy[i] += 8; /* gravity, 0.5 px/frame^2 */
      if (CS_->dvy[i] > 32)
        CS_->dvy[i] = 32; /* terminal: 2 px/frame */
      if (CS_->dtl[i] && --CS_->dtl[i] == 0) {
        CS_->dx_[i] = -999; /* wreckage burns out mid-air */
        continue;
      }
      int px = CS_->dx_[i], py = CS_->dy_[i];
      if (py >= GROUND_Y - 2 || py < 4 || px < 2 || px > 236) {
        CS_->dx_[i] = -999;
        continue;
      }
      for (int h = 0; h < NH; h++)
        if (CS_->hx[h] != -999 && px > CS_->hx[h] - 14 &&
            px < CS_->hx[h] + 14 && py > CS_->hy[h] - 2 &&
            py < CS_->hy[h] + 12) {
          heli_kill(h); /* chains: the wreck bursts too */
          CS_->dx_[i] = -999;
          break;
        }
      if (CS_->dx_[i] == -999 || !CS_->dht[i])
        continue; /* the gun's own remains never hurt troopers */
      for (int t = 0; t < NT; t++) {
        int st = CS_->tst[t];
        if (st == T_FREE)
          continue;
        int ty = st == T_LAND ? GROUND_Y - 8 : CS_->ty[t];
        if (px > CS_->tx[t] - 10 && px < CS_->tx[t] + 10 &&
            py > ty - 12 && py < ty + 10) {
          troop_kill(t);
          CS_->dx_[i] = -999;
          snd_play(300, 40, 2);
          break;
        }
      }
    }
    /* bullets hit troopers, then helicopters */
    for (int b = 0; b < NB; b++) {
      if (CS_->bx[b] == -999)
        continue;
      int bx = CS_->bx[b], by = CS_->by[b];
      for (int i = 0; i < NT; i++) {
        int st = CS_->tst[i];
        if (st != T_CHUTE && st != T_FALL)
          continue;
        int dxx = bx - CS_->tx[i], dyy = by - CS_->ty[i];
        if (dxx > -11 && dxx < 11 && dyy > -12 && dyy < 12) {
          if (st == T_CHUTE && dyy < 0) { /* chute hit: he drops */
            troop_erase(i);
            CS_->tst[i] = T_SHOT;
            CS_->score += 5;
          } else { /* body hit */
            troop_erase(i);
            CS_->tst[i] = T_FREE;
            CS_->score += 10;
          }
          CS_->bx[b] = -999;
          snd_play(500, 50, 2);
          led_blink(LED_BRIGHT(0xFFA000), 1);
          break;
        }
      }
      if (CS_->bx[b] == -999)
        continue;
      for (int i = 0; i < NH; i++) {
        if (CS_->hx[i] == -999)
          continue;
        int dxx = bx - CS_->hx[i], dyy = by - CS_->hy[i];
        if (dxx > -14 && dxx < 14 && dyy > -2 && dyy < 12) {
          heli_kill(i);
          CS_->bx[b] = -999;
          break;
        }
      }
    }
    /* the gun's last stand played out: raise the over screen */
    if (!CS_->gunon && CS_->gunfx > 0 && --CS_->gunfx == 0) {
      CS_->over = 1;
      uputs("chute: game over\n");
    }

    /* phase 3: draw, back to front */
    for (int i = 0; i < NT; i++)
      if (CS_->tst[i] != T_FREE)
        troop_draw(i);
    for (int i = 0; i < NH; i++)
      if (CS_->hx[i] != -999)
        heli_draw(i, 0);
    for (int i = 0; i < NG; i++)
      if (CS_->gx[i] != -999)
        gfx_fill(CS_->gx[i] - 1, CS_->gy[i] - 1, 3, 3, C_INK);
    if (CS_->gunon)
      draw_gun();
    for (int i = 0; i < ND; i++)
      if (CS_->dx_[i] != -999)
        gfx_fill(CS_->dx_[i], CS_->dy_[i], 4, 3, C_INK);
    for (int i = 0; i < NB; i++)
      if (CS_->bx[i] != -999)
        bullet_draw(i);
    for (int i = 0; i < NG; i++)
      if (CS_->gx[i] != -999)
        gfx_damage(CS_->gx[i] - 2, CS_->gy[i] - 2, CS_->gx[i] + 3,
                   CS_->gy[i] + 3);
    for (int i = 0; i < ND; i++)
      if (CS_->dx_[i] != -999)
        gfx_damage(CS_->dx_[i] - 1, CS_->dy_[i] - 1, CS_->dx_[i] + 5,
                   CS_->dy_[i] + 4);
    /* repaint the HUD only when something changed or crossed it —
     * the every-frame repaint forced a HUD-to-ground damage rect,
     * ~27 ms of SPI per frame, the whole budget on the wire */
    if (hudtouch || CS_->score != CS_->drawn_score)
      draw_score();
    if (CS_->over) {
      /* raised THIS frame (later frames skip the phases): painted
       * after every sprite, so a drifting chute can't cover it */
      gfx_text2(40, 104, "Destroyed!", C_OVER, C_SKY);
      gfx_text(48, 128, "Press to try again", C_TEXT, C_SKY);
      gfx_text(48, 140, "Down: back to menu", C_TEXT, C_SKY);
    }
    gfx_present();
  }
}
