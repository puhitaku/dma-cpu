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

/* Sprite cells carry baked-in background margins so a moving blit
 * erases its own trail — no separate erase fill, no second pass:
 * cacti get 12 px of sky on the right (they move left <= 10 px a
 * frame), the dino gets 6 sky rows above and below (vertical speed
 * tops out ~6 px a frame). */
#define OM 12          /* obstacle right margin, px */
#define DM 6           /* dino vertical margin, rows */
#define DCH (DH + 2 * DM)
static ushort cell_run_a[DW * DCH];
static ushort cell_run_b[DW * DCH];
static ushort cell_dead[DW * DCH];
static ushort cell_cact_s[(CSW + OM) * CSH];
static ushort cell_cact_l[(CLW + OM) * CLH];
static ushort cell_cloud[(20 + 4) * 5];

/* render 1bpp art into a cell with margins around it */
static void
cell_render(const uint *rows, int w, int h, ushort fg, ushort *dst,
            int right, int vert)
{
  int cw = w + right;
  for (int i = 0; i < cw * (h + 2 * vert); i++)
    dst[i] = C_BG;
  for (int r = 0; r < h; r++) {
    uint bits = rows[r];
    uint mask = 1u << (32 - w);
    ushort *p = dst + (r + vert) * cw;
    for (int c = w - 1; c >= 0; c--, mask <<= 1)
      if (bits & mask)
        p[c] = fg;
  }
}

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

/* the dash row under the ground line slides with the world: a
 * pre-rendered 264 px pattern, copied into the fb at offset goff by
 * ONE dma transfer (goff stays even, so the copy stays aligned).
 * The scalar version wrote 240 halfwords a frame — the profiler's
 * biggest labeled cost after the score text. */
static ushort dashpat[LCD_W + 24];

static void
dash_init(void)
{
  for (int i = 0; i < LCD_W + 24; i++)
    dashpat[i] = C_BG;
  for (int x = 6; x < LCD_W + 16; x += 24)
    for (int i = 0; i < 8; i++)
      dashpat[x + i] = C_FG;
}

static void
draw_dashes(int goff)
{
  /* sstride must be nonzero: gdma_rows reads it as copy-vs-fill, and
   * a "fill" repeats the FIRST pattern word across the row — a solid
   * line flickering with goff instead of a scrolling texture. */
  gdma_rows((uint)&fb[(GROUND_Y + 5) * LCD_W], (uint)&dashpat[goff],
            LCD_W / 2, 1, 0, LCD_W * 2);
  gfx_damage(0, GROUND_Y + 5, LCD_W - 1, GROUND_Y + 5);
}

/* the score as maintained digits: ++ with carry, so the frame path
 * never divides (numstr costs five rt_udivmod calls per draw), and
 * pre-rendered digit cells so drawing is five aligned blits instead
 * of per-pixel text (the profiler's #1 frame cost) */
static char sbuf[6];
static ushort cell_digit[10][64];

#define SCORE_X (LCD_W - 5 * 8 - 8)

static void
score_reset(void)
{
  for (int i = 0; i < 5; i++)
    sbuf[i] = '0';
  sbuf[5] = 0;
}

static void
score_inc(void)
{
  int i = 4;
  while (i >= 0) {
    if (++sbuf[i] <= '9')
      break;
    sbuf[i] = '0';
    i--;
  }
}

static void
draw_score(void)
{
  for (int i = 0; i < 5; i++)
    gdma_rows((uint)&fb[8 * LCD_W + SCORE_X + i * 8],
              (uint)cell_digit[sbuf[i] - '0'], 4, 8, LCD_W * 2, 16);
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
  dash_init();
  for (int d = 0; d < 10; d++)
    gfx_glyph_cell('0' + d, C_FG, C_BG, cell_digit[d]);
  cell_render(art_dino_a, DW, DH, C_FG, cell_run_a, 0, DM);
  cell_render(art_dino_b, DW, DH, C_FG, cell_run_b, 0, DM);
  cell_render(art_dino_dead, DW, DH, C_FG, cell_dead, 0, DM);
  cell_render(art_cact_s, CSW, CSH, C_CACT, cell_cact_s, OM, 0);
  cell_render(art_cact_l, CLW, CLH, C_CACT, cell_cact_l, OM, 0);
  cell_render(art_cloud, 20, 5, C_CLOUD, cell_cloud, 4, 0);

restart:
  uputs("dino: start\n");
  led(0, 0); /* dark until something happens */
  gfx_clear(C_BG);
  draw_ground();
  draw_dashes(0);
  score_reset();
  draw_score();
  gfx_present();

  int ypix = 0, y_sub = 0; /* height above ground: pixels + subpixel */
  int vy_fp = 0;           /* velocity, 8.8 */
  uint score = 0, frame = 0, cent = 0;
  int gap = 90; /* frames until next spawn attempt */
  /* world speed in 8.8 px/frame at 60 fps. The accumulator only ever
   * emits EVEN pixel steps (blits stay word-aligned), the leftover
   * carries, so the 2.0 -> 5.0 px/frame ramp stays smooth. */
  int speed_fp = 512, gappen = 32; /* gappen tracks 16*speed_px */
  int move_acc = 0, goff = 0, prev_dy = GROUND_Y - DH;
  struct cld {
    int x, y;
  };
  struct cld clouds[2];
  clouds[0].x = 150;
  clouds[0].y = 40;
  clouds[1].x = 40;
  clouds[1].y = 64;
  gfx_blit(clouds[0].x, clouds[0].y, cell_cloud, 24, 5);
  gfx_blit(clouds[1].x, clouds[1].y, cell_cloud, 24, 5);
  obs[0].x = obs[1].x = -1000;

  for (;;) {
    frame_sync(16667); /* 60 fps */
    in_poll();
    frame++;

    /* physics (60 fps constants): apex ~44 px, ~0.63 s airtime.
     * Height is kept as pixels + a subpixel remainder and settled by
     * a short loop — y_fp >> 8 was a ~1300-record runtime call. */
    if ((in_edge & (BTN_A | BTN_UP)) && ypix == 0 && y_sub == 0) {
      vy_fp = 1200; /* ~4.7 px/frame */
      snd_play(900, 35, 6);
    }
    if (ypix > 0 || y_sub > 0 || vy_fp > 0) {
      y_sub += vy_fp;
      vy_fp -= 64; /* gravity: 0.25 px/frame^2 */
      while (y_sub >= 256) {
        y_sub -= 256;
        ypix++;
      }
      while (y_sub < 0 && ypix > 0) {
        y_sub += 256;
        ypix--;
      }
      if (ypix == 0 && y_sub <= 0) {
        y_sub = 0;
        vy_fp = 0;
      }
    }

    /* the world scrolls by an even step, settled without shifts */
    move_acc += speed_fp;
    int dx = 0;
    while (move_acc >= 512) {
      move_acc -= 512;
      dx += 2;
    }

    /* the dino: a margin blit erases its own trail (the cell carries
     * DM sky rows each side), clipped so it never paints the ground
     * line. y_fp>>8 is a runtime call — computed once. */
    int dy = GROUND_Y - DH - ypix;
    if (dy != prev_dy || (frame & 7) == 0) {
      ushort *cell = (frame & 8) ? cell_run_a : cell_run_b;
      if (ypix > 0)
        cell = cell_run_a;
      int bh = GROUND_Y - (dy - DM); /* clip the bottom margin */
      if (bh > DCH)
        bh = DCH;
      gfx_blit(DINO_X, dy - DM, cell, DW, bh);
      lcd_flush(DINO_X, dy - DM, DINO_X + DW - 1, dy - DM + bh - 1);
      prev_dy = dy;
    }

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
          gap = 70 + (int)rng_below(80) - gappen;
          if (gap < 50)
            gap = 50;
        }
        continue;
      }
      int oldx = o->x;
      o->x -= dx;
      if (o->x + o->w <= 0) {
        fillf(0, oy, oldx + o->w + OM, o->h, C_BG);
        o->x = -1000;
        continue;
      }
      gfx_blit(o->x, oy, o->cell, o->w + OM, o->h);
      int bx = o->x < 0 ? 0 : o->x;
      int be = o->x + o->w + OM;
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
        clouds[i].x -= 2;
        if (clouds[i].x < -24)
          clouds[i].x = LCD_W;
        gfx_blit(clouds[i].x, clouds[i].y, cell_cloud, 24, 5);
        int bx = clouds[i].x < 0 ? 0 : clouds[i].x;
        int be = clouds[i].x + 24;
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
      score_inc();
      if (++cent == 100) { /* level up: rainbow burst, no division */
        cent = 0;
        snd_play(1200, 40, 6);
        led_rainbow(30); /* half a second at 60 fps */
      }
    }
    if (speed_fp < 1280 && (frame & 63) == 0) {
      speed_fp += 8; /* +8/256 px/frame; gappen: +16 per whole px */
      if (frame & 64)
        gappen++;
    }

    if ((frame & 1) == 0) {
      draw_score();
      lcd_flush(SCORE_X, 8, SCORE_X + 39, 15);
    }

    /* collision: AABB with a 3 px mercy margin */
    int dtop = dy + 3, dbot = GROUND_Y - ypix - 1;
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
    led_blink(0xFF0000, 3); /* rapid tri-ramp, three times */
    gfx_blit(DINO_X, dy - DM, cell_dead, DW,
             GROUND_Y - (dy - DM) > DCH ? DCH : GROUND_Y - (dy - DM));
    gfx_text2(48, 56, "GAME OVER", C_OVER, C_BG);
    gfx_text(24, 80, "press: retry  down: menu", C_FG, C_BG);
    gfx_present();
    pcm_play(sfx_tab[0], sfx_tab[1]); /* AFTER the last draw: the clip
                                       * borrows the gdma channel */
    uputs("dino: over score=");
    uputn(score);
    uputs("\n");
    for (;;) {
      frame_sync(16667);
      in_poll();
      if (in_edge & (BTN_A | BTN_UP)) {
        pcm_stop(); /* the screen is about to redraw over ch11 */
        goto restart;
      }
      if (in_edge & BTN_DOWN) {
        pcm_stop();
        led(0, 0);
        return;
      }
    }
  }
}
