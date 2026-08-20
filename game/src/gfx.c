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

void
gfx_fill(int x, int y, int w, int h, ushort c)
{
  if (w <= 0 || h <= 0)
    return;
  for (int r = 0; r < h; r++) {
    ushort *p = &fb[(y + r) * LCD_W + x];
    /* row fill: word-wide when aligned and even, else scalar */
    if (((uint)p & 3) == 0 && (w & 1) == 0)
      gdma_fill((uint)p, (uint)c | ((uint)c << 16), (uint)w * 2);
    else
      for (int i = 0; i < w; i++)
        p[i] = c;
  }
  gfx_damage(x, y, x + w - 1, y + h - 1);
}

void
gfx_text(int x, int y, const char *s, ushort fg, ushort bg)
{
  int cx = x;
  for (; *s; s++, cx += 8) {
    const uchar *g = &fbfont[(uint)(*s & 0x7F) * 8];
    for (int r = 0; r < 8; r++) {
      ushort *p = &fb[(y + r) * LCD_W + cx];
      uint bits = g[r];
      for (int i = 0; i < 8; i++)
        p[i] = (bits & (0x80u >> i)) ? fg : bg;
    }
  }
  gfx_damage(x, y, cx - 1, y + 7);
}
