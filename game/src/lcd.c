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

/* Frame size switch: PL022 wants SSE off while CR0 changes. */
static void
spi_bits(uint n)
{
  spi_wait_idle();
  W32(SPI_CR1) = 0;            /* SSE off */
  W32(SPI_CR0) = (n - 1) & 0xF; /* DSS; SPO/SPH 0 (mode 0), SCR 0 */
  W32(SPI_CR1) = 2;            /* SSE on */
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
  /* SPI0: CPSR=2, SCR=0 -> clk_peri/2 = 62.5 MHz at the board's
   * repurposed 125 MHz peri clock (the ST7789V serial-write limit). */
  W32(SPI_CR1) = 0;
  W32(SPI_CPSR) = 2;
  W32(SPI_CR0) = 7;    /* 8-bit frames, mode 0 */
  W32(SPI_DMACR) = 2;  /* TXDMAE: without it the PL022 never raises the
                        * TX DREQ and the paced pixel channel starves
                        * (found on silicon: flush hung at row 0) */
  W32(SPI_CR1) = 2;    /* SSE */
  gpio_fn(PIN_LCD_SCK, 1);  /* FUNCSEL 1 = SPI */
  gpio_fn(PIN_LCD_SDA, 1);
  gpio_out(PIN_LCD_CS, 0); /* one device: CS held low */
  gpio_out(PIN_LCD_DC, 1);
  gpio_out(PIN_LCD_BLK, 1); /* backlight on */

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
  lcd_cmd(0x29); /* DISPON */
  delay_us(20000);
}

/* Send the framebuffer rect [x0..x1]x[y0..y1] (inclusive). */
void
lcd_flush(int x0, int y0, int x1, int y1)
{
  lcd_cmd(0x2A); /* CASET */
  lcd_dat((uint)x0 >> 8);
  lcd_dat((uint)x0);
  lcd_dat((uint)x1 >> 8);
  lcd_dat((uint)x1);
  lcd_cmd(0x2B); /* RASET */
  lcd_dat((uint)y0 >> 8);
  lcd_dat((uint)y0);
  lcd_dat((uint)y1 >> 8);
  lcd_dat((uint)y1);
  lcd_cmd(0x2C); /* RAMWR */
  spi_bits(16);
  uint w = (uint)(x1 - x0 + 1);
  for (int y = y0; y <= y1; y++) {
    uint row = (uint)&fb[y * LCD_W + x0];
    gdma_spi16(row, w);
  }
  spi_bits(8);
}
