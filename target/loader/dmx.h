/* DMX executable loader for the DMA machine (RP2 target side).
 *
 * Parses the DMX image format (doc/dmx.md), places segments into SRAM,
 * applies relocations and init writes, and starts the 3-channel
 * fetch/execute machine. Freestanding C99; no Pico SDK dependency — MMIO
 * is done through volatile pointers, so this compiles into any bare-metal
 * or SDK-based firmware.
 *
 * SKU selection: the DMA CTRL bit layout differs between RP2040 and
 * RP2350. Compile with -DDMX_TARGET_RP2350 for RP2350; the default is
 * RP2040. The image itself must also have been assembled for the same
 * SKU — DMX carries SKU-specific control words as opaque payload.
 *
 * NOT YET VALIDATED ON HARDWARE: the emulator-side loader (host/img/load.go) is
 * the behavioural reference until the Phase 0 HIL rig exists.
 */
#ifndef DMX_H
#define DMX_H

#include <stddef.h>
#include <stdint.h>

enum {
    DMX_OK = 0,
    DMX_ERR_TRUNCATED = -1,
    DMX_ERR_MAGIC = -2,
    DMX_ERR_FLAGS = -3,
    DMX_ERR_RANGE = -4,     /* table index or offset out of range */
    DMX_ERR_ALIGN = -5,     /* segment/entry alignment violated */
    DMX_ERR_TOO_MANY = -6,  /* more segments than DMX_MAX_SEGMENTS */
    DMX_ERR_CONFIG = -7,    /* bad machine configuration */
};

#define DMX_MAX_SEGMENTS 16

/* Placement: load address per segment, or 0 to use the link address.
 * (0 is never a valid SRAM load address on RP2 chips.) Pass NULL to load
 * everything at link addresses (Tier 1). */
typedef struct {
    uint32_t addr[DMX_MAX_SEGMENTS];
} dmx_placement;

typedef struct {
    int fetch, exec, fix;   /* DMA channel numbers; ABI v0: 0, 1, 2 */
    uint32_t scratch;       /* reserved SRAM word; ABI v0: 0x2003FF00 */
    int compact;            /* Tier-C 8-byte-record machine: fixed channel
                             * map (fetch=7), bank/fix config carried by the
                             * image's init writes; fetch-only setup here. */
} dmx_machine_cfg;

/* ABI v0 defaults; mirrors img.DefaultMachine() on the host side. */
#define DMX_DEFAULT_MACHINE_CFG {0, 1, 2, 0x2003FF00u, 0}
#define DMX_COMPACT_MACHINE_CFG {0, 0, 0, 0, 1}

/* Parse and place the image, apply relocations and init writes, and return
 * the resolved entry address in *entry_out. Does not start the machine. */
int dmx_load(const uint8_t *image, size_t len, const dmx_placement *pl,
             uint32_t *entry_out);

/* Configure the fetch/execute/fix channels and start execution at entry.
 * The final register write triggers the first fetch, after which the
 * machine runs without further CPU involvement. */
int dmx_start(const dmx_machine_cfg *cfg, uint32_t entry);

#endif /* DMX_H */
