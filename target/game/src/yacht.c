/* yacht.c: the classic dice game, single player, traditional scoring
 * (upper section counts, Choice/Four-of-a-Kind/Full House as die
 * sums, straights 30, Yacht 50). Left/right walks the dice row and
 * the ROLL button; press holds a die or rolls. Up/down drops into the
 * score sheet; press there books the hovered category. */
#include "g.h"

#define C_BG RGB(8, 40, 24)
#define C_PANEL RGB(14, 60, 36)
#define C_DIE RGB(245, 245, 235)
#define C_PIP RGB(20, 20, 24)
#define C_HELD RGB(255, 210, 60)
#define C_CUR RGB(255, 90, 60)
#define C_TEXT RGB(200, 215, 205)
#define C_DIM RGB(110, 130, 118)
#define C_SCORE RGB(255, 255, 255)
#define C_PREV RGB(120, 220, 160)

#define NCAT 12
static const char *catname[NCAT] = {
    "Aces",       "Twos",           "Threes",       "Fours",
    "Fives",      "Sixes",          "Choice",       "Four Kind",
    "Full House", "Small Straight", "Big Straight", "Yacht"};

/* Game state in the shared arena; the aliases keep every use site
 * reading as before. All fields are filled at yacht_run() entry. */
struct ystate {
  int dice[5], held[5], scores[NCAT], rolls_left, turn;
};
#define YST ((struct ystate *)g_arena)
#define dice (YST->dice)
#define held (YST->held)
#define scores (YST->scores)
#define rolls_left (YST->rolls_left)
#define turn (YST->turn)

/* pip layout per face: bit i set = pip at cell i of a 3x3 grid
 * (0=TL, 2=TR, 4=center, 6=BL, 8=BR; 3/5 = middle left/right) */
static const ushort pips[7] = {0, 0x010, 0x101, 0x111, 0x145, 0x155, 0x16D};

static void
draw_die(int i, int cursor)
{
  int x = 6 + i * 34, y = 18;
  gfx_fill(x - 2, y - 2, 32, 40, C_BG);
  gfx_fill(x, y, 28, 28, C_DIE);
  gfx_rect(x, y, 28, 28, 1, C_PIP);
  uint p = pips[dice[i]];
  uint bit = 1;
  for (int b = 0; b < 9; b++, bit <<= 1)
    if (p & bit) {
      int px = x + 4 + (b % 3) * 8, py = y + 4 + (b / 3) * 8;
      gfx_fill(px, py, 4, 4, C_PIP);
    }
  if (held[i])
    gfx_fill(x + 2, y + 31, 24, 4, C_HELD);
  if (cursor)
    gfx_rect(x - 2, y - 2, 32, 40, 2, C_CUR);
}

static void
draw_roll_btn(int cursor)
{
  int x = 178, y = 18;
  gfx_fill(x - 2, y - 2, 58, 40, C_BG);
  gfx_fill(x, y, 54, 22, rolls_left ? C_PANEL : C_BG);
  gfx_rect(x, y, 54, 22, 1, rolls_left ? C_TEXT : C_DIM);
  gfx_text(x + 11, y + 7, "ROLL", rolls_left ? C_SCORE : C_DIM,
           rolls_left ? C_PANEL : C_BG);
  char b[2];
  b[0] = (char)('0' + rolls_left);
  b[1] = 0;
  gfx_text(x + 24, y + 26, b, C_DIM, C_BG);
  if (cursor)
    gfx_rect(x - 2, y - 2, 58, 40, 2, C_CUR);
}

static int
cat_score(int cat)
{
  int cnt[7] = {0, 0, 0, 0, 0, 0, 0}, sum = 0;
  for (int i = 0; i < 5; i++) {
    cnt[dice[i]]++;
    sum += dice[i];
  }
  if (cat < 6) { /* upper: face value times count, by addition */
    int s = 0;
    for (int k = 0; k < cnt[cat + 1]; k++)
      s += cat + 1;
    return s;
  }
  if (cat == 6) /* Choice */
    return sum;
  if (cat == 7) { /* Four of a Kind: sum of those four dice */
    for (int f = 1; f <= 6; f++)
      if (cnt[f] >= 4)
        return f + f + f + f;
    return 0;
  }
  if (cat == 8) { /* Full House */
    int has3 = 0, has2 = 0;
    for (int f = 1; f <= 6; f++) {
      if (cnt[f] == 3)
        has3 = 1;
      else if (cnt[f] == 2)
        has2 = 1;
    }
    return (has3 && has2) ? sum : 0;
  }
  if (cat == 9) { /* Small Straight: any run of four faces */
    for (int lo = 1; lo <= 3; lo++) {
      int run = 1;
      for (int f = lo; f <= lo + 3; f++)
        if (!cnt[f])
          run = 0;
      if (run)
        return 30;
    }
    return 0;
  }
  if (cat == 10) { /* Big Straight: any run of five faces */
    for (int lo = 1; lo <= 2; lo++) {
      int run = 1;
      for (int f = lo; f <= lo + 4; f++)
        if (!cnt[f])
          run = 0;
      if (run)
        return 30;
    }
    return 0;
  }
  for (int f = 1; f <= 6; f++) /* Yacht */
    if (cnt[f] == 5)
      return 50;
  return 0;
}

static int
total(void)
{
  int t = 0;
  for (int c = 0; c < NCAT; c++)
    if (scores[c] >= 0)
      t += scores[c];
  return t;
}

/* draw_cat: booked boxes show their score in white; every open box
 * previews (dim green) what the current five dice would score there
 * — holds and cursor position never hide a detection. */
static void
draw_cat(int c, int cursor)
{
  int y = 66 + c * 12;
  gfx_fill(4, y - 1, 232, 11, cursor ? C_PANEL : C_BG);
  gfx_text(10, y, catname[c], scores[c] >= 0 ? C_DIM : C_TEXT,
           cursor ? C_PANEL : C_BG);
  char b[4];
  if (scores[c] >= 0) { /* booked: dimmed like its name — bright was
                         * too easy to mistake for an open preview */
    numsp(b, 3, (uint)scores[c]);
    gfx_text(200, y, b, C_DIM, cursor ? C_PANEL : C_BG);
  } else if (rolls_left < 3) { /* no previews before the first roll */
    numsp(b, 3, (uint)cat_score(c));
    gfx_text(200, y, b, C_PREV, cursor ? C_PANEL : C_BG);
  }
}

/* 2. round indicator, top right: "01/12" */
static void
draw_round(void)
{
  char b[6];
  numstr(b, 2, (uint)turn);
  b[2] = '/';
  b[3] = '1';
  b[4] = '2';
  b[5] = 0;
  gfx_text(LCD_W - 5 * 8 - 4, 4, b, C_TEXT, C_BG);
}

/* 4. roulette roll: unheld dice tick through random faces, fast then
 * decelerating, and the last tick lands on the already-decided final
 * faces. ~0.8 s total; input is not polled while it runs. */
static void
roll_anim(void)
{
  static const uchar pause[7] = {1, 1, 2, 3, 4, 6, 8}; /* frames */
  int fin[5];
  for (int i = 0; i < 5; i++)
    fin[i] = dice[i];
  for (int t = 0; t < 7; t++) {
    for (int f = 0; f < pause[t]; f++) {
      frame_sync(33000);
      if (f == 0)
        led(0, 0); /* each tick is a one-frame faint blink */
    }
    for (int i = 0; i < 5; i++)
      if (!held[i])
        dice[i] = t == 6 ? fin[i] : 1 + (int)rng_below(6);
    for (int i = 0; i < 5; i++)
      if (!held[i])
        draw_die(i, 0);
    snd_play(t == 6 ? 900 : 1400, 25, 1); /* tick, lower final thunk */
    led(LED_DIM(0xFFFFFF), LED_DIM(0xFFFFFF)); /* faint, with the tick */
    gfx_present();
  }
  frame_sync(33000);
  led(0, 0); /* dice settled: lights out */
  for (int i = 0; i < 5; i++)
    dice[i] = fin[i];
}

static void
draw_total(void)
{
  gfx_fill(4, 212, 232, 20, C_BG);
  gfx_text(10, 218, "TOTAL", C_TEXT, C_BG);
  gfx_text(64, 218, "hold press: quit", C_DIM, C_BG);
  char b[4];
  numsp(b, 3, (uint)total());
  gfx_text(200, 218, b, C_SCORE, C_BG);
}

static void
roll_dice(void)
{
  for (int i = 0; i < 5; i++)
    if (!held[i])
      dice[i] = 1 + (int)rng_below(6);
  rolls_left--;
}

void
yacht_run(void)
{
  uputs("yacht: start\n");
  led(LED_DIM(0xFFFF80), LED_DIM(0xFFFF80)); /* warm table glow */
  for (int c = 0; c < NCAT; c++)
    scores[c] = -1;
  turn = 0;

  gfx_clear(C_BG);
  gfx_text(6, 4, "YACHT", C_HELD, C_BG);
  for (;;) { /* one turn per iteration */
    turn++;
    rolls_left = 3;
    for (int i = 0; i < 5; i++)
      held[i] = 0;
    for (int i = 0; i < 5; i++)
      dice[i] = 0; /* blank faces until the player rolls */

    int cur = 5, incats = 0, catc = 0; /* cur 0-4 dice, 5 = ROLL */
    while (scores[catc] >= 0)
      catc++;
    for (int i = 0; i < 5; i++)
      draw_die(i, 0);
    draw_roll_btn(1);
    draw_round();
    for (int c = 0; c < NCAT; c++)
      draw_cat(c, 0);
    draw_total();
    gfx_present();

    int booked = -1;
    uint hold = 0;
    while (booked < 0) {
      frame_sync(33000);
      in_poll();
      if (in_down & BTN_A)
        hold++;
      else
        hold = 0;
      if (hold > 45) { /* ~1.5 s hold quits to the menu */
        uputs("yacht: quit\n");
        return;
      }
      if (!incats) {
        if (in_edge & BTN_LEFT) {
          int p = cur;
          cur = cur == 0 ? 5 : cur - 1;
          if (p == 5)
            draw_roll_btn(0);
          else
            draw_die(p, 0);
          if (cur == 5)
            draw_roll_btn(1);
          else
            draw_die(cur, 1);
          gfx_present();
        }
        if (in_edge & BTN_RIGHT) {
          int p = cur;
          cur = cur == 5 ? 0 : cur + 1;
          if (p == 5)
            draw_roll_btn(0);
          else
            draw_die(p, 0);
          if (cur == 5)
            draw_roll_btn(1);
          else
            draw_die(cur, 1);
          gfx_present();
        }
        if (in_edge & BTN_A) {
          if (cur < 5) {
            held[cur] = !held[cur];
            draw_die(cur, 1);
            gfx_present();
          } else if (rolls_left > 0) {
            roll_dice();
            roll_anim();
            draw_roll_btn(1);
            for (int c = 0; c < NCAT; c++)
              draw_cat(c, 0);
            gfx_present();
            uputs("yacht: roll\n");
          }
        }
        if ((in_edge & (BTN_UP | BTN_DOWN)) && rolls_left < 3) {
          /* into the sheet — locked until the dice have been rolled */
          incats = 1;
          if (cur == 5)
            draw_roll_btn(0);
          else
            draw_die(cur, 0);
          draw_cat(catc, 1);
          gfx_present();
        }
      } else {
        if (in_edge & (BTN_LEFT | BTN_RIGHT)) { /* back to the dice */
          incats = 0;
          draw_cat(catc, 0);
          if (cur == 5)
            draw_roll_btn(1);
          else
            draw_die(cur, 1);
          gfx_present();
        }
        if (in_edge & BTN_UP) {
          int p = catc;
          do
            catc = catc == 0 ? NCAT - 1 : catc - 1;
          while (scores[catc] >= 0);
          draw_cat(p, 0);
          draw_cat(catc, 1);
          gfx_present();
        }
        if (in_edge & BTN_DOWN) {
          int p = catc;
          do
            catc = catc == NCAT - 1 ? 0 : catc + 1;
          while (scores[catc] >= 0);
          draw_cat(p, 0);
          draw_cat(catc, 1);
          gfx_present();
        }
        if (in_edge & BTN_A) {
          snd_play(800, 45, 4);
          scores[catc] = cat_score(catc);
          booked = catc;
          uputs("yacht: cat=");
          uputn((uint)catc);
          uputs(" score=");
          uputn((uint)scores[catc]);
          uputs("\n");
        }
      }
    }
    draw_cat(booked, 0);
    draw_total();
    gfx_present();
    if (turn == NCAT)
      break;
  }

  gfx_fill(30, 96, 180, 52, C_PANEL);
  gfx_rect(30, 96, 180, 52, 2, C_HELD);
  gfx_text2(52, 104, "FINISHED", C_HELD, C_PANEL);
  char b[4];
  numsp(b, 3, (uint)total());
  gfx_text(76, 124, "total", C_TEXT, C_PANEL);
  gfx_text(124, 124, b, C_SCORE, C_PANEL);
  gfx_text(74, 136, "press: menu", C_TEXT, C_PANEL);
  gfx_present();
  snd_play(990, 60, 30);
  led(LED_BRIGHT(0x20FF20), LED_BRIGHT(0x20FF20));
  uputs("yacht: total=");
  uputn((uint)total());
  uputs("\n");
  for (;;) {
    frame_sync(33000);
    in_poll();
    if (in_edge & BTN_A)
      return;
  }
}
