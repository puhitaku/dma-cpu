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

/* nine aim steps: bullet velocity per step, no trig */
static const signed char adx[9] = {-6, -5, -4, -2, 0, 2, 4, 5, 6};
static const signed char ady[9] = {-4, -5, -6, -7, -7, -7, -6, -5, -4};

/* trooper states */
#define T_FREE 0
#define T_FALL 1  /* freefall: 0.5 s before the canopy opens */
#define T_CHUTE 2 /* drifting down */
#define T_SHOT 3  /* chute hit: falling to a thud */
#define T_LAND 4  /* on the ground; four of these throw grenades */

struct cst {
  int aim, score, landed, over, hold, drawn_score;
  int gunon, gunfx; /* gun alive; destruction countdown to the over screen */
  int bx[NB], by[NB], bvx[NB], bvy[NB]; /* bx == -999: free */
  int hx[NH], hy[NH], hvx[NH], hdrop[NH];
  int tx[NT], ty[NT], tst[NT], ttm[NT]; /* ttm: freefall / grenade timer */
  int gx[NG], gy[NG], gvx[NG], gvy[NG]; /* gx == -999: free */
  int dx_[ND], dy_[ND], dvx[ND], dvy[ND]; /* debris; dx_ == -999: free */
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

/* gun: dome cell + a stub barrel of three fills along the aim */
static void
turret_erase(void)
{
  gfx_fill(TUR_X - 14, GUN_Y - 14, 28, 14, C_SKY);
  gfx_damage(TUR_X - 14, GUN_Y - 14, TUR_X + 13, GUN_Y - 1);
}

static void
draw_gun(void)
{
  gfx_blit_runs(TUR_X - 14, GUN_Y, cell_gun, 26, 12, rt_gun);
  int a = CS_->aim;
  for (int i = 1; i <= 3; i++)
    gfx_fill(TUR_X - 2 + (int)adx[a] * i / 3, GUN_Y - 2 - 3 * i, 4, 4,
             C_INK);
  gfx_damage(TUR_X - 14, GUN_Y - 14, TUR_X + 13, GUN_Y + 11);
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

/* spawn one debris rect (silently drops when the pool is full) */
static void
debris_spawn(int x, int y, int vx, int vy)
{
  for (int i = 0; i < ND; i++)
    if (CS_->dx_[i] == -999) {
      CS_->dx_[i] = x;
      CS_->dy_[i] = y;
      CS_->dvx[i] = vx;
      CS_->dvy[i] = vy;
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
  debris_spawn(x - 8, y + 2, -2, -1); /* wreckage rains DOWN */
  debris_spawn(x - 2, y + 4, -1, -2);
  debris_spawn(x + 2, y + 2, 1, -1);
  debris_spawn(x + 8, y + 4, 2, 0);
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
  debris_spawn(TUR_X - 10, GUN_Y + 2, -4, -6);
  debris_spawn(TUR_X - 4, GUN_Y, -2, -8);
  debris_spawn(TUR_X + 2, GUN_Y, 2, -7);
  debris_spawn(TUR_X + 8, GUN_Y + 2, 4, -5);
  debris_spawn(TUR_X, GUN_Y + 4, 6, -4);
  uputs("chute: gun destroyed\n");
  snd_play(90, 80, 20);
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
  CS_->aim = 4;
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
    if (CS_->over) { /* frozen field; press restarts the sortie */
      if (in_edge & BTN_A) {
        uputs("chute: again\n");
        goto restart;
      }
      continue;
    }

    /* --- TWO-PHASE FRAME: erase every mover at its old spot, run
     * the whole update (moves, spawns, hits — a victim freed here
     * simply isn't drawn), then draw back-to-front. */

    /* phase 1: erase */
    for (int i = 0; i < NB; i++)
      if (CS_->bx[i] != -999)
        sky(CS_->bx[i] - 3, CS_->by[i] - 3, 6, 6);
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
      if ((in_edge & BTN_RIGHT) && CS_->aim < 8) {
        CS_->aim++;
        turret_erase();
      }
      if (in_edge & (BTN_A | BTN_UP)) {
        for (int i = 0; i < NB; i++)
          if (CS_->bx[i] == -999) {
            CS_->bx[i] = TUR_X + (int)adx[CS_->aim];
            CS_->by[i] = GUN_Y - 14;
            CS_->bvx[i] = adx[CS_->aim];
            CS_->bvy[i] = ady[CS_->aim];
            snd_play(900, 40, 2);
            break;
          }
      }
    }
    /* bullets march */
    for (int i = 0; i < NB; i++) {
      if (CS_->bx[i] == -999)
        continue;
      CS_->bx[i] += CS_->bvx[i];
      CS_->by[i] += CS_->bvy[i];
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
          CS_->hdrop[i] = 20 + (int)rng_below(60);
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
      if (--CS_->hdrop[i] == 0 && CS_->hx[i] > 30 && CS_->hx[i] < 210) {
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
              snd_play(400, 35, 2);
              break;
            }
        }
        continue;
      }
      if (st == T_FALL) {
        CS_->ty[i] += 4;
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
    /* debris tumbles (half speed: it reads better slow), and
     * destroys whatever it touches */
    for (int i = 0; i < ND; i++) {
      if (CS_->dx_[i] == -999)
        continue;
      if (CS_->frame & 1) {
        CS_->dx_[i] += CS_->dvx[i];
        CS_->dy_[i] += CS_->dvy[i];
        if ((CS_->frame & 3) == 1)
          CS_->dvy[i]++;
      }
      if (CS_->dy_[i] >= GROUND_Y - 2 || CS_->dy_[i] < 16 ||
          CS_->dx_[i] < 2 || CS_->dx_[i] > 236) {
        CS_->dx_[i] = -999; /* y < 16 also keeps it out of the HUD */
        continue;
      }
      for (int h = 0; h < NH; h++)
        if (CS_->hx[h] != -999 && CS_->dx_[i] > CS_->hx[h] - 14 &&
            CS_->dx_[i] < CS_->hx[h] + 14 && CS_->dy_[i] > CS_->hy[h] - 2 &&
            CS_->dy_[i] < CS_->hy[h] + 12) {
          heli_kill(h); /* chains: the wreck bursts too */
          CS_->dx_[i] = -999;
          break;
        }
      if (CS_->dx_[i] == -999)
        continue;
      for (int t = 0; t < NT; t++) {
        int st = CS_->tst[t];
        if (st == T_FREE)
          continue;
        int ty = st == T_LAND ? GROUND_Y - 8 : CS_->ty[t];
        if (CS_->dx_[i] > CS_->tx[t] - 10 && CS_->dx_[i] < CS_->tx[t] + 10 &&
            CS_->dy_[i] > ty - 12 && CS_->dy_[i] < ty + 10) {
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
      gfx_text2(40, 104, "Destroyed!", C_OVER, C_SKY);
      gfx_text(48, 128, "Press to try again", C_TEXT, C_SKY);
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
    draw_score(); /* every frame: debris and bullets cross the HUD
                   * strip, and their erases were eating the meter */
    gfx_present();
  }
}
