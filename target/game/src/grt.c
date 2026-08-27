/* grt.c: the gamepico bare-metal runtime — UART logging, microsecond
 * time, GPIO overrides, and the bulk-DMA helpers. Everything here is
 * machine code driving registers directly; the ARM is asleep. */
#include "g.h"

extern volatile unsigned int __dma_uart_dr; /* mapped by dmacc */
extern volatile unsigned int __dma_uart_fr;

/* Loader-poked CTRL words for the helper channel (11, unused by the
 * compact machine): SKU bit positions come from the generator, the
 * CHAIN_TO=self no-chain lesson included (prompts/037). */
uint memctrl;   /* mem->mem: SIZE32, INCR both, permanent, quiet */
uint spictrl;   /* fb->SPI0 DR: SIZE16, INCR read, TREQ SPI0_TX */

/* The shared game arena (see g.h): the active game's bulk state. */
uint arena_w[GARENA_SZ / 4];
#define GD 11
#define GD_INCR_READ 0x10u /* bit 4 on both SKUs */

static void
uputc(int c)
{
  /* Terminals expect CRLF: the ARM's stdio translates, the machine
   * writes the UART raw — so LF grows its CR here. (No recursion:
   * dmacc frames are static, a self-call clobbers the saved lr.) */
  if (c == '\n') {
    while (__dma_uart_fr & 0x20) /* TXFF */
      ;
    __dma_uart_dr = (uint)'\r';
  }
  while (__dma_uart_fr & 0x20)
    ;
  __dma_uart_dr = (uint)c;
}

void
uputs(const char *s)
{
  while (*s)
    uputc(*s++);
}

void
uputn(uint v)
{
  char d[12];
  int i = 0;
  do {
    d[i++] = '0' + (char)(v % 10);
    v /= 10;
  } while (v);
  while (i)
    uputc(d[--i]);
}

void
uputhex(uint v)
{
  for (int s = 28; s >= 0; s -= 4) {
    uint n = (v >> s) & 0xF;
    uputc(n < 10 ? '0' + (int)n : 'a' + (int)n - 10);
  }
}

/* numstr: v as zero-padded decimal into buf[0..width-1] + NUL. */
void
numstr(char *buf, int width, uint v)
{
  buf[width] = 0;
  for (int i = width - 1; i >= 0; i--) {
    buf[i] = '0' + (char)(v % 10);
    v /= 10;
  }
}

/* numsp: like numstr but space-padded (right-aligned, no leading
 * zeros; a lone 0 still prints). */
void
numsp(char *buf, int width, uint v)
{
  buf[width] = 0;
  for (int i = width - 1; i >= 0; i--) {
    if (v || i == width - 1)
      buf[i] = '0' + (char)(v % 10);
    else
      buf[i] = ' ';
    v /= 10;
  }
}

uint
now_us(void)
{
  return W32(TIMERAWL);
}

void
delay_us(uint us)
{
  uint t0 = W32(TIMERAWL);
  while (W32(TIMERAWL) - t0 < us)
    ;
}

/* --- GPIO: the silicon-proven IO_BANK0 override trick (SIO is
 * CPU-private; OUTOVER/OEOVER in the pin's CTRL register are not). */
#define PAD_INIT 0x52u

void
gpio_fn(int pin, uint ctrl)
{
  W32(PADSBANK0 + 4 + 4 * (uint)pin) = PAD_INIT;
  W32(IOBANK0 + 8 * (uint)pin + 4) = ctrl;
}

void
gpio_out(int pin, int hi)
{
  /* RP2040: OEOVER bits 13:12 = 3 (enable), OUTOVER bits 9:8 */
  W32(IOBANK0 + 8 * (uint)pin + 4) = (3u << 12) | ((hi ? 3u : 2u) << 8);
}

void
gpio_in_init(int pin)
{
  W32(PADSBANK0 + 4 + 4 * (uint)pin) = PAD_INIT | 0x8; /* PUE */
}

uint
gpio_in(int pin)
{
  /* Returns the RAW masked bit (nonzero = high), deliberately not a
   * 0/1 bool: `!= 0` makes clang canonicalize the test into
   * lshr 17 + and 1, and every >> on this machine is a ~30-iteration
   * runtime loop — the sampling profiler clocked that one shift at
   * 71%% of the dino frame. A bare mask has nothing to canonicalize. */
  return W32(IOBANK0 + 8 * (uint)pin) & 0x20000u;
}

/* --- bulk DMA on channel 11 (the kdma pattern, bare-metal) --- */

/* gd_wait: ch11 may still be draining an ASYNC lcd flush (the wire
 * is slow; the machine shoots radiosity meanwhile). Every entry that
 * programs the channel — and fx.c's pcm_play, which borrows it —
 * waits here first. */
void
gd_wait(void)
{
  while (W32(DMACH(GD) + 0x8) != 0)
    ;
}

static void
gd_run(uint rd, uint wr, uint count, uint ctrl)
{
  gd_wait();
  W32(DMACH(GD) + 0x0) = rd;
  W32(DMACH(GD) + 0x4) = wr;
  W32(DMACH(GD) + 0x8) = count;
  W32(DMACH(GD) + 0xC) = ctrl; /* CTRL_TRIG */
  while (W32(DMACH(GD) + 0x8) != 0)
    ;
}

void
gdma_copy(uint dst, uint src, uint bytes)
{
  if (bytes == 0)
    return;
  if (((dst | src | bytes) & 3) == 0 && memctrl) {
    gd_run(src, dst, bytes >> 2, memctrl);
    return;
  }
  const uchar *s = (const uchar *)src;
  uchar *d = (uchar *)dst;
  for (uint i = 0; i < bytes; i++)
    d[i] = s[i];
}

void
gdma_fill(uint dst, uint word, uint bytes)
{
  static uint fill;
  if (bytes == 0)
    return;
  if (((dst | bytes) & 3) == 0 && memctrl) {
    fill = word;
    gd_run((uint)&fill, dst, bytes >> 2, memctrl & ~GD_INCR_READ);
    return;
  }
  for (uint p = dst; p < dst + bytes; p += 4)
    W32(p) = word;
}

/* gdma_rows: n rows of `words` 32-bit words each, dst advancing by
 * dstride bytes per row, src by sstride (0 = refill from the same
 * place). One CTRL decode and NO shifts — the per-row gd_run path
 * cost a runtime bytes>>2 per row, which the profiler saw. */
void
gdma_rows(uint dst, uint src, uint words, int rows, uint dstride,
          uint sstride)
{
  /* AL3 alias trick: CTRL and TRANS_COUNT program ONCE (the count
   * reloads itself on every trigger), so each row is two register
   * writes — write addr, then READ_ADDR_TRIG fires it. The row loop
   * is the hottest thing the profiler sees; every store here is
   * dmacc-compiled and far from free. */
  gd_wait();
  W32(DMACH(GD) + 0x10) = sstride ? memctrl : (memctrl & ~GD_INCR_READ);
  W32(DMACH(GD) + 0x38) = words; /* AL3_TRANS_COUNT: the reload */
  for (int r = 0; r < rows; r++) {
    W32(DMACH(GD) + 0x34) = dst; /* AL3_WRITE_ADDR */
    W32(DMACH(GD) + 0x3C) = src; /* AL3_READ_ADDR_TRIG: go */
    while (W32(DMACH(GD) + 0x8) != 0)
      ;
    dst += dstride;
    src += sstride;
  }
}

/* gdma_spi_rows: the flush inner loop — dst (SPI DR), count, and
 * CTRL are constant, so each row is ONE trigger write plus the
 * completion poll. A full-width rectangle is contiguous in the fb:
 * one burst, one poll — the per-row spin waited out the WIRE row by
 * row (61 us per full row at 62.5 Mbit) and profiled as the hottest
 * paint-path function. */
void
gdma_spi_rows(uint src, uint halfwords, int rows, uint sstride)
{
  gd_wait();
  W32(DMACH(GD) + 0x10) = spictrl;
  W32(DMACH(GD) + 0x34) = SPI0 + 0x8;
  if (sstride == halfwords * 2) { /* contiguous rect: fire and RETURN
                                   * — the caller's next gdma/lcd op
                                   * absorbs the wire wait via
                                   * gd_wait, and the machine computes
                                   * through the drain */
    W32(DMACH(GD) + 0x38) = halfwords * (uint)rows;
    W32(DMACH(GD) + 0x3C) = src;
    return;
  }
  W32(DMACH(GD) + 0x38) = halfwords;
  for (int r = 0; r < rows; r++) {
    W32(DMACH(GD) + 0x3C) = src; /* AL3_READ_ADDR_TRIG */
    src += sstride;
    if (r != rows - 1) /* the last row drains under the next gd_wait */
      while (W32(DMACH(GD) + 0x8) != 0)
        ;
  }
}

/* Stream halfwords into the SPI0 data register, paced by the TX
 * DREQ. NO drain here: multi-row flushes only need the bus idle
 * before the D/C flip, and spi_bits' wait_idle covers that — a
 * per-row full drain serialized every row on the wire. */
void
gdma_spi16(uint src, uint halfwords)
{
  gd_run(src, SPI0 + 0x8, halfwords, spictrl);
}
