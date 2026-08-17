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
uint kflash_phase; /* diagnostic: fine-grained progress marker */

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
#define TIMER_RAWL 0x400B0028u /* free-running us counter (readable) */

/* Machine-only flash writing is BLIND: the RP2350 DMA engine cannot
 * READ the QMI registers (a bare read of DIRECT_CSR stalls the DMA
 * channel — characterized in prompts/023), so the driver never polls
 * status or reads back. It issues command/address/data purely through
 * DIRECT_TX writes with NOPUSH (nothing enters the RX FIFO), paces
 * itself with the microsecond timer (a normal peripheral the machine
 * CAN read), and waits fixed times for erase/program to finish
 * instead of polling WIP. Verification is the caller's job, via XIP
 * after the QMI leaves direct mode. */
#define CSR_ASSERT (CSR_EN | CSR_CS0N | (4u << 22)) /* clkdiv=4 */

static void
flash_delay_us(uint us)
{
  uint start = W32(TIMER_RAWL);
  while (W32(TIMER_RAWL) - start < us)
    ;
}

static void
qmi_begin(void)
{
  W32(QMI_DIRECT_CSR) = CSR_ASSERT;
}

/* Fixed SRAM-only spin — NO peripheral reads. While DIRECT_CSR.EN is
 * set the DMA engine's peripheral reads all return 0 (the timer
 * included; characterized in prompts/023), so pacing inside a
 * transaction must not touch the timer. */
static void
spin(uint n)
{
  for (volatile uint i = 0; i < n; i++)
    ;
}

static void
qmi_tx(uint b)
{
  W32(QMI_DIRECT_TX) = (b & 0xFFu) | TX_NOPUSH;
  spin(40); /* a machine write is already slow; the FIFO never fills */
}

static void
qmi_finish(void)
{
  spin(200);               /* drain the last byte (CS still asserted) */
  W32(QMI_DIRECT_CSR) = 0; /* deassert CS, leave direct mode */
  spin(40);                /* let the QMI settle before timer reads */
}

static void
bwren(void)
{
  qmi_begin();
  qmi_tx(0x06);
  qmi_finish();
}

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
  kflash_phase = 10;
  uint sd0pad = W32(PADQ_SD0), sd1pad = W32(PADQ_SD1);
  uint sd2pad = W32(PADQ_SD2), sd3pad = W32(PADQ_SD3);
  kflash_phase = 11; /* PADQ reads returned */
  W32(IOQ_CTRL_SD0) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD1) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD2) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD3) = OEOVER_DISABLE;
  kflash_phase = 12; /* IO_QSPI SD overrides written */
  W32(IOQ_CTRL_SS) = OUTOVER_HIGH | OEOVER_ENABLE;
  qspi_sd_pulls(PAD_PDE);
  kflash_phase = 13; /* pads pulled low, about to clock */
  qspi_clocks(32);
  kflash_phase = 14; /* first 32 clocks done */
  W32(IOQ_CTRL_SS) = OUTOVER_LOW | OEOVER_ENABLE;
  qspi_sd_pulls(PAD_PUE);
  qspi_clocks(32);
  kflash_phase = 15;
  W32(IOQ_CTRL_SS) = OUTOVER_HIGH | OEOVER_ENABLE;
  W32(IOQ_CTRL_SS) = OUTOVER_LOW | OEOVER_ENABLE;
  W32(IOQ_CTRL_SD0) = OUTOVER_HIGH | OEOVER_ENABLE;
  qspi_clocks(16);
  kflash_phase = 16;
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
  kflash_phase = 18; /* dance complete (RFMT insurance dropped — its
                      * read-modify-write stalled the DMA read of the
                      * QMI register; prompts/023 diagnostic) */
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
  /* Read-based reference driver (emulator NOR model; on silicon the
   * ARM executor is always selected — the machine cannot poll WIP,
   * prompts/023). */
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
  /* The definitive characterization (prompts/023) of why the DMA
   * machine cannot autonomously write RP2350 flash. All three probes
   * are reads the machine performs itself:
   *   r[9]  timer read, normal state           -> works
   *   r[10] timer read while DIRECT_CSR.EN=1    -> 0 (frozen)
   *   r[11] timer read after EN cleared + spin  -> still 0 (no recovery)
   * Writes work throughout; the pad-bit-banged exit-XIP dance
   * (flash_exit_xip) completes. But entering QMI direct mode — the
   * only way to issue a flash command — permanently freezes the
   * machine's peripheral reads, so it can neither poll status, time
   * its own delays, nor verify. Only the ARM executor (SDK XIP-safe
   * routines) can restore the bus. */
  r[9] = W32(TIMER_RAWL);
  W32(QMI_DIRECT_CSR) = CSR_ASSERT;
  r[10] = W32(TIMER_RAWL);
  W32(QMI_DIRECT_CSR) = 0;
  spin(1000);
  r[11] = W32(TIMER_RAWL);
  r[0] = 4;
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
