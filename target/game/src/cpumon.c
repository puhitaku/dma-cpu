/* cpumon.c: the "are the CPUs really asleep?" screen. Two Cortex-M0+
 * cores drawn as little chips with shut eyes and rising Zzz, plus the
 * honest facts:
 *
 *  - CORE0 is in WFI (its entire post-boot program is cpsid; wfi;
 *    b .-1 — three instructions, forever), CORE1 was never released
 *    from reset on this board.
 *  - An idle clock counting up from the timestamp the ARM stamped
 *    just before it parked (firmware, 0x2003FF00). It only advances,
 *    which is the proof: if the CPU ever executed again it could
 *    move that stamp, and it never does.
 */
#include "g.h"

#define CPU_STAT 0x2003FF00u
#define CPU_STAT_MAGIC 0x51EE9500u

#define C_BG RGB(10, 12, 28)
#define C_CHIP RGB(40, 46, 78)
#define C_CHIPE RGB(90, 100, 150)
#define C_PIN RGB(150, 155, 120)
#define C_FACE RGB(220, 225, 245)
#define C_Z RGB(120, 200, 255)
#define C_TITLE RGB(255, 210, 60)
#define C_TEXT RGB(180, 190, 215)
#define C_DIM RGB(105, 112, 140)
#define C_LIVE RGB(90, 240, 140)

#define CHIP_Y 52

/* one chip: body, pins, two shut eyes, a little breathing mouth */
static void
draw_chip(int x, int y)
{
  gfx_fill(x, y, 76, 60, C_CHIP);
  gfx_rect(x, y, 76, 60, 2, C_CHIPE);
  for (int i = 0; i < 4; i++) { /* pins down each side */
    gfx_fill(x - 5, y + 10 + i * 12, 5, 6, C_PIN);
    gfx_fill(x + 76, y + 10 + i * 12, 5, 6, C_PIN);
  }
  /* shut eyes: gentle content "‿ ‿" */
  for (int e = 0; e < 2; e++) {
    int ex = x + 18 + e * 30, ey = y + 26;
    gfx_fill(ex, ey, 3, 2, C_FACE);
    gfx_fill(ex + 3, ey + 2, 6, 2, C_FACE);
    gfx_fill(ex + 9, ey, 3, 2, C_FACE);
  }
  /* small open mouth — breathing in its sleep */
  gfx_fill(x + 33, y + 40, 10, 7, RGB(20, 22, 40));
  gfx_rect(x + 33, y + 40, 10, 7, 1, C_FACE);
}

/* Zzz above a chip: z, Z, Z of growing size on a rising diagonal,
 * revealed one at a time by phase, looping. The box sits ENTIRELY in
 * the clear band above the chips (y 24..50, chips start at 52), so
 * the background erase touches only background — no chip corner is
 * clipped — and the erase spans the full glyph extent including the
 * big Z's top row, so nothing is left behind. */
#define ZZZ_Y 24
#define ZZZ_H 27

static void
draw_zzz(int bx, uint phase)
{
  gfx_fill(bx, ZZZ_Y, 40, ZZZ_H, C_BG);
  uint n = (phase / 8) % 4; /* 0..3 visible */
  if (n >= 1)
    gfx_text(bx, ZZZ_Y + 18, "z", C_Z, C_BG);
  if (n >= 2)
    gfx_text(bx + 11, ZZZ_Y + 9, "Z", C_Z, C_BG);
  if (n >= 3)
    gfx_text2(bx + 22, ZZZ_Y, "Z", C_Z, C_BG);
  gfx_damage(bx, ZZZ_Y, bx + 39, ZZZ_Y + ZZZ_H - 1);
}

static void
draw_idle(uint secs)
{
  char b[6];
  uint mm = secs / 60, ss = secs % 60;
  b[0] = (char)('0' + mm / 10 % 10);
  b[1] = (char)('0' + mm % 10);
  b[2] = ':';
  b[3] = (char)('0' + ss / 10);
  b[4] = (char)('0' + ss % 10);
  b[5] = 0;
  gfx_fill(100, 146, 80, 16, C_BG);
  gfx_text2(100, 146, b, C_LIVE, C_BG);
}

void
cpumon_run(void)
{
  uputs("cpumon: up\n");
  led(LED_DIM(0x0040FF), LED_DIM(0x0040FF));
  gfx_clear(C_BG);
  gfx_text2(32, 6, "CPU ASLEEP", C_TITLE, C_BG);

  draw_chip(24, CHIP_Y);
  draw_chip(140, CHIP_Y);
  gfx_text(38, 118, "CORE 0", C_TEXT, C_BG);
  gfx_text(48, 130, "wfi", C_DIM, C_BG); /* one char in from the label */
  gfx_text(154, 118, "CORE 1", C_TEXT, C_BG);
  gfx_text(158, 130, "reset", C_DIM, C_BG);

  /* the facts */
  gfx_text(8, 150, "Idle for:", C_TEXT, C_BG);
  gfx_text(8, 174, "CPU program:", C_TEXT, C_BG);
  gfx_text(8, 186, "  cpsid i; wfi; b .-1", C_DIM, C_BG);
  gfx_text(8, 198, "3 instructions, forever.", C_DIM, C_BG);
  gfx_text(8, 220, "press: back", C_DIM, C_BG);

  /* seed the idle clock from the ARM's park stamp (or 0 if the
   * monitor is running under the emulator, where nothing stamped it) */
  uint secs = 0, acc = 0;
  uint last = now_us();
  if (W32(CPU_STAT) == CPU_STAT_MAGIC)
    secs = (now_us() - W32(CPU_STAT + 4)) / 1000000u; /* one-time seed */
  draw_idle(secs);
  gfx_present();

  uint phase = 0;
  for (;;) {
    frame_sync(33000);
    in_poll();
    if (in_edge & (BTN_A | BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)) {
      led(0, 0);
      uputs("cpumon: back\n");
      return;
    }
    phase++;
    if ((phase & 3) == 0) {
      /* anchored toward each chip's right temple, not mid-head */
      draw_zzz(70, phase);
      draw_zzz(182, phase + 16);
      gfx_present();
    }
    /* advance the idle clock in real time */
    uint now = now_us();
    acc += now - last;
    last = now;
    if (acc >= 1000000u) {
      acc -= 1000000u;
      secs++;
      draw_idle(secs);
      gfx_present();
    }
  }
}
