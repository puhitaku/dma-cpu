/* seq.c: the percussion sequencer demo. Five drums are SYNTHESIZED —
 * no samples shipped — by the DMA machine itself on first entry:
 *
 *   kick    triangle wave gliding down in pitch (808-style)
 *   snare   square wave, high and short
 *   tom     square wave, lower, with a slight droop
 *   hat     1-bit LFSR white noise, very short
 *   cymbal  1-bit LFSR white noise, long tail
 *
 * All envelopes are shift-subtract exponentials (a -= a >> k): no
 * multiplies, which this machine doesn't have. The rendered PCM
 * lives in the fixed audio region below the ring.
 *
 * Playback rides the existing ch9 ring stream: one sequencer step ==
 * one ring pass (4096 frames). At every ring wrap the machine
 * gdma-copies the next step's drum into the ring; the copier runs at
 * bus speed and laps the 44.1 kHz reader within the first frames, so
 * steps swap seamlessly. Tempo is the sample clock (snd_rate), kept
 * inside the amp's 30.4-50.4 kHz LRCLK band — faster tempo also
 * pitches the kit up, tape-style.
 */
#include "g.h"

#define NSTEP 16
#define NINST 6 /* 0 = rest */

#define DRUMS 0x2002E000u /* PCM arena below the ring (g.h) */

#define C_BG RGB(16, 10, 28)
#define C_TEXT RGB(190, 180, 210)
#define C_DIM RGB(100, 92, 125)
#define C_CUR RGB(255, 255, 255)
#define C_PLAY RGB(255, 210, 60)

/* per-instrument: PCM frames, cell color, letter */
static const int dlen[NINST] = {0, 2800, 1900, 2000, 800, 2700};
static uint daddr[NINST];
static const ushort dcol[NINST] = {
    RGB(34, 26, 52),  RGB(255, 90, 40),  RGB(255, 210, 60),
    RGB(60, 220, 120), RGB(70, 200, 230), RGB(190, 110, 255)};
static const char dletter[NINST] = {'.', 'K', 'S', 'T', 'H', 'C'};

static uchar pattern[NSTEP] = {1, 0, 4, 0, 2, 0, 4, 4,
                               1, 0, 4, 1, 2, 0, 5, 0};
static int rendered;

static uint
frame(int s)
{
  uint us = (ushort)s;
  return (us << 16) | us; /* L|R, same both */
}

static void
render_kick(volatile uint *d, int n)
{
  int val = 0, dir = 1, amp = 14000, slope = 150;
  for (int i = 0; i < n; i++) {
    val += dir > 0 ? slope : -slope;
    if (val >= amp) {
      val = amp;
      dir = -1;
    } else if (val <= -amp) {
      val = -amp;
      dir = 1;
    }
    if ((i & 7) == 0) {
      slope -= slope >> 8; /* the pitch glide */
      if (slope < 8)
        slope = 8;
    }
    amp -= amp >> 10; /* the body decay */
    d[i] = frame(val);
  }
}

static void
render_square(volatile uint *d, int n, int half, int glide, int amp, int dk)
{
  int ph = 0, pol = 1;
  for (int i = 0; i < n; i++) {
    if (++ph >= half) {
      ph = 0;
      pol = -pol;
    }
    if (glide && (i & 31) == 0)
      half++;
    amp -= amp >> dk;
    d[i] = frame(pol > 0 ? amp : -amp);
  }
}

static void
render_noise(volatile uint *d, int n, int amp, int dk)
{
  uint x = 0x1D872B41u;
  for (int i = 0; i < n; i++) {
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    amp -= amp >> dk;
    d[i] = frame((x & 1) ? amp : -amp);
  }
}

/* Steep fade-in/out on a drum's ends (48 frames ~= 1.1 ms each):
 * the raw waveforms start and stop mid-swing, and that step is an
 * audible pop. Shift-ladder scaling, 8-frame blocks — no multiplies. */
static uint
fade_frame(uint w, int sh)
{
  int s = (int)(short)(ushort)(w & 0xFFFFu);
  s >>= sh;
  uint us = (ushort)s;
  return (us << 16) | us;
}

static void
fade_ends(volatile uint *d, int n)
{
  for (int k = 0; k < 6; k++)
    for (int i = 0; i < 8; i++)
      d[k * 8 + i] = fade_frame(d[k * 8 + i], 6 - k);
  for (int k = 0; k < 6; k++)
    for (int i = 0; i < 8; i++) {
      int idx = n - 48 + k * 8 + i;
      d[idx] = fade_frame(d[idx], k + 1);
    }
}

static void
render_drums(void)
{
  uint a = DRUMS;
  for (int i = 1; i < NINST; i++) {
    daddr[i] = a;
    a += (uint)dlen[i] * 4;
  }
  render_kick((volatile uint *)daddr[1], dlen[1]);
  render_square((volatile uint *)daddr[2], dlen[2], 67, 0, 10000, 9);
  render_square((volatile uint *)daddr[3], dlen[3], 138, 1, 12000, 11);
  render_noise((volatile uint *)daddr[4], dlen[4], 9000, 7);
  render_noise((volatile uint *)daddr[5], dlen[5], 9000, 10);
  for (int i = 1; i < NINST; i++)
    fade_ends((volatile uint *)daddr[i], dlen[i]);
  rendered = 1;
}

/* --- UI: 16 steps as two rows of eight 26 px cells --- */

static int
cell_x(int i)
{
  return 6 + (i & 7) * 29;
}

static int
cell_y(int i)
{
  return i < 8 ? 64 : 104;
}

static void
draw_step(int i, int cursor)
{
  int x = cell_x(i), y = cell_y(i);
  uint inst = pattern[i];
  gfx_fill(x, y, 26, 26, dcol[inst]);
  if (inst) {
    char b[2];
    b[0] = dletter[inst];
    b[1] = 0;
    gfx_text(x + 9, y + 9, b, RGB(10, 8, 16), dcol[inst]);
  }
  gfx_rect(x, y, 26, 26, cursor ? 2 : 1,
           cursor ? C_CUR : RGB(60, 50, 84));
}

static void
draw_playhead(int prev, int i)
{
  if (prev >= 0)
    gfx_fill(cell_x(prev), cell_y(prev) + 27, 26, 3, C_BG);
  gfx_fill(cell_x(i), cell_y(i) + 27, 26, 3, C_PLAY);
}

static void
draw_tempo(int level)
{
  char b[2];
  b[0] = (char)('1' + level);
  b[1] = 0;
  gfx_text(140, 40, b, C_CUR, C_BG);
}

void
seq_run(void)
{
  uputs("seq: up\n");
  gfx_clear(C_BG);
  gfx_text2(48, 8, "SEQUENCER", C_PLAY, C_BG);
  if (!rendered) {
    /* 21 chars, centered both ways */
    gfx_text(36, 116, "Synthesizing Drums...", C_TEXT, C_BG);
    gfx_present();
    render_drums();
    gfx_fill(0, 116, LCD_W, 8, C_BG);
  }
  gfx_text(72, 40, "tempo", C_TEXT, C_BG);
  for (int i = 0; i < NSTEP; i++)
    draw_step(i, i == 0);
  gfx_text(6, 150, "K kick   S snare  T tom", C_TEXT, C_BG);
  gfx_text(6, 162, "H hat    C cymbal", C_TEXT, C_BG);
  gfx_text(6, 200, "l/r: step  press: change", C_DIM, C_BG);
  gfx_text(6, 212, "hold: exit  up/down: tempo", C_DIM, C_BG);

  /* tempo notch -> sample clock; both ends stay inside the amp's
   * LRCLK band. Level 4 ~= 44.1 kHz, a 93 ms step. Dividers are
   * anchored to clk_sys (fs = 1e9/div at 250 MHz) — scale with the
   * overclock, or the whole song plays faster. */
  static const uint tdiv[8] = {32875, 31000, 28750, 26500, 22675,
                               21250, 20500, 19875};
  int tempo = 4;
  snd_rate(tdiv[tempo]);
  draw_tempo(tempo);

  int cur = 0, step = -1, playhead = -1;
  uint hold = 0, prev_rd = 0;
  gdma_fill(AURING, 0, AURING_BYTES);
  gfx_present();

  for (;;) {
    frame_sync(4000); /* tight: wrap detection is the step clock */
    in_poll();
    if (in_edge & BTN_LEFT) {
      draw_step(cur, 0);
      cur = cur == 0 ? NSTEP - 1 : cur - 1;
      draw_step(cur, 1);
      gfx_present();
    }
    if (in_edge & BTN_RIGHT) {
      draw_step(cur, 0);
      cur = cur == NSTEP - 1 ? 0 : cur + 1;
      draw_step(cur, 1);
      gfx_present();
    }
    if (in_edge & BTN_A) {
      pattern[cur] = (uchar)((pattern[cur] + 1) % NINST);
      draw_step(cur, 1);
      gfx_present();
      uputs("seq: step set\n");
    }
    if (in_edge & BTN_UP && tempo < 7) {
      snd_rate(tdiv[++tempo]);
      draw_tempo(tempo);
      gfx_present();
    }
    if (in_edge & BTN_DOWN && tempo > 0) {
      snd_rate(tdiv[--tempo]);
      draw_tempo(tempo);
      gfx_present();
    }
    if (in_down & BTN_A)
      hold++;
    else
      hold = 0;
    if (hold > 300) { /* ~1.2 s at the 4 ms frame */
      gdma_fill(AURING, 0, AURING_BYTES);
      snd_rate(22675); /* back to 44.1 kHz for the tone engine */
      led(0, 0);
      uputs("seq: exit\n");
      return;
    }

    /* the step clock: ch9's read pointer wrapping the ring */
    uint rd = W32(DMACH(9) + 0x0);
    if (rd < prev_rd) {
      step = (step + 1) & (NSTEP - 1);
      uint inst = pattern[step];
      if (inst) {
        uint bytes = (uint)dlen[inst] * 4;
        gdma_copy(AURING, daddr[inst], bytes);
        gdma_fill(AURING + bytes, 0, AURING_BYTES - bytes);
      } else {
        gdma_fill(AURING, 0, AURING_BYTES);
      }
      draw_playhead(playhead, step);
      playhead = step;
      if (inst == 1)
        led(LED_BRIGHT(0xFF4000), 0); /* kick: warm flash */
      else if (inst == 2)
        led(0, LED_BRIGHT(0xFFFF40)); /* snare: the other one */
      else if (inst)
        led(LED_DIM(0x00FFFF), LED_DIM(0x00FFFF));
      else
        led(0, 0);
      gfx_present();
    }
    prev_rd = rd;
  }
}
