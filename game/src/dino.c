/* dino.c: the Chrome-runner clone. White sky, scrolling ground, a
 * T-rex that jumps cacti; speed climbs with the score. Sprites are
 * 1bpp art pre-rendered into RGB565 cells at start (background baked
 * in, so every frame is opaque gdma blits), and all movers step in
 * 2 px increments to keep the copies word-aligned. */
#include "g.h"

/* art_dino_a: 21x22 */
static const uint art_dino_a[22] = {
  0x003fc000,
  0x007fe000,
  0x006fe000,
  0x007fe000,
  0x007fe000,
  0x007fe000,
  0x007c0000,
  0x007f8000,
  0x807c0000,
  0x80fc0000,
  0xc1fe0000,
  0xe3fc0000,
  0xfffc0000,
  0x7ffc0000,
  0x3ffc0000,
  0x1ff80000,
  0x0ff00000,
  0x07e00000,
  0x06600000,
  0x06700000,
  0x07000000,
  0x00000000,
};
/* art_dino_b: 20x22 */
static const uint art_dino_b[22] = {
  0x003fc000,
  0x007fe000,
  0x006fe000,
  0x007fe000,
  0x007fe000,
  0x007fe000,
  0x007c0000,
  0x007f8000,
  0x807c0000,
  0x80fc0000,
  0xc1fe0000,
  0xe3fc0000,
  0xfffc0000,
  0x7ffc0000,
  0x3ffc0000,
  0x1ff80000,
  0x0ff00000,
  0x07e00000,
  0x06600000,
  0x07600000,
  0x00700000,
  0x00000000,
};
/* art_dino_dead: 20x22 */
static const uint art_dino_dead[22] = {
  0x003fc000,
  0x007fe000,
  0x0057e000,
  0x006fe000,
  0x0057e000,
  0x007fe000,
  0x007c0000,
  0x007f8000,
  0x807c0000,
  0x80fc0000,
  0xc1fe0000,
  0xe3fc0000,
  0xfffc0000,
  0x7ffc0000,
  0x3ffc0000,
  0x1ff80000,
  0x0ff00000,
  0x07e00000,
  0x06600000,
  0x06700000,
  0x07000000,
  0x00000000,
};
/* art_cact_s: 12x24 */
static const uint art_cact_s[24] = {
  0x06000000,
  0x06000000,
  0x06000000,
  0x46200000,
  0x66600000,
  0x66600000,
  0x66600000,
  0x66600000,
  0x66600000,
  0x76e00000,
  0x3ec00000,
  0x1fc00000,
  0x0f000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
  0x06000000,
};
/* art_cact_l: 18x30 */
static const uint art_cact_l[30] = {
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x61e18000,
  0x71e38000,
  0x71e38000,
  0x71e38000,
  0x71e38000,
  0x71e38000,
  0x71e38000,
  0x79e78000,
  0x3fe70000,
  0x1ffe0000,
  0x07fc0000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
  0x01e00000,
};

/* art_cloud: 20x5, drifting in the distant sky */
static const uint art_cloud[5] = {
  0x07c00000,
  0x1ff38000,
  0x3fffc000,
  0x7fffe000,
  0x3fff8000,
};

#define DW 20
#define DH 22
#define CSW 12
#define CSH 24
#define CLW 18
#define CLH 30

#define C_BG RGB(255, 255, 255)
#define C_FG RGB(60, 60, 60)
#define C_CLOUD RGB(185, 192, 205)
#define C_CACT RGB(0, 130, 60)
#define C_OVER RGB(200, 40, 40)

#define GROUND_Y 190 /* top of the ground line; feet rest here */
#define DINO_X 30
#define STRIP_Y 100 /* redrawn play area: STRIP_Y..GROUND_Y-1 */

static ushort cell_run_a[DW * DH];
static ushort cell_run_b[DW * DH];
static ushort cell_dead[DW * DH];
static ushort cell_cact_s[CSW * CSH];
static ushort cell_cact_l[CLW * CLH];
static ushort cell_cloud[20 * 5];

/* one obstacle slot: x < -100 = free */
struct obst {
  int x;
  int w, h;
  ushort *cell;
};
static struct obst obs[2];

static void
draw_ground(void)
{
  gfx_fill(0, GROUND_Y, LCD_W, 2, C_FG);
}

/* fillf: clamped fill + immediate flush of a dirty band — the game
 * runs at 60 fps by touching only the pixels that changed, instead
 * of re-flushing the whole play strip (a full-width flush alone is
 * ~23 ms of SPI wire at 31.25 MHz). */
static void
fillf(int x, int y, int w, int h, ushort c)
{
  if (x < 0) {
    w += x;
    x = 0;
  }
  if (x + w > LCD_W)
    w = LCD_W - x;
  if (w <= 0 || h <= 0)
    return;
  gfx_fill(x, y, w, h, c);
  lcd_flush(x, y, x + w - 1, y + h - 1);
}

/* the dash row under the ground line slides with the world */
static void
draw_dashes(int goff)
{
  gfx_fill(0, GROUND_Y + 5, LCD_W, 1, C_BG);
  for (int x = 6 - goff; x < LCD_W; x += 24) {
    int xx = x, ww = 8;
    if (xx < 0) {
      ww += xx;
      xx = 0;
    }
    if (xx + ww > LCD_W)
      ww = LCD_W - xx;
    if (ww > 0)
      gfx_fill(xx, GROUND_Y + 5, ww, 1, C_FG);
  }
}

static void
draw_score(uint score)
{
  char b[6];
  numstr(b, 5, score);
  gfx_text(LCD_W - 5 * 8 - 8, 8, b, C_FG, C_BG);
}

static void
spawn(struct obst *o, uint score)
{
  if (score > 100 && (rng() & 3) == 0) {
    o->w = CLW;
    o->h = CLH;
    o->cell = cell_cact_l;
  } else {
    o->w = CSW;
    o->h = CSH;
    o->cell = cell_cact_s;
  }
  o->x = LCD_W;
}

void
dino_run(void)
{
  gfx_sprite(art_dino_a, DW, DH, C_FG, C_BG, cell_run_a);
  gfx_sprite(art_dino_b, DW, DH, C_FG, C_BG, cell_run_b);
  gfx_sprite(art_dino_dead, DW, DH, C_FG, C_BG, cell_dead);
  gfx_sprite(art_cact_s, CSW, CSH, C_CACT, C_BG, cell_cact_s);
  gfx_sprite(art_cact_l, CLW, CLH, C_CACT, C_BG, cell_cact_l);
  gfx_sprite(art_cloud, 20, 5, C_CLOUD, C_BG, cell_cloud);

restart:
  uputs("dino: start\n");
  led(0, 0); /* dark until something happens */
  gfx_clear(C_BG);
  draw_ground();
  draw_dashes(0);
  draw_score(0);
  gfx_present();

  int y_fp = 0;  /* dino height above ground, 8.8 fixed point, up > 0 */
  int vy_fp = 0; /* velocity */
  uint score = 0, frame = 0;
  int gap = 90; /* frames until next spawn attempt */
  /* world speed in 8.8 px/frame at 60 fps. The accumulator only ever
   * emits EVEN pixel steps (blits stay word-aligned), the leftover
   * carries, so the 2.0 -> 5.0 px/frame ramp stays smooth. */
  int speed_fp = 512;
  int move_acc = 0, goff = 0, prev_dy = GROUND_Y - DH;
  struct cld {
    int x, y;
  };
  struct cld clouds[2];
  clouds[0].x = 150;
  clouds[0].y = 40;
  clouds[1].x = 40;
  clouds[1].y = 64;
  gfx_blit(clouds[0].x, clouds[0].y, cell_cloud, 20, 5);
  gfx_blit(clouds[1].x, clouds[1].y, cell_cloud, 20, 5);
  obs[0].x = obs[1].x = -1000;

  for (;;) {
    frame_sync(16667); /* 60 fps */
    in_poll();
    frame++;

    /* physics (60 fps constants): apex ~44 px, ~0.63 s airtime */
    if ((in_edge & (BTN_A | BTN_UP)) && y_fp == 0) {
      vy_fp = 1200; /* ~4.7 px/frame */
      snd_play(900, 35, 6);
    }
    if (y_fp > 0 || vy_fp > 0) {
      y_fp += vy_fp;
      vy_fp -= 64; /* gravity: 0.25 px/frame^2 */
      if (y_fp <= 0) {
        y_fp = 0;
        vy_fp = 0;
      }
    }

    /* the world scrolls by an even step from the 8.8 accumulator */
    move_acc += speed_fp;
    int dx = (move_acc >> 8) & ~1;
    move_acc -= dx << 8;
    int speed_px = speed_fp >> 8;

    /* obstacles: erase at the old spot, march, redraw, flush only
     * the union band the move touched */
    if (gap > 0)
      gap--;
    for (int i = 0; i < 2; i++) {
      struct obst *o = &obs[i];
      int oy = GROUND_Y - o->h;
      if (o->x < -100) {
        if (gap == 0) {
          spawn(o, score);
          gap = 60 + (int)rng_below(80) - (speed_px << 4);
          if (gap < 36)
            gap = 36;
        }
        continue;
      }
      int oldx = o->x;
      gfx_fill(oldx < 0 ? 0 : oldx, oy, oldx < 0 ? o->w + oldx : o->w,
               o->h, C_BG);
      o->x -= dx;
      if (o->x + o->w <= 0) {
        fillf(0, oy, oldx + o->w, o->h, C_BG);
        o->x = -1000;
        continue;
      }
      gfx_blit(o->x, oy, o->cell, o->w, o->h);
      int bx = o->x < 0 ? 0 : o->x;
      int be = oldx + o->w;
      if (be > LCD_W)
        be = LCD_W;
      lcd_flush(bx, oy, be - 1, GROUND_Y - 1);
    }

    /* ground dashes slide with the world; clouds drift on their own */
    goff += dx;
    if (goff >= 24)
      goff -= 24;
    draw_dashes(goff);
    lcd_flush(0, GROUND_Y + 5, LCD_W - 1, GROUND_Y + 5);
    if ((frame & 15) == 0) {
      for (int i = 0; i < 2; i++) {
        int oldx = clouds[i].x;
        gfx_fill(oldx < 0 ? 0 : oldx, clouds[i].y, 20, 5, C_BG);
        clouds[i].x -= 2;
        if (clouds[i].x < -20)
          clouds[i].x = LCD_W;
        gfx_blit(clouds[i].x, clouds[i].y, cell_cloud, 20, 5);
        int bx = clouds[i].x < 0 ? 0 : clouds[i].x;
        int be = oldx + 20;
        if (be > LCD_W)
          be = LCD_W;
        if (be > bx)
          lcd_flush(bx, clouds[i].y, be - 1, clouds[i].y + 4);
      }
    }

    /* score + difficulty: the speed creeps up a little at a time
     * (2.0 -> 5.0 px/frame at 60 fps over ~100 s) */
    if ((frame & 3) == 0) {
      score++;
      if (score % 100 == 0) { /* level up: rainbow burst */
        snd_play(1200, 40, 6);
        led_rainbow(30); /* half a second at 60 fps */
      }
    }
    if (speed_fp < 1280 && (frame & 63) == 0)
      speed_fp += 8;

    /* the dino: redraw only when it moved or the run frame flips */
    int dy = GROUND_Y - DH - (y_fp >> 8);
    if (dy != prev_dy || (frame & 7) == 0) {
      int top = dy < prev_dy ? dy : prev_dy;
      gfx_fill(DINO_X, top, DW, prev_dy + DH - top, C_BG);
      ushort *cell = (frame & 8) ? cell_run_a : cell_run_b;
      if (y_fp > 0)
        cell = cell_run_a;
      gfx_blit(DINO_X, dy, cell, DW, DH);
      lcd_flush(DINO_X, top, DINO_X + DW - 1, prev_dy + DH - 1);
      prev_dy = dy;
    }
    if ((frame & 1) == 0) {
      draw_score(score);
      lcd_flush(LCD_W - 5 * 8 - 8, 8, LCD_W - 9, 15);
    }

    /* collision: AABB with a 3 px mercy margin */
    int dtop = dy + 3, dbot = GROUND_Y - (y_fp >> 8) - 1;
    int dl = DINO_X + 3, dr = DINO_X + DW - 3;
    for (int i = 0; i < 2; i++) {
      struct obst *o = &obs[i];
      if (o->x < -100)
        continue;
      int ol = o->x + 2, or_ = o->x + o->w - 2;
      int otop = GROUND_Y - o->h + 2;
      if (dr > ol && dl < or_ && dbot > otop && dtop < GROUND_Y)
        goto dead;
    }
    continue;

  dead:
    snd_play(220, 70, 36);
    led_blink(0xFF0000, 3); /* rapid tri-ramp, three times */
    gfx_blit(DINO_X, dy, cell_dead, DW, DH);
    gfx_text2(48, 56, "GAME OVER", C_OVER, C_BG);
    gfx_text(24, 80, "press: retry  down: menu", C_FG, C_BG);
    gfx_present();
    uputs("dino: over score=");
    uputn(score);
    uputs("\n");
    for (;;) {
      frame_sync(16667);
      in_poll();
      if (in_edge & (BTN_A | BTN_UP))
        goto restart;
      if (in_edge & BTN_DOWN) {
        led(0, 0);
        return;
      }
    }
  }
}
