/* DMA-machine flash persistence (prompts/022): sync POLICY lives in
 * the kernel — the dirty-sector map, incremental vs full burns, the
 * header-last commit, the generation counter — while the erase and
 * program PRIMITIVES are posted to the parked ARM's SRAM-resident
 * loop, which runs the SDK's XIP-safe routines and acks.
 *
 * Why the ARM: the RP2350's DMA engine cannot write flash unaided —
 * it cannot read QMI registers, and entering QMI direct mode freezes
 * its peripheral-read path irrecoverably (silicon-characterized in
 * prompts/023, where the removed machine-side QSPI driver and the
 * cal_flash findings are preserved). The emulator plays the ARM by
 * servicing the same mailbox between run chunks.
 *
 * Slot layout (loader-patched fsslot, sector-aligned XIP address):
 *   +0x0000  header sector: magic 'DMFS', generation, length,
 *            word-sum checksum of the image
 *   +0x1000  the disk image
 *
 * The header is erased first and programmed LAST: a torn sync leaves
 * an invalid header and boot falls back to the golden image. Clean
 * reads (headers, boot staging) go through plain XIP. */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"

#define W32(a) (*(volatile uint *)(a))

#define FLASH_SECTOR 4096u
#define FLASH_PAGE 256u
#define FS_MAGIC 0x53464D44u /* 'DMFS' */

extern uint dma_disk;     /* RAM disk base (kbio.c) */
extern uint dma_disksize;
extern uint fs_dirty;     /* per-4K-sector dirty bits (kbio.c) */

uint fsslot;     /* loader-patched: XIP address of the slot header;
                  * 0 = no persistence configured */
uint kflash_arm; /* loader-patched: &flashreq mailbox in SRAM;
                  * 0 = no executor (sync fails) */

struct flashreq {
  uint op;  /* 1 erase 4K, 2 program 256 */
  uint off; /* flash byte offset */
  uint src; /* PROG: RAM source */
  uint seq, ack;
};

static uint fs_gen; /* generation we last saw/wrote in the slot */

static void
arm_request(uint op, uint off, uint src)
{
  volatile struct flashreq *r = (volatile struct flashreq *)kflash_arm;
  r->op = op;
  r->off = off;
  r->src = src;
  r->seq = r->seq + 1;
  while (r->ack != r->seq)
    ;
}

static void
flash_erase4k(uint off)
{
  arm_request(1, off, 0);
}

static void
flash_prog_page(uint off, const uchar *src)
{
  arm_request(2, off, (uint)src);
}

static void
flash_write_sector(uint off, const uchar *src)
{
  flash_erase4k(off);
  for (uint p = 0; p < FLASH_SECTOR; p += FLASH_PAGE)
    flash_prog_page(off + p, src + p);
}

static uint
disk_checksum(void)
{
  uint sum = 0;
  const uint *p = (const uint *)dma_disk;
  for (uint i = 0; i < dma_disksize / 4; i++)
    sum += p[i];
  return sum;
}

/* Reads the slot header via XIP; returns the generation, or 0 when
 * the slot does not hold a valid image of our size. */
uint
kflash_slot_gen(void)
{
  if (fsslot == 0)
    return 0;
  const uint *h = (const uint *)fsslot;
  if (h[0] != FS_MAGIC || h[2] != dma_disksize)
    return 0;
  return h[1];
}

void
kflash_init(void)
{
  fs_gen = kflash_slot_gen();
}

/* SYS_sync: burn the RAM disk into the slot. Returns 0, or -1 when
 * persistence is not configured. */
int
kflash_sync(void)
{
  if (fsslot == 0 || kflash_arm == 0)
    return -1;
  uint base = fsslot - 0x10000000u; /* flash offset of the header */
  uint nsect = dma_disksize / FLASH_SECTOR;
  uint full = kflash_slot_gen() != fs_gen || fs_gen == 0;
  if (!full && fs_dirty == 0)
    return 0; /* nothing changed since the last sync */

  /* Invalidate first: a torn sync must not present a stale header. */
  flash_erase4k(base);
  for (uint i = 0; i < nsect; i++) {
    if (full || (fs_dirty & (1u << i)))
      flash_write_sector(base + FLASH_SECTOR + i * FLASH_SECTOR,
                         (const uchar *)(dma_disk + i * FLASH_SECTOR));
  }
  uint hdr[FLASH_PAGE / 4];
  for (uint i = 0; i < FLASH_PAGE / 4; i++)
    hdr[i] = 0xFFFFFFFFu;
  hdr[0] = FS_MAGIC;
  hdr[1] = fs_gen + 1;
  hdr[2] = dma_disksize;
  hdr[3] = disk_checksum();
  flash_prog_page(base, (const uchar *)hdr);

  fs_gen++;
  fs_dirty = 0;
  return 0;
}
