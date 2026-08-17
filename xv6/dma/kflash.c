/* DMA-machine flash persistence (prompts/022, machine-only path
 * reinstated in prompts/028): sync POLICY lives in the kernel — the
 * dirty-sector map, incremental vs full burns, the header-last
 * commit, the generation counter — and the erase/program PRIMITIVES
 * run on one of two executors:
 *
 *  - QMI direct mode, driven ENTIRELY BY THE MACHINE. This was
 *    believed hardware-impossible (prompts/023: QMI register reads
 *    stalled the DMA channel, and setting DIRECT_CSR.EN froze the
 *    machine's peripheral reads). The real cause was ACCESSCTRL:
 *    XIP_QMI and XIP_CTRL reset to 0xB8 — DMA access FORBIDDEN
 *    (RP2350 datasheet §10.6.2.1) — so every machine access to the
 *    QMI bus-faulted. The firmware now opens them (password
 *    0xacce0000 | 0xfc) before starting the machine, and the driver
 *    below runs on silicon: exit-XIP dance, WREN, RDSR/WIP polling,
 *    4K erase, 256B page program, then an XIP-compatible serial read
 *    config so subsequent XIP fetches work from plain-SPI state.
 *  - The parked ARM's SRAM mailbox loop (kflash_arm != 0): the SDK's
 *    XIP-safe routines execute {op, off, src} requests. Kept as the
 *    fallback executor and for A/B validation.
 *
 * Slot layout (loader-patched fsslot, sector-aligned XIP address):
 *   +0x0000  header sector: magic 'DMFS', generation, length,
 *            word-sum checksum of the image
 *   +0x1000  the disk image
 * The header is erased first and programmed LAST: a torn sync leaves
 * an invalid header and boot falls back to the golden image. */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"

#define W32(a) (*(volatile uint *)(a))

/* QMI direct mode (RP2350; register layout from hardware/regs/qmi.h). */
#define QMI_DIRECT_CSR 0x400D0000u
#define QMI_DIRECT_TX 0x400D0004u
#define QMI_DIRECT_RX 0x400D0008u
#define QMI_M0_RFMT 0x400D0010u
#define QMI_M0_RCMD 0x400D0014u
#define CSR_EN (1u << 0)
#define CSR_BUSY (1u << 1)
#define CSR_CS0N (1u << 2)
#define CSR_RXEMPTY (1u << 16)
#define CSR_ASSERT (CSR_EN | CSR_CS0N | (4u << 22)) /* clkdiv=4 */

#define FLASH_SECTOR 4096u
#define FLASH_PAGE 256u
#define FS_MAGIC 0x53464D44u /* 'DMFS' */

#define TIMER_RAWL 0x400B0028u /* free-running us counter */

extern uint dma_disk;     /* RAM disk base (kbio.c) */
extern uint dma_disksize;
extern uint fs_dirty;     /* per-4K-sector dirty bits (kbio.c) */

uint fsslot;     /* loader-patched: XIP address of the slot header;
                  * 0 = no persistence configured */
uint kflash_arm; /* loader-patched: &flashreq mailbox in SRAM, or 0
                  * to let the machine drive the QMI itself */
uint kflash_phase; /* diagnostic: fine-grained progress marker */

struct flashreq {
  uint op;  /* 1 erase 4K, 2 program 256 */
  uint off; /* flash byte offset */
  uint src; /* PROG: RAM source */
  uint seq, ack;
};

static uint fs_gen; /* generation we last saw/wrote in the slot */

/* --- QMI direct-mode primitives (machine executor) --- */

static void
qmi_cs(int assert)
{
  uint v = W32(QMI_DIRECT_CSR);
  if (assert)
    v |= CSR_EN | CSR_CS0N | (4u << 22);
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

/* --- The exit-XIP dance (the bootrom's sequence, bit-banged through
 * the QSPI pad overrides so it works whatever read mode the flash is
 * in — 1-bit or quad continuous):
 *   1. CS high, SD0..3 PULLED low,  32 clocks   (mode bits = 0)
 *   2. CS low,  SD0..3 PULLED high, 32 clocks   (mode bits = 1)
 *   3. CS high
 *   4. CS low,  SD0 DRIVEN high,    16 clocks   (FFh FFh)
 *   5. CS high, restore all overrides
 * The pulls (not drives) avoid contention while the flash may still
 * be driving SD1 during reads. Afterwards the flash parses plain-SPI
 * commands. */
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
  W32(IOQ_CTRL_SD0) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD1) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD2) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SD3) = OEOVER_DISABLE;
  W32(IOQ_CTRL_SS) = OUTOVER_HIGH | OEOVER_ENABLE;
  qspi_sd_pulls(PAD_PDE);
  kflash_phase = 13;
  qspi_clocks(32);
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
  kflash_phase = 18;
}

/* After direct-mode work the flash sits in plain-SPI mode; program
 * the XIP read path to match (serial 03h read, command re-sent every
 * burst) so header checks and boot staging keep working. Slow reads,
 * but the disk lives in RAM — XIP is only metadata. The next ARM
 * reboot restores the bootrom's quad configuration. */
static void
qmi_serial_xip(void)
{
  W32(QMI_M0_RFMT) = 0x1000u; /* PREFIX_LEN=1, all lanes serial */
  W32(QMI_M0_RCMD) = 0x03u;   /* plain read, no suffix */
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

/* --- ARM mailbox executor (fallback) --- */

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

/* --- Executor-dispatched primitives --- */

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

/* Reads the slot header via the UNCACHED XIP alias (+0x04000000):
 * after a sync rewrote the header, the cached window may hold stale
 * lines and neither executor flushes the XIP cache for us. Returns
 * the generation, or 0 when the slot does not hold a valid image of
 * our size. */
uint
kflash_slot_gen(void)
{
  if (fsslot == 0)
    return 0;
  const uint *h = (const uint *)(fsslot + 0x04000000u);
  if (h[0] != FS_MAGIC || h[2] != dma_disksize)
    return 0;
  return h[1];
}

void
kflash_init(void)
{
  fs_gen = kflash_slot_gen();
}

/* cal_flash (prompts/028, replacing the prompts/023 characterization):
 * the machine-only probe, now with ACCESSCTRL opened by the firmware.
 * Results into r[0..11] for the firmware/SWD to report:
 *   r[9]  us-timer read, normal state
 *   r[1]  DIRECT_CSR readback after writing EN (0 would mean the old
 *         ACCESSCTRL stall; nonzero = the register file answers)
 *   r[10] us-timer read while DIRECT_CSR.EN is set
 *   r[11] us-timer read after EN cleared
 *   r[2]  JEDEC id (9Fh, expect 0xEF4016 on the Pico 2's W25Q32)
 *   r[3]  status register; r[4] status after WREN (WEL, bit 1)
 *   r[5]  scratch word after 4K erase, read back over direct 03h
 *         (expect 0xFFFFFFFF)
 *   r[6]  the same word after page program (expect 0x0DA0CE11)
 *   r[7]  the same word via the uncached XIP alias afterwards
 *   r[8]  done flag. Scratch sector: flash offset 0x130000. */
#define CAL_OFF 0x130000u

static uint
qmi_read32(uint off)
{
  qmi_cs(1);
  qmi_xfer(0x03);
  qmi_xfer(off >> 16);
  qmi_xfer(off >> 8);
  qmi_xfer(off);
  uint v = 0;
  for (int i = 0; i < 4; i++)
    v |= qmi_xfer(0) << (8 * i);
  qmi_end();
  return v;
}

void
kflash_cal(volatile uint *r)
{
  /* Wait for the ARM to reach its SRAM wait loop (it writes the GO
   * word there): from the first DIRECT_CSR write onward, XIP is
   * unusable and any ARM flash fetch is an instruction bus error. */
  while (r[12] != 0x600D600Du)
    ;
  r[0] = 1;
  r[9] = W32(TIMER_RAWL);
  W32(QMI_DIRECT_CSR) = CSR_ASSERT & ~CSR_CS0N; /* EN, CS idle */
  r[1] = W32(QMI_DIRECT_CSR);
  r[10] = W32(TIMER_RAWL);
  W32(QMI_DIRECT_CSR) = 0;
  r[11] = W32(TIMER_RAWL);
  r[0] = 2;
  flash_exit_xip();
  r[0] = 3;
  qmi_cs(1);
  qmi_xfer(0x9F);
  r[2] = (qmi_xfer(0) << 16) | (qmi_xfer(0) << 8) | qmi_xfer(0);
  qmi_end();
  qmi_cs(1);
  qmi_xfer(0x05);
  r[3] = qmi_xfer(0);
  qmi_end();
  flash_wren();
  qmi_cs(1);
  qmi_xfer(0x05);
  r[4] = qmi_xfer(0);
  qmi_end();
  r[0] = 4;
  flash_erase4k(CAL_OFF);
  r[5] = qmi_read32(CAL_OFF);
  r[0] = 5;
  static const uchar pat[4] = {0x11, 0xCE, 0xA0, 0x0D};
  uchar page[FLASH_PAGE];
  for (uint i = 0; i < FLASH_PAGE; i++)
    page[i] = pat[i % 4];
  flash_prog_page(CAL_OFF, page);
  r[6] = qmi_read32(CAL_OFF);
  r[0] = 6;
  qmi_serial_xip();
  r[7] = W32(0x14000000u + CAL_OFF); /* uncached XIP alias */
  r[0] = 7;
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
  if (!kflash_arm)
    qmi_serial_xip(); /* keep XIP readable from plain-SPI state */

  fs_gen++;
  fs_dirty = 0;
  return 0;
}