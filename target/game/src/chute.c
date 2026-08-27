/* chute.c: Parachute — the click-wheel classic. Helicopters cross
 * the night sky dropping paratroopers; the turret at the bottom
 * center swings between five aim steps and fires. Shoot the chute
 * and the trooper drops; let four land and they storm the gun.
 * Everything is fill-erase sprites (a dozen objects, a few fills
 * each — the machine decides ~100 things a frame, DMA moves the
 * pixels), plus one arena-rendered chute cap cell. */
#include "g.h"

#define C_SKY RGB(10, 14, 40)
#define C_GROUND RGB(70, 60, 50)
#define C_TURRET RGB(160, 160, 170)
#define C_BARREL RGB(220, 220, 230)
#define C_HELI RGB(120, 130, 145)
#define C_ROTOR RGB(200, 200, 210)
#define C_TROOP RGB(230, 200, 150)
#define C_CHUTE RGB(240, 240, 245)
#define C_SHOT RGB(255, 220, 80)
#define C_TEXT RGB(180, 190, 210)
#define C_OVER RGB(230, 60, 60)

#define GROUND_Y 226
#define TUR_X 120 /* turret muzzle pivot */
#define TUR_Y 214

#define NB 3 /* bullets */
#define NH 2 /* helicopters */
#define NT 6 /* paratroopers */

/* aim steps: barrel direction and bullet velocity, no trig */
static const signed char adx[5] = {-5, -3, 0, 3, 5};
static const signed char ady[5] = {-4, -6, -7, -6, -4};

/* trooper states */
#define T_FREE 0
#define T_FALL 1  /* dropped, chute not yet open */
#define T_CHUTE 2 /* drifting down */
#define T_SHOT 3  /* chute hit: falling to a thud */
#define T_LAND 4  /* on the ground, one of the four */

struct cst {
  int aim, score, landed, over, hold, drawn_score;
  int bx[NB], by[NB], bvx[NB], bvy[NB]; /* bx == -999: free */
  int hx[NH], hvx[NH], hdrop[NH];       /* hx == -999: free */
  int hy[NH];
  int tx[NT], ty[NT], tst[NT];
  uint spawn, frame;
};
#define CS_ ((struct cst *)g_arena)
/* the chute cap: a 16x8 half-disc cell, rendered once at entry */
#define CAPW 16
#define capcell ((ushort *)(g_arena + 512)) /* 16x16 disc, top half used */

static void
sky(int x, int y, int w, int h)
{
  if (y + h > GROUND_Y)
    h = GROUND_Y - y;
  if (h > 0)
    gfx_fill(x, y, w, h, C_SKY);
}

static void
draw_turret(void)
{
  gfx_fill(TUR_X - 16, TUR_Y - 14, 32, 14, C_SKY); /* barrel arc */
  gfx_fill(TUR_X - 12, TUR_Y, 24, 8, C_TURRET);
  gfx_fill(TUR_X - 6, TUR_Y - 4, 12, 4, C_TURRET);
  int a = CS_->aim;
  for (int i = 1; i <= 3; i++) /* barrel: three steps along the aim */
    gfx_fill(TUR_X - 2 + (int)adx[a] * i / 2, TUR_Y - 4 - 3 * i, 4, 4,
             C_BARREL);
  gfx_damage(TUR_X - 16, TUR_Y - 14, TUR_X + 15, TUR_Y + 7);
}

static void
draw_score(void)
{
  char b[6];
  numstr(b, 5, (uint)CS_->score);
  gfx_text(4, 4, b, C_TEXT, C_SKY);
  for (int i = 0; i < 4; i++) /* the four-invader doom meter */
    gfx_fill(220 - i * 10, 6, 6, 6, i < CS_->landed ? C_OVER : RGB(60, 66, 90));
  gfx_damage(180, 4, 233, 13);
  CS_->drawn_score = CS_->score;
}

static void
troop_erase(int i)
{
  sky(CS_->tx[i] - 8, CS_->ty[i] - 10, 16, 24);
}

static void
troop_draw(int i)
{
  int x = CS_->tx[i], y = CS_->ty[i], st = CS_->tst[i];
  if (st == T_CHUTE) /* the cap cell: top half of the arena disc */
    gfx_blit(x - 8, y - 10, capcell, CAPW, 8);
  gfx_fill(x - 2, y, 4, 4, C_TROOP);     /* head */
  gfx_fill(x - 2, y + 4, 4, 8, st == T_SHOT ? C_OVER : C_TROOP);
  gfx_damage(x - 8, y - 10, x + 7, y + 13);
}

static void
heli_draw(int i, int erase)
{
  int x = CS_->hx[i], y = CS_->hy[i];
  if (erase) {
    sky(x - 14, y - 4, 28, 14);
    return;
  }
  gfx_fill(x - 10, y, 20, 8, C_HELI);
  gfx_fill(x + (CS_->hvx[i] > 0 ? -14 : 10), y + 2, 4, 4, C_HELI);
  gfx_fill(x - 12, y - 4 + ((int)(CS_->frame & 2)), 24, 2, C_ROTOR);
  gfx_damage(x - 14, y - 4, x + 13, y + 9);
}

static int
tfree(void)
{
  for (int i = 0; i < NT; i++)
    if (CS_->tst[i] == T_FREE)
      return i;
  return -1;
}

void
chute_run(void)
{
  uputs("chute: start\n");
  led(LED_DIM(0x4060FF), LED_DIM(0x4060FF));
  gfx_disc_cell(16, 8, C_CHUTE, C_SKY, capcell);
restart: /* no recursion on this machine: dmacc frames are static */
  gfx_clear(C_SKY);
  gfx_fill(0, GROUND_Y, LCD_W, LCD_H - GROUND_Y, C_GROUND);
  for (int i = 0; i < NB; i++)
    CS_->bx[i] = -999;
  for (int i = 0; i < NH; i++)
    CS_->hx[i] = -999;
  for (int i = 0; i < NT; i++)
    CS_->tst[i] = T_FREE;
  CS_->aim = 2;
  CS_->score = 0;
  CS_->landed = 0;
  CS_->over = 0;
  CS_->hold = 0;
  CS_->spawn = 1;
  CS_->frame = 0;
  draw_turret();
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
    /* aim and fire */
    if ((in_edge & BTN_LEFT) && CS_->aim > 0) {
      CS_->aim--;
      draw_turret();
    }
    if ((in_edge & BTN_RIGHT) && CS_->aim < 4) {
      CS_->aim++;
      draw_turret();
    }
    if (in_edge & (BTN_A | BTN_UP)) {
      for (int i = 0; i < NB; i++)
        if (CS_->bx[i] == -999) {
          CS_->bx[i] = TUR_X;
          CS_->by[i] = TUR_Y - 12;
          CS_->bvx[i] = adx[CS_->aim];
          CS_->bvy[i] = ady[CS_->aim];
          snd_play(900, 40, 2);
          break;
        }
    }
    /* bullets */
    for (int i = 0; i < NB; i++) {
      if (CS_->bx[i] == -999)
        continue;
      sky(CS_->bx[i] - 1, CS_->by[i] - 1, 4, 4);
      CS_->bx[i] += CS_->bvx[i];
      CS_->by[i] += CS_->bvy[i];
      if (CS_->by[i] < 0 || CS_->bx[i] < 2 || CS_->bx[i] > 236) {
        CS_->bx[i] = -999;
        continue;
      }
      gfx_fill(CS_->bx[i] - 1, CS_->by[i] - 1, 3, 3, C_SHOT);
      gfx_damage(CS_->bx[i] - 4, CS_->by[i] - 4, CS_->bx[i] + 6, CS_->by[i] + 8);
    }
    /* helicopters: spawn, fly, drop */
    if (--CS_->spawn == 0) {
      CS_->spawn = 90 + rng_below(90) - (uint)(CS_->score / 20 > 50 ? 50 : CS_->score / 20);
      for (int i = 0; i < NH; i++)
        if (CS_->hx[i] == -999) {
          int fromleft = (int)(rng() & 1);
          CS_->hx[i] = fromleft ? -12 : 252;
          CS_->hvx[i] = fromleft ? 2 : -2;
          CS_->hy[i] = 22 + (int)rng_below(2) * 16;
          CS_->hdrop[i] = 20 + (int)rng_below(60);
          break;
        }
    }
    for (int i = 0; i < NH; i++) {
      if (CS_->hx[i] == -999)
        continue;
      heli_draw(i, 1);
      CS_->hx[i] += CS_->hvx[i];
      if (CS_->hx[i] < -13 || CS_->hx[i] > 253) {
        CS_->hx[i] = -999;
        continue;
      }
      if (--CS_->hdrop[i] == 0 && CS_->hx[i] > 30 && CS_->hx[i] < 210) {
        int t = tfree();
        if (t >= 0) {
          CS_->tst[t] = T_FALL;
          CS_->tx[t] = CS_->hx[i] & ~1;
          CS_->ty[t] = CS_->hy[i] + 14;
        }
      }
      heli_draw(i, 0);
    }
    /* paratroopers */
    for (int i = 0; i < NT; i++) {
      int st = CS_->tst[i];
      if (st == T_FREE || st == T_LAND)
        continue;
      troop_erase(i);
      if (st == T_FALL) {
        CS_->ty[i] += 3;
        if (CS_->ty[i] > 70)
          CS_->tst[i] = T_CHUTE;
      } else if (st == T_CHUTE) {
        CS_->ty[i] += 1;
        if (CS_->frame & 4) /* drift with the wind, gently */
          CS_->tx[i] += ((CS_->frame & 8) ? 1 : -1);
      } else {
        CS_->ty[i] += 5;
      }
      if (CS_->ty[i] >= GROUND_Y - 12) { /* touchdown */
        CS_->ty[i] = GROUND_Y - 12;
        if (st == T_SHOT) { /* a thud, no invader */
          CS_->tst[i] = T_FREE;
          CS_->score += 2;
          snd_play(90, 60, 3);
          troop_erase(i);
          continue;
        }
        CS_->tst[i] = T_LAND;
        CS_->landed++;
        snd_play(150, 50, 4);
        troop_draw(i);
        draw_score();
        if (CS_->landed >= 4) {
          CS_->over = 1;
          gfx_text2(48, 104, "OVERRUN!", C_OVER, C_SKY);
          gfx_text(58, 128, "press to try again", C_TEXT, C_SKY);
          uputs("chute: game over\n");
          led_blink(LED_BRIGHT(0xFF2020), 6);
          snd_play(110, 70, 20);
        }
        continue;
      }
      troop_draw(i);
    }
    /* hits: bullets vs troopers, then helicopters */
    for (int b = 0; b < NB; b++) {
      if (CS_->bx[b] == -999)
        continue;
      int bx = CS_->bx[b], by = CS_->by[b];
      for (int i = 0; i < NT; i++) {
        int st = CS_->tst[i];
        if (st != T_CHUTE && st != T_FALL)
          continue;
        int dx = bx - CS_->tx[i], dy = by - CS_->ty[i];
        if (dx > -9 && dx < 9 && dy > -11 && dy < 13) {
          troop_erase(i);
          if (st == T_CHUTE && dy < 0) { /* chute hit: he drops */
            CS_->tst[i] = T_SHOT;
            CS_->score += 5;
          } else { /* body hit */
            CS_->tst[i] = T_FREE;
            CS_->score += 10;
          }
          sky(bx - 1, by - 1, 4, 4);
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
        int dx = bx - CS_->hx[i], dy = by - CS_->hy[i];
        if (dx > -13 && dx < 13 && dy > -5 && dy < 9) {
          heli_draw(i, 1);
          CS_->hx[i] = -999;
          sky(bx - 1, by - 1, 4, 4);
          CS_->bx[b] = -999;
          CS_->score += 20;
          snd_play(220, 70, 5);
          led_blink(LED_BRIGHT(0xFF6000), 2);
          break;
        }
      }
    }
    if (CS_->score != CS_->drawn_score)
      draw_score();
    gfx_present();
  }
}
