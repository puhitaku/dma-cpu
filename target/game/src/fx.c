/* fx.c: sound and light, machine-operated end to end. The DMA CPU
 * loads the PIO programs itself (instruction memory and SM config are
 * plain APB registers), then:
 *
 *  - PIO0 SM0 clocks I2S to the MAX98357 (BCLK/LRCLK/DIN = GP13..15).
 *    A free DMA channel (9 — the compact machine's IRQ injector,
 *    which the game build never arms) streams a 16 KiB ring of 32-bit
 *    frames into TXF0 forever, paced by the TX DREQ. Audio costs the
 *    machine nothing once armed: tones are made by writing a square
 *    wave into the ring and setting the pitch with SM0's CLKDIV.
 *  - PIO0 SM1 shifts WS2811 frames out of GP12. Two LEDs are two
 *    FIFO words, written directly — no DMA, no waiting.
 *
 * The amp's SD_MODE is strapped high (always on): the ring streams
 * silence between effects so the DAC never stops framing (no pops).
 */
#include "g.h"

#define PIO0 0x50200000u
#define PIO_CTRL (PIO0 + 0x000)
#define PIO_FSTAT (PIO0 + 0x004)
#define PIO_TXF0 (PIO0 + 0x010)
#define PIO_TXF1 (PIO0 + 0x014)
#define PIO_INSTR_MEM (PIO0 + 0x048)
#define SM0_CLKDIV (PIO0 + 0x0C8)
#define SM0_EXECCTRL (PIO0 + 0x0CC)
#define SM0_SHIFTCTRL (PIO0 + 0x0D0)
#define SM0_INSTR (PIO0 + 0x0D8)
#define SM0_PINCTRL (PIO0 + 0x0DC)
#define SM1_CLKDIV (PIO0 + 0x0E0)
#define SM1_EXECCTRL (PIO0 + 0x0E4)
#define SM1_SHIFTCTRL (PIO0 + 0x0E8)
#define SM1_INSTR (PIO0 + 0x0F0)
#define SM1_PINCTRL (PIO0 + 0x0F4)


/* Hand-assembled PIO programs (encodings per RP2040 datasheet 3.4).
 * 0..7: audio_i2s (.side_set 2: bit0 BCLK, bit1 LRCLK), 16-bit
 * stereo frames, autopull 32, 2 PIO cycles per bit, entry at 7.
 * 8..11: ws2811 (.side_set 1), 800 kHz at 10 cycles per bit,
 * autopull 24, shift left. */
static const ushort pioprog[12] = {
    0x7001, /* out pins,1   side 0b10 */
    0x1840, /* jmp x-- 0    side 0b11 */
    0x6001, /* out pins,1   side 0b00 */
    0xE82E, /* set x,14     side 0b01 */
    0x6001, /* out pins,1   side 0b00 */
    0x0844, /* jmp x-- 4    side 0b01 */
    0x7001, /* out pins,1   side 0b10 */
    0xF82E, /* set x,14     side 0b11 (entry) */
    0x6221, /* out x,1      side 0 [2] */
    0x112B, /* jmp !x,11    side 1 [1] */
    0x1408, /* jmp 8        side 1 [4] */
    0xA442, /* nop          side 0 [4] */
};

uint sndctrl; /* loader-poked ch9 CTRL: ring read -> TXF0, DREQ 0 */

void
snd_rate(uint div_fp8)
{
  W32(SM0_CLKDIV) = div_fp8 << 8;
}
static uint snd_frames; /* frames left of the current tone */

void
fx_init(void)
{
  /* GP12..15 to PIO0 (FUNCSEL 6) with the output-enable override the
   * machine already uses for plain GPIO (SIO is CPU-private). */
  for (int pin = PIN_WS; pin <= PIN_I2S_DIN; pin++)
    gpio_fn(pin, 6u | (3u << 12));
  for (int i = 0; i < 12; i++)
    W32(PIO_INSTR_MEM + 4u * (uint)i) = pioprog[i];
  /* SM0: I2S at fs = 44.1 kHz (div 88.57 at clk_sys 250 MHz — every
   * divider in this file is anchored to the firmware's overclock;
   * scale them together). The MAX98357 accepts
   * LRCLK only in discrete ranges — 22.05 kHz is by name NOT
   * supported (datasheet p.16) — and the widest range, 30.4-50.4
   * kHz, is continuous; everything here stays inside it. */
  W32(SM0_CLKDIV) = (88u << 16) | (147u << 8);
  W32(SM0_EXECCTRL) = 7u << 12; /* wrap 0..7 */
  W32(SM0_SHIFTCTRL) = 1u << 17; /* autopull, threshold 32, shift left */
  W32(SM0_PINCTRL) = (2u << 29) | (1u << 20) | ((uint)PIN_I2S_BCLK << 10) |
                     (uint)PIN_I2S_DIN;
  W32(SM0_INSTR) = 0x0007; /* jmp entry_point */
  /* SM1: WS2811. 10 PIO cycles per bit at 8 MHz -> 800 kHz
   * (250/31.25). */
  W32(SM1_CLKDIV) = (31u << 16) | (64u << 8);
  W32(SM1_EXECCTRL) = (11u << 12) | (8u << 7); /* wrap 8..11 */
  W32(SM1_SHIFTCTRL) = (1u << 17) | (24u << 25); /* autopull 24, left */
  W32(SM1_PINCTRL) = (1u << 29) | ((uint)PIN_WS << 10);
  W32(SM1_INSTR) = 0x0008; /* jmp bitloop */
  /* Silence into the ring, then let ch9 stream it forever (the count
   * is ~54 hours of audio; a demo reboots long before it runs dry). */
  gdma_fill(AURING, 0, AURING_BYTES);
  W32(DMACH(9) + 0x0) = AURING;
  W32(DMACH(9) + 0x4) = PIO_TXF0;
  W32(DMACH(9) + 0x8) = 0xFFFFFFFFu;
  W32(DMACH(9) + 0xC) = sndctrl;
  W32(PIO_CTRL) = 0x3; /* SM0 | SM1 on */
}

/* snd_play: a square wave, pitched inside the amp's clock window.
 * The MAX98357 tracks LRCLK only within its specified ranges, so the
 * sample rate fs = 1e9 / div_fp8 is clamped to the continuous
 * 30.4-50.4 kHz band, and coarser pitch comes from the ring period P
 * (a power of two, so the 1024-frame ring wraps seamlessly):
 * f = fs / P. Bands touch at geometric midpoints; a requested pitch
 * in a gap lands on the nearest band edge — bleep-grade tuning.
 * (The ring is 4096 frames now; the doubling loop just runs two more
 * rounds.) */
static uint sw_hz, sw_vol, sw_step; /* live sweep: Hz falls per tick */
static int nz_vol; /* noise voice level, fading per tick; 0 = off */

static void
tone_set(uint hz, uint vol)
{
  uint half, shift; /* half period in frames; shift = log2(P) */
  if (hz <= 216) {
    half = 128; /* P=256: 118-196 Hz */
    shift = 8;
  } else if (hz <= 432) {
    half = 64; /* P=128: 237-393 Hz */
    shift = 7;
  } else if (hz <= 864) {
    half = 32; /* P=64: 475-787 Hz */
    shift = 6;
  } else if (hz <= 1727) {
    half = 16; /* P=32: 950-1575 Hz */
    shift = 5;
  } else if (hz <= 3454) {
    half = 8; /* P=16: 1900-3150 Hz */
    shift = 4;
  } else {
    half = 4; /* P=8: 3800-6300 Hz */
    shift = 3;
  }
  uint div_fp8 = (1000000000u >> shift) / hz;
  if (div_fp8 > 32875) /* fs floor: 30.4 kHz */
    div_fp8 = 32875;
  if (div_fp8 < 19875) /* fs ceiling: 50.3 kHz */
    div_fp8 = 19875;
  W32(SM0_CLKDIV) = div_fp8 << 8;
  int s = (int)(vol << 6);
  uint hi = ((uint)(ushort)s << 16) | (ushort)s; /* L|R, same both */
  uint lo = ((uint)(ushort)-s << 16) | (ushort)-s;
  volatile uint *r = (volatile uint *)AURING;
  for (uint i = 0; i < half; i++)
    r[i] = hi;
  for (uint i = half; i < 2u * half; i++)
    r[i] = lo;
  for (uint sz = 8u * half; sz < AURING_BYTES; sz <<= 1)
    gdma_copy(AURING + sz, AURING, sz); /* double out to the full ring */
}

void
snd_play(uint hz, uint vol, uint frames)
{
  sw_step = 0;
  nz_vol = 0;
  tone_set(hz, vol);
  snd_frames = frames;
}

/* snd_sweep: a square that GLIDES down `step` Hz every frame — the
 * pew of a shot. Rides the tone engine; snd_tick re-pitches it. */
void
snd_sweep(uint hz, uint vol, uint frames, uint step)
{
  sw_hz = hz;
  sw_vol = vol;
  sw_step = step;
  nz_vol = 0;
  tone_set(hz, vol);
  snd_frames = frames;
}

/* Noise voice: a low crunchy burst, NES-style — a 16-bit LFSR picks
 * the level, HELD 16 samples so the energy sits low, and the
 * 1024-frame pattern doubles out to the ring (the short period IS
 * the classic metallic character). The LFSR shifts LEFT — feedback
 * read off the top bit — because a >> on this machine is a runtime
 * loop. snd_tick refills the SAME pattern at a decaying volume
 * (nz_vol, declared with the sweep state), so the crunch fades
 * instead of cutting. */
static void
noise_fill(uint vol)
{
  int s = (int)(vol << 6);
  uint hi = ((uint)(ushort)s << 16) | (ushort)s;
  uint lo = ((uint)(ushort)-s << 16) | (ushort)-s;
  volatile uint *r = (volatile uint *)AURING;
  uint lfsr = 0xBEEFu;
  for (uint i = 0; i < 1024u; i += 16) {
    uint w = (lfsr & 0x8000u) ? hi : lo;
    for (uint k = 0; k < 16u; k++)
      r[i + k] = w;
    uint b = lfsr ^ (lfsr << 2) ^ (lfsr << 3) ^ (lfsr << 5);
    lfsr = ((lfsr << 1) | ((b & 0x8000u) ? 1u : 0u)) & 0xFFFFu;
  }
  for (uint sz = 4096u; sz < AURING_BYTES; sz <<= 1)
    gdma_copy(AURING + sz, AURING, sz);
}

void
snd_noise(uint vol, uint frames)
{
  sw_step = 0;
  nz_vol = (int)vol;
  snd_rate(32875); /* fs floor 30.4 kHz: the growliest band */
  noise_fill(vol);
  snd_frames = frames;
}

/* --- PCM playback: mono 16-bit clips streamed from flash ---
 *
 * The ring channel (9) pauses (EN clear is the documented pause) and
 * the gdma helper channel (11) streams the clip as SIZE16 transfers
 * into TXF0, paced by the same DREQ. The RP2040 bus fabric
 * REPLICATES narrow IO writes across the 32-bit bus (datasheet
 * 2.1.4), so each mono halfword arrives as S:S — a full L|R frame,
 * full volume, zero conversion. The caller must sit on a static
 * screen: gdma helpers are off-limits while a clip plays (the two
 * users, the dino game-over and the LANWalk win, only poll input).
 * pcm_tick (from frame_sync) restores the ring when the clip ends.
 */

uint sfx_tab[4]; /* loader-poked: {addr,samples} x {dino,lanwalk} */
static uint pcm_active;

void
pcm_play(uint addr, uint samples)
{
  gd_wait();        /* an async lcd flush may still hold ch11 */
  snd_off();        /* cancel any tone; uses ch11 BEFORE we take it */
  snd_rate(22675); /* clips are 44.1 kHz (1e9/22675) */
  W32(DMACH(9) + 0x10) = sndctrl & ~1u; /* pause the ring stream */
  /* ch11: like the SPI pixel ctrl but paced by DREQ 0 (PIO0 TX0).
   * TREQ_SEL is bits 20:15 on RP2040 (this board is SKU-locked). */
  extern uint spictrl;
  W32(DMACH(11) + 0x0) = addr;
  W32(DMACH(11) + 0x4) = PIO_TXF0;
  W32(DMACH(11) + 0x8) = samples;
  W32(DMACH(11) + 0xC) = spictrl & ~(0x3Fu << 15);
  pcm_active = 1;
}

void
pcm_stop(void)
{
  if (!pcm_active)
    return;
  /* The documented-safe abort: pause first (EN clear), THEN abort
   * and wait for it to complete. Aborting a RUNNING channel is the
   * silicon wedge from prompts/040; a paused, DREQ-idle one is the
   * datasheet's own sequence. Without this, the next gdma helper
   * call would RESUME the half-played clip with a mem-copy CTRL and
   * sprint off through the address space (found in emulation). */
  W32(DMACH(11) + 0x10) = 0;
  W32(0x50000444u) = 1u << 11; /* CHAN_ABORT */
  while (W32(0x50000444u) & (1u << 11))
    ;
  W32(DMACH(9) + 0x10) = sndctrl; /* resume the (silent) ring */
  pcm_active = 0;
}

void
pcm_tick(void)
{
  if (pcm_active && W32(DMACH(11) + 0x8) == 0)
    pcm_stop();
}

/* snd_off: silence now — the ring zeroes and any pending tone
 * budget is dropped. */
void
snd_off(void)
{
  snd_frames = 0;
  sw_step = 0;
  nz_vol = 0;
  gdma_fill(AURING, 0, AURING_BYTES);
}

/* snd_tick: frame_sync calls this once per frame; the tone decays to
 * silence (a zeroed ring) when its budget runs out, and a live sweep
 * re-pitches on the way down. */
void
snd_tick(void)
{
  if (!snd_frames)
    return;
  if (--snd_frames == 0) {
    sw_step = 0;
    nz_vol = 0;
    gdma_fill(AURING, 0, AURING_BYTES);
  } else if (sw_step) {
    sw_hz = sw_hz > sw_step + 60u ? sw_hz - sw_step : 60u;
    tone_set(sw_hz, sw_vol);
  } else if (nz_vol > 0) {
    /* the crunch fades: ~-12%/frame reaches near-silence in a
     * second, and the final frame's hard cut lands inaudible */
    nz_vol -= nz_vol / 8 + 1;
    if (nz_vol < 0)
      nz_vol = 0;
    noise_fill((uint)nz_vol);
  }
}

/* --- LEDs: both WS2811s, colors as 0xRRGGBB. Wire order is GRB (the
 * common integrated parts); swap the packing here if the strip is an
 * RGB-order WS2811. Two words fit the four-deep FIFO, and the >50 us
 * frame gap latches automatically. Every path runs through a
 * per-channel hard cap (the global comfort ceiling); call sites pick
 * their tier with LED_BRIGHT/LED_DIM (g.h). Short animations
 * (rainbow, blink) overlay the base colors and restore them. */

#define LED_CAP 0x60u

static uint led_base0, led_base1;
static int leda_mode;  /* 0 none, 1 rainbow, 2 blink */
static uint leda_n;    /* frames left */
static uint leda_hue, leda_rgb, leda_phase;

static uint
led_capc(uint c)
{
  uint r = (c >> 16) & 0xFF, g = (c >> 8) & 0xFF, b = c & 0xFF;
  if (r > LED_CAP)
    r = LED_CAP;
  if (g > LED_CAP)
    g = LED_CAP;
  if (b > LED_CAP)
    b = LED_CAP;
  return (r << 16) | (g << 8) | b;
}

static void
led_raw(uint rgb0, uint rgb1)
{
  uint c[2];
  c[0] = led_capc(rgb0);
  c[1] = led_capc(rgb1);
  for (int i = 0; i < 2; i++) {
    uint grb = ((c[i] & 0x00FF00) << 8) | ((c[i] & 0xFF0000) >> 8) |
               (c[i] & 0x0000FF);
    while (W32(PIO_FSTAT) & (1u << 17)) /* SM1 TXFULL */
      ;
    W32(PIO_TXF1) = grb << 8; /* left-justify for shift-left autopull 24 */
  }
}

void
led(uint rgb0, uint rgb1)
{
  led_base0 = rgb0;
  led_base1 = rgb1;
  if (!leda_mode)
    led_raw(rgb0, rgb1);
}

void
led_rainbow(uint frames)
{
  leda_mode = 1;
  leda_n = frames;
  leda_hue = 0;
}

void
led_blink(uint rgb, uint cycles)
{
  leda_mode = 2;
  leda_rgb = rgb;
  leda_n = cycles * 8; /* 4 frames up, 4 down per cycle */
  leda_phase = 0;
}

/* folded triangle: a cheap smooth hue wheel with no multiplies */
static uint
tri8(uint x)
{
  x &= 0xFF;
  return x < 128 ? x << 1 : (255 - x) << 1;
}

static uint
wheel(uint h)
{
  return (tri8(h) << 16) | (tri8(h + 85) << 8) | tri8(h + 170);
}

/* scale a packed color to num/4 brightness, shifts only */
static uint
led_scale4(uint c, uint num)
{
  if (num == 0)
    return 0;
  if (num == 1)
    return (c >> 2) & 0x3F3F3F;
  if (num == 2)
    return (c >> 1) & 0x7F7F7F;
  if (num == 3)
    return ((c >> 1) & 0x7F7F7F) + ((c >> 2) & 0x3F3F3F);
  return c;
}

void
led_tick(void)
{
  if (!leda_mode)
    return;
  if (leda_n == 0) {
    leda_mode = 0;
    led_raw(led_base0, led_base1);
    return;
  }
  leda_n--;
  if (leda_mode == 1) { /* rainbow: two loops in ~30 frames */
    leda_hue += 17;
    led_raw(LED_BRIGHT(wheel(leda_hue)), LED_BRIGHT(wheel(leda_hue + 128)));
  } else { /* blink: linear tri-ramp, 4 frames per side */
    uint ph = leda_phase;
    leda_phase = ph == 7 ? 0 : ph + 1;
    uint up = ph < 4 ? ph : 8 - ph;
    uint c = led_scale4(LED_BRIGHT(leda_rgb), up);
    led_raw(c, c);
  }
}
