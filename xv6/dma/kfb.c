/* HDMI framebuffer scanout driver (prompts/036). The framebuffer
 * lives in PSRAM (QMI CS1, accessed through the uncached XIP alias so
 * nothing needs cache maintenance); a pure-DMA descriptor engine on
 * channels 13-15 streams it to the HSTX FIFO forever with zero CPU
 * involvement:
 *
 *   walker (13): walks a ring of 4-word blocks in SRAM, writing each
 *     into the executor's alias0 through a 16-byte write ring; a tail
 *     block loops it. Every block ends on CTRL_TRIG, so each block is
 *     one executor run.
 *   executor (14): per active line, first a "kick" block copies one
 *     3-word kick-table entry into the copier's alias3 (priming the
 *     NEXT line's pixels into the other line buffer), then a "stream"
 *     block feeds the line buffer (9 HSTX command words + the pixel
 *     words) to the FIFO, paced by the HSTX DREQ. Vblank regions are
 *     one block each, replaying an 8-word sync sequence through a
 *     32-byte read ring.
 *   copier (15): PSRAM -> SRAM line buffer, kicked one line ahead, so
 *     sync timing never depends on the contended QSPI bus: a starved
 *     copy shows a stale line, never a dropped sync.
 *
 * Scrolling is a vertical pan: the kick table's READ column decides
 * which PSRAM row appears on which scanline, so kfb_setpan() rewrites
 * 480 SRAM words instead of moving 300 KiB of PSRAM.
 *
 * SKU-specific CTRL encodings arrive as loader-patched globals
 * (boards.FbCtrls); fb_psram == 0 means the board has no display and
 * every entry point is a no-op. */

#include "kernel/types.h"

#define W32(a) (*(volatile uint *)(a))

uint fb_psram;     /* loader-patched: fb base (uncached CS1 alias); 0 = none */
uint fb_psram_sz;  /* loader-patched: PSRAM size */
uint fb_sram;      /* loader-patched: scanout working area (boards.FbHome) */
uint fb_hstx;      /* loader-patched: HSTX FIFO address */
uint fb_dmabase;   /* loader-patched: DMA block base */
uint fb_abort;     /* loader-patched: CHAN_ABORT register address */
uint fb_ctrl_walk; /* loader-patched: boards.FbCtrls values */
uint fb_ctrl_kick;
uint fb_ctrl_strm;
uint fb_ctrl_vbl;
uint fb_ctrl_tail;
uint fb_ctrl_copy;

/* Scanout channels; must match boards.FbChan*. */
#define CH_WALK 13
#define CH_EXEC 14
#define CH_COPY 15

/* The display mode — changeable in code. 640x480@60 (CEA-861 mode 1
 * timing, 25.2 MHz pixel clock = clk_hstx/5), RGB332: 16 bpp at this
 * width exceeds QSPI PSRAM bandwidth. Geometry below derives from
 * these eight numbers plus the firmware's clk_hstx. */
#define FB_W     640
#define FB_H     480
#define FB_HFP   16
#define FB_HSYNC 96
#define FB_HBP   48
#define FB_VFP   10
#define FB_VSYNC 2
#define FB_VBP   33

#define FB_PITCH FB_W       /* bytes per line at 8 bpp */
#define FB_PXW   (FB_W / 4) /* pixel words per line */

/* HSTX FIFO command words (RP2350 datasheet §12.11): count in the low
 * 12 bits. RAW_REPEAT holds one raw 30-bit symbol for N pixel clocks;
 * TMDS encodes N pixels through the expander. The SYNC_* words carry
 * the DVI control symbols for {vsync,hsync} on lane 0 (both syncs are
 * active-low in this mode) and idle on lanes 1/2. */
#define CMD_RAW_REPEAT (0x1u << 12)
#define CMD_TMDS       (0x2u << 12)
#define CMD_NOP        (0xFu << 12)
#define TMDS_CTRL_00 0x354u
#define TMDS_CTRL_01 0x0ABu
#define TMDS_CTRL_10 0x154u
#define TMDS_CTRL_11 0x2ABu
#define SYNC_LANE12 (TMDS_CTRL_00 << 10 | TMDS_CTRL_00 << 20)
#define SYNC_V0_H0 (TMDS_CTRL_00 | SYNC_LANE12)
#define SYNC_V0_H1 (TMDS_CTRL_01 | SYNC_LANE12)
#define SYNC_V1_H0 (TMDS_CTRL_10 | SYNC_LANE12)
#define SYNC_V1_H1 (TMDS_CTRL_11 | SYNC_LANE12)

/* SRAM layout inside [fb_sram, boards.FbEnd): ring, kick table, two
 * line buffers (9 command words + one line of pixels each), the two
 * 32-byte-aligned vblank sequences, the tail's reset word. */
#define NBLK    (2 * FB_H + 4)
#define RING    (fb_sram)
#define KICKTAB (RING + NBLK * 16)
#define BUFSZ   (36 + FB_PITCH)
#define BUFS    (KICKTAB + FB_H * 12)
#define VBUFS   ((BUFS + 2 * BUFSZ + 31) & ~31u)
#define RESETW  (VBUFS + 64)

static uint fb_owner; /* pid holding the fb; 0 = fbcon renders */
static uint fb_on;

int
kfb_active(void)
{
  return fb_on;
}

uint
kfb_base(void)
{
  return fb_psram;
}

int
kfb_w(void)
{
  return FB_W;
}

int
kfb_h(void)
{
  return FB_H;
}

uint
kfb_owner(void)
{
  return fb_owner;
}

void
kfb_setowner(uint pid)
{
  fb_owner = pid;
}

/* kfb_setpan maps pixel row `row0` of the framebuffer onto scanline 0
 * by rewriting the kick table's READ column (the fb is a circular row
 * buffer; fbcon scrolls by advancing the pan). */
void
kfb_setpan(uint row0)
{
  if (!fb_on)
    return;
  /* Two straight runs (before and after the fb wrap), unrolled by 8
   * — this rewrites 480 words on every scroll, so no per-entry wrap
   * check and few loop compares. row0 is a cell-row multiple of 8,
   * so both run lengths divide by 8. */
  uint rd = fb_psram + row0 * FB_PITCH;
  uint e = KICKTAB + 8;
  uint runs[2];
  runs[0] = FB_H - row0;
  runs[1] = row0;
  for (int half = 0; half < 2; half++) {
    uint n = runs[half];
    while (n >= 8) {
      W32(e) = rd;
      W32(e + 12) = rd + FB_PITCH;
      W32(e + 24) = rd + 2 * FB_PITCH;
      W32(e + 36) = rd + 3 * FB_PITCH;
      W32(e + 48) = rd + 4 * FB_PITCH;
      W32(e + 60) = rd + 5 * FB_PITCH;
      W32(e + 72) = rd + 6 * FB_PITCH;
      W32(e + 84) = rd + 7 * FB_PITCH;
      e += 96;
      rd += 8 * FB_PITCH;
      n -= 8;
    }
    rd = fb_psram;
  }
}

static void
build_ring(void)
{
  uint i;
  /* Active-line command prefix, identical in both line buffers. */
  for (i = 0; i < 2; i++) {
    uint b = BUFS + i * BUFSZ;
    W32(b + 0) = CMD_RAW_REPEAT | FB_HFP;
    W32(b + 4) = SYNC_V1_H1;
    W32(b + 8) = CMD_NOP;
    W32(b + 12) = CMD_RAW_REPEAT | FB_HSYNC;
    W32(b + 16) = SYNC_V1_H0;
    W32(b + 20) = CMD_NOP;
    W32(b + 24) = CMD_RAW_REPEAT | FB_HBP;
    W32(b + 28) = SYNC_V1_H1;
    W32(b + 32) = CMD_TMDS | FB_W;
  }
  /* Vblank line sequences (8 words each: vsync off, vsync on). */
  for (i = 0; i < 2; i++) {
    uint b = VBUFS + i * 32;
    uint h1 = i ? SYNC_V0_H1 : SYNC_V1_H1;
    uint h0 = i ? SYNC_V0_H0 : SYNC_V1_H0;
    W32(b + 0) = CMD_RAW_REPEAT | FB_HFP;
    W32(b + 4) = h1;
    W32(b + 8) = CMD_RAW_REPEAT | FB_HSYNC;
    W32(b + 12) = h0;
    W32(b + 16) = CMD_RAW_REPEAT | (FB_HBP + FB_W);
    W32(b + 20) = h1;
    W32(b + 24) = CMD_NOP;
    W32(b + 28) = CMD_NOP;
  }
  /* Kick table: entry n primes fb line n into buffer n&1. */
  uint rd = fb_psram;
  for (i = 0; i < FB_H; i++) {
    uint e = KICKTAB + i * 12;
    W32(e + 0) = BUFS + (i & 1) * BUFSZ + 36;
    W32(e + 4) = FB_PXW;
    W32(e + 8) = rd;
    rd += FB_PITCH;
  }
  /* The block ring. */
  uint copyb = fb_dmabase + CH_COPY * 0x40;
  uint walkb = fb_dmabase + CH_WALK * 0x40;
  uint blk = RING;
  for (i = 0; i < FB_H; i++) {
    uint nx = i + 1;
    if (nx == FB_H)
      nx = 0;
    W32(blk + 0) = KICKTAB + nx * 12; /* prime the next line... */
    W32(blk + 4) = copyb + 0x34;      /* AL3 WRITE/COUNT/READ_TRIG */
    W32(blk + 8) = 3;
    W32(blk + 12) = fb_ctrl_kick;
    W32(blk + 16) = BUFS + (i & 1) * BUFSZ; /* ...then stream this one */
    W32(blk + 20) = fb_hstx;
    W32(blk + 24) = 9 + FB_PXW;
    W32(blk + 28) = fb_ctrl_strm;
    blk += 32;
  }
  W32(blk + 0) = VBUFS; /* front porch */
  W32(blk + 4) = fb_hstx;
  W32(blk + 8) = 8 * FB_VFP;
  W32(blk + 12) = fb_ctrl_vbl;
  W32(blk + 16) = VBUFS + 32; /* vsync */
  W32(blk + 20) = fb_hstx;
  W32(blk + 24) = 8 * FB_VSYNC;
  W32(blk + 28) = fb_ctrl_vbl;
  blk += 32;
  W32(blk + 0) = VBUFS; /* back porch */
  W32(blk + 4) = fb_hstx;
  W32(blk + 8) = 8 * FB_VBP;
  W32(blk + 12) = fb_ctrl_vbl;
  W32(RESETW) = RING;
  W32(blk + 16) = RESETW; /* tail: loop the walker */
  W32(blk + 20) = walkb + 0x3C;
  W32(blk + 24) = 1;
  W32(blk + 28) = fb_ctrl_tail;
}

static void
start(void)
{
  uint copyb = fb_dmabase + CH_COPY * 0x40;
  uint walkb = fb_dmabase + CH_WALK * 0x40;
  /* Copier CTRL is static; the kicks feed everything else. */
  W32(copyb + 0x10) = fb_ctrl_copy; /* AL1_CTRL, no trigger */
  /* Prime line 0 into buffer 0 by issuing kick-table entry 0 by hand,
   * then wait for the copy (TRANS_COUNT reads back the remainder). */
  W32(copyb + 0x34) = W32(KICKTAB + 0);
  W32(copyb + 0x38) = W32(KICKTAB + 4);
  W32(copyb + 0x3C) = W32(KICKTAB + 8);
  while (W32(copyb + 0x08) != 0)
    ;
  /* Walker: CTRL and fixed write target, then trigger at the ring. */
  W32(walkb + 0x10) = fb_ctrl_walk;
  W32(walkb + 0x04) = fb_dmabase + CH_EXEC * 0x40;
  W32(walkb + 0x08) = 4;
  W32(walkb + 0x3C) = RING;
}

/* kfb_pause stops the scanout (CHAN_ABORT all three channels — full
 * restarts only, per the machine's interrupt findings). Required
 * around QMI direct-mode sessions: flash sync owns the XIP bus, and a
 * scanout access during it would fault. */
void
kfb_pause(void)
{
  if (!fb_on)
    return;
  uint mask = (1u << CH_WALK) | (1u << CH_EXEC) | (1u << CH_COPY);
  W32(fb_abort) = mask;
  /* CHAN_ABORT is asynchronous: it reads back as the in-progress
   * abort bits, and an in-flight PSRAM burst must retire BEFORE the
   * caller tears the XIP window down (RP2350 datasheet §12.6;
   * skipping this wedged sync on silicon). */
  while (W32(fb_abort) & mask)
    ;
}

void
kfb_resume(void)
{
  if (!fb_on)
    return;
  start();
}

/* SYS_fb (kproc.c dispatches here so lean kernels can stub it out).
 * op 0: fill a 5-word {base, w, h, bpp, pitch} info struct at a1
 * (badinfo reports the caller's buffer-validity check). op 1: acquire
 * — fbcon detaches and the pan resets to 0, handing pid a linear
 * framebuffer. op 2: release — clear, fbcon resumes. A dying owner is
 * released by terminate(). */
void kfbcon_reset(void);

int
kfb_syscall(uint op, uint a1, uint pid, int badinfo)
{
  if (!fb_on)
    return -1;
  if (op == 0) {
    if (badinfo)
      return -1;
    uint *fi = (uint *)a1;
    fi[0] = fb_psram;
    fi[1] = FB_W;
    fi[2] = FB_H;
    fi[3] = 8;
    fi[4] = FB_PITCH;
    return 0;
  }
  if (op == 1) {
    if (fb_owner != 0 && fb_owner != pid)
      return -1;
    kfbcon_reset();
    fb_owner = pid;
    return 0;
  }
  if (op == 2) {
    if (fb_owner != pid)
      return -1;
    fb_owner = 0;
    kfbcon_reset();
    return 0;
  }
  return -1;
}

/* kfb_init brings the display up; returns fb size in KiB, 0 when the
 * board has no display, -1 when the PSRAM self-test fails (fb left
 * off; the console stays UART-only). */
int
kfb_init(void)
{
  if (fb_psram == 0)
    return 0;
  W32(fb_psram) = 0x5AFE57A2;
  W32(fb_psram + fb_psram_sz - 4) = 0xC0FFEE00;
  if (W32(fb_psram) != 0x5AFE57A2 || W32(fb_psram + fb_psram_sz - 4) != 0xC0FFEE00) {
    fb_psram = 0;
    return -1;
  }
  /* Clear the visible framebuffer (color 0: black). */
  uint end = fb_psram + FB_H * FB_PITCH;
  for (uint p = fb_psram; p < end; p += 4)
    W32(p) = 0;
  build_ring();
  start();
  fb_on = 1;
  return (FB_H * FB_PITCH) >> 10;
}
