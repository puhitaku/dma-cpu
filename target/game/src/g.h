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

/* --- the shared game arena (grt.c) ---
 * Per-game bulk state lives in ONE buffer the ACTIVE game claims for
 * as long as it runs — games are mutually exclusive (menu -> one
 * game -> menu), so N games cost max(need), not sum, and a new game
 * adds ZERO static data as long as it fits. House rules:
 *   - a game lays its arrays out as offset macros over g_arena
 *     (radio.c's RAD_RAM pattern) and initializes EVERYTHING it
 *     reads at *_run() entry: no initializers, no cross-run state;
 *   - state that must survive between runs (the sequencer's edited
 *     pattern) stays static, and had better be small;
 *   - radiosity keeps its own window (RAD_RAM: the 15.9 KiB above
 *     the audio region) — its ~15.4 KiB doesn't fit here.
 * Word-backed so every offset may be cast to any element type. */
#define GARENA_SZ 9216
extern uint arena_w[GARENA_SZ / 4]; /* symbol g_arena_w */
#define g_arena ((uchar *)arena_w)

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
void gpio_in_init(int pin); /* enable the pull-up, once */
uint gpio_in(int pin);      /* raw masked level: nonzero = high */
void gd_wait(void); /* ch11 idle (async lcd flush may be draining) */
void gdma_copy(uint dst, uint src, uint bytes);
void gdma_fill(uint dst, uint word, uint bytes);
void gdma_spi16(uint src, uint halfwords); /* paced pixel stream */
void gdma_rows(uint dst, uint src, uint words, int rows, uint dstride,
               uint sstride); /* 2-write row loop (AL3 trigger) */
void gdma_spi_rows(uint src, uint halfwords, int rows,
                   uint sstride); /* 1-write row loop into the SPI */

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
void gfx_glyph_cell(int ch, ushort fg, ushort bg,
                    ushort *dst); /* one 8x8 font glyph -> 64 pixels */
void gfx_disc_cell(int cw, int r, ushort fg, ushort bg,
                   ushort *dst); /* filled disc in a cw x cw cell;
                                  * multiply-heavy, init-time only */
int gfx_cell_runs(const ushort *cell, int cw, int ch, ushort bg,
                  uchar *out, int cap); /* exact silhouette runs, for */
void gfx_blit_runs(int x, int y, const ushort *src, int cw, int ch,
                   const uchar *rt); /* ...true-transparency blits */
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
 * ring wrap is an address mask): 4096 L|R frames. Reserved region
 * 0x20038000..0x2003C000 is the ring; dmxgen asserts the image stays
 * clear. (The drum PCM lives in the flash blob — synthesized at build
 * time by gameassets.) */
#define AURING 0x20038000u
#define AURING_BYTES 16384u
void fx_init(void);
void snd_play(uint hz, uint vol, uint frames); /* vol 0..255 */
void snd_sweep(uint hz, uint vol, uint frames, uint step); /* -step Hz/frame */
void snd_noise(uint vol, uint frames); /* low LFSR noise burst */
void snd_rate(uint div_fp8); /* SM0 CLKDIV, keep 19875..32875 in-band */
void snd_off(void); /* silence immediately */
extern uint sfx_tab[4]; /* {addr,samples} x {dino_fail, lanwalk_success} */
void pcm_play(uint addr, uint samples); /* mono 16-bit clip from flash */
void pcm_stop(void);
void pcm_tick(void);
void snd_tick(void);
void led(uint rgb0, uint rgb1); /* 0xRRGGBB each; per-channel capped */
void led_rainbow(uint frames);   /* fast hue loop, then back to base */
void led_blink(uint rgb, uint cycles); /* tri-ramp blink, 4 f/side */
void led_tick(void); /* frame_sync drives the animations */

/* Global LED brightness tiers: write call sites with full-saturation
 * colors and wrap them — the scale plus led()'s hard cap keeps both
 * WS2811s even and comfortable everywhere. */
#define LED_BRIGHT(c) (((c) >> 2) & 0x3F3F3F)
#define LED_DIM(c) (((c) >> 4) & 0x0F0F0F)
void seq_run(void); /* the percussion sequencer demo */

/* the games (each returns when the player exits to the menu) */
int menu_run(void); /* index into menu.c's names[] */
void dino_run(void);
void lanwalk_run(void);
void yacht_run(void);
void cpumon_run(void); /* the "CPU is asleep" monitor */
void bench_run(void);  /* the fixed-work MIPS benchmark */
void radio_run(void);  /* progressive radiosity in the light box */
void boing_run(void);  /* the precomputed bouncing-ball demo */
void chute_run(void);  /* Parachute: defend the turret */
void puni_run(void);   /* Puni Puni: falling-pairs chain puzzle */

#define RGB(r, g, b) \
  ((ushort)((((r) & 0xF8) << 8) | (((g) & 0xFC) << 3) | (((b) & 0xF8) >> 3)))

#endif
