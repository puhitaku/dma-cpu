/* fbcon: a terminal emulator on the HDMI framebuffer (prompts/036),
 * the display half of the console tee — cputc hands every console
 * byte to the UART and to kfbcon_putc. The VT subset (BS/TAB/CR/LF,
 * CSI A B C D H f J K m, 16 ANSI colors) follows the shape of the
 * SimpleTerminal reference (references/simpleterminal, MIT/X — see
 * LICENSE); state fits the machine: no allocation, no recursion.
 *
 * Rendering writes RGB332 bytes straight into the SRAM framebuffer.
 * The unit of work is a 4-pixel word looked up BY FONT BYTE in two
 * 256-word LUTs (left/right half of the row), rebuilt on color
 * changes: one glyph row = one font load, two LUT loads, four stores,
 * no shifts and no masks. (A naive `bits >> 4` costs thousands of
 * cycles here: dmacc lowers right shifts through a per-bit runtime
 * loop; the benchmark caught it at ~50k cycles per glyph.)
 *
 * What the per-byte path costs is COMPARISONS, not pixels: dmacc
 * lowers every one through millicode, so a test is a call, and the
 * profile that shaped this file (host/dmacc/zz_fbconprof_test.go) put
 * ~40 % of fbcon's cycle bill in __cw_eq/__cw_eqz. Four rules follow.
 * The dispatcher is ordered by byte frequency, not by the VT grammar.
 * The blits count down to zero rather than up to a constant. The
 * cursor's cell address is kept standing in frowa instead of being
 * multiplied out per byte. And the printable path does not un-draw the
 * cursor, because the glyph it is about to write covers those pixels
 * anyway.
 *
 * Scrolling is one bulk-DMA row move (ch11, ~2.7 ms) plus a cleared
 * row: the pure-DMA scanout reads fb rows at fixed addresses from its
 * immutable descriptor table, so the old O(1) vertical pan has no
 * consumer anymore. The screen has no text shadow buffer; the cursor
 * is an XOR-inverted underline (cell rows 6-7) so it un-draws by
 * re-XOR. */

#include "kernel/types.h"

#include "kfbfont.h"

#define W32(a) (*(volatile uint *)(a))

int kfb_active(void);
uint kfb_condark(void);                             /* kfb.c */
extern uint fb_base;                                /* kfb.c, loader-patched */
extern void kdmaset(uint dst, uint word, uint len); /* kdma.c */
extern void kdmacpy(uint dst, uint src, uint len); /* kdma.c */
int kfb_w(void);
int kfb_h(void);

#define CELLW 8
#define FONTH 8  /* the font bitmap is 8 rows */
#define CELLH 16 /* each font row drawn twice: at 480p an 8-row cell
                  * halved the glyphs the user knew from the doubled-
                  * scan era; 80x30 with 8x16 cells restores the look */
#define COLS (640 / CELLW)
#define ROWS (480 / CELLH)
#define PITCH 640

/* The 16 ANSI colors in RGB332 (SimpleTerminal's colormap, quantized). */
static const uchar fbpal[16] = {
    0x00, 0x80, 0x10, 0x90, 0x02, 0x82, 0x12, 0xDB,
    0x92, 0xE0, 0x1C, 0xFC, 0x03, 0xE3, 0x1F, 0xFF,
};

static int fcx, fcy;      /* cursor cell */
static uint ffg, fbg;     /* palette indices */

static uint flut16[16];   /* font nibble -> 4-pixel word (rebuild scratch) */
static uint fluthi[256];  /* font byte -> left 4-pixel word, current colors */
static uint flutlo[256];  /* font byte -> right 4-pixel word */
static int fstate;        /* 0 plain, 1 ESC, 2 CSI */
static int fpar[4], fnpar, fpriv;
static int fcursor;       /* cursor currently drawn (XORed) */

/* nibmask[n]: 0xFF per set nibble bit, bit 3 = leftmost = byte 0. */
static const uint nibmask[16] = {
    0x00000000, 0xFF000000, 0x00FF0000, 0xFFFF0000,
    0x0000FF00, 0xFF00FF00, 0x00FFFF00, 0xFFFFFF00,
    0x000000FF, 0xFF0000FF, 0x00FF00FF, 0xFFFF00FF,
    0x0000FFFF, 0xFF00FFFF, 0x00FFFFFF, 0xFFFFFFFF,
};

static void
lut_build(void)
{
  uint fgw = fbpal[ffg] * 0x01010101u, bgw = fbpal[fbg] * 0x01010101u;
  for (uint n = 0; n < 16; n++) {
    uint m = nibmask[n];
    flut16[n] = (fgw & m) | (bgw & ~m);
  }
  uint idx = 0;
  for (uint h = 0; h < 16; h++) {
    uint hw = flut16[h];
    for (uint l = 0; l < 16; l++) {
      fluthi[idx] = hw;
      flutlo[idx] = flut16[l];
      idx++;
    }
  }
}

/* Screen cells map straight onto fb rows (scroll moves the pixels; the
 * scanout's row addresses are fixed), so a cell address is
 * fb_base + cy * (CELLH * PITCH) + cx * CELLW. That product is a
 * fourteen-record double-and-add chain — the machine has no multiplier
 * and 10240 is not a power of two — which is why the CURSOR row's half
 * of it is kept standing in frowa: every fcy write goes through
 * set_cy, and the per-byte path then adds a shifted fcx to one loaded
 * word. fb_base is read straight out of kfb.c: a cross-module call per
 * cell address is pure overhead here.
 *
 * cell_addr is the general form, for the cold callers that address a
 * row other than the cursor's (clear_cells under CSI J/K). */
static uint frowa; /* fb_base + fcy * (CELLH * PITCH) */

static void
set_cy(int cy)
{
  fcy = cy;
  frowa = fb_base + (uint)cy * (CELLH * PITCH);
}

static uint
cur_addr(void)
{
  return frowa + (uint)fcx * CELLW;
}

static uint
cell_addr(int cx, int cy)
{
  return fb_base + (uint)cy * (CELLH * PITCH) + (uint)cx * CELLW;
}

/* Both per-byte blits count DOWN to zero. The trip counts are
 * constants either way, but the comparison is not: `r == 0` lowers to
 * __cw_eqz (three records and a one-operand site), `r == FONTH` to
 * __cw_eq (four records and two operands), and twelve of them run per
 * printable byte.
 *
 * Unrolling them away is the obvious next step and is NOT taken.
 * Under XIPText every pointer store becomes a self-patched record in
 * .ramtext, so unrolling costs the kernel's two scarcest windows in
 * proportion to the unroll factor: measured at +4.1 K text, +0.6 K
 * data and +1.1 K ramtext for both blits, against a feather data
 * window with ~40 bytes of slack and a .ramtext window with ~550. It
 * is a real win waiting for a board map that can pay for it. */
static void
cursor_xor(void)
{
  /* the underline is font rows 6-7, i.e. fb rows 12-15 */
  uint a = cur_addr() + 12 * PITCH;
  for (uint r = 4; r != 0; r--) {
    W32(a) ^= 0xFFFFFFFFu;
    W32(a + 4) ^= 0xFFFFFFFFu;
    a += PITCH;
  }
}

static void
draw_glyph(int c)
{
  const uchar *g = &fbfont[(uint)(c & 0x7F) * 8];
  uint a = cur_addr();
  for (uint r = FONTH; r != 0; r--) {
    uint bits = *g++;
    uint hi = fluthi[bits], lo = flutlo[bits];
    W32(a) = hi;
    W32(a + 4) = lo;
    W32(a + PITCH) = hi;
    W32(a + PITCH + 4) = lo;
    a += 2 * PITCH;
  }
}

/* The background as a 4-pixel word — what every blank fill writes. */
static uint
bg_word(void)
{
  uint bg = fbpal[fbg];
  return bg | bg << 8 | bg << 16 | bg << 24;
}

static void
clear_cells(int cx0, int cy, int n)
{
  uint w = bg_word();
  uint a = cell_addr(cx0, cy);
  if (n >= 8) { /* wide spans: DMA fill, row by row */
    for (uint r = CELLH; r != 0; r--) {
      kdmaset(a, w, (uint)(8 * n));
      a += PITCH;
    }
    return;
  }
  for (uint r = CELLH; r != 0; r--) {
    uint p = a, words = (uint)(2 * n);
    while (words > 0) {
      W32(p) = w;
      p += 4;
      words--;
    }
    a += PITCH;
  }
}

static void
scroll_up(void)
{
  /* Move rows 1..29 up one cell row in one ch11 burst (dst < src:
   * the ascending copy is overlap-safe), then blank the new bottom.
   * The bottom row is full width and pitch IS the width, so it is one
   * contiguous fill — not the sixteen row fills clear_cells would
   * issue, each a channel setup plus a completion spin. */
  uint fb = fb_base;
  kdmacpy(fb, fb + CELLH * PITCH, (ROWS - 1) * CELLH * PITCH);
  kdmaset(fb + (ROWS - 1) * CELLH * PITCH, bg_word(), CELLH * PITCH);
}

static void
newline(void)
{
  fcx = 0;
  if (fcy < ROWS - 1)
    set_cy(fcy + 1);
  else
    scroll_up();
}

/* The whole screen is one contiguous run of framebuffer bytes, so it
 * blanks in a single DMA fill — not the 480 row fills it used to
 * issue. vi clears a screen per repaint. */
static void
clear_screen(void)
{
  kdmaset(fb_base, bg_word(), ROWS * CELLH * PITCH);
}

void
kfbcon_reset(void)
{
  if (!kfb_active())
    return;
  fcx = 0;
  set_cy(0);
  ffg = 7;
  fbg = 0;
  fstate = 0;
  fcursor = 0;
  lut_build();
  clear_screen();
}

static void
sgr(void)
{
  if (fnpar == 0)
    fpar[fnpar++] = 0;
  for (int i = 0; i < fnpar; i++) {
    int p = fpar[i];
    if (p == 0) {
      ffg = 7;
      fbg = 0;
    } else if (p == 1) {
      ffg |= 8;
    } else if (p == 7) {
      uint t = ffg;
      ffg = fbg;
      fbg = t;
    } else if (p >= 30 && p <= 37) {
      ffg = (ffg & 8) | (uint)(p - 30);
    } else if (p >= 40 && p <= 47) {
      fbg = (uint)(p - 40);
    } else if (p >= 90 && p <= 97) {
      ffg = (uint)(p - 90 + 8);
    } else if (p >= 100 && p <= 107) {
      fbg = (uint)(p - 100 + 8);
    } else if (p == 39) {
      ffg = 7;
    } else if (p == 49) {
      fbg = 0;
    }
  }
  lut_build();
}

static void
csi(int final)
{
  int n = fpar[0] ? fpar[0] : 1;
  if (fpriv) {
    /* ?1049 (alternate screen): no saved screen to restore — both
     * directions become a clean screen. Everything else: ignored. */
    if (fpar[0] == 1049 && (final == 'h' || final == 'l')) {
      clear_screen();
      fcx = 0;
      set_cy(0);
    }
    return;
  }
  switch (final) {
  case 'A':
    fcy -= n;
    if (fcy < 0)
      fcy = 0;
    set_cy(fcy);
    break;
  case 'B':
    fcy += n;
    if (fcy >= ROWS)
      fcy = ROWS - 1;
    set_cy(fcy);
    break;
  case 'C':
    fcx += n;
    if (fcx >= COLS)
      fcx = COLS - 1;
    break;
  case 'D':
    fcx -= n;
    if (fcx < 0)
      fcx = 0;
    break;
  case 'H':
  case 'f': {
    int y = (fpar[0] ? fpar[0] : 1) - 1;
    int x = (fnpar > 1 && fpar[1] ? fpar[1] : 1) - 1;
    set_cy(y < 0 ? 0 : (y >= ROWS ? ROWS - 1 : y));
    fcx = x < 0 ? 0 : (x >= COLS ? COLS - 1 : x);
    break;
  }
  case 'J':
    if (fpar[0] == 2) {
      clear_screen();
    } else if (fpar[0] == 1) {
      for (int y = 0; y < fcy; y++)
        clear_cells(0, y, COLS);
      clear_cells(0, fcy, fcx + 1);
    } else {
      clear_cells(fcx, fcy, COLS - fcx);
      for (int y = fcy + 1; y < ROWS; y++)
        clear_cells(0, y, COLS);
    }
    break;
  case 'K':
    if (fpar[0] == 2)
      clear_cells(0, fcy, COLS);
    else if (fpar[0] == 1)
      clear_cells(0, fcy, fcx + 1);
    else
      clear_cells(fcx, fcy, COLS - fcx);
    break;
  case 'm':
    sgr();
    break;
  }
}

/* csi_byte: one byte of a CSI sequence — parameter digits, separators,
 * the private marker, or the final that dispatches. Split out of
 * kfbcon_putc so the printable fast path below is not carrying its
 * blocks. */
static void
csi_byte(int c)
{
  if (c >= '0' && c <= '9') {
    if (fnpar == 0)
      fnpar = 1;
    fpar[fnpar - 1] = fpar[fnpar - 1] * 10 + (c - '0');
  } else if (c == ';') {
    if (fnpar < 4)
      fnpar++;
    if (fnpar == 1)
      fnpar = 2; /* leading ';': an empty first parameter */
  } else if (c == '?') {
    fpriv = 1;
  } else {
    fstate = 0;
    csi(c);
  }
}

/* kfbcon_putc is ordered by frequency, not by the VT grammar. Every
 * test it makes is a comparison, and dmacc lowers comparisons through
 * millicode (a call, not a flag), so the printable byte — the case
 * that carries a `cat` or a scroll — is decided in two: the plain
 * state, then one unsigned range test for [0x20,0x7F). Writing the
 * control bytes as a trailing else-if chain keeps clang from folding
 * them into a switch, which lowered to five sequential equality sites
 * AHEAD of the printable path. The escape states stay behind a single
 * branch: their bytes are rare and pay for the extra hop.
 *
 * The cursor is drawn on exit and un-drawn on entry, except on the
 * printable path, which lets the glyph blit do the un-drawing. */
void
kfbcon_putc(int c)
{
  if (kfb_condark())
    return;
  c &= 0xFF;
  if (fstate != 0) {
    if (fcursor)
      cursor_xor();
    if (fstate == 1) {
      if (c == '[') {
        fstate = 2;
        fnpar = 0;
        fpriv = 0;
        fpar[0] = fpar[1] = fpar[2] = fpar[3] = 0;
      } else {
        fstate = 0;
      }
    } else {
      csi_byte(c);
    }
  } else if ((uint)(c - ' ') < 0x5Fu) {
    /* No entry un-draw here: the glyph covers the WHOLE cell, cursor
     * rows included, so the blit erases the old underline itself. That
     * is one of the two cursor_xor calls every printable byte used to
     * pay, and the more expensive half of the cursor. */
    draw_glyph(c);
    if (++fcx >= COLS)
      newline();
  } else {
    if (fcursor)
      cursor_xor();
    if (c == '\n') {
      newline();
    } else if (c == 0x1B) {
      fstate = 1;
    } else if (c == '\r') {
      fcx = 0;
    } else if (c == '\b') {
      if (fcx > 0)
        fcx--;
    } else if (c == '\t') {
      fcx = (fcx + 8) & ~7;
      if (fcx >= COLS)
        fcx = COLS - 1;
    }
  }
  cursor_xor();
  fcursor = 1;
}
