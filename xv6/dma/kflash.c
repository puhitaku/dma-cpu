/* DMA-machine flash persistence (Phase 10, prompts/022): the kernel
 * programs its own disk. SYS_sync burns the RAM disk into the single
 * flash slot over RP2350 QMI direct mode — safe because the kernel
 * runs to completion with the ARM parked in an SRAM-resident wfi loop
 * (nothing fetches XIP while the flash is in direct mode), and
 * because the header sector is erased first and programmed LAST: a
 * torn sync leaves an invalid header and boot falls back to the
 * golden image baked in the firmware.
 *
 * Slot layout (loader-patched fsslot, sector-aligned XIP address):
 *   +0x0000  header sector: magic 'DMFS', generation, length,
 *            word-sum checksum of the image
 *   +0x1000  the disk image
 *
 * Sync is incremental when the slot already holds our lineage (the
 * kbio dirty-sector map says what changed); anything else burns every
 * sector. Clean reads go through plain XIP — after direct commands
 * the QMI re-issues its configured read sequence, which re-enters the
 * flash's continuous-read mode (validated on silicon; the emulator's
 * model has no modes to exit). */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"

#define W32(a) (*(volatile uint *)(a))

/* QMI direct mode (RP2350; register layout from hardware/regs/qmi.h). */
#define QMI_DIRECT_CSR 0x400D0000u
#define QMI_DIRECT_TX 0x400D0004u
#define QMI_DIRECT_RX 0x400D0008u
#define CSR_EN (1u << 0)
#define CSR_BUSY (1u << 1)
#define CSR_CS0N (1u << 2)
#define CSR_TXEMPTY (1u << 11)
#define CSR_RXEMPTY (1u << 16)
#define TX_NOPUSH (1u << 20)

#define FLASH_SECTOR 4096u
#define FLASH_PAGE 256u
#define FS_MAGIC 0x53464D44u /* 'DMFS' */

extern uint dma_disk;     /* RAM disk base (kbio.c) */
extern uint dma_disksize;
extern uint fs_dirty;     /* per-4K-sector dirty bits (kbio.c) */

uint fsslot;   /* loader-patched: XIP address of the slot header; 0 = no
                * persistence configured */

/* Flash executor selection. The QMI direct-mode driver below is the
 * reference implementation (exercised by the emulator's NOR model).
 * On silicon the exit-XIP dance for a quad-mode flash belongs to the
 * bootrom, so the loader configures an ARM mailbox instead: the
 * parked ARM's SRAM-resident loop executes erase/program requests
 * with the SDK's XIP-safe routines. Policy (what to burn, when,
 * header-last) stays in the kernel either way. */
struct flashreq {
  uint op;  /* 1 erase 4K, 2 program 256 */
  uint off; /* flash byte offset */
  uint src; /* PROG: RAM source */
  uint seq, ack;
};
uint kflash_arm; /* loader-patched: &flashreq in SRAM, or 0 for QMI */

static uint fs_gen; /* generation we last saw/wrote in the slot */

static void
qmi_cs(int assert)
{
  uint v = W32(QMI_DIRECT_CSR);
  if (assert)
    v |= CSR_EN | CSR_CS0N;
  else
    v &= ~CSR_CS0N;
  W32(QMI_DIRECT_CSR) = v;
}

static uint
qmi_xfer(uint b)
{
  W32(QMI_DIRECT_TX) = b & 0xFFu;
  while (W32(QMI_DIRECT_CSR) & CSR_RXEMPTY)
    ;
  return W32(QMI_DIRECT_RX) & 0xFFu;
}

static void
qmi_end(void)
{
  qmi_cs(0);
  while (W32(QMI_DIRECT_CSR) & CSR_BUSY)
    ;
  W32(QMI_DIRECT_CSR) = W32(QMI_DIRECT_CSR) & ~CSR_EN;
}

/* Take the flash out of XIP continuous-read mode so plain-SPI
 * commands parse (the bootrom's exit-xip essence: clock out FFh with
 * CS asserted, twice for good measure). */
static void
flash_exit_xip(void)
{
  for (int i = 0; i < 2; i++) {
    qmi_cs(1);
    qmi_xfer(0xFF);
    qmi_xfer(0xFF);
    qmi_end();
  }
}

static void
flash_wait_wip(void)
{
  for (;;) {
    qmi_cs(1);
    qmi_xfer(0x05); /* RDSR */
    uint sr = qmi_xfer(0);
    qmi_end();
    if ((sr & 1u) == 0)
      return;
  }
}

static void
flash_wren(void)
{
  qmi_cs(1);
  qmi_xfer(0x06);
  qmi_end();
}

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
  if (kflash_arm) {
    arm_request(1, off, 0);
    return;
  }
  flash_wren();
  qmi_cs(1);
  qmi_xfer(0x20);
  qmi_xfer(off >> 16);
  qmi_xfer(off >> 8);
  qmi_xfer(off);
  qmi_end();
  flash_wait_wip();
}

static void
flash_prog_page(uint off, const uchar *src)
{
  if (kflash_arm) {
    arm_request(2, off, (uint)src);
    return;
  }
  flash_wren();
  qmi_cs(1);
  qmi_xfer(0x02);
  qmi_xfer(off >> 16);
  qmi_xfer(off >> 8);
  qmi_xfer(off);
  for (uint i = 0; i < FLASH_PAGE; i++)
    qmi_xfer(src[i]);
  qmi_end();
  flash_wait_wip();
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
  if (fsslot == 0)
    return -1;
  uint base = fsslot - 0x10000000u; /* flash offset of the header */
  uint nsect = dma_disksize / FLASH_SECTOR;
  uint full = kflash_slot_gen() != fs_gen || fs_gen == 0;
  if (!full && fs_dirty == 0)
    return 0; /* nothing changed since the last sync */

  if (!kflash_arm)
    flash_exit_xip();
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
