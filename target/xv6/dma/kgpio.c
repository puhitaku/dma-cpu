/* GPIO, pin-mux and PIO driver (prompts/034). Manipulation is a
 * kernel API (SYS_gpio / SYS_pinmux / SYS_pio), gpiod-style — not
 * device files — so the footprint stays a few hundred bytes. All of
 * it is plain MMIO the DMA machine issues itself: IO_BANK0 CTRL
 * overrides for output (the silicon-proven trick of the dmaasm `gpio`
 * instruction — SIO is CPU-private and unreachable from DMA),
 * GPIOx_STATUS.INFROMPAD for input, PADS_BANK0 for pad setup, and the
 * PIO register files for programs and state machines.
 *
 * SKU differences (register bases, the override CTRL encodings)
 * arrive as loader-patched globals, like g_fatvol and friends. */

#include "kernel/types.h"

#define W32(a) (*(volatile uint *)(a))

uint iobank0;   /* loader-patched: IO_BANK0 base */
uint padsbank0; /* loader-patched: PADS_BANK0 base */
uint pio0base;  /* loader-patched: PIO0 base; PIO1/2 at +0x100000 each */
uint gpiopins;  /* loader-patched: pin count */
uint gpio_hi;   /* loader-patched: CTRL word driving the pad high */
uint gpio_lo;   /* loader-patched: CTRL word driving the pad low */

/* Pad setup: input buffer on, 4 mA drive, schmitt, output enabled,
 * pulls off. Bit 8 clears RP2350's pad isolation latch and is a
 * write-ignore on RP2040. */
#define PAD_INIT 0x52u

static int
pin_ok(uint pin)
{
  return iobank0 != 0 && pin < gpiopins;
}

static void
pad_init(uint pin)
{
  W32(padsbank0 + 4 + 4 * pin) = PAD_INIT;
}

int
kgpio(uint op, uint pin, uint val)
{
  if (!pin_ok(pin))
    return -1;
  pad_init(pin);
  if (op == 0) { /* write: override the pad regardless of function */
    W32(iobank0 + 8 * pin + 4) = val ? gpio_hi : gpio_lo;
    return 0;
  }
  if (op == 1) /* read: the pad's input buffer */
    return (int)((W32(iobank0 + 8 * pin) >> 17) & 1);
  if (op == 2) { /* read with the internal pull-up (idle-high inputs;
                  * a floating pin then reads 1, not noise) */
    W32(padsbank0 + 4 + 4 * pin) = PAD_INIT | 0x8; /* PUE */
    return (int)((W32(iobank0 + 8 * pin) >> 17) & 1);
  }
  return -1;
}

int
kpinmux(uint pin, uint func)
{
  if (!pin_ok(pin) || func > 0x1F)
    return -1;
  pad_init(pin);
  W32(iobank0 + 8 * pin + 4) = func; /* FUNCSEL, all overrides off */
  return 0;
}

/* --- PIO: load a program, configure a state machine, gate it ---
 * Register map (identical layout on both SKUs): CTRL +0x000 (with
 * +0x2000/+0x3000 set/clear aliases), INSTR_MEM +0x048, and per-SM
 * blocks of 0x18 bytes from +0x0C8: CLKDIV, EXECCTRL, SHIFTCTRL,
 * ADDR, INSTR, PINCTRL. */

struct pio_prog {
  uint pio, origin, count;
  uint instr[32];
};

struct pio_smcfg {
  uint pio, sm, origin;
  uint clkdiv, execctrl, shiftctrl, pinctrl;
};

static uint
pio_base(uint pio)
{
  return pio0base + pio * 0x100000u;
}

int
kpio(uint op, uint a, uint b)
{
  if (pio0base == 0)
    return -1;
  if (op == 0) { /* load: a -> struct pio_prog */
    struct pio_prog *pp = (struct pio_prog *)a;
    if (pp->pio > 2 || pp->origin > 31 || pp->count > 32 ||
        pp->origin + pp->count > 32)
      return -1;
    uint base = pio_base(pp->pio);
    for (uint i = 0; i < pp->count; i++)
      W32(base + 0x48 + 4 * (pp->origin + i)) = pp->instr[i] & 0xFFFFu;
    return 0;
  }
  if (op == 1) { /* init: a -> struct pio_smcfg (SM left disabled) */
    struct pio_smcfg *c = (struct pio_smcfg *)a;
    if (c->pio > 2 || c->sm > 3 || c->origin > 31)
      return -1;
    uint base = pio_base(c->pio);
    uint smb = base + 0xC8 + c->sm * 0x18;
    W32(base + 0x3000) = 1u << c->sm; /* CTRL clear: disable first */
    W32(smb + 0x00) = c->clkdiv;
    W32(smb + 0x04) = c->execctrl;
    W32(smb + 0x08) = c->shiftctrl;
    W32(smb + 0x14) = c->pinctrl;
    W32(base + 0x2000) = 1u << (4 + c->sm); /* CTRL set: SM_RESTART */
    W32(base + 0x2000) = 1u << (8 + c->sm); /* CLKDIV_RESTART */
    W32(smb + 0x10) = c->origin; /* INSTR: forced `jmp origin` */
    return 0;
  }
  if (op == 2) { /* gate: a = pio<<8|sm, b = run/stop */
    uint pio = a >> 8, sm = a & 0xFF;
    if (pio > 2 || sm > 3)
      return -1;
    W32(pio_base(pio) + (b ? 0x2000 : 0x3000)) = 1u << sm;
    return 0;
  }
  return -1;
}

/* /dev introspection (kdev.c): a pad's input level WITHOUT touching
 * the pad config (reading the file must not have side effects). */
uint
kgpio_peek(uint pin)
{
  if (!pin_ok(pin))
    return 0;
  return (W32(iobank0 + 8 * pin) >> 17) & 1;
}

/* /dev introspection (kdev.c): the enabled-SM mask of one PIO. */
uint
kpio_ctrl(uint pio)
{
  if (pio0base == 0 || pio > 2)
    return 0;
  return W32(pio_base(pio)) & 0xFu;
}
