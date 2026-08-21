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
  led(0x104010, 0x000000); /* runner green, second dark */
  gfx_clear(C_BG);
  draw_ground();
  draw_dashes(0);
  draw_score(0);
  gfx_present();

  int y_fp = 0;  /* dino height above ground, 8.8 fixed point, up > 0 */
  int vy_fp = 0; /* velocity */
  uint score = 0, frame = 0;
  int gap = 45; /* frames until next spawn attempt */
  /* world speed in 8.8 px/frame. The accumulator only ever emits
   * EVEN pixel steps (blits stay word-aligned), the leftover carries,
   * so the ramp is smooth even though positions move 2 px at a time. */
  int speed_fp = 1024; /* 4.0 */
  int move_acc = 0, goff = 0;
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
    frame_sync(33000);
    in_poll();
    frame++;

    /* physics: press or up jumps from the ground. Apex ~44 px —
     * high enough for the large cactus, low enough that fast play
     * stays possible — and inside the redrawn strip (no ghosting). */
    if ((in_edge & (BTN_A | BTN_UP)) && y_fp == 0) {
      vy_fp = 2400; /* ~9.4 px/frame */
      snd_play(900, 35, 3);
    }
    if (y_fp > 0 || vy_fp > 0) {
      y_fp += vy_fp;
      vy_fp -= 256; /* gravity: 1 px/frame^2 */
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

    /* obstacles march left; spawn on a cooling-down random gap */
    if (gap > 0)
      gap--;
    for (int i = 0; i < 2; i++) {
      struct obst *o = &obs[i];
      if (o->x < -100) {
        if (gap == 0) {
          spawn(o, score);
          gap = 30 + (int)rng_below(40) - (speed_px * 2);
          if (gap < 18)
            gap = 18;
        }
        continue;
      }
      o->x -= dx;
      if (o->x + o->w <= 0)
        o->x = -1000;
    }

    /* ground dashes slide with the world; clouds drift on their own */
    goff += dx;
    if (goff >= 24)
      goff -= 24;
    draw_dashes(goff);
    if ((frame & 7) == 0) {
      for (int i = 0; i < 2; i++) {
        gfx_fill(clouds[i].x, clouds[i].y, 20, 5, C_BG);
        clouds[i].x -= 2;
        if (clouds[i].x < -20)
          clouds[i].x = LCD_W;
        gfx_blit(clouds[i].x, clouds[i].y, cell_cloud, 20, 5);
      }
    }

    /* score + difficulty: the speed creeps up a little at a time
     * (4.0 -> 10.0 px/frame over ~100 s) instead of stepping */
    if ((frame & 1) == 0) {
      score++;
      if (score % 100 == 0) { /* milestone chirp + flash */
        snd_play(1200, 40, 3);
        led(0x404040, 0x104010);
      }
    }
    if (speed_fp < 2560 && (frame & 31) == 0)
      speed_fp += 16;

    /* redraw the play strip: sky, dino, cacti, ground fringe */
    gfx_fill(0, STRIP_Y, LCD_W, GROUND_Y - STRIP_Y, C_BG);
    int dy = GROUND_Y - DH - (y_fp >> 8);
    ushort *cell = (frame & 4) ? cell_run_a : cell_run_b;
    if (y_fp > 0)
      cell = cell_run_a;
    gfx_blit(DINO_X, dy, cell, DW, DH);
    for (int i = 0; i < 2; i++)
      if (obs[i].x > -100)
        gfx_blit(obs[i].x, GROUND_Y - obs[i].h, obs[i].cell, obs[i].w,
                 obs[i].h);
    if ((frame & 1) == 0)
      draw_score(score);
    gfx_present();

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
    snd_play(220, 70, 18);
    led(0x600000, 0x600000);
    gfx_blit(DINO_X, dy, cell_dead, DW, DH);
    gfx_text2(48, 56, "GAME OVER", C_OVER, C_BG);
    gfx_text(24, 80, "press: retry  down: menu", C_FG, C_BG);
    gfx_present();
    uputs("dino: over score=");
    uputn(score);
    uputs("\n");
    for (;;) {
      frame_sync(33000);
      in_poll();
      if (in_edge & (BTN_A | BTN_UP))
        goto restart;
      if (in_edge & BTN_DOWN)
        return;
    }
  }
}
