/* ksd.c: machine-driven MicroSD (SPI mode) — the ARM's last storage
 * duty moves onto the DMA machine. The PL022 is an APB peripheral, so
 * every access here is a register beat: the display-safe traffic
 * class (prompts/041 — nothing below parks the shared read master on
 * a stallable window). Protocol logic is the ARM executor's driver
 * ported record-for-record (CMD0/8/ACMD41 init at ~300 kHz, CMD58 for
 * SDHC block addressing, CMD9/CSD for capacity, CMD17 reads at
 * 25 MHz); the 512-byte payload borrows kdma's channel 11 as an
 * RX-DREQ-paced drain while a machine loop feeds the TX clocks —
 * ch11 is free whenever the kernel runs (kdmacpy runs to completion
 * inside its caller, and the kernel is single-threaded).
 *
 * Zero-config-off like every board seam: g_sd_spi = 0 (the baked
 * default) keeps kflash_sd on the ARM-mailbox path. The loader bakes
 * the SPI base, the CS pin's IO_BANK0 CTRL register and its two
 * override words (drive-low / drive-high with output-enable forced,
 * so the machine owns the pin whatever the ARM left there), and the
 * SKU's drain CTRL (emu.SDRxCtrl). The ARM still muxes the SPI pins
 * and un-resets the block at boot — one-time plumbing, not a runtime
 * role. */
#include "kernel/types.h"

uint sd_spi;    /* g_sd_spi: PL022 base; 0 = machine SD off */
uint sd_csreg;  /* g_sd_csreg: IO_BANK0 GPIOn_CTRL of the CS pin */
uint sd_cs_hi;  /* g_sd_cs_hi: CTRL word driving CS high (deselect) */
uint sd_cs_lo;  /* g_sd_cs_lo: CTRL word driving CS low (select) */
uint sd_rxctrl; /* g_sd_rxctrl: ch11 drain CTRL (TREQ = SPI0 RX) */

#define W(a) (*(volatile uint *)(a))
#define SPI_CR0 (sd_spi + 0x00u)
#define SPI_CR1 (sd_spi + 0x04u)
#define SPI_DR (sd_spi + 0x08u)
#define SPI_SR (sd_spi + 0x0Cu)
#define SPI_CPSR (sd_spi + 0x10u)
#define SPI_DMACR (sd_spi + 0x24u)
#define SR_TNF 0x2u
#define SR_RNE 0x4u

#define SD_CH 11u /* kdma's channel, borrowed between kdmacpy calls */
#define SDCH(i) (*(volatile uint *)(0x50000000u + SD_CH * 0x40u + 4u * (i)))

static uint sd_hc;      /* SDHC/SDXC: block addressing */
static uint sd_sectors; /* capacity from the CSD; 0 = card not up */

int
ksd_on(void)
{
  return sd_spi != 0;
}

static uint
xf(uint b)
{
  W(SPI_DR) = b;
  for (uint i = 0; i < 100000u; i++) {
    if (W(SPI_SR) & SR_RNE)
      return W(SPI_DR) & 0xFFu;
  }
  return 0xFFu;
}

static void
cs(int assert)
{
  W(sd_csreg) = assert ? sd_cs_lo : sd_cs_hi;
  xf(0xFF); /* one clock either side of CS: cards want the edge idle */
}

static uint
sd_cmd(uint c, uint arg, uint crc)
{
  xf(0xFF);
  xf(0x40u | c);
  xf(arg >> 24);
  xf(arg >> 16);
  xf(arg >> 8);
  xf(arg);
  xf(crc);
  for (int i = 0; i < 9; i++) {
    uint r = xf(0xFF);
    if (!(r & 0x80u))
      return r;
  }
  return 0xFFu;
}

/* sd_clock: 8-bit mode-0 frames at clk_peri/(cpsr*(scr+1)); both xsh
 * boards run clk_peri at 150 MHz. */
static void
sd_clock(uint cpsr, uint scr)
{
  W(SPI_CR1) = 0;
  W(SPI_CR0) = (scr << 8) | 7u;
  W(SPI_CPSR) = cpsr;
  W(SPI_DMACR) = 0;
  W(SPI_CR1) = 2u; /* SSE */
}

static int
sd_init_card(uint res)
{
  sd_sectors = 0;
  sd_clock(254u, 1u); /* ~295 kHz for the identification handshake */
  cs(0);
  for (int i = 0; i < 10; i++) /* 80 clocks, CS high: SPI-mode entry */
    xf(0xFF);
  cs(1);
  if (sd_cmd(0, 0, 0x95) != 0x01) {
    cs(0);
    return -1;
  }
  uint v2 = 0;
  if (sd_cmd(8, 0x1AA, 0x87) == 0x01) {
    uint r7 = 0;
    for (int i = 0; i < 4; i++)
      r7 = (r7 << 8) | xf(0xFF);
    if ((r7 & 0xFFFu) == 0x1AAu)
      v2 = 1;
  }
  int ok = 0;
  for (int i = 0; i < 20000; i++) {
    sd_cmd(55, 0, 0x01);
    if (sd_cmd(41, v2 ? (1u << 30) : 0, 0x01) == 0x00) {
      ok = 1;
      break;
    }
  }
  if (!ok) {
    cs(0);
    return -2;
  }
  sd_hc = 0;
  if (v2 && sd_cmd(58, 0, 0x01) == 0x00) {
    uint ocr = 0;
    for (int i = 0; i < 4; i++)
      ocr = (ocr << 8) | xf(0xFF);
    sd_hc = (ocr >> 30) & 1u;
  }
  if (!sd_hc)
    sd_cmd(16, 512, 0x01);
  if (sd_cmd(9, 0, 0x01) == 0x00) { /* SEND_CSD: capacity */
    int tok = -1;
    for (int i = 0; i < 200000; i++) {
      if (xf(0xFF) == 0xFEu) {
        tok = 0;
        break;
      }
    }
    if (tok == 0) {
      uchar csd[16];
      for (int i = 0; i < 16; i++)
        csd[i] = xf(0xFF);
      xf(0xFF); /* CRC */
      xf(0xFF);
      if (csd[0] >> 6 == 1) { /* CSD v2 */
        uint csize = ((uint)(csd[7] & 0x3F) << 16) | ((uint)csd[8] << 8) | csd[9];
        sd_sectors = (csize + 1) * 1024u;
      } else { /* CSD v1 */
        uint csize = ((uint)(csd[6] & 3) << 10) | ((uint)csd[7] << 2) | (csd[8] >> 6);
        uint mult = ((uint)(csd[9] & 3) << 1) | (csd[10] >> 7);
        uint bl = csd[5] & 0xFu;
        sd_sectors = ((csize + 1) << (mult + 2)) << bl >> 9;
      }
    }
  }
  cs(0);
  sd_clock(6u, 0u); /* 25 MHz for data */
  W(res) = sd_sectors ? 0 : (uint)-1;
  W(res + 4) = sd_sectors;
  return sd_sectors ? 0 : -3;
}

static int
sd_read_sector(uint lba, uint dst)
{
  if (sd_sectors == 0)
    return -1;
  cs(1);
  if (sd_cmd(17, sd_hc ? lba : lba * 512u, 0x01) != 0x00) {
    cs(0);
    return -2;
  }
  int tok = -3;
  for (int i = 0; i < 200000; i++) {
    uint r = xf(0xFF);
    if (r == 0xFEu) {
      tok = 0;
      break;
    }
    if (r != 0xFFu && (r & 0xF0u) == 0) {
      tok = -4;
      break;
    }
  }
  if (tok != 0) {
    cs(0);
    return tok;
  }
  /* Payload: ch11 drains SSPDR into the buffer at the RX DREQ's pace
   * while this loop feeds the 512 TX clocks through the 8-deep FIFO.
   * Drain any stray byte first so count and bytes line up. */
  while (W(SPI_SR) & SR_RNE)
    (void)W(SPI_DR);
  W(SPI_DMACR) = 1u; /* RXDMAE */
  SDCH(0) = SPI_DR;
  SDCH(1) = dst;
  SDCH(2) = 512u;
  SDCH(3) = sd_rxctrl;
  uint fed = 0;
  for (uint guard = 0; fed < 512u && guard < 4000000u; guard++) {
    if (W(SPI_SR) & SR_TNF) {
      W(SPI_DR) = 0xFFu;
      fed++;
    }
  }
  for (uint guard = 0; SDCH(2) != 0 && guard < 4000000u; guard++)
    ;
  W(SPI_DMACR) = 0;
  if (SDCH(2) != 0) { /* drain wedged: abort the borrow, fail the read */
    W(0x50000000u + 0x464u) = 1u << SD_CH; /* CHAN_ABORT (RP2350) */
    cs(0);
    return -5;
  }
  xf(0xFF); /* CRC */
  xf(0xFF);
  cs(0);
  return 0;
}

/* ksd_op mirrors the mailbox contract (kflash.c routes here when the
 * seam is armed): op 4 reads sector `off` into `src`; op 5 brings the
 * card up and writes {status, sectors} at `src`. */
int
ksd_op(uint op, uint off, uint src)
{
  if (sd_spi == 0)
    return -1;
  if (op == 5) { /* mailbox contract: the status word at src carries
                  * failure; the call itself succeeds once armed */
    sd_init_card(src);
    return 0;
  }
  if (op == 4)
    return sd_read_sector(off, src) == 0 ? 0 : -1;
  return -1;
}
