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

/* --- board wiring (see prompts/040) ---
 * Joysticks occupy GP2..GP11 but NOT in role order — the as-built
 * harness (input.c holds the tables):
 *   A: up=GP3 down=GP4 left=GP2 right=GP5 press=GP6
 *   B: up=GP8 down=GP9 left=GP7 right=GP10 press=GP11 */
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
void numstr(char *buf, int width, uint v); /* zero-padded decimal */
void numsp(char *buf, int width, uint v);  /* space-padded decimal */
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
void gfx_rect(int x0, int y0, int w, int h, int t, ushort c); /* outline */
void gfx_text(int x, int y, const char *s, ushort fg, ushort bg);
void gfx_text2(int x, int y, const char *s, ushort fg, ushort bg); /* 2x */
void gfx_blit(int x, int y, const ushort *src, int w, int h); /* opaque */
void gfx_sprite(const uint *rows, int w, int h, ushort fg, ushort bg,
                ushort *dst); /* 1bpp rows (MSB left) -> RGB565 */
void gfx_damage(int x0, int y0, int x1, int y1);
void gfx_present(void); /* flush the damage rect, reset it */

/* input.c: both joysticks merged, active-high bit set = engaged */
#define BTN_UP 0x01
#define BTN_DOWN 0x02
#define BTN_LEFT 0x04
#define BTN_RIGHT 0x08
#define BTN_A 0x10
extern uint in_down; /* held buttons */
extern uint in_edge; /* newly pressed since the previous poll */
void in_poll(void);
uint rng(void);           /* xorshift32, mixed with input timing */
uint rng_below(uint n);   /* uniform-ish 0..n-1 */
void frame_sync(uint us); /* pace the caller's loop to one tick per us */

/* fx.c: sound (PIO0 SM0 I2S + ring-streaming DMA) and light (PIO0
 * SM1 WS2811). snd_tick runs from frame_sync, so a tone's frame
 * budget counts in every loop that paces itself.
 * The audio ring is 16 KiB at a fixed 16 KiB-aligned address (the
 * ring wrap is an address mask): 4096 L|R frames, which is also one
 * sequencer step. Reserved region 0x2002C000..0x2003C000 holds the
 * drum PCM then the ring; dmxgen asserts the image stays clear. */
#define AURING 0x20038000u
#define AURING_BYTES 16384u
void fx_init(void);
void snd_play(uint hz, uint vol, uint frames); /* vol 0..255 */
void snd_rate(uint div_fp8); /* SM0 CLKDIV, keep 15900..26300 in-band */
void snd_tick(void);
void led(uint rgb0, uint rgb1); /* 0xRRGGBB each */
void seq_run(void); /* the percussion sequencer demo */

/* the games (each returns when the player exits to the menu) */
int menu_run(void); /* 0 Dinosaur, 1 LANWalk, 2 Yacht, 3 Sequencer */
void dino_run(void);
void lanwalk_run(void);
void yacht_run(void);

#define RGB(r, g, b) \
  ((ushort)((((r) & 0xF8) << 8) | (((g) & 0xFC) << 3) | (((b) & 0xF8) >> 3)))

#endif
