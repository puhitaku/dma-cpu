/* fx.c: sound and light, machine-operated end to end. The DMA CPU
 * loads the PIO programs itself (instruction memory and SM config are
 * plain APB registers), then:
 *
 *  - PIO0 SM0 clocks I2S to the MAX98357 (BCLK/LRCLK/DIN = GP13..15).
 *    A free DMA channel (9 — the compact machine's IRQ injector,
 *    which the game build never arms) streams a 4 KiB ring of 32-bit
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

/* The audio ring: fixed, 4096-aligned (the ring wrap is an address
 * mask), above the data segment and below the machine scratch word.
 * dmxgen asserts the segments stay clear of it. */
#define AURING 0x2003C000u
#define AURING_BYTES 4096u

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

uint sndctrl;     /* loader-poked ch9 CTRL: ring read -> TXF0, DREQ 0 */
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
  /* SM0: I2S at fs = 44.1 kHz (div 70.86). The MAX98357 accepts
   * LRCLK only in discrete ranges — 22.05 kHz is by name NOT
   * supported (datasheet p.16) — and the widest range, 30.4-50.4
   * kHz, is continuous; everything here stays inside it. */
  W32(SM0_CLKDIV) = (70u << 16) | (220u << 8);
  W32(SM0_EXECCTRL) = 7u << 12; /* wrap 0..7 */
  W32(SM0_SHIFTCTRL) = 1u << 17; /* autopull, threshold 32, shift left */
  W32(SM0_PINCTRL) = (2u << 29) | (1u << 20) | ((uint)PIN_I2S_BCLK << 10) |
                     (uint)PIN_I2S_DIN;
  W32(SM0_INSTR) = 0x0007; /* jmp entry_point */
  /* SM1: WS2811. 10 PIO cycles per bit at 8 MHz -> 800 kHz. */
  W32(SM1_CLKDIV) = 25u << 16;
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
 * sample rate fs = 800e6 / div_fp8 is clamped to the continuous
 * 30.4-50.4 kHz band, and coarser pitch comes from the ring period P
 * (a power of two, so the 1024-frame ring wraps seamlessly):
 * f = fs / P. Bands touch at geometric midpoints; a requested pitch
 * in a gap lands on the nearest band edge — bleep-grade tuning. */
void
snd_play(uint hz, uint vol, uint frames)
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
  uint div_fp8 = (800000000u >> shift) / hz;
  if (div_fp8 > 26300) /* fs floor: 30.4 kHz */
    div_fp8 = 26300;
  if (div_fp8 < 15900) /* fs ceiling: 50.4 kHz */
    div_fp8 = 15900;
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
  snd_frames = frames;
}

/* snd_tick: frame_sync calls this once per frame; the tone decays to
 * silence (a zeroed ring) when its budget runs out. */
void
snd_tick(void)
{
  if (snd_frames && --snd_frames == 0)
    gdma_fill(AURING, 0, AURING_BYTES);
}

/* led: both WS2811s, colors as 0xRRGGBB. Wire order is GRB (the
 * common integrated parts); swap the packing here if the strip is an
 * RGB-order WS2811. Two words fit the four-deep FIFO, and the >50 us
 * frame gap latches automatically. */
void
led(uint rgb0, uint rgb1)
{
  uint c[2];
  c[0] = rgb0;
  c[1] = rgb1;
  for (int i = 0; i < 2; i++) {
    uint grb = ((c[i] & 0x00FF00) << 8) | ((c[i] & 0xFF0000) >> 8) |
               (c[i] & 0x0000FF);
    while (W32(PIO_FSTAT) & (1u << 17)) /* SM1 TXFULL */
      ;
    W32(PIO_TXF1) = grb << 8; /* left-justify for shift-left autopull 24 */
  }
}
