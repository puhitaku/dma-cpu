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
 * background-color escape only when the color changes, park the
 * cursor at home between frames, and count the seconds.
 *
 * The crop is fixed at 39x29 cells — 78 columns of the 80, so a row's
 * own '\n' is the only line break (a full-width row would wrap AND
 * newline, costing a blank line every row); the two spare columns are
 * painted by a CSI K. The crop stays inside the 64x64 grid, so the
 * x<0 rainbow-tail generator upstream needs for wide terminals never
 * fires and is not carried.
 *
 * Every escape this emits is in kfbcon's vocabulary already: the
 * background codes 40-47 and 100-107 (sgr()), CSI H, CSI J, SGR 0/1/37.
 * Nothing here asked the console to grow.
 *
 * A frame is ~3.5 KB of console traffic. The framebuffer takes that in
 * about 80 ms of machine time, so the 90 ms delay below is the pace on
 * the display; the console is a TEE, though, and the same bytes also
 * go out the UART, where 3.5 KB at 115200 baud is 300 ms. The cat runs
 * at the speed of whichever consumer is watching.
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
 * strings of comparisons, each one a millicode call on this machine. */
static uchar cidx[128];

/* One row of output at a time: 39 cells of "  " plus, worst case, an
 * escape before every one of them, plus the newline. */
static char obuf[512];
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

/* finish(): colors off, screen clean, cooked console back. */
static void
finish(void)
{
  ttyraw(0);
  emit("\033[0m\033[H\033[2J");
  flush();
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

  for (int i = 0; cchars[i]; i++)
    cidx[(int)cchars[i]] = (uchar)i;

  /* Raw mode: a keypress must reach us as a byte, and the cooked
   * line discipline's echo would paint over the cat. */
  ttyraw(1);
  emit("\033[H\033[2J");
  flush();

  uint start = (uint)uptime();
  uint i = 0, f = 0;
  for (;;) {
    emit("\033[H");
    /* `last` spans the whole frame, as upstream: the color a row ends
     * on is still current when the next row starts, so a run that
     * crosses the line break costs no escape. It is also most of the
     * frame's cost — one escape per CELL instead of per RUN triples
     * both the console traffic and this loop. */
    char last = 0;
    for (int y = MIN_ROW; y < MAX_ROW; y++) {
      const char *row = frames[i][y];
      for (int x = MIN_COL; x < MAX_COL; x++) {
        char c = row[x];
        if (c != last) {
          last = c;
          emit(cseq[cidx[(int)c & 0x7F]]);
        }
        obuf[olen++] = ' ';
        obuf[olen++] = ' ';
      }
      /* The console is 80 columns and the crop is 78. CSI K fills the
       * rest of the line in the CURRENT background, so setting the
       * frame background first paints the two-column gutter instead
       * of leaving it at the cleared black. */
      if (last != ',') {
        emit(cseq[0]); /* ',' — the frame background */
        last = ',';
      }
      emit("\033[K");
      obuf[olen++] = '\n';
      flush();
    }
    /* "You have nyaned for N seconds!", centered on the last line.
     * CSI J paints the rest of it in the current background (the
     * blue the last frame cell left standing), exactly as upstream
     * relies on; the line carries no newline, so the screen never
     * scrolls and the next frame's CSI H lands at the top. */
    uint secs = ((uint)uptime() - start) / 10000;
    int pad = (80 - 29 - digits(secs)) / 2;
    while (pad-- > 0)
      obuf[olen++] = ' ';
    emit("\033[1;37mYou have nyaned for ");
    emitn(secs);
    emit(" seconds!\033[J\033[0m");
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
