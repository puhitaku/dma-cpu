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
  if (w <= 0 || h <= 0)
    return;
  ushort *p = &fb[y * LCD_W + x];
  if (((uint)p & 3) == 0 && (w & 1) == 0) {
    fillword = (uint)c | ((uint)c << 16);
    gdma_rows((uint)p, (uint)&fillword, halfof(w), h, LCD_W * 2, 0);
  } else {
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
  for (; *s && cx + 8 <= LCD_W; s++, cx += 8) {
    const uchar *g = &fbfont[(uint)(*s & 0x7F) * 8];
    for (int r = 0; r < 8; r++) {
      ushort *p = &fb[(y + r) * LCD_W + cx];
      uint bits = g[r];
      /* LEFT-running mask, walking pixels right-to-left: on this
       * machine << 1 is one sniff double, while ANY >> — even >> 1 —
       * is a ~30-iteration runtime loop (rt_lshr was 75%% of the
       * frame in the sampling profile) */
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
