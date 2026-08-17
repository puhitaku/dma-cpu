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

/* --- The REAL exit-XIP dance (prompts/023): the bootrom's sequence,
 * bit-banged through the QSPI pad overrides so it works whatever
 * read mode the flash is in (1-bit or quad continuous):
 *   1. CS high, SD0..3 PULLED low,  32 clocks   (mode bits = 0)
 *   2. CS low,  SD0..3 PULLED high, 32 clocks   (mode bits = 1)
 *   3. CS high
 *   4. CS low,  SD0 DRIVEN high,    16 clocks   (FFh FFh)
 *   5. CS high, restore all overrides
 * The pulls (not drives) avoid contention while the flash may still
 * be driving SD1 during reads. Afterwards the flash parses plain-SPI
 * commands; M0_RFMT.PREFIX_LEN is forced to 1 so XIP bursts re-send
 * their command prefix and work from any flash state. */
#define IOQ_CTRL_SCLK 0x40030014u
#define IOQ_CTRL_SS 0x4003001Cu
#define IOQ_CTRL_SD0 0x40030024u
#define IOQ_CTRL_SD1 0x4003002Cu
#define IOQ_CTRL_SD2 0x40030034u
#define IOQ_CTRL_SD3 0x4003003Cu
#define OUTOVER_LOW (2u << 12)
#define OUTOVER_HIGH (3u << 12)
#define OEOVER_DISABLE (2u << 14)
#define OEOVER_ENABLE (3u << 14)
#define PADQ_SD0 0x40040008u
#define PADQ_SD1 0x4004000Cu
#define PADQ_SD2 0x40040010u
#define PADQ_SD3 0x40040014u
#define PAD_IE (1u << 6)
#define PAD_PUE (1u << 3)
#define PAD_PDE (1u << 2)
#define QMI_M0_RFMT 0x400D0010u
#define RFMT_PREFIX_LEN (1u << 12)

static void
qspi_clocks(int n)
{
  for (int i = 0; i < n; i++) {
    W32(IOQ_CTRL_SCLK) = OUTOVER_LOW | OEOVER_ENABLE;
    W32(IOQ_CTRL_SCLK) = OUTOVER_HIGH | OEOVER_ENABLE;
  }
}

static void
qspi_sd_pulls(uint pull)
{
  W32(PADQ_SD0) = PAD_IE | pull;
  W32(PADQ_SD1) = PAD_IE | pull;
  W32(PADQ_SD2) = PAD_IE | pull;
  W32(PADQ_SD3) = PAD_IE | pull;
}

static void
flash_exit_xip(void)
{
  uint sd0pad = W32(PADQ_SD0), sd1pad = W32(PADQ_SD1);
  uint sd2pad = W32(PADQ_SD2), sd3pad = W32(PADQ_SD3);
  /* Float the data lines (pulled, not driven). */
  W32(IOQ_CTRL_SD0) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD1) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD2) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD3) = OEOVER_DISABLE;
  /* 1: CS high, IOs pulled low, 32 clocks. */
  W32(IOQ_CTRL_SS) = OUTOVER_HIGH | OEOVER_ENABLE;
  qspi_sd_pulls(PAD_PDE);
  qspi_clocks(32);
  /* 2: CS low, IOs pulled high, 32 clocks. */
  W32(IOQ_CTRL_SS) = OUTOVER_LOW | OEOVER_ENABLE;
  qspi_sd_pulls(PAD_PUE);
  qspi_clocks(32);
  /* 3: CS high. */
  W32(IOQ_CTRL_SS) = OUTOVER_HIGH | OEOVER_ENABLE;
  /* 4: CS low, SD0 driven high, 16 clocks (FFh FFh). */
  W32(IOQ_CTRL_SS) = OUTOVER_LOW | OEOVER_ENABLE;
  W32(IOQ_CTRL_SD0) = OUTOVER_HIGH | OEOVER_ENABLE;
  qspi_clocks(16);
  /* 5: CS high; hand the pins back to the QMI. */
  W32(IOQ_CTRL_SS) = 0;
  W32(IOQ_CTRL_SCLK) = 0;
  W32(IOQ_CTRL_SD0) = 0;
  W32(IOQ_CTRL_SD1) = 0;
  W32(IOQ_CTRL_SD2) = 0;
  W32(IOQ_CTRL_SD3) = 0;
  W32(PADQ_SD0) = sd0pad;
  W32(PADQ_SD1) = sd1pad;
  W32(PADQ_SD2) = sd2pad;
  W32(PADQ_SD3) = sd3pad;
  /* XIP insurance: re-send the command prefix on every burst. */
  W32(QMI_M0_RFMT) = W32(QMI_M0_RFMT) | RFMT_PREFIX_LEN;
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

/* cal_flash2 (prompts/023): the machine-only flash probe sequence,
 * results into r[0..11] for the firmware/SWD to report:
 * r0 phase, r1 JEDEC id, r2 SR, r3 SR after WREN, r4 baseline word,
 * r5 word after erase, r6 word after program, r7 the same word via
 * XIP, r8 done flag. Scratch sector: flash offset 0x130000. */
void
kflash_cal(volatile uint *r)
{
  const uint scratch = 0x130000u;
  r[0] = 1;
  flash_exit_xip();
  r[0] = 2;
  qmi_cs(1);
  qmi_xfer(0x9F);
  r[1] = qmi_xfer(0) << 16 | qmi_xfer(0) << 8 | qmi_xfer(0);
  qmi_end();
  r[0] = 3;
  qmi_cs(1);
  qmi_xfer(0x05);
  r[2] = qmi_xfer(0);
  qmi_end();
  r[0] = 4;
  flash_wren();
  qmi_cs(1);
  qmi_xfer(0x05);
  r[3] = qmi_xfer(0);
  qmi_end();
  r[0] = 5;
  uint rd;
  qmi_cs(1);
  qmi_xfer(0x03);
  qmi_xfer(scratch >> 16);
  qmi_xfer(scratch >> 8);
  qmi_xfer(scratch);
  rd = qmi_xfer(0) | qmi_xfer(0) << 8 | qmi_xfer(0) << 16 | qmi_xfer(0) << 24;
  qmi_end();
  r[4] = rd;
  r[0] = 6;
  flash_erase4k(scratch);
  qmi_cs(1);
  qmi_xfer(0x03);
  qmi_xfer(scratch >> 16);
  qmi_xfer(scratch >> 8);
  qmi_xfer(scratch);
  rd = qmi_xfer(0) | qmi_xfer(0) << 8 | qmi_xfer(0) << 16 | qmi_xfer(0) << 24;
  qmi_end();
  r[5] = rd;
  r[0] = 7;
  uchar page[FLASH_PAGE];
  for (uint i = 0; i < FLASH_PAGE; i++)
    page[i] = (uchar)(0xC0 + i);
  flash_prog_page(scratch, page);
  qmi_cs(1);
  qmi_xfer(0x03);
  qmi_xfer(scratch >> 16);
  qmi_xfer(scratch >> 8);
  qmi_xfer(scratch);
  rd = qmi_xfer(0) | qmi_xfer(0) << 8 | qmi_xfer(0) << 16 | qmi_xfer(0) << 24;
  qmi_end();
  r[6] = rd;
  r[0] = 8;
  r[7] = W32(0x10000000u + scratch); /* XIP must still work */
  r[8] = 1;
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
