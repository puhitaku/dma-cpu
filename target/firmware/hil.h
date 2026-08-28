/* Shared declarations for the HIL firmware, split three ways: main.c
 * is the bare boot path, executor.c is the parked ARM's service loop
 * plus the fallback drivers, devtests.c is the on-boot TEST/CAL/EXP
 * battery (HIL_DEV=1 builds only). */
#ifndef HIL_FIRMWARE_HIL_H
#define HIL_FIRMWARE_HIL_H

#include <stdio.h>
#include <string.h>

#include "pico/stdlib.h"

#include "dmx.h"
#include "images.h"

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

/* executor.c: the ARM's post-boot life. */
void park_forever(void);

#if defined(ADAFRUIT_FEATHER_RP2350)
/* --- MicroSD in SPI mode (prompts/037). ---
 * Wiring: SCK=GPIO22, MOSI=GPIO23, MISO=GPIO20 (the Feather's SPI0
 * pins), CS=GPIO10 (D10, the Adalogger FeatherWing convention). The
 * machine's kernel drives the card itself (ksd.c) and mounts the vfat
 * partition with its own read-only driver; the park executor's mailbox
 * (op 4 reads a 512-byte sector, op 5 initializes) is the fallback. */
#define SD_SPI  spi0
#define SD_SCK  22
#define SD_MOSI 23
#define SD_MISO 20
#define SD_CS   10

/* Shared HSTX video geometry (main.c blanks the framebuffer,
 * executor.c's fallback core-1 feeder scans it out). */
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

/* The bootrom's fast M0 window config, snapshotted at boot by
 * feather_video_init for the executor's end-of-sync restore. */
extern volatile uint32_t boot_m0[3];
extern volatile uint32_t boot_m0_saved;
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
