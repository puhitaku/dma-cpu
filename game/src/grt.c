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

int
gpio_in_pu(int pin)
{
  W32(PADSBANK0 + 4 + 4 * (uint)pin) = PAD_INIT | 0x8; /* PUE */
  return (int)((W32(IOBANK0 + 8 * (uint)pin) >> 17) & 1);
}

/* --- bulk DMA on channel 11 (the kdma pattern, bare-metal) --- */

static void
gd_run(uint rd, uint wr, uint count, uint ctrl)
{
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

/* Stream halfwords into the SPI0 data register, paced by the TX
 * DREQ, then drain: the caller flips D/C right after. */
void
gdma_spi16(uint src, uint halfwords)
{
  gd_run(src, SPI0 + 0x8, halfwords, spictrl);
  while (W32(SPI0 + 0xC) & 0x10) /* SSPSR.BSY */
    ;
}
