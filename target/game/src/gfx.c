/* gfx.c: RGB565 framebuffer with single-bounding-rect damage. The
 * panel is write-only, so composition happens here and lcd_flush
 * ships only what changed since the last present. */
#include "g.h"
#include "../../xv6/dma/kfbfont.h" /* shared 8x8 console font */

ushort fb[LCD_W * LCD_H];

static int dx0, dy0, dx1, dy1; /* damage bounds; dx0 > dx1 = clean */

static void
damage_reset(void)
{
  dx0 = LCD_W;
  dy0 = LCD_H;
  dx1 = -1;
  dy1 = -1;
}

void
gfx_damage(int x0, int y0, int x1, int y1)
{
  if (x0 < 0)
    x0 = 0;
  if (y0 < 0)
    y0 = 0;
  if (x1 >= LCD_W)
    x1 = LCD_W - 1;
  if (y1 >= LCD_H)
    y1 = LCD_H - 1;
  if (x0 > x1 || y0 > y1)
    return;
  if (x0 < dx0)
    dx0 = x0;
  if (y0 < dy0)
    dy0 = y0;
  if (x1 > dx1)
    dx1 = x1;
  if (y1 > dy1)
    dy1 = y1;
}

void
gfx_present(void)
{
  if (dx1 < dx0)
    return;
  lcd_flush(dx0, dy0, dx1, dy1);
  damage_reset();
}

void
gfx_clear(ushort c)
{
  uint w = (uint)c | ((uint)c << 16);
  gdma_fill((uint)fb, w, sizeof fb);
  gfx_damage(0, 0, LCD_W - 1, LCD_H - 1);
}

static uint fillword; /* gdma_rows refill source for fills */

/* halve a small count without a shift: w>>1 is a ~30-iteration
 * runtime call, and clang idiom-recognizes a counting loop right
 * back into one — a lookup table is safe from both. */
static uchar half_tab[LCD_W + 1];

static uint
halfof(int w)
{
  if (half_tab[2] == 0) { /* build once */
    uint n = 0;
    for (int i = 0; i <= LCD_W; i++) {
      half_tab[i] = (uchar)n;
      if (i & 1)
        n++;
    }
  }
  return half_tab[w];
}

void
gfx_fill(int x, int y, int w, int h, ushort c)
{
  if (x < 0) { /* clip: sprites enter and leave along every edge */
    w += x;
    x = 0;
  }
  if (y < 0) {
    h += y;
    y = 0;
  }
  if (x + w > LCD_W)
    w = LCD_W - x;
  if (y + h > LCD_H)
    h = LCD_H - y;
  if (w <= 0 || h <= 0)
    return;
  ushort *p = &fb[y * LCD_W + x];
  if (((uint)p & 3) == 0 && (w & 1) == 0) {
    fillword = (uint)c | ((uint)c << 16);
    gdma_rows((uint)p, (uint)&fillword, halfof(w), h, LCD_W * 2, 0);
  } else {
    /* CPU stores must not race a draining gdma op or the async lcd
     * flush over the same fb bytes: a prior fill's LAST row (or the
     * flush) lands AFTER these stores and eats them — the source of
     * parity-dependent sprite holes (TestZZChuteTrace). */
    gd_wait();
    for (int r = 0; r < h; r++, p += LCD_W)
      for (int i = 0; i < w; i++)
        p[i] = c;
  }
  gfx_damage(x, y, x + w - 1, y + h - 1);
}

void
gfx_text(int x, int y, const char *s, ushort fg, ushort bg)
{
  int cx = x;
  gd_wait(); /* CPU stores below; see gfx_fill's CPU branch */
  for (; *s && cx + 8 <= LCD_W; s++, cx += 8) {
    const uchar *g = &fbfont[(uint)(*s & 0x7F) * 8];
    for (int r = 0; r < 8; r++) {
      ushort *p = &fb[(y + r) * LCD_W + cx];
      uint bits = g[r];
      /* LEFT-running mask, walking pixels right-to-left: on this
       * machine << 1 is one sniff double, while ANY >> is a runtime
       * call — rt_ashr rebuilds the word bit by bit, and even
       * rt_lshr's sub-16 bit-reversal path costs ~25 instructions
       * (rt_lshr was 75%% of the frame in the sampling profile) */
      uint mask = 1;
      for (int i = 7; i >= 0; i--, mask <<= 1)
        p[i] = (bits & mask) ? fg : bg;
    }
  }
  gfx_damage(x, y, cx - 1, y + 7);
}

void
gfx_text2(int x, int y, const char *s, ushort fg, ushort bg)
{
  int cx = x;
  gd_wait(); /* CPU stores below; see gfx_fill's CPU branch */
  for (; *s && cx + 16 <= LCD_W; s++, cx += 16) {
    const uchar *g = &fbfont[(uint)(*s & 0x7F) * 8];
    for (int r = 0; r < 8; r++) {
      ushort *p = &fb[(y + r * 2) * LCD_W + cx];
      uint bits = g[r];
      uint mask = 1; /* left-running mask: see gfx_text */
      for (int i = 7; i >= 0; i--, mask <<= 1) {
        ushort c = (bits & mask) ? fg : bg;
        p[i * 2] = c;
        p[i * 2 + 1] = c;
        p[LCD_W + i * 2] = c;
        p[LCD_W + i * 2 + 1] = c;
      }
    }
  }
  gfx_damage(x, y, cx - 1, y + 15);
}

void
gfx_rect(int x, int y, int w, int h, int t, ushort c)
{
  gfx_fill(x, y, w, t, c);
  gfx_fill(x, y + h - t, w, t, c);
  gfx_fill(x, y + t, t, h - 2 * t, c);
  gfx_fill(x + w - t, y + t, t, h - 2 * t, c);
}

/* Opaque blit; clips to the screen. Copies stay word-wide when the
 * caller keeps x and w even (gdma_copy falls back to a slow byte loop
 * otherwise, so sprite movers should move in 2 px steps). */
void
gfx_blit(int x, int y, const ushort *src, int w, int h)
{
  int sx = 0, sy = 0;
  if (x < 0) {
    sx = -x;
    sx += sx & 1; /* keep the copy 4-byte aligned */
    x += sx;
    w -= sx;
  }
  if (y < 0) {
    sy = -y;
    y = 0;
    h -= sy;
  }
  int cw = w, ch = h;
  if (x + cw > LCD_W)
    cw = LCD_W - x;
  cw &= ~1;
  if (y + ch > LCD_H)
    ch = LCD_H - y;
  if (cw <= 0 || ch <= 0)
    return;
  const ushort *row = src + sx;
  for (int r = 0; r < sy; r++)
    row += w + sx; /* original stride is the unclipped width */
  if ((((uint)row | (uint)&fb[y * LCD_W + x]) & 3) == 0)
    gdma_rows((uint)&fb[y * LCD_W + x], (uint)row, halfof(cw), ch,
              LCD_W * 2, ((uint)w + (uint)sx) * 2);
  else
    for (int r = 0; r < ch; r++) {
      gdma_copy((uint)&fb[(y + r) * LCD_W + x], (uint)row, (uint)cw * 2);
      row += w + sx;
    }
  gfx_damage(x, y, x + cw - 1, y + ch - 1);
}

/* gfx_cell_runs: extract the EXACT opaque silhouette of a cw x ch
 * cell whose transparent color is exactly `bg`, as a run table:
 * per row, {uchar n, then n x {uchar x0, uchar w}} — every run is
 * pixel-precise, no rounding, no bounding-box interior (a dino row
 * spanning tail to head keeps the sky between them transparent).
 * Returns the table length in bytes, or -1 when it would exceed
 * cap (the caller sized the arena slot short). Init-time only. */
int
gfx_cell_runs(const ushort *cell, int cw, int ch, ushort bg, uchar *out,
              int cap)
{
  int len = 0;
  for (int r = 0; r < ch; r++) {
    const ushort *row = cell + r * cw;
    int nslot = len++;
    if (len > cap)
      return -1;
    int n = 0, i = 0;
    while (i < cw) {
      while (i < cw && row[i] == bg)
        i++;
      if (i >= cw)
        break;
      int x0 = i;
      while (i < cw && row[i] != bg)
        i++;
      if (len + 2 > cap)
        return -1;
      out[len] = (uchar)x0;
      out[len + 1] = (uchar)(i - x0);
      len += 2;
      n++;
    }
    out[nslot] = (uchar)n;
  }
  return len;
}

/* gfx_blit_runs: TRUE-transparency blit of a cell through its run
 * table — only the silhouette's pixels land, so an overlapped
 * neighbor keeps everything outside it. Each run's odd edge pixels
 * are stored by the machine and the even interior rides one ch11
 * copy, so arbitrary run boundaries stay off the byte-loop slow
 * path. Clips on every edge; callers keep x even (the cells sit
 * word-aligned in the arena). */
void
gfx_blit_runs(int x, int y, const ushort *src, int cw, int ch,
              const uchar *rt)
{
  gd_wait(); /* edge pixels are CPU stores; see gfx_fill's CPU branch */
  uint dstrow = (uint)fb + (uint)((y * LCD_W + x) * 2);
  uint srow = (uint)src;
  for (int r = 0; r < ch; r++) {
    int n = *rt++;
    int yy = y + r;
    for (int k = 0; k < n; k++) {
      int lo = x + rt[0];
      int hi = lo + rt[1];
      rt += 2;
      if (yy < 0 || yy >= LCD_H)
        continue;
      if (lo < 0)
        lo = 0;
      if (hi > LCD_W)
        hi = LCD_W;
      if (hi <= lo)
        continue;
      uint d = dstrow + (uint)(lo - x) * 2;
      uint s = srow + (uint)(lo - x) * 2;
      if (lo & 1) { /* odd left edge: one machine store */
        *(ushort *)d = *(const ushort *)s;
        lo++;
        d += 2;
        s += 2;
      }
      if ((hi - lo) & 1) { /* odd right edge likewise */
        hi--;
        *(ushort *)(dstrow + (uint)(hi - x) * 2) =
            *(const ushort *)(srow + (uint)(hi - x) * 2);
      }
      if (hi > lo)
        gdma_copy(d, s, (uint)(hi - lo) * 2);
    }
    dstrow += LCD_W * 2;
    srow += (uint)cw * 2;
  }
  gfx_damage(x, y, x + cw - 1, y + ch - 1);
}

/* gfx_disc_cell: render a filled disc of radius r centered in a
 * cw x cw cell (background baked into the corners, so a cell blit
 * erases as it draws — the dino margin trick, round). Doubled
 * coordinates keep the circle centered on the even-sized cell.
 * Multiply-heavy, so INIT-TIME ONLY: a game renders its discs into
 * the arena once at entry and blits ever after. */
void
gfx_disc_cell(int cw, int r, ushort fg, ushort bg, ushort *dst)
{
  int rr = 4 * r * r;
  for (int y = 0; y < cw; y++) {
    int dy = 2 * y - cw + 1;
    for (int x = 0; x < cw; x++) {
      int dx = 2 * x - cw + 1;
      dst[y * cw + x] = (dx * dx + dy * dy <= rr) ? fg : bg;
    }
  }
}

/* gfx_glyph_cell: render one font glyph into a 64-pixel cell, so hot
 * paths can blit text instead of re-rendering it per pixel (the
 * dino's score draw was ~60%% of its frame). */
void
gfx_glyph_cell(int ch, ushort fg, ushort bg, ushort *dst)
{
  const uchar *g = &fbfont[(uint)(ch & 0x7F) * 8];
  int idx = 0;
  for (int r = 0; r < 8; r++) {
    uint bits = g[r];
    uint mask = 1;
    for (int i = 7; i >= 0; i--, mask <<= 1)
      dst[idx + i] = (bits & mask) ? fg : bg;
    idx += 8;
  }
}

/* Render a 1bpp bitmap (each row a 32-bit word, MSB = leftmost pixel)
 * into an RGB565 buffer with the background baked in, so blits stay
 * opaque rectangle copies. */
void
gfx_sprite(const uint *rows, int w, int h, ushort fg, ushort bg, ushort *dst)
{
  int idx = 0;
  for (int r = 0; r < h; r++) {
    uint bits = rows[r];
    uint mask = 1u << (32 - w); /* left-running mask: see gfx_text */
    for (int c = w - 1; c >= 0; c--, mask <<= 1)
      dst[idx + c] = (bits & mask) ? fg : bg;
    idx += w;
  }
}
