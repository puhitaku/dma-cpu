/* The ARM's final state: an SRAM-resident loop with interrupts masked
 * that serves as the machine's flash executor (prompts/022): the
 * kernel's sync posts erase/program requests to a mailbox and the ARM
 * runs the SDK's XIP-safe routines (they handle the quad-mode
 * exit-XIP dance the machine cannot). Between requests the loop just
 * spins in SRAM — the ARM never fetches from flash again. */
#include "hardware/flash.h"
#if defined(ADAFRUIT_FEATHER_RP2350)
#include "hardware/spi.h"
#include "hardware/structs/qmi.h"
#include "hardware/structs/hstx_fifo.h"
#endif

#include "hil.h"

#if defined(ADAFRUIT_FEATHER_RP2350)
/* The bootrom's fast M0 window config, snapshotted at boot for the
 * executor's end-of-sync restore (feather_video_init fills it). */
volatile uint32_t boot_m0[3];
volatile uint32_t boot_m0_saved;

static int sd_ready;

static void sd_cs(int assert) { gpio_put(SD_CS, !assert); }

static uint8_t sd_xfer(uint8_t b)
{
    uint8_t r;
    spi_write_read_blocking(SD_SPI, &b, &r, 1);
    return r;
}

/* Send a command, return R1 (0xFF on response timeout). */
static uint8_t sd_cmd(uint8_t cmd, uint32_t arg, uint8_t crc)
{
    sd_xfer(0xFF);
    sd_xfer(0x40 | cmd);
    sd_xfer(arg >> 24);
    sd_xfer(arg >> 16);
    sd_xfer(arg >> 8);
    sd_xfer(arg);
    sd_xfer(crc);
    for (int i = 0; i < 16; i++) {
        uint8_t r = sd_xfer(0xFF);
        if (!(r & 0x80))
            return r;
    }
    return 0xFF;
}

static int sd_hc;           /* SDHC/SDXC: block addressing */
static uint32_t sd_sectors; /* capacity from the CSD (op 5 reports it) */

static int sd_init_card(void)
{
    sd_ready = 0;
    spi_init(SD_SPI, 400 * 1000);
    gpio_set_function(SD_SCK, GPIO_FUNC_SPI);
    gpio_set_function(SD_MOSI, GPIO_FUNC_SPI);
    gpio_set_function(SD_MISO, GPIO_FUNC_SPI);
    gpio_init(SD_CS);
    gpio_set_dir(SD_CS, true);
    sd_cs(0);
    for (int i = 0; i < 10; i++) /* 80 clocks, CS high: SPI mode entry */
        sd_xfer(0xFF);
    sd_cs(1);
    if (sd_cmd(0, 0, 0x95) != 0x01) { /* GO_IDLE */
        sd_cs(0);
        return -1;
    }
    int v2 = 0;
    if (sd_cmd(8, 0x1AA, 0x87) == 0x01) { /* SEND_IF_COND */
        uint32_t r7 = 0;
        for (int i = 0; i < 4; i++)
            r7 = (r7 << 8) | sd_xfer(0xFF);
        if ((r7 & 0xFFF) == 0x1AA)
            v2 = 1;
    }
    /* ACMD41 until ready (~1 s worst case). */
    int ok = 0;
    for (int i = 0; i < 20000; i++) {
        sd_cmd(55, 0, 0x01);
        if (sd_cmd(41, v2 ? (1u << 30) : 0, 0x01) == 0x00) {
            ok = 1;
            break;
        }
    }
    if (!ok) {
        sd_cs(0);
        return -2;
    }
    sd_hc = 0;
    if (v2 && sd_cmd(58, 0, 0x01) == 0x00) { /* READ_OCR: CCS */
        uint32_t ocr = 0;
        for (int i = 0; i < 4; i++)
            ocr = (ocr << 8) | sd_xfer(0xFF);
        sd_hc = (ocr >> 30) & 1;
    }
    if (!sd_hc)
        sd_cmd(16, 512, 0x01); /* byte-addressed cards: block size 512 */
    sd_sectors = 0;
    if (sd_cmd(9, 0, 0x01) == 0x00) { /* SEND_CSD: card capacity */
        int tok = -1;
        for (int i = 0; i < 200000; i++) {
            if (sd_xfer(0xFF) == 0xFE) {
                tok = 0;
                break;
            }
        }
        if (tok == 0) {
            uint8_t csd[16];
            for (int i = 0; i < 16; i++)
                csd[i] = sd_xfer(0xFF);
            sd_xfer(0xFF); /* CRC */
            sd_xfer(0xFF);
            if (csd[0] >> 6 == 1) { /* CSD v2 (SDHC/SDXC) */
                uint32_t csize = ((uint32_t)(csd[7] & 0x3F) << 16) |
                                 ((uint32_t)csd[8] << 8) | csd[9];
                sd_sectors = (csize + 1) * 1024;
            } else { /* CSD v1 */
                uint32_t csize = ((uint32_t)(csd[6] & 3) << 10) |
                                 ((uint32_t)csd[7] << 2) | (csd[8] >> 6);
                uint32_t mult = ((uint32_t)(csd[9] & 3) << 1) | (csd[10] >> 7);
                uint32_t bl = csd[5] & 0xF;
                sd_sectors = ((csize + 1) << (mult + 2)) << bl >> 9;
            }
        }
    }
    sd_cs(0);
    sd_xfer(0xFF);
    spi_set_baudrate(SD_SPI, 20 * 1000 * 1000);
    sd_ready = 1;
    return 0;
}

static int sd_read_sector(uint32_t lba, uint8_t *dst)
{
    if (!sd_ready)
        return -1;
    sd_cs(1);
    if (sd_cmd(17, sd_hc ? lba : lba * 512, 0x01) != 0x00) {
        sd_cs(0);
        return -2;
    }
    int tok = -3; /* wait for the 0xFE data token (~100 ms cap) */
    for (int i = 0; i < 200000; i++) {
        uint8_t r = sd_xfer(0xFF);
        if (r == 0xFE) {
            tok = 0;
            break;
        }
        if (r != 0xFF && (r & 0xF0) == 0) { /* data error token */
            tok = -4;
            break;
        }
    }
    if (tok != 0) {
        sd_cs(0);
        return tok;
    }
    for (int i = 0; i < 512; i++)
        dst[i] = sd_xfer(0xFF);
    sd_xfer(0xFF); /* CRC */
    sd_xfer(0xFF);
    sd_cs(0);
    sd_xfer(0xFF);
    return 0;
}

/* --- The core-1 video feeder (prompts/036). ---
 * The display is fed by CPU stores from core 1, not by DMA: the
 * machine IS the DMA controller, and any DMA-side feed shares the
 * single read master with the machine's XIP cache misses — a one-
 * microsecond stall drains the 8-word HSTX FIFO and the monitor
 * "struggles to sync" whenever the kernel is busy (measured on
 * silicon). Core 1 runs this loop from SRAM, reads only SRAM and the
 * HSTX FIFO, and therefore cannot be stalled by anything: not the
 * machine, not flash sync, not PSRAM traffic. The FIFO's FULL flag
 * paces it, so the wire format is exactly the VESA 640x480@60 the
 * HSTX command words describe.
 *
 * Shared state with the machine's kernel (kfb.c): one control word
 * at HIL_XSH_FBCTL — the vertical pan in framebuffer rows. The
 * framebuffer is 640x480 bytes at HIL_XSH_FBBUF; one row per
 * scanline (prompts/039: the 480p squeeze). */
#if HIL_VIDEO_CPU_FEEDER
void __attribute__((noinline, section(".time_critical.vfeed"))) video_feeder(void)
{
    volatile uint32_t *fifo = &hstx_fifo_hw->fifo;
    volatile uint32_t *stat = &hstx_fifo_hw->stat;
    volatile uint32_t *ctl = (volatile uint32_t *)HIL_XSH_FBCTL;
    const uint32_t vactive[9] = {
        VF_CMD_RAW_REPEAT | 16, VF_CTRL_11 | VF_L12, VF_CMD_NOP,
        VF_CMD_RAW_REPEAT | 96, VF_CTRL_10 | VF_L12, VF_CMD_NOP,
        VF_CMD_RAW_REPEAT | 48, VF_CTRL_11 | VF_L12, VF_CMD_TMDS | VF_W,
    };
    const uint32_t vblank_off[7] = {
        VF_CMD_RAW_REPEAT | 16, VF_CTRL_11 | VF_L12,
        VF_CMD_RAW_REPEAT | 96, VF_CTRL_10 | VF_L12,
        VF_CMD_RAW_REPEAT | (48 + VF_W), VF_CTRL_11 | VF_L12, VF_CMD_NOP,
    };
    const uint32_t vblank_on[7] = {
        VF_CMD_RAW_REPEAT | 16, VF_CTRL_01 | VF_L12,
        VF_CMD_RAW_REPEAT | 96, VF_CTRL_00 | VF_L12,
        VF_CMD_RAW_REPEAT | (48 + VF_W), VF_CTRL_01 | VF_L12, VF_CMD_NOP,
    };
    for (;;) {
        for (uint32_t line = 0; line < VF_LINES; line++) {
            for (int i = 0; i < 9; i++) {
                while (*stat & HSTX_FIFO_STAT_FULL_BITS)
                    ;
                *fifo = vactive[i];
            }
            uint32_t row = line + *ctl; /* 480p: one fb row per scanline */
            if (row >= VF_ROWS)
                row -= VF_ROWS;
            const uint32_t *px =
                (const uint32_t *)(HIL_XSH_FBBUF + row * VF_W);
            for (int i = 0; i < VF_W / 4; i++) {
                while (*stat & HSTX_FIFO_STAT_FULL_BITS)
                    ;
                *fifo = px[i];
            }
        }
        for (uint32_t bl = 0; bl < 45; bl++) {
            const uint32_t *seq = (bl >= 10 && bl < 12) ? vblank_on : vblank_off;
            for (int i = 0; i < 7; i++) {
                while (*stat & HSTX_FIFO_STAT_FULL_BITS)
                    ;
                *fifo = seq[i];
            }
        }
    }
}
#endif /* HIL_VIDEO_CPU_FEEDER */
#endif

void __attribute__((noinline, section(".time_critical.park"))) park_forever(void)
{
    __asm volatile("cpsid i");
#ifdef HIL_XSH_FLASHREQ
    volatile uint32_t *req = (volatile uint32_t *)HIL_XSH_FLASHREQ; /* op,off,src,seq,ack */
    for (;;) {
        if (req[3] != req[4]) {
            uint32_t op = req[0], off = req[1], src = req[2];
            if (op == 1) {
#if SCAN_CH_MASK
                video_dma_stop(); /* the erase kills the XIP window */
#endif
                flash_range_erase(off, 4096);
#if SCAN_CH_MASK
                video_dma_start();
#endif
            } else if (op == 2) {
#if SCAN_CH_MASK
                video_dma_stop();
#endif
                flash_range_program(off, (const uint8_t *)src, 256);
#if SCAN_CH_MASK
                video_dma_start();
#endif
#if defined(ADAFRUIT_FEATHER_RP2350)
            } else if (op == 4) { /* SD: read sector `off` to `src` */
                if (sd_read_sector(off, (uint8_t *)src) != 0)
                    for (int i = 0; i < 512; i++) /* poison, never stale */
                        ((uint8_t *)src)[i] = 0xFF;
            } else if (op == 5) { /* SD: (re)init; {status, sectors} at src */
                ((uint32_t *)src)[0] = (uint32_t)sd_init_card();
                ((uint32_t *)src)[1] = sd_sectors;
#endif
            } else if (op == 3) {
                /* End-of-sync XIP restore, once per sync. The SDK's
                 * per-op path leaves XIP in the bootrom's slow serial
                 * command mode (fine while the machine waits in
                 * .ramtext); flash_start_xip makes XIP valid again
                 * (and re-runs the CS1/PSRAM hook), then the M0
                 * registers snapshotted at boot bring back the
                 * bootrom's fast per-burst quad config. (Calling the
                 * bootrom's saved XIP stub here hard-faulted: boot
                 * RAM is reused after boot, so the saved pointer is a
                 * lottery — plain register restore is exact.) */
                flash_start_xip();
#if defined(ADAFRUIT_FEATHER_RP2350)
                if (boot_m0_saved) {
                    qmi_hw->m[0].timing = boot_m0[0];
                    qmi_hw->m[0].rfmt = boot_m0[1];
                    qmi_hw->m[0].rcmd = boot_m0[2];
                }
#endif
            }
            req[4] = req[3];
        }
    }
#else
    for (;;) {
        __asm volatile("wfi");
    }
#endif
}
