/* Shared declarations for the HIL firmware, split three ways: main.c
 * is the bare boot path, executor.c is the ARM's terminal state after
 * handover, devtests.c is the on-boot TEST/CAL/EXP battery (HIL_DEV=1
 * builds only). */
#ifndef HIL_FIRMWARE_HIL_H
#define HIL_FIRMWARE_HIL_H

#include <stdio.h>
#include <string.h>

#include "pico/stdlib.h"

#include "dmx.h"
#include "images.h"

/* HIL_ARM_HALT marks the boards whose ARM is switched OFF once the
 * machine is running (CMakeLists defines it for gamepico and feather,
 * the two deployed boards, together with their scratch-bank RAM map).
 * On those the firmware's .data/.bss/heap sit in the scratch banks
 * alone (and the feather's boot stack in a window the machine only
 * claims after it starts), so the machine owns SRAM from 0x20000000
 * up, and park_forever drops core 0 into PSM reset instead of
 * looping. HIL_FW_RAM_BASE/_END carry the same window to main.c.
 *
 * The gamepico map cannot be inferred from PICO_BOARD (gamepico and
 * the plain pico bench are both PICO_BOARD=pico) — a build that misses
 * -DHIL_BOARD=gamepico would link the firmware's RAM straight on top
 * of the game's, so refuse it here rather than on silicon. */
#if defined(HIL_HAS_GAME) && !defined(HIL_ARM_HALT)
#error "gamepico needs -DHIL_BOARD=gamepico: build via `make firmware HIL_BOARD=gamepico`"
#endif

/* The parked-ARM flash mailbox (prompts/022) exists for one board: the
 * plain-pico bench, whose kernel posts erase/program requests to it.
 * dmxgen emits HIL_XSH_FLASHREQ for every xsh board, so the halt
 * boards are subtracted here — on them core 0 is in reset and could
 * not answer anyway. gamepico has no xsh and never had a mailbox. */
#if defined(HIL_XSH_FLASHREQ) && !defined(HIL_ARM_HALT)
#define HIL_ARM_MAILBOX 1
#else
#define HIL_ARM_MAILBOX 0
#endif

/* Every firmware log line carries "[sec.ms] " from the ARM's boot
 * epoch (main.c wraps printf for all three translation units). */
int ts_printf(const char *fmt, ...);
#define printf ts_printf

/* Shared per-channel register offsets (same on all RP2 SKUs). */
#define CH_READ_ADDR 0x00u
#define CH_WRITE_ADDR 0x04u
#define CH_TRANS_COUNT 0x08u
#define CH_CTRL_TRIG 0x0Cu
#define CH_AL1_CTRL 0x10u
#define CH_AL1_READ_ADDR 0x14u
#define CH_AL1_WRITE_ADDR 0x18u
#define CH_AL1_TRANS_COUNT_TRIG 0x1Cu
#define CH_AL2_TRANS_COUNT 0x24u
#define CH_AL2_READ_ADDR 0x28u
#define CH_AL2_WRITE_ADDR_TRIG 0x2Cu
#define CH_AL3_WRITE_ADDR 0x34u

static inline void reg_wr(uint32_t addr, uint32_t val)
{
    *(volatile uint32_t *)(uintptr_t)addr = val;
}

static inline uint32_t reg_rd(uint32_t addr)
{
    return *(volatile uint32_t *)(uintptr_t)addr;
}

static inline uint32_t chreg(int ch, uint32_t off)
{
    return 0x50000000u + (uint32_t)ch * 0x40u + off;
}

/* HIL_VIDEO_CPU_FEEDER=1 restores the core-1 CPU feeder (the 036
 * verdict's fix) instead of the pure-DMA scanout. */
#ifndef HIL_VIDEO_CPU_FEEDER
#define HIL_VIDEO_CPU_FEEDER 0
#endif
#if HIL_VIDEO_CPU_FEEDER && defined(HIL_ARM_HALT)
/* The feeder needs a core 1 that keeps running forever, and core 1's
 * stack lives in the boot-only window borrowed from the machine's
 * kernel arena (CMakeLists) — the machine would allocate that page out
 * from under it. Restoring this fallback means restoring a stack (and
 * .data room for the .time_critical feeder) outside machine RAM. */
#error "HIL_VIDEO_CPU_FEEDER needs a live ARM: incompatible with the HIL_ARM_HALT memory map"
#endif
#if defined(ADAFRUIT_FEATHER_RP2350) && !HIL_VIDEO_CPU_FEEDER && defined(HIL_XSH_DTAB_HOME)
/* The scanout walker/executor pair lives outside the machine and must
 * survive every machine reset: the display is the one hard-real-time
 * consumer in the system. */
#define SCAN_CH_MASK ((1u << 14) | (1u << 15))
#else
#define SCAN_CH_MASK 0u
#endif

void machine_reset(void);
#if SCAN_CH_MASK
void video_dma_stop(void);
void video_dma_start(void);
#endif
void stage_blob(uint32_t home, const uint8_t *src, size_t len);
void arm_tick_ch(int ch, uint32_t vec, uint32_t disp0, uint32_t ctrl);

/* executor.c: the ARM's terminal state — PSM reset under HIL_ARM_HALT,
 * the flash mailbox loop under HIL_ARM_MAILBOX. Never returns. */
void park_forever(void);

#if defined(ADAFRUIT_FEATHER_RP2350)
/* --- MicroSD in SPI mode (prompts/037). ---
 * Wiring: SCK=GPIO22, MOSI=GPIO23, MISO=GPIO20 (the Feather's SPI0
 * pins), CS=GPIO10 (D10, the Adalogger FeatherWing convention). The
 * machine's kernel drives the card itself (ksd.c, MachineSDExec) and
 * mounts the vfat partition with its own read-only driver; the ARM
 * only muxes the pins at boot (main.c) and is in reset by the time
 * the first sector is read. */
#define SD_SPI  spi0
#define SD_SCK  22
#define SD_MOSI 23
#define SD_MISO 20
#define SD_CS   10

/* Shared HSTX video geometry (main.c blanks the framebuffer;
 * executor.c's core-1 feeder — the retired fallback above — scans it
 * out when HIL_VIDEO_CPU_FEEDER is on). */
#define VF_W      640
#define VF_ROWS   480
#define VF_LINES  480
#define VF_CMD_RAW_REPEAT (0x1u << 12)
#define VF_CMD_TMDS       (0x2u << 12)
#define VF_CMD_NOP        (0xFu << 12)
#define VF_CTRL_00 0x354u
#define VF_CTRL_01 0x0ABu
#define VF_CTRL_10 0x154u
#define VF_CTRL_11 0x2ABu
#define VF_L12 (VF_CTRL_00 << 10 | VF_CTRL_00 << 20)

#if HIL_VIDEO_CPU_FEEDER
void video_feeder(void);
#endif
#endif /* ADAFRUIT_FEATHER_RP2350 */

#ifdef HIL_DEV_TESTS
void devtests_run(unsigned iter);
#ifdef HIL_HAS_SHELL
void shell_start(void);
#endif
#endif

#endif /* HIL_FIRMWARE_HIL_H */
