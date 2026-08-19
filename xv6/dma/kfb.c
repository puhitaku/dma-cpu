/* HDMI framebuffer state (prompts/036). The display pipeline is not
 * the kernel's: core 1 of the parked ARM feeds the HSTX FIFO from
 * SRAM with CPU stores (target/firmware main.c, video_feeder) — any
 * DMA-fed design shares the single DMA read master with this
 * machine's own XIP cache misses, and a one-microsecond stall drains
 * the 8-word FIFO and breaks sync (measured; the pure-DMA scanout
 * rings that preceded this are chronicled in prompts/036). The
 * machine's whole interface to video is memory:
 *
 *   - the framebuffer: 640x240 RGB332 bytes in SRAM (fb_base), each
 *     row scanned twice — the wire format is VESA 640x480@60;
 *   - one control word (fb_ctl): the vertical pan in fb rows, read
 *     by the feeder once per scan line. Scroll is O(1).
 *
 * fb_base == 0 means the board has no display and every entry point
 * is a no-op. The feeder runs from ARM boot (showing black), so
 * pause/resume are vestigial no-ops kept for the sync bracket. */

#include "kernel/types.h"

#define W32(a) (*(volatile uint *)(a))

uint fb_base; /* loader-patched: the SRAM framebuffer; 0 = none */
uint fb_ctl;  /* loader-patched: the feeder's pan word */

#define FB_W     640
#define FB_ROWS  240
#define FB_PITCH FB_W

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
  return fb_base;
}

int
kfb_w(void)
{
  return FB_W;
}

int
kfb_h(void)
{
  return FB_ROWS;
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

/* kfb_setpan maps fb row `row0` onto scan line 0. One word: the
 * feeder samples it per scan line. */
void
kfb_setpan(uint row0)
{
  if (!fb_on)
    return;
  W32(fb_ctl) = row0;
}

void
kfb_pause(void)
{
}

void
kfb_resume(void)
{
}

void kfbcon_reset(void);

/* SYS_fb (kproc.c dispatches here so lean kernels can stub it out).
 * op 0: fill a 5-word {base, w, h, bpp, pitch} info struct at a1
 * (badinfo reports the caller's buffer-validity check). op 1: acquire
 * — fbcon detaches and the pan resets to 0, handing pid a linear
 * framebuffer. op 2: release — clear, fbcon resumes. A dying owner is
 * released by terminate(). */
int
kfb_syscall(uint op, uint a1, uint pid, int badinfo)
{
  if (!fb_on)
    return -1;
  if (op == 0) {
    if (badinfo)
      return -1;
    uint *fi = (uint *)a1;
    fi[0] = fb_base;
    fi[1] = FB_W;
    fi[2] = FB_ROWS;
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

/* kfb_init takes over a display the feeder already drives: self-test
 * the fb, blank it, reset the pan. Returns fb KiB, 0 when the board
 * has no display, -1 on self-test failure. */
int
kfb_init(void)
{
  if (fb_base == 0)
    return 0;
  W32(fb_base) = 0x5AFE57A2;
  if (W32(fb_base) != 0x5AFE57A2) {
    fb_base = 0;
    return -1;
  }
  uint end = fb_base + FB_ROWS * FB_PITCH;
  for (uint p = fb_base; p < end; p += 4)
    W32(p) = 0;
  W32(fb_ctl) = 0;
  fb_on = 1;
  return (FB_ROWS * FB_PITCH) >> 10;
}
