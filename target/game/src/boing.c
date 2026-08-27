/* boing.c: the classic bouncing-ball demo, done the way the 1984
 * original really was — the "3D" checkered sphere is PRECOMPUTED
 * (dmxgen's gameBallBlob ray-casts 8 rotation phases offline) and
 * runtime is nothing but DMA span blits: per frame the machine
 * restores the grid under the old position (~30 fills) and copies
 * one row-span per scanline of the ball from flash (~90 copies),
 * every one on ch11's word fast path. The machine never touches a
 * pixel; it decides ~120 things per frame and sleeps. */
#include "g.h"

/* must match dmxgen gameBallBlob's palette */
#define C_BG RGB(170, 170, 170)
#define C_GRID RGB(140, 60, 220)

#define BW 88  /* ball cell edge */
#define NPH 8  /* phases; NPH steps span the checker's 90-degree
                * COLOR period (45 degrees only swaps red/white) */
#define GP 24  /* background grid pitch */

uint ball_home; /* dmxgen-patched: flash home of the ball blob —
                 * span table (BW x {x0,w} bytes), then the phases */

/* per-frame scratch in the shared arena */
struct bstate {
  int x, y, vx, vy, ph, boing, fr;
};
#define BS ((struct bstate *)g_arena)

/* restore background (grid over gray) inside one rect */
static void
bg_rect(int x, int y, int w, int h)
{
  gfx_fill(x, y, w, h, C_BG);
  for (int gx = 0; gx < LCD_W; gx += GP)
    if (gx + 2 > x && gx < x + w) {
      int cx = gx < x ? x : gx;
      int cw = gx + 2 - cx;
      if (cx + cw > x + w)
        cw = x + w - cx;
      gfx_fill(cx, y, cw, h, C_GRID);
    }
  for (int gy = 0; gy < LCD_H; gy += GP)
    if (gy + 2 > y && gy < y + h) {
      int cy = gy < y ? y : gy;
      int ch = gy + 2 - cy;
      if (cy + ch > y + h)
        ch = y + h - cy;
      gfx_fill(x, cy, w, ch, C_GRID);
    }
}

/* blit one ball phase at (x, y): span copies from flash, incremental
 * addressing — one multiply per frame, adds per row */
static void
ball_blit(int x, int y, int ph)
{
  const uchar *sp = (const uchar *)ball_home;
  uint src = ball_home + 2 * BW + (uint)ph * (BW * BW * 2);
  uint dst = (uint)&fb[y * LCD_W + x];
  for (int r = 0; r < BW; r++) {
    uint w = sp[2 * r + 1];
    if (w) {
      uint x0 = sp[2 * r];
      gdma_copy(dst + 2 * x0, src + 2 * x0, 2 * w);
    }
    dst += LCD_W * 2;
    src += BW * 2;
  }
}

#define X_MAX (LCD_W - BW)  /* even, so the spans stay word-aligned */
#define Y_MAX (LCD_H - BW - 6)

void
boing_run(void)
{
  uputs("boing: start\n");
  led(LED_DIM(0xFF3030), LED_DIM(0xFFFFFF)); /* the ball's colors */
  bg_rect(0, 0, LCD_W, LCD_H);
  gfx_present();
  BS->x = 24;
  BS->y = 20;
  BS->vx = 2;
  BS->vy = 0;
  BS->ph = 0;
  BS->boing = 0;
  BS->fr = 0;
  for (;;) {
    frame_sync(33000);
    in_poll();
    if (in_edge & (BTN_A | BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)) {
      uputs("boing: quit\n"); /* a demo: ANY input exits */
      snd_off();
      return;
    }
    int ox = BS->x, oy = BS->y;
    BS->vy += 1;
    BS->y += BS->vy;
    if (BS->y >= Y_MAX) { /* floor: full-restitution bounce */
      BS->y = Y_MAX;
      BS->vy = -17;
      BS->boing = 6;
    }
    BS->x += BS->vx;
    if (BS->x <= 0 || BS->x >= X_MAX) {
      BS->x = BS->x <= 0 ? 0 : X_MAX;
      BS->vx = -BS->vx; /* the spin follows the travel direction */
      BS->boing = 4;
    }
    BS->fr++;
    if (BS->fr & 1) { /* half-rate spin: 11.25 degrees per step */
      BS->ph += BS->vx > 0 ? 1 : NPH - 1;
      if (BS->ph >= NPH)
        BS->ph -= NPH;
    }
    bg_rect(ox, oy, BW, BW);
    ball_blit(BS->x, BS->y, BS->ph);
    {
      int x0 = ox < BS->x ? ox : BS->x;
      int y0 = oy < BS->y ? oy : BS->y;
      int x1 = (ox > BS->x ? ox : BS->x) + BW - 1;
      int y1 = (oy > BS->y ? oy : BS->y) + BW - 1;
      gfx_damage(x0, y0, x1, y1);
    }
    gfx_present();
    if (BS->boing) { /* falling-pitch chirp on impact */
      snd_play(80u + (uint)BS->boing * 30u, 60, 2);
      BS->boing--;
    }
  }
}
