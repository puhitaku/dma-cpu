/* lcd.c: ST7789V over SPI0, 4-wire write-only (the M154 module brings
 * out no TE and no MISO — init is blind, tear-sync impossible; damage
 * rects keep write windows short instead). Commands go as 8-bit SPI
 * frames with D/C low, parameters as 8-bit with D/C high, and pixel
 * runs as 16-bit frames streamed by the DREQ-paced helper channel —
 * RGB565 big-endian for free, since SPI shifts MSB first. */
#include "g.h"

#define SPI_CR0 (SPI0 + 0x0)
#define SPI_CR1 (SPI0 + 0x4)
#define SPI_DR (SPI0 + 0x8)
#define SPI_SR (SPI0 + 0xC)
#define SPI_CPSR (SPI0 + 0x10)
#define SPI_DMACR (SPI0 + 0x24)

static void
spi_wait_idle(void)
{
  while (W32(SPI_SR) & 0x10) /* BSY */
    ;
}

/* Frame size switch: PL022 wants SSE off while CR0 changes.
 * SPI mode 3 (SPO|SPH, bits 6-7), not mode 0: with CS strapped low
 * the ST7789 counts clock edges continuously, and an idle-low clock
 * miscounts the first edge — the classic dark-panel failure of
 * CS-less ST7789 wiring. Mode 3 idles the clock high. */
static uint spi16; /* current frame size (the async flush leaves 16) */

static void
spi_bits(uint n)
{
  spi16 = n == 16;
  spi_wait_idle();
  W32(SPI_CR1) = 0;                    /* SSE off */
  W32(SPI_CR0) = ((n - 1) & 0xF) | 0xC0; /* DSS; mode 3; SCR 0 */
  W32(SPI_CR1) = 2;                    /* SSE on */
}

static void
spi_put8(uint b)
{
  while (!(W32(SPI_SR) & 0x2)) /* TNF */
    ;
  W32(SPI_DR) = b & 0xFF;
}

static void
lcd_cmd(uint c)
{
  gd_wait(); /* an async flush may still own the wire */
  if (spi16)
    spi_bits(8);
  spi_wait_idle();
  gpio_out(PIN_LCD_DC, 0);
  spi_put8(c);
  spi_wait_idle();
  gpio_out(PIN_LCD_DC, 1);
}

static void
lcd_dat(uint d)
{
  spi_put8(d);
}

void
lcd_init(void)
{
  /* SPI0: CPSR=4, SCR=0 -> clk_peri/4 = 31.25 MHz. The ST7789V spec
   * ceiling is 62.5 MHz (CPSR=2), but that leaves zero margin over
   * jumper wires; a full-screen flush at 31.25 MHz is ~30 ms, plenty
   * for every screen here. Dial CPSR back to 2 once the panel is on
   * a soldered harness. */
  W32(SPI_CR1) = 0;
  W32(SPI_CPSR) = 4;
  W32(SPI_CR0) = 7 | 0xC0; /* 8-bit frames, mode 3 (see spi_bits) */
  W32(SPI_DMACR) = 2;  /* TXDMAE: without it the PL022 never raises the
                        * TX DREQ and the paced pixel channel starves
                        * (found on silicon: flush hung at row 0) */
  W32(SPI_CR1) = 2;    /* SSE */
  gpio_fn(PIN_LCD_SCK, 1);  /* FUNCSEL 1 = SPI */
  gpio_fn(PIN_LCD_SDA, 1);
  gpio_out(PIN_LCD_CS, 0); /* one device: CS held low */
  gpio_out(PIN_LCD_DC, 1);
  gpio_out(PIN_LCD_BLK, 0); /* dark until the GRAM is clean */

  gpio_out(PIN_LCD_RES, 0); /* hardware reset pulse */
  delay_us(20000);
  gpio_out(PIN_LCD_RES, 1);
  delay_us(120000);

  lcd_cmd(0x11); /* SLPOUT */
  delay_us(120000);
  lcd_cmd(0x3A); /* COLMOD: 16bpp */
  lcd_dat(0x55);
  lcd_cmd(0x36); /* MADCTL: row/col order default, RGB */
  lcd_dat(0x00);
  lcd_cmd(0x21); /* INVON: these IPS panels are inverted */
  lcd_cmd(0x13); /* NORON */
  /* The controller's GRAM powers up as noise: paint it black (fb is
   * still all-zero here) BEFORE the panel shows anything, then turn
   * the display and backlight on — no garbled boot flash. */
  lcd_flush(0, 0, LCD_W - 1, LCD_H - 1);
  lcd_cmd(0x29); /* DISPON */
  delay_us(20000);
  gpio_out(PIN_LCD_BLK, 1); /* backlight on over a clean screen */
}

/* Send the framebuffer rect [x0..x1]x[y0..y1] (inclusive). */
void
lcd_flush(int x0, int y0, int x1, int y1)
{
  /* A rect at least half the panel wide is widened to FULL width:
   * fb rows are contiguous, so the whole flush becomes one burst on
   * the contiguous fast path and runs out asynchronously while the
   * machine computes (the extra pixels carry their own fb values —
   * visually identical). Narrow rects (sprites) keep the strided
   * path: widening those would multiply their wire time. */
  if ((x1 - x0) * 2 >= LCD_W - 2) {
    x0 = 0;
    x1 = LCD_W - 1;
  }
  /* high address bytes are always zero on a 240 px panel — and on
   * this machine a >>8 is a runtime loop, so spell out the zeros */
  lcd_cmd(0x2A); /* CASET */
  lcd_dat(0);
  lcd_dat((uint)x0);
  lcd_dat(0);
  lcd_dat((uint)x1);
  lcd_cmd(0x2B); /* RASET */
  lcd_dat(0);
  lcd_dat((uint)y0);
  lcd_dat(0);
  lcd_dat((uint)y1);
  lcd_cmd(0x2C); /* RAMWR */
  spi_bits(16);
  gdma_spi_rows((uint)&fb[y0 * LCD_W + x0], (uint)(x1 - x0 + 1),
                y1 - y0 + 1, LCD_W * 2);
  /* NO trailing drain: the flush runs out asynchronously while the
   * machine computes; the next lcd_cmd/gdma op gd_waits and drops
   * the frame size back to 8 bits before touching the wire. */
}
