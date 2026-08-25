/* kdma.c: bulk copy/fill through a FREE DMA channel — generic DMA in
 * the Linux sense, on a machine that is itself made of DMA. The
 * compiler lowers C loops to interpreted control-block traffic (tens
 * of transfers per copied word); one hardware sequence moves a word
 * per bus slot. Channel 11 is outside the compact machine (the
 * contiguous ch0..8: banks 0-6, fetch 7, cleanup 8) on BOTH SKUs;
 * ch9+ is the board pool (9 = the injector slot by convention, and
 * the RP2040 has 12 channels in total).
 *
 * dmacpy_ctrl arrives loader-patched with the SKU's CTRL encoding
 * (EN | HIGH_PRIORITY | SIZE32 | INCR_READ | INCR_WRITE | TREQ_PERM |
 * IRQ_QUIET — the INCR_WRITE and TREQ/QUIET fields moved between
 * SKUs); zero means "not configured" and every call falls back to a
 * plain loop, so unpatched lean kernels never notice. HIGH_PRIORITY
 * is deliberate: the machine only polls TRANS_COUNT while the copy
 * runs, so the copier owning every bus slot is the fastest schedule.
 * Completion is polled on TRANS_COUNT reaching zero — the BUSY flag
 * lives in a SKU-dependent bit, the count does not.
 */
#include "kernel/types.h"

#define KDMA_CH 11u
#define KCH(i) (*(volatile uint *)(0x50000000u + KDMA_CH * 0x40u + 4u * (i)))
#define KDMA_INCR_READ 0x10u /* bit 4 on both SKUs */

uint dmacpy_ctrl; /* loader-patched (symbol g_dmacpy_ctrl); 0 = plain loops */

/* Flash sources on the video board go through the QMI's XIP streamer
 * instead of memory-mapped XIP reads: the streamer prefetches into
 * its own FIFO and the paced channel (TREQ = XIP_STREAM) only pops
 * words that are ALREADY THERE — flash latency hides inside the QMI
 * and the shared DMA read master never stalls on a miss. Without
 * this, an exec's ~40 KB app copy parked the master on back-to-back
 * QSPI reads for milliseconds and the HSTX scanout's 1.3 us FIFO
 * had no chance. Zero-config-off, kdma-style. */
uint dmacpy_sctrl; /* g_dmacpy_sctrl: the streamer-paced CTRL; 0 = off */
uint xip_stream;   /* g_xip_stream: QMI STREAM_ADDR (CTR at +4) */
uint xip_aux;      /* g_xip_aux: the stream drain port */
#define W32(a) (*(volatile uint *)(a))

/* kdmacpy: forward copy of len bytes. Word-aligned dst/src/len take
 * the hardware path; anything ragged runs a byte loop (callers here
 * never overlap backward). */
void
kdmacpy(uint dst, uint src, uint len)
{
  if (len == 0)
    return;
  if (dmacpy_ctrl == 0 || ((dst | src | len) & 3) != 0) {
    if (((dst | src | len) & 3) == 0) { /* unpatched but aligned */
      const uint *s = (const uint *)src;
      uint *d = (uint *)dst;
      for (uint i = 0; i < (len >> 2); i++)
        d[i] = s[i];
      return;
    }
    const uchar *s = (const uchar *)src;
    uchar *d = (uchar *)dst;
    for (uint i = 0; i < len; i++)
      d[i] = s[i];
    return;
  }
  if (dmacpy_sctrl != 0 && (src >> 28) == 1) { /* flash: stream it */
    W32(xip_stream) = src;
    W32(xip_stream + 4) = len >> 2;
    KCH(0) = xip_aux; /* fixed drain port, no INCR_READ */
    KCH(1) = dst;
    KCH(2) = len >> 2;
    KCH(3) = dmacpy_sctrl;
    while (KCH(2) != 0)
      ;
    return;
  }
  KCH(0) = src;             /* READ_ADDR */
  KCH(1) = dst;             /* WRITE_ADDR */
  KCH(2) = len >> 2;        /* TRANS_COUNT (reload) */
  KCH(3) = dmacpy_ctrl;   /* CTRL_TRIG */
  while (KCH(2) != 0)
    ;
}

/* kdmaset: fill len bytes with a word pattern (INCR_READ cleared: the
 * channel re-reads one SRAM word). The kernel runs to completion, so
 * the static fill word needs no guarding. */
void
kdmaset(uint dst, uint word, uint len)
{
  static uint fill;
  if (len == 0)
    return;
  if (dmacpy_ctrl == 0 || ((dst | len) & 3) != 0) {
    for (uint p = dst; p < dst + len; p += 4)
      *(volatile uint *)p = word;
    return;
  }
  fill = word;
  KCH(0) = (uint)&fill;
  KCH(1) = dst;
  KCH(2) = len >> 2;
  KCH(3) = dmacpy_ctrl & ~KDMA_INCR_READ;
  while (KCH(2) != 0)
    ;
}
