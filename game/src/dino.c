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
  0x06300000,
  0x071c0000,
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
  0x06700000,
  0x07000000,
  0x07800000,
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
  0x06300000,
  0x071c0000,
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

#define DW 20
#define DH 22
#define CSW 12
#define CSH 24
#define CLW 18
#define CLH 30

#define C_BG RGB(255, 255, 255)
#define C_FG RGB(60, 60, 60)
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
  for (int x = 6; x < LCD_W; x += 24)
    gfx_fill(x, GROUND_Y + 5, 8, 1, C_FG);
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

restart:
  uputs("dino: start\n");
  led(0x104010, 0x000000); /* runner green, second dark */
  gfx_clear(C_BG);
  draw_ground();
  draw_score(0);
  gfx_present();

  int y_fp = 0;  /* dino height above ground, 8.8 fixed point, up > 0 */
  int vy_fp = 0; /* velocity */
  uint score = 0, frame = 0;
  int speed = 4, gap = 45; /* frames until next spawn attempt */
  obs[0].x = obs[1].x = -1000;

  for (;;) {
    frame_sync(33000);
    in_poll();
    frame++;

    /* physics: press or up jumps from the ground. Apex ~55 px keeps
     * the sprite inside the redrawn strip (no ghosting above it). */
    if ((in_edge & (BTN_A | BTN_UP)) && y_fp == 0) {
      vy_fp = 2688; /* 10.5 px/frame */
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

    /* obstacles march left; spawn on a cooling-down random gap */
    if (gap > 0)
      gap--;
    for (int i = 0; i < 2; i++) {
      struct obst *o = &obs[i];
      if (o->x < -100) {
        if (gap == 0) {
          spawn(o, score);
          gap = 30 + (int)rng_below(40) - (speed * 2);
          if (gap < 18)
            gap = 18;
        }
        continue;
      }
      o->x -= speed;
      if (o->x + o->w <= 0)
        o->x = -1000;
    }

    /* score + difficulty */
    if ((frame & 1) == 0) {
      score++;
      if (score % 100 == 0) { /* milestone chirp + flash */
        snd_play(1200, 40, 3);
        led(0x404040, 0x104010);
      }
    }
    if (score == 150 || score == 400 || score == 800)
      if (speed < 10)
        speed += 2;

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
    if ((frame & 7) == 0)
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
    gfx_text2(48, 130, "GAME OVER", C_OVER, C_BG);
    gfx_text(24, 154, "press: retry  down: menu", C_FG, C_BG);
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
