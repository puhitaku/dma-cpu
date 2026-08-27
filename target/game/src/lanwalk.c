/* lanwalk.c: a NetWalk clone. A 7x7 board holds a scrambled spanning
 * tree of network cable; the server sits at the center and every leaf
 * is a workstation. Rotate tiles (press = clockwise) until the whole
 * LAN lights up. The tree comes from a randomized DFS, so every cell
 * is reachable and the solved state always exists. */
#include "g.h"

#define GRID 7
#define CELLS (GRID * GRID)
#define TILE 30
#define OX 15 /* board origin */
#define OY 8
#define SERVER 24 /* center cell (3,3) */

#define C_BG RGB(10, 14, 32)
#define C_GRIDLN RGB(30, 38, 70)
#define C_WIRE RGB(110, 115, 130)
#define C_LIT RGB(60, 230, 120)
#define C_SERVER RGB(255, 170, 40)
#define C_CURSOR RGB(255, 255, 255)
#define C_TEXT RGB(170, 180, 205)

/* connection mask bits: 0=N 1=E 2=S 3=W. Board state lives in the
 * shared arena; the emulator tests peek the board via the g_arena_w
 * symbol (mask sits at arena offset 0 by contract). */
#define mask (g_arena + 0)     /* CELLS = 49 B */
#define lit (g_arena + 64)     /* 49 B */
#define stack (g_arena + 128)  /* 49 B */

static const signed char dr[4] = {-1, 0, 1, 0};
static const signed char dc[4] = {0, 1, 0, -1};
static const uchar bit4[4] = {1, 2, 4, 8}; /* 1<<d without runtime shl */

static uint
rotcw(uint m)
{
  return ((m << 1) | (m >> 3)) & 0xF;
}

static int
neigh(int cell, int d)
{
  int r = cell / GRID + dr[d], c = cell % GRID + dc[d];
  if (r < 0 || r >= GRID || c < 0 || c >= GRID)
    return -1;
  return r * GRID + c;
}

static void
gen_board(void)
{
  for (int i = 0; i < CELLS; i++) {
    mask[i] = 0;
    lit[i] = 0;
  }
  int sp = 0;
  stack[sp++] = SERVER;
  lit[SERVER] = 1; /* borrow lit[] as the visited set during gen */
  while (sp > 0) {
    int cur = stack[sp - 1];
    int cand[4], n = 0;
    for (int d = 0; d < 4; d++) {
      int nx = neigh(cur, d);
      if (nx >= 0 && !lit[nx])
        cand[n++] = d;
    }
    if (n == 0) {
      sp--;
      continue;
    }
    int d = cand[rng_below((uint)n)];
    int nx = neigh(cur, d);
    mask[cur] |= bit4[d];
    mask[nx] |= bit4[(d + 2) & 3];
    lit[nx] = 1;
    stack[sp++] = (uchar)nx;
  }
  for (int i = 0; i < CELLS; i++) {
    uint m = mask[i], r = rng() & 3;
    while (r--)
      m = rotcw(m);
    mask[i] = (uchar)m;
  }
}

/* relight: BFS from the server over edges both sides agree on. */
static void
relight(void)
{
  for (int i = 0; i < CELLS; i++)
    lit[i] = 0;
  int sp = 0;
  stack[sp++] = SERVER;
  lit[SERVER] = 1;
  while (sp > 0) {
    int cur = stack[--sp];
    for (int d = 0; d < 4; d++) {
      int nx = neigh(cur, d);
      if (nx < 0 || lit[nx])
        continue;
      if ((mask[cur] & bit4[d]) && (mask[nx] & bit4[(d + 2) & 3])) {
        lit[nx] = 1;
        stack[sp++] = (uchar)nx;
      }
    }
  }
}

static int
all_lit(void)
{
  for (int i = 0; i < CELLS; i++)
    if (!lit[i])
      return 0;
  return 1;
}

static int
popcount4(uint m)
{
  return (int)((m & 1) + ((m >> 1) & 1) + ((m >> 2) & 1) + ((m >> 3) & 1));
}

static void
draw_tile(int cell, int cursor)
{
  int x = OX + (cell % GRID) * TILE, y = OY + (cell / GRID) * TILE;
  gfx_fill(x, y, TILE, TILE, C_BG);
  gfx_rect(x, y, TILE, TILE, 1, C_GRIDLN);
  uint m = mask[cell];
  ushort wc = lit[cell] ? C_LIT : C_WIRE;
  /* wire arms: 4 px wide bars from the center to each open edge */
  if (m & 1)
    gfx_fill(x + 13, y, 4, 17, wc);
  if (m & 2)
    gfx_fill(x + 13, y + 13, 17, 4, wc);
  if (m & 4)
    gfx_fill(x + 13, y + 13, 4, 17, wc);
  if (m & 8)
    gfx_fill(x, y + 13, 17, 4, wc);
  if (cell == SERVER) {
    gfx_fill(x + 8, y + 8, 14, 14, C_SERVER);
  } else if (popcount4(m) == 1) { /* leaf = workstation */
    /* an old desktop computer: a big CRT square sitting on a wide,
     * low case. Unlit it is a gray outline with a dark screen; lit it
     * goes green and a smiley glows on the CRT. */
    gfx_rect(x + 7, y + 5, 16, 16, 2, wc);     /* CRT bezel */
    gfx_fill(x + 9, y + 7, 12, 12, C_BG);      /* screen (hides cable) */
    gfx_fill(x + 4, y + 21, 22, 4, wc);        /* desktop case */
    if (lit[cell]) {                           /* the smiley wakes up */
      gfx_fill(x + 11, y + 9, 2, 3, C_LIT);    /* eyes */
      gfx_fill(x + 17, y + 9, 2, 3, C_LIT);
      gfx_fill(x + 10, y + 13, 2, 2, C_LIT);   /* smile, mirror-perfect */
      gfx_fill(x + 12, y + 15, 6, 2, C_LIT);   /* about the eye axis   */
      gfx_fill(x + 18, y + 13, 2, 2, C_LIT);
    }
  }
  if (cursor)
    gfx_rect(x + 1, y + 1, TILE - 2, TILE - 2, 2, C_CURSOR);
}

static void
draw_moves(uint moves)
{
  char b[5];
  numstr(b, 4, moves);
  gfx_text(OX, 222, "moves", C_TEXT, C_BG);
  gfx_text(OX + 48, 222, b, C_CURSOR, C_BG);
}

void
lanwalk_run(void)
{
  uputs("lanwalk: start\n");
  gen_board();
  relight();
  if (all_lit()) { /* scramble landed solved: break one tile */
    mask[0] = (uchar)rotcw(mask[0]);
    relight();
  }
  int cur = SERVER;
  uint moves = 0;
  gfx_clear(C_BG);
  for (int i = 0; i < CELLS; i++)
    draw_tile(i, i == cur);
  gfx_text(OX + 96, 222, "hold press: quit", C_TEXT, C_BG);
  draw_moves(0);
  gfx_present();
  led(LED_DIM(0x00FFFF), LED_DIM(0x00FFFF)); /* dim cyan: LAN dark */

  uint hold = 0;
  for (;;) {
    frame_sync(33000);
    in_poll();
    int prev = cur;
    if (in_edge & BTN_UP)
      cur = neigh(cur, 0) >= 0 ? neigh(cur, 0) : cur;
    if (in_edge & BTN_RIGHT)
      cur = neigh(cur, 1) >= 0 ? neigh(cur, 1) : cur;
    if (in_edge & BTN_DOWN)
      cur = neigh(cur, 2) >= 0 ? neigh(cur, 2) : cur;
    if (in_edge & BTN_LEFT)
      cur = neigh(cur, 3) >= 0 ? neigh(cur, 3) : cur;
    if (cur != prev) {
      draw_tile(prev, 0);
      draw_tile(cur, 1);
      gfx_present();
    }
    if (in_down & BTN_A)
      hold++;
    else
      hold = 0;
    if (hold > 45) { /* ~1.5 s hold quits to the menu */
      uputs("lanwalk: quit\n");
      return;
    }
    if (in_edge & BTN_A) {
      snd_play(600, 35, 2);
      mask[cur] = (uchar)rotcw(mask[cur]);
      moves++;
      uchar was[CELLS];
      for (int i = 0; i < CELLS; i++)
        was[i] = lit[i];
      relight();
      for (int i = 0; i < CELLS; i++)
        if (was[i] != lit[i] || i == cur)
          draw_tile(i, i == cur);
      draw_moves(moves);
      gfx_present();
      if (all_lit()) {
        gfx_fill(30, 100, 180, 44, C_BG);
        gfx_rect(30, 100, 180, 44, 2, C_LIT);
        gfx_text2(48, 108, "CONNECTED", C_LIT, C_BG);
        gfx_text(74, 128, "press: menu", C_TEXT, C_BG);
        gfx_present();
        pcm_play(sfx_tab[2], sfx_tab[3]); /* the success fanfare */
        led(LED_BRIGHT(0x00FF20), LED_BRIGHT(0x00FF20));
        uputs("lanwalk: solved moves=");
        uputn(moves);
        uputs("\n");
        for (;;) {
          frame_sync(33000);
          in_poll();
          if (in_edge & BTN_A) {
            pcm_stop();
            return;
          }
        }
      }
    }
  }
}
