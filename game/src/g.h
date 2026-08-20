/* g.h: the gamepico bare-metal runtime's one header. No xv6, no libc
 * — the DMA machine drives every peripheral register itself, and the
 * ARM cores sleep. Register addresses are RP2040's (this board is
 * SKU-locked; the emulator models the same map). */
#ifndef GAME_G_H
#define GAME_G_H

typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;

#define W32(a) (*(volatile uint *)(a))

/* --- RP2040 fixed addresses --- */
#define IOBANK0 0x40014000u
#define PADSBANK0 0x4001C000u
#define TIMERAWL 0x40054028u /* microsecond counter, low word */
#define SPI0 0x4003C000u     /* PL022: CR0 +0, CR1 +4, DR +8, SR +C, CPSR +10 */
#define DMACH(n) (0x50000000u + (uint)(n) * 0x40u)

/* --- board wiring (see prompts/040) --- */
#define PIN_JOYA_UP 2 /* joystick A: GP2..GP6 = U D L R press */
#define PIN_JOYB_UP 7 /* joystick B: GP7..GP11 */
#define PIN_WS 12     /* two chained WS2811 */
#define PIN_I2S_BCLK 13
#define PIN_I2S_LRCLK 14
#define PIN_I2S_DIN 15
#define PIN_LCD_DC 16
#define PIN_LCD_CS 17
#define PIN_LCD_SCK 18
#define PIN_LCD_SDA 19
#define PIN_LCD_RES 20
#define PIN_LCD_BLK 21

#define LCD_W 240
#define LCD_H 240

/* grt.c: runtime */
void uputs(const char *s);
void uputn(uint v);
void uputhex(uint v);
uint now_us(void);
void delay_us(uint us);
void gpio_fn(int pin, uint funcsel);
void gpio_out(int pin, int hi);
int gpio_in_pu(int pin);
void gdma_copy(uint dst, uint src, uint bytes);
void gdma_fill(uint dst, uint word, uint bytes);
void gdma_spi16(uint src, uint halfwords); /* paced pixel stream */

/* lcd.c */
void lcd_init(void);
void lcd_flush(int x0, int y0, int x1, int y1); /* inclusive rect */

/* gfx.c */
extern ushort fb[LCD_W * LCD_H];
void gfx_clear(ushort c);
void gfx_fill(int x0, int y0, int w, int h, ushort c);
void gfx_text(int x, int y, const char *s, ushort fg, ushort bg);
void gfx_damage(int x0, int y0, int x1, int y1);
void gfx_present(void); /* flush the damage rect, reset it */

#define RGB(r, g, b) \
  ((ushort)((((r) & 0xF8) << 8) | (((g) & 0xFC) << 3) | (((b) & 0xF8) >> 3)))

#endif
