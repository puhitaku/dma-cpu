/* seq.c: the percussion sequencer demo. Five drums are SYNTHESIZED —
 * no samples recorded — kick (gliding triangle), snare/tom (squares),
 * hat/cymbal (1-bit LFSR noise), all shift-subtract envelopes. The
 * synthesis used to run ON the machine into a 40 KiB SRAM arena; it
 * now runs at BUILD time (host/gameassets DrumPCM, the same
 * algorithms verbatim) and the PCM rides the flash blob like every
 * other clip — the ring copier streams it by DMA either way, and the
 * arena went back to the data segment.
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

#define C_BG RGB(16, 10, 28)
#define C_TEXT RGB(190, 180, 210)
#define C_DIM RGB(100, 92, 125)
#define C_CUR RGB(255, 255, 255)
#define C_PLAY RGB(255, 210, 60)

/* per-instrument: PCM frames, cell color, letter. dlen must match
 * gameassets.DrumPCM's rendered lengths; daddr is loader-patched
 * with each clip's flash address (symbol g_daddr; [0] unused). */
static const int dlen[NINST] = {0, 2800, 1900, 2000, 800, 2700};
uint daddr[NINST];
static const ushort dcol[NINST] = {
    RGB(34, 26, 52),  RGB(255, 90, 40),  RGB(255, 210, 60),
    RGB(60, 220, 120), RGB(70, 200, 230), RGB(190, 110, 255)};
static const char dletter[NINST] = {'.', 'K', 'S', 'T', 'H', 'C'};

static uchar pattern[NSTEP] = {1, 0, 4, 0, 2, 0, 4, 4,
                               1, 0, 4, 1, 2, 0, 5, 0};

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
