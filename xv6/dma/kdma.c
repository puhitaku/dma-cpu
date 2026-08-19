/* kdma.c: bulk copy/fill through a FREE DMA channel — generic DMA in
 * the Linux sense, on a machine that is itself made of DMA. The
 * compiler lowers C loops to interpreted control-block traffic (tens
 * of transfers per copied word); one hardware sequence moves a word
 * per bus slot. Channel 11 is unused by the compact machine (banks
 * 0-6, fetch 7, fix 8, injector 9, cleanup 10) on BOTH SKUs (the
 * RP2040 has 12 channels).
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
