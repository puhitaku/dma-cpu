/*
 * Copyright (c) 2011-2018 K. Lange.  All rights reserved.
 *
 * Developed by:            K. Lange
 *                          http://github.com/klange/nyancat
 *                          http://nyancat.dakko.us
 *
 * 40-column support by:    Peter Hazenberg
 *                          http://github.com/Peetz0r/nyancat
 *                          http://peter.haas-en-berg.nl
 *
 * Build tools unified by:  Aaron Peschel
 *                          https://github.com/apeschel
 *
 * For a complete listing of contributors, please see the git commit history.
 *
 * This is a simple telnet server / standalone application which renders the
 * classic Nyan Cat (or "poptart cat") to your terminal.
 *
 * It makes use of various ANSI escape sequences to render color, or in the case
 * of a VT220, simply dumps text to the screen.
 *
 * For more information, please see:
 *
 *     http://nyancat.dakko.us
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal with the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimers.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimers in the
 *      documentation and/or other materials provided with the distribution.
 *   3. Neither the names of the Association for Computing Machinery, K.
 *      Lange, nor the names of its contributors may be used to endorse
 *      or promote products derived from this Software without specific prior
 *      written permission.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * WITH THE SOFTWARE.
 */

/* --- The xv6 port ---------------------------------------------------
 *
 * What the machine has: an 80x30 framebuffer console (dma/kfbcon.c)
 * that parses CSI A B C D H f J K m over the 16 ANSI colors, a
 * wallclock-honest pause()/select(), and a raw console mode. What it
 * does not have: a network, a terminal to negotiate with, termios,
 * signals other than SIGINT, an environment, or getopt.
 *
 * So the telnet server, the TERM sniffing, the 256-color/vt220/text
 * modes, SIGWINCH resizing and the intro MOTD are all gone, and the
 * 16-color path is hardcoded. What survives is the loop: crop the
 * 64x64 frames to the screen, walk them cell by cell emitting a
 * background-color escape only when the color changes, and count the
 * seconds.
 *
 * The crop is fixed at 39x29 cells — 78 columns of the 80, so on the
 * first frame a row's own '\n' is the only line break (a full-width
 * row would wrap AND newline, costing a blank line every row); the two
 * spare columns are painted by a CSI K, once, and nothing writes there
 * again. The crop stays inside the 64x64 grid, so the x<0 rainbow-tail
 * generator upstream needs for wide terminals never fires and is not
 * carried.
 *
 * Every escape this emits is in kfbcon's vocabulary already: the
 * background codes 40-47 and 100-107 (sgr()), CSI H, CSI J, SGR 0/1/37.
 * Nothing here asked the console to grow.
 *
 * The console is a TEE: every byte written here is rendered into the
 * framebuffer AND clocked out of the UART, and the frame paces at
 * whichever consumer is slower. Both were measured, not guessed
 * (host/dmacc, the feather at 300 MHz; silicon runs ~1.25x the
 * emulator's compute). A FULL frame is ~3620 bytes: the framebuffer
 * takes them in ~217 ms of machine time (~271 ms on silicon) and the
 * UART needs ~314 ms of wire time at 115200 baud, so a full redraw
 * costs ~360 ms a frame and the 90 ms delay below is not the pace of
 * anything.
 *
 * Which is why this port does not redraw. Only 13 % of the crop's
 * cells differ between consecutive frames, so after the first frame
 * the loop diffs against the previous one and emits the changed runs
 * alone, addressed with CSI row;colH (see delta_frame). That is ~1260
 * bytes a frame — both consumers shrink with it, and the frame lands
 * at ~170 ms with the UART no longer the one setting the pace.
 */

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* The animation, verbatim from the upstream src/animation.c — which
 * spells its frame-list terminator NULL, a name the freestanding
 * userland has no header for. */
#define NULL 0
#include "user/nyancat_anim.h"

/* The crop: 39 cells wide (78 of the console's 80 columns) and 29
 * rows, centered in the 64x64 frame, leaving the console's last line
 * for the counter. Upstream computes these from the terminal size;
 * here the terminal is the framebuffer console and never resizes. */
#define MIN_COL 12
#define MAX_COL 51
#define MIN_ROW 17
#define MAX_ROW 46

/* The console itself (dma/kfbcon.c): 80x30 cells, the last line being
 * the counter's. */
#define CONCOLS 80
#define CONROWS 30

/* Upstream's default 90 ms frame delay, in the kernel's 100 us ticks.
 * pause()/select() have honored wallclock since the timer rework, so
 * this is 90 ms and not "however long 900 quanta take". */
#define DELAY_TICKS 900

/* The 16-color palette, upstream's TERM=linux branch: one background
 * SGR per frame character. kfbcon parses 40-47 and 100-107, which is
 * exactly this set. */
static const char cchars[] = ",.'@$->&+#=;*%";
static const char *const cseq[] = {
    "\033[104m", /* ','  blue background */
    "\033[107m", /* '.'  white stars */
    "\033[40m",  /* '\'' black border */
    "\033[47m",  /* '@'  tan poptart */
    "\033[105m", /* '$'  pink poptart */
    "\033[101m", /* '-'  red poptart */
    "\033[101m", /* '>'  red rainbow */
    "\033[43m",  /* '&'  orange rainbow */
    "\033[103m", /* '+'  yellow rainbow */
    "\033[102m", /* '#'  green rainbow */
    "\033[104m", /* '='  light blue rainbow */
    "\033[44m",  /* ';'  dark blue rainbow */
    "\033[100m", /* '*'  gray cat face */
    "\033[105m", /* '%'  pink cheeks */
};

/* Frame char -> cseq index, built once at startup: the inner loop runs
 * 1131 times a frame and a linear scan of cchars there would be 1131
 * strings of comparisons, each one a millicode call on this machine.
 *
 * The index is CANONICAL: three of the fourteen sprite characters
 * share a background with an earlier one ('>' with '-', '=' with ',',
 * '%' with '$'), and the table folds each onto the first index that
 * emits that escape. Two consequences, both wanted: a run that crosses
 * such a pair costs no escape, and the frame diff below sees a cell as
 * changed only when its COLOR changed. */
static uchar cidx[128];

/* The crop's shape, as the diff sees it. */
#define NCOL (MAX_COL - MIN_COL)
#define NROW (MAX_ROW - MIN_ROW)

/* prev: the colors the screen is currently showing, one byte a cell —
 * the frame diff's whole state. cur: the row being examined, resolved
 * to colors once so the gap scan below can look ahead without paying
 * the table again. */
static uchar prev[NROW][NCOL];
static uchar cur[NCOL];

/* curcol: the background the console has standing, as a cidx value, or
 * -1 when it is something this loop did not set (start of a frame,
 * where the counter line's SGR 0 left it at the default). SGR state
 * survives cursor motion, so a colour set in one run is still current
 * in the next one and only genuine changes cost an escape. */
static int curcol;

/* Output is batched across rows: a delta row is a few dozen bytes and
 * one write() per row would spend more on syscalls than on pixels.
 * The buffer holds a flush threshold plus the worst case single row
 * (a wholly changed row: 39 cells of escape+"  ", a position escape
 * and the line's own tail). */
#define OFLUSH 384
static char obuf[1024];
static int olen;

static void
flush(void)
{
  if (olen) {
    write(1, obuf, olen);
    olen = 0;
  }
}

static void
emit(const char *s)
{
  while (*s)
    obuf[olen++] = *s++;
}

static void
emitn(uint v)
{
  char d[12];
  int i = 0;
  do {
    d[i++] = '0' + v % 10;
    v /= 10;
  } while (v);
  while (i)
    obuf[olen++] = d[--i];
}

/* digits(), upstream's libm-free counter-centering helper. */
static int
digits(uint v)
{
  int d = 1;
  while (v >= 10) {
    v /= 10;
    d++;
  }
  return d;
}

/* gotoxy: CSI row;colH, both 1-based. kfbcon parses H and f alike;
 * H is the spelling every other escape in this file uses. */
static void
gotoxy(int row, int col)
{
  emit("\033[");
  emitn((uint)row);
  obuf[olen++] = ';';
  emitn((uint)col);
  obuf[olen++] = 'H';
}

/* setcol: the background escape, when the console is not already
 * showing that color. */
static void
setcol(int col)
{
  if (col != curcol) {
    curcol = col;
    emit(cseq[col]);
  }
}

/* finish(): colors off, screen clean, cooked console back. */
static void
finish(void)
{
  ttyraw(0);
  emit("\033[0m\033[H\033[2J");
  flush();
}

/* full_frame: the whole crop, as upstream draws it — the first frame,
 * and the only one that paints the 78th-to-80th column gutter (CSI K
 * in the frame background) or leaves the cursor walking down the
 * screen on newlines. It also seeds prev[][] for the diff.
 *
 * `curcol` spans the whole frame, as upstream's `last` does: the color
 * a row ends on is still current when the next row starts, so a run
 * that crosses the line break costs no escape. That is most of the
 * frame's cost — one escape per CELL instead of per RUN triples both
 * the console traffic and this loop. */
static void
full_frame(uint i)
{
  emit("\033[H");
  curcol = -1;
  for (int y = 0; y < NROW; y++) {
    const char *row = frames[i][y + MIN_ROW];
    uchar *pr = prev[y];
    for (int x = 0; x < NCOL; x++) {
      int col = cidx[(int)row[x + MIN_COL] & 0x7F];
      pr[x] = (uchar)col;
      setcol(col);
      obuf[olen++] = ' ';
      obuf[olen++] = ' ';
    }
    /* The console is 80 columns and the crop is 78. CSI K fills the
     * rest of the line in the CURRENT background, so setting the
     * frame background first paints the two-column gutter instead
     * of leaving it at the cleared black. Nothing ever writes there
     * again, which is why the delta frames below can ignore it. */
    setcol(0); /* ',' — the frame background */
    emit("\033[K");
    obuf[olen++] = '\n';
    if (olen > OFLUSH)
      flush();
  }
}

/* GAP: how many unchanged cells are worth painting over rather than
 * jumping across. A position escape is 7-9 bytes and a cell is 2, so
 * a run breaks only when the hole is wider than the jump — and a
 * bridged cell costs no escape unless its color differs from the run's
 * current one, which inside a hole it usually does not. */
#define GAP 4

/* delta_frame: the cells whose color differs from what the screen is
 * already showing, in runs, each addressed absolutely. Everything else
 * is left standing — including the gutter, the counter line's own
 * background, and every cell the animation did not touch. */
static void
delta_frame(uint i)
{
  for (int y = 0; y < NROW; y++) {
    const char *row = frames[i][y + MIN_ROW];
    uchar *pr = prev[y];
    for (int x = 0; x < NCOL; x++)
      cur[x] = cidx[(int)row[x + MIN_COL] & 0x7F];
    int x = 0;
    while (x < NCOL) {
      if (cur[x] == pr[x]) {
        x++;
        continue;
      }
      /* Extend the run over holes narrower than a jump; `e` is the
       * last cell in it that actually changed. */
      int e = x, gap = 0;
      for (int k = x + 1; k < NCOL; k++) {
        if (cur[k] != pr[k]) {
          e = k;
          gap = 0;
        } else if (++gap > GAP) {
          break;
        }
      }
      gotoxy(y + 1, 2 * x + 1);
      for (int c = x; c <= e; c++) {
        int col = cur[c];
        pr[c] = (uchar)col;
        setcol(col);
        obuf[olen++] = ' ';
        obuf[olen++] = ' ';
      }
      x = e + 1;
    }
    if (olen > OFLUSH)
      flush();
  }
}

int
main(int argc, char **argv)
{
  /* -f N: stop after N frames (upstream's --frames). The other
   * options describe a terminal or a telnet session this port does
   * not have. */
  uint frame_count = 0;
  if (argc == 3 && argv[1][0] == '-' && argv[1][1] == 'f' && argv[1][2] == 0) {
    frame_count = (uint)atoi(argv[2]);
  } else if (argc > 1) {
    write(2, "usage: nyancat [-f frames]\n", 27);
    exit(1);
  }

  /* cidx, canonicalized: an entry points at the FIRST index emitting
   * its escape, so duplicate palette rows collapse. */
  for (int i = 0; cchars[i]; i++) {
    int j = 0;
    while (j < i) {
      const char *a = cseq[i], *b = cseq[j];
      while (*a && *a == *b) {
        a++;
        b++;
      }
      if (*a == *b)
        break;
      j++;
    }
    cidx[(int)cchars[i]] = (uchar)j;
  }

  /* Raw mode: a keypress must reach us as a byte, and the cooked
   * line discipline's echo would paint over the cat. */
  ttyraw(1);
  emit("\033[H\033[2J");
  flush();

  uint start = (uint)uptime();
  uint i = 0, f = 0;
  for (;;) {
    if (f == 0)
      full_frame(i);
    else
      delta_frame(i);
    /* "You have nyaned for N seconds!", centered on the last line and
     * redrawn every frame — it costs some eighty bytes and it is what
     * parks the cursor (an XOR underline on this console) off the
     * animation. CSI J paints the rest of the line in the current
     * background, exactly as upstream relies on, so the frame color
     * goes down first; the line carries no newline, so the screen
     * never scrolls. Its SGR 0 is also what leaves the background at
     * something this loop did not choose, hence the reset below. */
    uint secs = ((uint)uptime() - start) / 10000;
    int pad = (CONCOLS - 29 - digits(secs)) / 2;
    gotoxy(CONROWS, 1);
    setcol(0);
    while (pad-- > 0)
      obuf[olen++] = ' ';
    emit("\033[1;37mYou have nyaned for ");
    emitn(secs);
    emit(" seconds!\033[J\033[0m");
    curcol = -1;
    flush();

    f++;
    if (frame_count != 0 && f == frame_count)
      break;
    if (!frames[++i])
      i = 0;
    /* Sleep the frame delay, but wake the instant a key arrives:
     * select() on fd 0 with a timeout is the honest form of
     * "usleep(delay) unless the user is done". */
    if (select(1u, DELAY_TICKS) != 0)
      break;
  }

  /* Swallow whatever was typed so it does not land on the shell. */
  char c;
  while (read_nb(0, &c, 1) == 1)
    ;
  finish();
  exit(0);
}
