/* kcons.c: console DMA — three board-pool channels take the UART wire
 * off the kernel's hands (emu.ConsTxCh and friends; boards with
 * ConsRings set; kconsstub.c is the polling-only twin for kernels that
 * must stay small or boards without the channels).
 *
 * TX: kcons_tx stores into a 512-byte ring and a channel paced by the
 * UART TX DREQ drains it — the FIFO-full spin (~700 instructions per
 * character at wire speed) disappears; kexit's kcons_kick hands each
 * kernel entry's output to the channel in one burst. RX: a channel
 * paced by the RX DREQ lands every received byte in a 1 KiB ring; its
 * chain fires the wake channel, which patches the scheduler dispatch
 * word exactly like the tick injector — input becomes an interrupt,
 * so echo and Ctrl-C stop waiting for the next timer tick. All
 * zero-config-off: g_ctx_ctrl = 0 (the baked default) keeps kproc.c
 * on its polling paths. Registers are baked by dmxgen like inj_wreg.
 */
#include "kernel/types.h"

extern uint inj_wreg; /* kproc.c: the tick injector's WRITE_ADDR reg */

#define W(a) (*(volatile uint *)(a))

#define CONS_TXSZ 512u  /* must match emu.ConsTxRingSize */
#define CONS_RXSZ 1024u /* must match emu.ConsRxRingSize */
uint ctx_base;          /* TX drain channel register block */
uint ctx_ring;          /* TX ring base (size-aligned) */
uint ctx_ctrl;          /* TX CTRL; zero = console DMA off */
uint crx_base, crx_ring, crx_ctrl;
uint cwk_base, cwk_ctrl;
uint cuart_dr; /* UART0 DR address (dmacc's __dma_uart_dr symbol is a
                * register, not an object: its address cannot be taken
                * in C, so the loader bakes the number) */

#define CH_READ_ADDR 0x00u
#define CH_WRITE_ADDR 0x04u
#define CH_TRANS_COUNT 0x08u
#define CH_CTRL_TRIG 0x0Cu
#define CH_AL1_CTRL 0x10u
#define CH_AL1_READ_ADDR 0x14u
#define CH_AL1_WRITE_ADDR 0x18u
#define CH_AL1_COUNT_TRIG 0x1Cu
#define CH_AL2_TRANS_COUNT 0x24u

static uint ctx_head, ctx_tail; /* free-running byte counters */
static uint ctx_prog;           /* bytes handed to the running burst */
static uint crx_tail;           /* RX consumer, an address in the ring */
static uint cwk_scrap;          /* wake target while the kernel runs */
static int cons_on;

int
kcons_on(void)
{
  return cons_on;
}

static void
cons_dma_init(void)
{
  /* UARTDMACR: TXDMAE|RXDMAE — the PL011 raises no DREQ without them
   * (the SPI's TXDMAE taught the same lesson on silicon). DR at +0,
   * DMACR at +0x48. */
  uint dr = cuart_dr;
  W(dr + 0x48) = 0x3;
  /* TX: ring -> DR, byte-wide, armed per burst by kcons_kick. */
  W(ctx_base + CH_AL1_READ_ADDR) = ctx_ring;
  W(ctx_base + CH_AL1_WRITE_ADDR) = dr;
  W(ctx_base + CH_AL1_CTRL) = ctx_ctrl;
  /* Wake: the tick injector's own source word (the scheduler vector)
   * copied over whatever kcons_aim points it at. Chained back to the
   * RX channel, so the pair re-arms itself forever. */
  W(cwk_base + CH_AL1_READ_ADDR) = W(inj_wreg - 4); /* INJ READ_ADDR */
  W(cwk_base + CH_AL1_WRITE_ADDR) = (uint)&cwk_scrap;
  W(cwk_base + CH_AL2_TRANS_COUNT) = 1;
  W(cwk_base + CH_AL1_CTRL) = cwk_ctrl;
  /* RX: DR -> ring, one byte per DREQ; the CTRL_TRIG write arms it. */
  W(crx_base + CH_READ_ADDR) = dr;
  W(crx_base + CH_WRITE_ADDR) = crx_ring;
  W(crx_base + CH_TRANS_COUNT) = 1;
  ctx_head = ctx_tail = 0;
  ctx_prog = 0;
  crx_tail = crx_ring;
  cons_on = 1;
  W(crx_base + CH_CTRL_TRIG) = crx_ctrl;
}

/* kcons_kick: hand any pending ring bytes to the drain channel. Called
 * from kexit (every print path runs inside the kernel) and the
 * ring-full wait; never per byte. */
void
kcons_kick(void)
{
  if (!cons_on || W(ctx_base + CH_TRANS_COUNT) != 0)
    return; /* off, or a burst is still draining */
  ctx_tail += ctx_prog;
  uint n = ctx_head - ctx_tail;
  ctx_prog = n;
  if (n != 0)
    W(ctx_base + CH_AL1_COUNT_TRIG) = n;
}

/* kcons_tx: queue one byte for the wire. Returns 0 when console DMA
 * is not configured (the caller falls back to the FIFO poll). Blocks
 * only on a full 512-byte ring — and then on ring SPACE at one check
 * per drained byte, not ~700 spins per character. */
int
kcons_tx(uint b)
{
  if (!cons_on) {
    if (ctx_ctrl == 0)
      return 0;
    cons_dma_init();
  }
  for (;;) {
    kcons_kick(); /* reclaims the tail as bursts complete */
    uint drained = ctx_prog - W(ctx_base + CH_TRANS_COUNT);
    if (ctx_head - ctx_tail - drained < CONS_TXSZ)
      break;
  }
  *(volatile uchar *)(ctx_ring + (ctx_head & (CONS_TXSZ - 1))) = (uchar)b;
  ctx_head++;
  return 1;
}

/* kcons_rx: one input byte; -1 when the ring is empty, -2 when console
 * DMA is off (the caller reads the FIFO itself). The producer cursor
 * is the fill channel's own WRITE_ADDR register. The ring gives 1 KiB
 * of type-ahead; a producer lapping a stalled consumer silently
 * overwrites the oldest kilobyte, which no interactive or scripted
 * workload approaches. */
int
kcons_rx(void)
{
  if (!cons_on)
    return -2;
  if (W(crx_base + CH_WRITE_ADDR) == crx_tail)
    return -1;
  uint c = *(volatile uchar *)crx_tail;
  crx_tail = crx_ring + ((crx_tail + 1 - crx_ring) & (CONS_RXSZ - 1));
  return (int)c;
}

/* kcons_aim: retarget the wake channel, tick-injector style — at a
 * process dispatch word (or the park vector) on kernel exit, at the
 * internal scrap word (addr 0) while the kernel runs. */
void
kcons_aim(uint addr)
{
  if (!cons_on)
    return;
  if (addr == 0)
    addr = (uint)&cwk_scrap;
  W(cwk_base + CH_WRITE_ADDR) = addr;
}
