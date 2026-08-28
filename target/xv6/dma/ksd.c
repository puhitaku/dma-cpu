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
uint sd_txch;   /* g_sd_txch: console-TX channel regs (borrowed as the
                 * TX-DREQ-paced clock feeder while it idles); 0 = off */
uint sd_txctrl; /* g_sd_txctrl: the borrowed feeder's CTRL */

static uint sd_ff = 0xFFFFFFFFu; /* idle-clock source byte */

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

/* Bring-up diagnostic: one line per init attempt over the kernel
 * console — each handshake stage's response byte, so silicon
 * failures name their stage instead of a bare "mount: failed". */
extern void kconswrite(const char *b, int n);
extern void klogts(void); /* kproc.c: "[sec.ms] " kernel-log stamp */
static void
sd_diag(const char *tag, uint v)
{
  char b[16];
  int n = 0;
  while (*tag)
    b[n++] = *tag++;
  const char *hx = "0123456789abcdef";
  b[n++] = hx[(v >> 28) & 0xF];
  b[n++] = hx[(v >> 24) & 0xF];
  b[n++] = hx[(v >> 20) & 0xF];
  b[n++] = hx[(v >> 16) & 0xF];
  b[n++] = hx[(v >> 12) & 0xF];
  b[n++] = hx[(v >> 8) & 0xF];
  b[n++] = hx[(v >> 4) & 0xF];
  b[n++] = hx[v & 0xF];
  kconswrite(b, n);
}

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

/* sd_wait_ready: clock until the card outputs idle 0xFF — absorbs
 * R1b busy states, residual bytes of an aborted block read, and the
 * first-exchange-after-select glitch silicon showed. */
static int
sd_wait_ready(void)
{
  for (uint i = 0; i < 500000u; i++) {
    if (xf(0xFF) == 0xFFu)
      return 0;
  }
  return -1;
}

static uint
sd_cmd(uint c, uint arg, uint crc)
{
  /* A stale RX byte desyncs every response that follows (the R1 poll
   * eats it and the token wait then chews the real R1): start every
   * command with an empty FIFO. */
  while (W(SPI_SR) & SR_RNE)
    (void)W(SPI_DR);
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
  /* Live update, SDK-style: the PL022 takes CPSR/SCR changes while
   * enabled (spi_set_baudrate does exactly this), and toggling SSE
   * between init and reads left state that desynced the RX stream on
   * silicon. Only the very first call finds SSE clear and sets it. */
  W(SPI_CR0) = (scr << 8) | 7u;
  W(SPI_CPSR) = cpsr;
  W(SPI_CR1) = 2u; /* SSE (idempotent) */
}

static int
sd_init_card(uint res)
{
  sd_sectors = 0;
  /* Bisect (silicon bring-up): attempt the handshake FIRST on the
   * SDK's untouched boot configuration (400 kHz, mode 0) — no machine
   * writes to CR0/CPSR at all — and only reprogram the block if that
   * fails. Distinguishes "machine SPI-config corrupts the clock" from
   * protocol-level trouble. */
  sd_clock(254u, 1u); /* ~295 kHz for the identification handshake */
  cs(0);
  for (int i = 0; i < 10; i++) /* 80 clocks, CS high: SPI-mode entry */
    xf(0xFF);
  cs(1);
  /* CMD0 with retries: the first exchange after power-up can carry a
   * garbage byte in the response gap (silicon showed a stray 0x7F
   * before the real 0x01), and the R1 poll takes the first bit7-clear
   * byte. Fresh idle clocks between attempts let the card settle. */
  uint r0 = 0xFF;
  for (int t = 0; t < 8; t++) {
    r0 = sd_cmd(0, 0, 0x95);
    if (r0 == 0x01)
      break;
    sd_wait_ready();
  }
  klogts();
  sd_diag("sd: cmd0=", r0);
  if (r0 != 0x01) {
    cs(0);
    kconswrite("\n", 1);
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
  sd_diag(" v2=", v2);
  sd_diag(" a41=", (uint)ok);
  if (!ok) {
    cs(0);
    kconswrite("\n", 1);
    return -2;
  }
  sd_hc = 0;
  if (v2 && sd_cmd(58, 0, 0x01) == 0x00) {
    uint ocr = 0;
    for (int i = 0; i < 4; i++)
      ocr = (ocr << 8) | xf(0xFF);
    sd_hc = (ocr >> 30) & 1u;
  }
  sd_cmd(59, 0, 0x01); /* CRC explicitly OFF: CMD8's real-CRC frame
                        * leaves some cards in an ambiguous state */
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
  sd_clock(6u, 0u); /* 25 MHz for data. (The bring-up's "fast clock
                     * failures" were the dmacc switch-width bug
                     * wearing a signal-integrity costume: the token
                     * check could never match at ANY clock.) */
  sd_diag(" hc=", sd_hc);
  sd_diag(" cap=", sd_sectors);
  kconswrite("\n", 1);
  W(res) = sd_sectors ? 0 : (uint)-1;
  W(res + 4) = sd_sectors;
  return sd_sectors ? 0 : -3;
}

/* sd_token_wait: clock until the 0xFE data token. 0 on token, -1 on
 * an error token or exhaustion. Sized for the FAST clock (see
 * sd_begin_read). */
static int
sd_token_wait(void)
{
  for (uint i = 0; i < 2000000u; i++) {
    uint r = xf(0xFF);
    if (r == 0xFEu)
      return 0;
    if (r != 0xFFu && r != 0 && (r & 0xF0u) == 0)
      return -1; /* a real error token (0x01..0x0F; 0x00 is data) */
  }
  return -1;
}

/* sd_begin_read: CMD17 + data-token wait. 0 on token. The wait is
 * iteration-counted, so it must be sized for the FAST clock: the SD
 * spec allows 100 ms of access time, and at 25 MHz two hundred
 * thousand polled bytes was only ~65 ms of wire time — the 295 kHz
 * CSD read enjoyed an 80x longer budget purely by running slower. */
static int
sd_begin_read(uint lba)
{
  cs(1);
  /* First-command-after-select retries, all within one CS session:
   * silicon showed the first frame of a fresh session corrupting
   * (CMD0 needed the same treatment), and the misheard command can
   * leave the card busy — wait-ready between attempts clears it. */
  uint r1 = 0xFFu;
  for (int t = 0; t < 4; t++) {
    sd_wait_ready();
    r1 = sd_cmd(17, sd_hc ? lba : lba * 512u, 0x01);
    if (r1 == 0x00)
      break;
  }
  if (r1 != 0x00) {
    cs(0);
    sd_diag(" r1=", r1);
    return -2;
  }
  if (sd_token_wait() == 0)
    return 0;
  cs(0);
  return -3;
}

static uint sd_slow; /* the fast clock failed: stay at init speed */

/* The speed ladder: reads run at 25 MHz; a failure drops to the
 * proven identification clock permanently (one diag line marks it)
 * after a wait-ready absorbs whatever the failed attempt left. */
static int
sd_begin_read_any(uint lba)
{
  int r = sd_begin_read(lba);
  if (r == 0 || sd_slow)
    return r;
  sd_slow = 1;
  sd_clock(254u, 1u);
  klogts();
  sd_diag("sd: rd=", (uint)-r);
  kconswrite(" -> slow\n", 9);
  return sd_begin_read(lba);
}

/* Polled payload: the certain path (one xf per byte). */
static int
sd_read_polled(uint lba, uint dst)
{
  int r = sd_begin_read_any(lba);
  if (r != 0)
    return r;
  for (uint i = 0; i < 512u; i++)
    *(volatile uchar *)(dst + i) = (uchar)xf(0xFF);
  xf(0xFF); /* CRC */
  xf(0xFF);
  cs(0);
  return 0;
}

static uint sd_burst_state; /* 0 untried, 1 works, 2 failed (diag once) */
static int sd_payload(uint dst);

static int
sd_read_sector(uint lba, uint dst)
{
  if (sd_sectors == 0)
    return -1;
  if (sd_burst_state == 2)
    return sd_read_polled(lba, dst);
  int r = sd_begin_read_any(lba);
  if (r != 0)
    return r;
  r = sd_payload(dst);
  if (r == -9) { /* drain wedged: caller-visible recovery below */
    cs(0); /* deselect aborts the single-block read */
    for (int i = 0; i < 4; i++)
      xf(0xFF);
    return sd_read_polled(lba, dst);
  }
  if (r != 0)
    return r;
  sd_burst_state = 1;
  xf(0xFF); /* CRC */
  xf(0xFF);
  cs(0);
  return 0;
}

/* sd_payload: one 512-byte block into dst — ch11 drains SSPDR at the
 * RX DREQ's pace while the TX clocks come from the console-channel
 * borrow (or the credit-batched machine feed). 0 on success; -9 when
 * the drain wedged (ch11 aborted, sd_burst_state marked: the caller
 * abandons the session). */
static int
sd_payload(uint dst)
{
  /* Drain any stray byte first so count and bytes line up. */
  while (W(SPI_SR) & SR_RNE)
    (void)W(SPI_DR);
  W(SPI_DMACR) = 3u; /* RXDMAE|TXDMAE */
  SDCH(0) = SPI_DR;
  SDCH(1) = dst;
  SDCH(2) = 512u;
  SDCH(3) = sd_rxctrl;
  /* TX clocks: borrow the console drain channel while it idles (the
   * kernel prints nothing mid-read) — both directions then run at
   * DREQ pace and the whole payload costs ~machine-free wire time.
   * Its registers are saved and restored around the borrow, and no
   * kconswrite may happen in between (a console kick would fight
   * it). Fallback: the credit-batched machine feed. */
  uint tx = sd_txch;
  if (tx != 0 && !(W(tx + 0x10u) & (1u << 26))) { /* BUSY (RP2350) */
    uint s_r = W(tx + 0x00u), s_w = W(tx + 0x04u), s_c = W(tx + 0x10u);
    W(tx + 0x00u) = (uint)&sd_ff;
    W(tx + 0x04u) = SPI_DR;
    W(tx + 0x10u) = sd_txctrl;
    W(tx + 0x1Cu) = 512u; /* AL1 count trigger: the feed runs */
    for (uint guard = 0; (W(tx + 0x10u) & (1u << 26)) && guard < 4000000u; guard++)
      ; /* wire-paced (~165 us at 25 MHz) */
    W(tx + 0x00u) = s_r;
    W(tx + 0x04u) = s_w;
    W(tx + 0x10u) = s_c;
  } else {
    uint fed = 0;
    for (uint guard = 0; fed < 512u && guard < 4000000u; guard++) {
      uint inflight = fed - (512u - SDCH(2));
      if (inflight == 0 && fed <= 504u) {
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        W(SPI_DR) = 0xFFu;
        fed += 8u;
        continue;
      }
      uint room = 0;
      if (inflight < 8u)
        room = 8u - inflight;
      if (room > 512u - fed)
        room = 512u - fed;
      for (uint k = 0; k < room; k++) {
        W(SPI_DR) = 0xFFu;
        fed++;
      }
    }
  }
  for (uint guard = 0; SDCH(2) != 0 && guard < 4000000u; guard++)
    ;
  W(SPI_DMACR) = 0;
  if (SDCH(2) != 0) { /* drain wedged: abort ch11, mark, bail */
    uint left = SDCH(2);
    W(0x50000000u + 0x464u) = 1u << SD_CH; /* CHAN_ABORT (RP2350) */
    for (uint guard = 0; (SDCH(4) & (1u << 26)) && guard < 100000u; guard++)
      ; /* AL1_CTRL.BUSY: the abort is asynchronous on silicon */
    SDCH(4) = 0;
    if (sd_burst_state != 2) {
      sd_burst_state = 2;
      klogts();
      sd_diag("sd: burst left=", left);
      kconswrite(" -> polled\n", 11);
    }
    return -9;
  }
  return 0;
}

/* ksd_read_run: `n` contiguous sectors straight into dst via CMD18 —
 * ONE command and ONE card access gap for the whole run instead of
 * per sector (the per-CMD17 NAND access time dominated slide loads:
 * ~600 sectors x hundreds of us of card latency). Any failure
 * returns -1 with the session closed; the caller re-reads the span
 * per-sector, so partial data never leaks. */
int
ksd_read_run(uint lba, uint dst, uint n)
{
  if (sd_spi == 0 || sd_sectors == 0 || sd_slow || sd_burst_state == 2)
    return -1;
  cs(1);
  uint r1 = 0xFFu;
  for (int t = 0; t < 4; t++) {
    sd_wait_ready();
    r1 = sd_cmd(18, sd_hc ? lba : lba * 512u, 0x01);
    if (r1 == 0x00)
      break;
  }
  if (r1 != 0x00) {
    cs(0);
    return -1;
  }
  for (uint i = 0; i < n; i++) {
    if (sd_token_wait() != 0 || sd_payload(dst + 512u * i) != 0) {
      sd_cmd(12, 0, 0x01); /* STOP, then absorb the busy tail */
      sd_wait_ready();
      cs(0);
      xf(0xFF);
      return -1;
    }
    xf(0xFF); /* block CRC */
    xf(0xFF);
  }
  sd_cmd(12, 0, 0x01);
  sd_wait_ready(); /* R1b: the card may hold busy after STOP */
  cs(0);
  xf(0xFF);
  sd_burst_state = 1;
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
