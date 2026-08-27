/* The DMA CPU's bootloader: everything the ARM cores do, and nothing
 * more. cpu0 sets clocks, opens ACCESSCTRL, prepares the fixed-function
 * video/SD hardware, stages the flash-resident images, loads the SRAM
 * segments through the DMX loader, starts the DMA machine — and parks
 * (executor.c). The on-boot test battery lives in devtests.c and is
 * compiled only into `make firmware HIL_DEV=1` builds. */
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#include "pico/stdlib.h"
#include "hardware/flash.h"
#if PICO_RP2350
#include "hardware/structs/accessctrl.h"
#else
#include "hardware/structs/ssi.h"
#endif
#include "hardware/gpio.h"
#include "hardware/sync.h"

#include "hardware/clocks.h"
#include "hardware/pll.h"
#include "hardware/vreg.h"
#if defined(ADAFRUIT_FEATHER_RP2350)
#include "hardware/psram.h"
#include "hardware/structs/hstx_ctrl.h"
#include "hardware/structs/qmi.h"
#include "hardware/spi.h"
#include "pico/multicore.h"
#endif

#include "hil.h"

#undef printf /* ts_printf itself speaks to the real stdio */
/* Every firmware log line carries "[sec.ms] " from the ARM's boot
 * epoch (time_us_64). The wrapper stamps at each line start —
 * including after newlines embedded mid-format — and passes the
 * text through otherwise unchanged. */
static bool ts_bol = true;
int ts_printf(const char *fmt, ...)
{
    char buf[512];
    va_list ap;
    va_start(ap, fmt);
    int n = vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    if (n < 0)
        return n;
    const char *p = buf;
    while (*p) {
        if (ts_bol) {
            uint64_t us = time_us_64();
            printf("[%lu.%03lu] ", (unsigned long)(us / 1000000ull),
                   (unsigned long)((us / 1000ull) % 1000ull));
            ts_bol = false;
        }
        const char *nl = strchr(p, '\n');
        if (nl) {
            printf("%.*s\n", (int)(nl - p), p);
            ts_bol = true;
            p = nl + 1;
        } else {
            printf("%s", p);
            break;
        }
    }
    return n;
}
#define printf ts_printf

/* dma_block_reset: RESETS-level reset of the whole DMA block. A channel
 * CHAN_ABORTed mid-transfer can WEDGE: stuck busy, ignoring further
 * aborts and re-triggers, surviving core resets — only this revives it
 * (measured over SWD on RP2040). Call only while no other subsystem
 * owns a channel. */
static void dma_block_reset(void)
{
    hw_set_bits(&resets_hw->reset, RESETS_RESET_DMA_BITS);
    busy_wait_us(10);
    hw_clear_bits(&resets_hw->reset, RESETS_RESET_DMA_BITS);
    while (!(resets_hw->reset_done & RESETS_RESET_DMA_BITS)) {
        tight_loop_contents();
    }
}

void machine_reset(void)
{
    reg_wr(HIL_CHAN_ABORT_ADDR, ((1u << HIL_NCHANNELS) - 1) & ~SCAN_CH_MASK);
    busy_wait_us(10);
    for (int ch = 0; ch < HIL_NCHANNELS; ch++) {
        if ((SCAN_CH_MASK >> ch) & 1u)
            continue;
        reg_wr(0x50000000u + (uint32_t)ch * 0x40u + CH_AL1_CTRL, 0);
    }
    reg_wr(HIL_INTR_ADDR, 0xFFFFu); /* write-1-to-clear raw status */
    reg_wr(HIL_SNIFF_CTRL_ADDR, 0);
    reg_wr(HIL_SNIFF_DATA_ADDR, 0);
    reg_wr(HIL_TIMER0_ADDR, 0);
}

#if SCAN_CH_MASK
/* The scanout reads its descriptor table through the XIP window, so
 * every flash operation that kills the window must bracket it — the
 * 036 lesson, relearned the hard way: one unbracketed staging pass at
 * boot wedged the ring and the screen stayed black. Stop aborts the
 * pair; start rebuilds the walker from the table top (one partial
 * frame, sync holds). */
void video_dma_stop(void)
{
    reg_wr(HIL_CHAN_ABORT_ADDR, SCAN_CH_MASK);
    busy_wait_us(10);
    reg_wr(0x50000000u + 14u * 0x40u + CH_AL1_CTRL, 0);
    reg_wr(0x50000000u + 15u * 0x40u + CH_AL1_CTRL, 0);
}

void video_dma_start(void)
{
    video_dma_stop();
    reg_wr(HIL_XSH_SCAN_WALKER + CH_READ_ADDR, HIL_XSH_DTAB_BLOCKS);
    reg_wr(HIL_XSH_SCAN_WALKER + CH_WRITE_ADDR, HIL_XSH_SCAN_EXEC);
    reg_wr(HIL_XSH_SCAN_WALKER + CH_TRANS_COUNT, 4);
    reg_wr(HIL_XSH_SCAN_WALKER + CH_CTRL_TRIG, HIL_XSH_SCAN_WALKER_CTRL);
}
#endif

/* Phase 5a (prompts/012): the preemptive round-robin proto-kernel. Two
 * relocated instances of the same compiled C program are scheduled by
 * kernel.dasm; a two-injector chain patches both dispatch words on
 * every pacing-timer tick, and the running process detours into the
 * scheduler at its next safepoint. The images arrive pre-wired from
 * dmxgen; this only loads, arms, starts A, and samples the counters. */
void arm_tick_ch(int ch, uint32_t vec, uint32_t disp0, uint32_t ctrl)
{
    reg_wr(HIL_TIMER0_ADDR + 4, (1u << 16) | HIL_TICK_CYCLES); /* TIMER1: 100 us tick */
    reg_wr(chreg(ch, CH_AL1_READ_ADDR), vec);
    reg_wr(chreg(ch, CH_AL1_WRITE_ADDR), disp0);
    reg_wr(chreg(ch, CH_TRANS_COUNT), 1);
    reg_wr(chreg(ch, CH_CTRL_TRIG), ctrl);
}

extern char __bss_end__;

#if defined(ADAFRUIT_FEATHER_RP2350)
static void flash_continuous_read(void); /* defined by the overclock block */
#endif

/* Copies a build-embedded blob to its registered RAM home, word-wise
 * through the machine's bus view (shared by the exec/shell demos and
 * the xsh disk staging). */
void stage_blob(uint32_t home, const uint8_t *src, size_t len)
{
    for (size_t i = 0; i < len; i += 4) {
        uint32_t w = (uint32_t)src[i] | ((uint32_t)src[i + 1] << 8) |
                     ((uint32_t)src[i + 2] << 16) | ((uint32_t)src[i + 3] << 24);
        reg_wr(home + i, w);
    }
}

#ifdef HIL_HAS_GAME
/* gamepico (prompts/040): the game's XIP text and PCM blobs are
 * LINKED at their flash homes (.gametext / .gamesfx sections pinned
 * by --section-start in CMakeLists), so the UF2 flashes them in
 * place — no staging copy, no second embedded instance eating the
 * firmware half. Load the SRAM segments, start the machine at gmain,
 * and go to sleep — the DMA CPU runs the whole console from here. */
static void game_start(void)
{
    /* Full block reset, not just machine_reset(): the freeze/abort
     * experiments leave channels wedged ("wedges=N/500" above). Safe
     * here: nothing else on this board owns a DMA channel, and the
     * game programs its own from scratch. */
    dma_block_reset();
    machine_reset();
    /* The references keep --gc-sections honest and prove the link
     * put the blobs where the machine will fetch them. */
    if ((uintptr_t)hil_game_blob_text != HIL_GAME_TEXT_HOME ||
        (uintptr_t)hil_game_blob_sfx != HIL_GAME_SFX_HOME) {
        printf("GAME: FAIL blob link (text %p sfx %p)\n",
               (const void *)hil_game_blob_text,
               (const void *)hil_game_blob_sfx);
        return;
    }
    printf("GAME: text %u B, sfx %u B in place\n",
           (unsigned)sizeof hil_game_blob_text,
           (unsigned)sizeof hil_game_blob_sfx);
    uint32_t e;
    if (dmx_load(hil_game_prog_dmx, sizeof hil_game_prog_dmx, NULL, &e) != DMX_OK) {
        printf("GAME: FAIL load\n");
        return;
    }
    /* Announce BEFORE starting the machine and drain the FIFO: once
     * dmx_start returns, the machine's own uputs bytes interleave
     * with anything the ARM still has in flight. */
    printf("=== handing over to the GAMEPICO machine (ARM -> wfi) ===\n");
    stdio_flush();
    uart_default_tx_wait_blocking();
    /* Stamp the CPU's final timestamp for the game's CPU-sleep
     * monitor: the ARM's only remaining work after this is dmx_start
     * plus the park prologue (a few us, invisible at second
     * resolution), then wfi forever. The monitor reads this block
     * (0x2003FF00, past the compact machine's scratch word and clear
     * of the radiosity demo's patch window at 0x2003C000) and shows
     * now - stamp climbing — a clock that only advances because
     * nothing on the CPU side ever runs again. */
    volatile uint32_t *cpustat = (volatile uint32_t *)0x2003FF00u;
    cpustat[1] = time_us_32();
    cpustat[0] = 0x51EE9500u; /* "SLEEP" marker: block valid */
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 1};
    if (dmx_start(&cfg, HIL_GAME_ENTRY) != DMX_OK) {
        printf("GAME: FAIL start\n");
        return;
    }
    park_forever();
}
#endif

#ifdef HIL_HAS_XSH
/* Phase 7 (prompts/019): hand the console to UPSTREAM xv6 sh.c on the
 * full filesystem kernel. The RAM disk (echo, cat, wc, README as an
 * xv6 fs image) is staged first; exec resolves paths on it, and
 * redirection and pipes work from the $ prompt. */
#ifdef HIL_XSH_KTEXT_HOME
/* XIP-resident text (prompts/030): the machine executes the fs kernel
 * and sh straight from the flash window; only their .ramtext stubs and
 * data are loaded to SRAM by dmx_load. Stage each text blob once,
 * content-compared so an unchanged build never reflashes. Same RAM
 * bounce as the fat golden: the blob source is itself in flash rodata
 * and flash_range_program runs with XIP disabled. */
#ifdef HIL_XSH_ARENA
/* The staging bounce buffer borrows the exec arena: every use runs
 * strictly before dmx_start (the machine has never touched the arena
 * yet), and the firmware's own .bss drops 4 KiB — RAM the map hands
 * straight back to that same arena. */
#define stage_sect ((uint8_t *)HIL_XSH_ARENA)
#else
static uint8_t stage_sect[4096]; /* shared with the fat-golden staging */
#endif

static void stage_xip_text(uint32_t dst, const uint8_t *blob, uint32_t len,
                           const char *what)
{
    if (memcmp((const void *)(uintptr_t)dst, blob, len) == 0)
        return;
    uint8_t *sect = stage_sect;
    uint32_t off = dst - 0x10000000u;
    for (uint32_t o = 0; o < len; o += 4096) {
        uint32_t n = len - o > 4096 ? 4096 : len - o;
        memcpy(sect, blob + o, n);
        memset(sect + n, 0xFF, 4096 - n);
        flash_range_erase(off + o, 4096);
        flash_range_program(off + o, sect, 4096);
    }
    printf("XSH: staged %s text (%u bytes)\n", what, (unsigned)len);
}
#endif


static void xsh_start(void)
{
    machine_reset();
#ifdef HIL_XSH_KTEXT_HOME
    stage_xip_text(HIL_XSH_KTEXT_HOME, hil_xsh_blob_ktext,
                   (uint32_t)sizeof hil_xsh_blob_ktext, "kernc");
    stage_xip_text(HIL_XSH_STEXT_HOME, hil_xsh_blob_stext,
                   (uint32_t)sizeof hil_xsh_blob_stext, "sh");
#endif
#ifdef HIL_XSH_VI_HOME
    stage_xip_text(HIL_XSH_VI_HOME, hil_xsh_blob_vib,
                   (uint32_t)sizeof hil_xsh_blob_vib, "vi");
#endif
#ifdef HIL_XSH_APPS_HOME
    stage_xip_text(HIL_XSH_APPS_HOME, hil_xsh_blob_apps,
                   (uint32_t)sizeof hil_xsh_blob_apps, "apps");
#endif
#if SCAN_CH_MASK
#if HIL_XSH_DTAB_RAM
    /* Flash-starvation isolation: the program runs from SRAM, so no
     * scanout read ever touches the XIP window (the copy overlays fb
     * rows 453+ — visible garbage, diagnostic builds only). */
    memcpy((void *)(uintptr_t)HIL_XSH_DTAB_RAM, hil_xsh_blob_dtab,
           sizeof hil_xsh_blob_dtab);
#else
    stage_xip_text(HIL_XSH_DTAB_HOME, hil_xsh_blob_dtab,
                   (uint32_t)sizeof hil_xsh_blob_dtab, "scanout table");
#endif
#endif
    uint32_t e;
    if (dmx_load(hil_xsh_kernel_dmx, sizeof hil_xsh_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_kernc_dmx, sizeof hil_xsh_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_sh_dmx, sizeof hil_xsh_sh_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_idle_dmx, sizeof hil_xsh_idle_dmx, NULL, &e) != DMX_OK) {
        printf("XSH: FAIL load\n");
        return;
    }
#ifdef HIL_XSH_FATVOL
    /* Golden vfat volume for `mount fat0` (prompts/029): staged once
     * into flash when no valid boot-sector signature is present. Must
     * run BEFORE dmx_start — flash ops disable XIP, and the running
     * machine reads the fs slot header through it. The blob lives in
     * rodata (flash), and flash_range_program must read its source
     * with XIP disabled — bounce each sector through RAM. */
    if (*(volatile uint16_t *)(HIL_XSH_FATVOL + 510) != 0xAA55u) {
#ifdef HIL_XSH_KTEXT_HOME
        uint8_t *sect = stage_sect;
#else
        static uint8_t sect[4096];
#endif
        uint32_t off = HIL_XSH_FATVOL - 0x10000000u;
        uint32_t len = (uint32_t)sizeof hil_xsh_blob_fat;
        for (uint32_t o = 0; o < len; o += 4096) {
            uint32_t n = len - o > 4096 ? 4096 : len - o;
            memcpy(sect, hil_xsh_blob_fat + o, n);
            memset(sect + n, 0xFF, 4096 - n);
            flash_range_erase(off + o, 4096);
            flash_range_program(off + o, sect, 4096);
        }
        printf("XSH: staged the vfat volume (%u bytes)\n", (unsigned)len);
    }
#endif
    /* Stage the disk: a valid persistent slot (magic, size, word-sum
     * checksum, header written last by the kernel's sync) wins over
     * the golden image. FSSLOT == 0 = read-only board: golden always. */
    int fromflash = 0;
    uint32_t slotgen = 0;
#if HIL_XSH_FSSLOT
    const uint32_t *hdr = (const uint32_t *)HIL_XSH_FSSLOT;
    if (hdr[0] == 0x32464D44u && hdr[2] == HIL_XSH_DISK_LEN &&
        hdr[4] == HIL_XSH_GOLDSUM) { /* 'DMF2', and from THIS build's
                                      * golden disk — an older build's
                                      * slot self-invalidates */
        const uint32_t *img = (const uint32_t *)(HIL_XSH_FSSLOT + 0x1000);
        uint32_t sum = 0;
        for (uint32_t i = 0; i < HIL_XSH_DISK_LEN / 4; i++)
            sum += img[i];
        if (sum == hdr[3]) {
            for (uint32_t i = 0; i < HIL_XSH_DISK_LEN; i += 4)
                reg_wr(HIL_XSH_BLOB_DISK_HOME + i, img[i / 4]);
            fromflash = 1;
            slotgen = hdr[1];
        }
    }
#endif
    if (!fromflash) {
        stage_blob(HIL_XSH_BLOB_DISK_HOME, hil_xsh_blob_disk, sizeof hil_xsh_blob_disk);
    }
    (void)slotgen;
#if defined(ADAFRUIT_FEATHER_RP2350)
    flash_continuous_read(); /* all flash writes are done for this boot */
#endif
    printf("cpu0: starting DMA CPU, and going to sleep now\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 1}; /* compact machine */
#if SCAN_CH_MASK
    video_dma_start();
    busy_wait_us(2000); /* ~1/8 frame: let the ring prove itself */
#ifdef HIL_DEV_TESTS
    printf("VID: walker rd=%08lx wr=%08lx exec ctrl=%08lx cnt=%lu "
           "fifostat=%08lx tab0=%08lx\n",
           (unsigned long)reg_rd(HIL_XSH_SCAN_WALKER + CH_READ_ADDR),
           (unsigned long)reg_rd(HIL_XSH_SCAN_WALKER + CH_WRITE_ADDR),
           (unsigned long)reg_rd(HIL_XSH_SCAN_EXEC + CH_AL1_CTRL),
           (unsigned long)reg_rd(HIL_XSH_SCAN_EXEC + CH_TRANS_COUNT),
           (unsigned long)reg_rd(0x50600000u),
           (unsigned long)reg_rd(HIL_XSH_DTAB_BLOCKS));
    printf("VID: cmds %08lx %08lx %08lx | %08lx %08lx | csr=%08lx\n",
           (unsigned long)reg_rd(HIL_XSH_DTAB_HOME + 0),
           (unsigned long)reg_rd(HIL_XSH_DTAB_HOME + 4),
           (unsigned long)reg_rd(HIL_XSH_DTAB_HOME + 8),
           (unsigned long)reg_rd(HIL_XSH_DTAB_BLOCKS + 8),
           (unsigned long)reg_rd(HIL_XSH_DTAB_BLOCKS + 12),
           (unsigned long)hstx_ctrl_hw->csr);
    busy_wait_us(100000); /* 6 frames: sustained-rate check + WOF */
    printf("VID: t+100ms walker rd=%08lx exec cnt=%lu ctrl=%08lx fifostat=%08lx\n",
           (unsigned long)reg_rd(HIL_XSH_SCAN_WALKER + CH_READ_ADDR),
           (unsigned long)reg_rd(HIL_XSH_SCAN_EXEC + CH_TRANS_COUNT),
           (unsigned long)reg_rd(HIL_XSH_SCAN_EXEC + CH_AL1_CTRL),
           (unsigned long)reg_rd(0x50600000u));
    busy_wait_us(900000);
    printf("VID: t+1s walker rd=%08lx exec cnt=%lu fifostat=%08lx\n",
           (unsigned long)reg_rd(HIL_XSH_SCAN_WALKER + CH_READ_ADDR),
           (unsigned long)reg_rd(HIL_XSH_SCAN_EXEC + CH_TRANS_COUNT),
           (unsigned long)reg_rd(0x50600000u));
#endif /* HIL_DEV_TESTS */
#endif
    for (int i = 0; i < 5; i++) /* clear the flash-request mailbox */
        reg_wr(HIL_XSH_FLASHREQ + 4u * i, 0);
    /* Unstamped divider: everything above is cpu0's epoch, everything
     * below is the DMA CPU's own log on its own clock. Printed (and
     * DRAINED) before dmx_start: the machine's kernel banner arrives on
     * the same UART within milliseconds, and an ARM byte still in
     * flight interleaves with it (mangled divider seen on silicon). */
    fputs("\n=== DMA CPU started (ch0-8: cpu, ch9-15: board) ===\n", stdout);
    stdio_flush();
    uart_default_tx_wait_blocking();
    if (dmx_start(&cfg, HIL_XSH_ENTRY) != DMX_OK) {
        printf("XSH: FAIL start\n");
        return;
    }
    arm_tick_ch(HIL_XSH_INJ_CH, HIL_XSH_VEC, HIL_XSH_DISP0, HIL_XSH_INJ_CTRL);
    park_forever();
}
#endif

#if defined(ADAFRUIT_FEATHER_RP2350)
/* Feather RP2350 video stage-setting (prompts/036). The DMA machine
 * scans the PSRAM framebuffer out through HSTX entirely by itself;
 * the ARM only prepares the fixed-function hardware:
 *  - clk_hstx = 126 MHz from the otherwise-unused USB PLL (VCO
 *    1260 MHz / 5 / 2): 640x480@60 wants a 25.2 MHz pixel clock and
 *    HSTX shifts 2 TMDS bits per cycle, 5 shifts per pixel. clk_sys
 *    runs at HIL_CLK_SYS_KHZ (300 MHz, overclock_init) independent of
 *    clk_hstx; clk_peri follows clk_sys and every divisor-consumer
 *    initializes after the switch (clk_usb/clk_adc die: unused).
 *  - HSTX TMDS encoder in RGB332, 4 pixels per FIFO word (the
 *    pico-examples dvi_out_hstx_encoder configuration).
 *  - Board pin map: HSTX bit N = GPIO 12+N; clock pair GPIO14/15,
 *    lane0 GPIO18/19, lane1 GPIO16/17, lane2 GPIO12/13.
 * PSRAM (QMI CS1, GPIO8) is brought up by the SDK runtime init
 * (hardware_psram), including XIP_CTRL.WRITABLE_M1 for writes. */
static void feather_video_init(void)
{
    /* The SDK's PSRAM bring-up probes the chip over QMI direct mode
     * and leaves one residual word in the direct-RX FIFO. The DMA
     * machine's flash driver assumes the FIFO starts empty: with the
     * residue every read of its session comes back shifted by one and
     * the session wedges (observed on silicon: DIRECT_CSR RXLEVEL=1
     * at the CAL flash hang). Drain it and shut direct mode before
     * the machine ever runs. */
    while (!(qmi_hw->direct_csr & QMI_DIRECT_CSR_RXEMPTY_BITS))
        (void)qmi_hw->direct_rx;
    hw_clear_bits(&qmi_hw->direct_csr, QMI_DIRECT_CSR_EN_BITS);

    pll_init(pll_usb, 1, 1260 * MHZ, 5, 2);
    clock_configure_undivided(clk_hstx, 0,
        CLOCKS_CLK_HSTX_CTRL_AUXSRC_VALUE_CLKSRC_PLL_USB, 126 * MHZ);

    /* Each lane takes the FULL rotated pixel byte (NBITS field 7 =
     * 8 bits) instead of just its own 3(2)-bit field: the expander
     * zero-fills below NBITS and cannot bit-replicate, so 3-bit
     * levels top out at 224 (blue at 192) and "white" rendered dark
     * and warm. With the whole byte, the bits below a lane's field
     * are the pixel's OTHER channels — 0xFF now displays as exact
     * (255,255,255), grays track, and the cost is a bounded additive
     * bleed into saturated colors (worst: blue picks up <=25% of a
     * bright red) which sldgen's dither model compensates for. */
    hstx_ctrl_hw->expand_tmds =
        7u << HSTX_CTRL_EXPAND_TMDS_L2_NBITS_LSB |
        0u << HSTX_CTRL_EXPAND_TMDS_L2_ROT_LSB |
        7u << HSTX_CTRL_EXPAND_TMDS_L1_NBITS_LSB |
        29u << HSTX_CTRL_EXPAND_TMDS_L1_ROT_LSB |
        7u << HSTX_CTRL_EXPAND_TMDS_L0_NBITS_LSB |
        26u << HSTX_CTRL_EXPAND_TMDS_L0_ROT_LSB;
    hstx_ctrl_hw->expand_shift = /* 4 RGB332 pixels per FIFO word */
        4u << HSTX_CTRL_EXPAND_SHIFT_ENC_N_SHIFTS_LSB |
        8u << HSTX_CTRL_EXPAND_SHIFT_ENC_SHIFT_LSB |
        1u << HSTX_CTRL_EXPAND_SHIFT_RAW_N_SHIFTS_LSB |
        0u << HSTX_CTRL_EXPAND_SHIFT_RAW_SHIFT_LSB;
    hstx_ctrl_hw->csr = 0;
    hstx_ctrl_hw->csr =
        HSTX_CTRL_CSR_EXPAND_EN_BITS |
        5u << HSTX_CTRL_CSR_CLKDIV_LSB |
        5u << HSTX_CTRL_CSR_N_SHIFTS_LSB |
        2u << HSTX_CTRL_CSR_SHIFT_LSB |
        HSTX_CTRL_CSR_EN_BITS;

    /* Clock pair on HSTX bits 2/3 (GPIO14/15). */
    hstx_ctrl_hw->bit[2] = HSTX_CTRL_BIT0_CLK_BITS;
    hstx_ctrl_hw->bit[3] = HSTX_CTRL_BIT0_CLK_BITS | HSTX_CTRL_BIT0_INV_BITS;
    /* TMDS lane -> HSTX bit of its positive pin: D0=GPIO18, D1=GPIO16,
     * D2=GPIO12. Even shifter bits leave in the first half-cycle. */
    static const int lane_bit[3] = {6, 4, 0};
    for (int lane = 0; lane < 3; lane++) {
        int bit = lane_bit[lane];
        uint32_t sel = (uint32_t)(lane * 10) << HSTX_CTRL_BIT0_SEL_P_LSB |
                       (uint32_t)(lane * 10 + 1) << HSTX_CTRL_BIT0_SEL_N_LSB;
        hstx_ctrl_hw->bit[bit] = sel;
        hstx_ctrl_hw->bit[bit + 1] = sel | HSTX_CTRL_BIT0_INV_BITS;
    }
    for (int pin = 12; pin <= 19; pin++)
        gpio_set_function((uint)pin, GPIO_FUNC_HSTX);

    printf("feather: psram %u KiB, clk_hstx 126 MHz, hstx dvi ready\n",
           (unsigned)(psram_get_size() / 1024));
    /* MEASURED clocks via the hardware frequency counter — the video
     * timing is only as good as the physical clk_hstx (126000 kHz
     * wanted: 25.2 MHz pixel clock at 5 clocks per pixel). */
    /* CPU-side PSRAM window speed: 4096 word writes + reads through
     * the uncached alias, microseconds via the us timer. */
    {
        volatile uint32_t *t = (volatile uint32_t *)0x400b0028; /* TIMERAWL */
        volatile uint32_t *p = (volatile uint32_t *)0x15100000;
        uint32_t t0 = *t;
        for (int i = 0; i < 4096; i++)
            p[i] = i;
        uint32_t t1 = *t;
        uint32_t acc = 0;
        for (int i = 0; i < 4096; i++)
            acc += p[i];
        uint32_t t2 = *t;
        printf("feather: cpu psram 4096w wr=%lu us rd=%lu us (acc=%08lx)\n",
               (unsigned long)(t1 - t0), (unsigned long)(t2 - t1),
               (unsigned long)acc);
    }
    printf("feather: fc0 clk_sys=%lu kHz clk_hstx=%lu kHz pll_usb=%lu kHz\n",
           (unsigned long)frequency_count_khz(CLOCKS_FC0_SRC_VALUE_CLK_SYS),
           (unsigned long)frequency_count_khz(CLOCKS_FC0_SRC_VALUE_CLK_HSTX),
           (unsigned long)frequency_count_khz(CLOCKS_FC0_SRC_VALUE_PLL_USB_CLKSRC_PRIMARY));
    /* The boot-time QMI window configs, for comparing against the
     * post-sync state (the executor must restore these exactly). */
    printf("feather: qmi m0 timing=%08lx rfmt=%08lx rcmd=%08lx\n",
           (unsigned long)qmi_hw->m[0].timing,
           (unsigned long)qmi_hw->m[0].rfmt, (unsigned long)qmi_hw->m[0].rcmd);
    printf("feather: qmi m1 timing=%08lx rfmt=%08lx rcmd=%08lx wfmt=%08lx\n",
           (unsigned long)qmi_hw->m[1].timing,
           (unsigned long)qmi_hw->m[1].rfmt, (unsigned long)qmi_hw->m[1].rcmd,
           (unsigned long)qmi_hw->m[1].wfmt);
    /* Snapshot the bootrom's fast M0 window config for the executor's
     * end-of-sync restore. It is per-burst (RFMT PREFIX_LEN=8, RCMD
     * suffix 0x00 — no continuous-read mode), so writing the three
     * registers back is exact and safe from any chip state. */
    boot_m0[0] = qmi_hw->m[0].timing;
    boot_m0[1] = qmi_hw->m[0].rfmt;
    boot_m0[2] = qmi_hw->m[0].rcmd;
    boot_m0_saved = 1;
}
#endif

#if defined(ADAFRUIT_FEATHER_RP2350)
/* Continuous-read XIP: after the LAST boot-time flash op, hand the
 * W25Q its continuous-read mode byte (M = 0xA0) and drop the 8-cycle
 * EB command prefix from every later transaction — ~20% shorter
 * machine flash stalls (the display-starvation knob) at ZERO
 * timing-margin cost, since only the transaction LENGTH changes.
 * Feather-only: this flash is machine-read-only (no QMI direct-mode
 * driver, no executor flash ops), so nothing ever fights the sticky
 * mode state. The sequence must be airtight: once the flash latches
 * M, any prefixed read decodes the command bits as address — SRAM
 * code, IRQs off, straight line to the prefix-clear. */
static void __no_inline_not_in_flash_func(flash_continuous_read)(void)
{
    uint32_t irqs = save_and_disable_interrupts();
    qmi_hw->m[0].rcmd = (qmi_hw->m[0].rcmd & ~QMI_M0_RCMD_SUFFIX_BITS) |
                        (0xA0u << QMI_M0_RCMD_SUFFIX_LSB);
    (void)*(volatile uint32_t *)XIP_NOCACHE_NOALLOC_BASE; /* latch M */
    hw_clear_bits(&qmi_hw->m[0].rfmt, QMI_M0_RFMT_PREFIX_LEN_BITS);
    restore_interrupts(irqs);
}
#endif

#if HIL_CLK_SYS_KHZ && PICO_RP2350
/* Flash XIP retiming for the overclock: the bootrom's M0 CLKDIV was
 * chosen for the boot clock; at 300 MHz CLKDIV=3 would run the quad
 * read at 100 MHz with a 2-cycle (6.7 ns) RXDELAY — right at the
 * part's edge. CLKDIV=4 + RXDELAY=4 (75 MHz, 13 ns) keeps the same
 * margins the 150 MHz map had. Runs from SRAM: it retunes the very
 * window the CPU executes from. */
static void __no_inline_not_in_flash_func(overclock_flash_retiming)(void)
{
    uint32_t t = qmi_hw->m[0].timing;
    t &= ~(QMI_M0_TIMING_CLKDIV_BITS | QMI_M0_TIMING_RXDELAY_BITS);
#if defined(ADAFRUIT_FEATHER_RP2350)
    /* 100 MHz quad reads (silicon-validated on the feather: the vi
     * flash-execution torture holds sync). The W25Q64JV is rated
     * 133 MHz; the edge is the ROUND TRIP: 2.5 ns SCK-out pad + 6 ns
     * flash tCLQV + 1.5 ns data-in pad = 10 ns worst-case against the
     * 10 ns bit cell (RP2350 DS 12.14.3 + W25Q64JV AC tables).
     * RXDELAY counts HALF sys-clock cycles (1.67 ns at 300 MHz):
     * capture lands at T/2 + 4 halves = 5 + 6.67 = 11.67 ns, centered
     * in the [10, 13] ns valid window (+1.7/-1.3 ns worst-PVT margin
     * — thin but real; every machine XIP stall shortens ~25%, the
     * display-starvation knob). */
    t |= (3u << QMI_M0_TIMING_CLKDIV_LSB) | (4u << QMI_M0_TIMING_RXDELAY_LSB);
#else
    /* pico2: the proven 75 MHz map (13.3 ns cell, capture mid-window
     * with ~3 ns margins) — 100 MHz is feather-validated only. */
    t |= (4u << QMI_M0_TIMING_CLKDIV_LSB) | (4u << QMI_M0_TIMING_RXDELAY_LSB);
#endif
    qmi_hw->m[0].timing = t;
}

#if defined(ADAFRUIT_FEATHER_RP2350)
/* PSRAM QMI M1 retiming: the runtime init computed the divider at the
 * boot 150 MHz; at 300 MHz that clocked the APS6404 at 150 (max 133).
 * Only the TIMING register needs to change — psram_reinitialize() is
 * NOT usable here: it re-sends the SPI-mode QUAD_ENABLE to a chip
 * already in QPI mode (which wedged it; the first window access hung
 * the bus mid-boot) and its flash_start_xip drops the flash M0 to
 * slow serial mode (hardware law from prompts/036). Same math as the
 * SDK's psram_configure_params, values recomputed for the new clock. */
static void __no_inline_not_in_flash_func(overclock_psram_retiming)(void)
{
    uint32_t clock_hz = HIL_CLK_SYS_KHZ * 1000u;
    uint32_t divisor = (clock_hz + PICO_DEFAULT_PSRAM_MAX_FREQ - 1) /
                       PICO_DEFAULT_PSRAM_MAX_FREQ;
    if (divisor == 1 && clock_hz > 100000000u)
        divisor = 2;
    uint32_t rxdelay = divisor;
    if (clock_hz / divisor > 100000000u)
        rxdelay += 1;
    uint32_t period_fs = (uint32_t)(1000000000000000ull / clock_hz);
    uint32_t max_select = (uint32_t)(((uint64_t)PICO_DEFAULT_PSRAM_MAX_SELECT *
                                      1000000ull) / (64ull * period_fs));
    uint32_t min_deselect =
        (PICO_DEFAULT_PSRAM_MIN_DESELECT * 1000000u + (period_fs - 1)) /
            period_fs -
        (divisor + 1) / 2;
    qmi_hw->m[1].timing = 1u << QMI_M1_TIMING_COOLDOWN_LSB |
                          QMI_M1_TIMING_PAGEBREAK_VALUE_1024
                              << QMI_M1_TIMING_PAGEBREAK_LSB |
                          max_select << QMI_M1_TIMING_MAX_SELECT_LSB |
                          min_deselect << QMI_M1_TIMING_MIN_DESELECT_LSB |
                          rxdelay << QMI_M1_TIMING_RXDELAY_LSB |
                          divisor << QMI_M1_TIMING_CLKDIV_LSB;
}
#endif

/* Bring clk_sys to HIL_CLK_SYS_KHZ before anything derives timing
 * from it: the UART divisor (stdio_init_all runs after), the SD SPI
 * baud (spi_init runs per-op), the PSRAM QMI divider (register-only
 * retiming — the SDK runtime computed it at the boot clock),
 * and the machine itself (the DMA engine runs on clk_sys; the tick
 * timer compensates via HIL_TICK_CYCLES). clk_hstx lives on the
 * repurposed USB PLL, so the video signal never notices. */
#endif /* HIL_CLK_SYS_KHZ && PICO_RP2350 */

#if HIL_CLK_SYS_KHZ && !PICO_RP2350
/* RP2040 flash XIP retiming for 250 MHz: boot2's even-only SSI
 * divider stays at 2, which now clocks the W25Q16JV at 125 MHz —
 * inside its 133 MHz rating (100 MHz is unreachable from 250; the
 * old 200 MHz map's div 2 WAS 100). What must move is the sampling
 * point: the ~10 ns worst-case round trip (pad out + tCLQV 6 ns +
 * pad in) overruns the 8 ns bit cell, so RX_SAMPLE_DLY=1 (one
 * clk_sys cycle, 4 ns) pushes capture into the next cell — the same
 * pattern the feather's validated 100 MHz map uses. SSI registers
 * take writes only while the block is disabled, and NOTHING may
 * fetch from flash inside the bracket: SRAM code, IRQs off. */
static void __no_inline_not_in_flash_func(overclock_flash_retiming_2040)(void)
{
    uint32_t irqs = save_and_disable_interrupts();
    ssi_hw->ssienr = 0;
    ssi_hw->rx_sample_dly = 1;
    ssi_hw->ssienr = 1;
    restore_interrupts(irqs);
}
#endif

#if HIL_CLK_SYS_KHZ
static void overclock_init(void)
{
#if PICO_RP2350
    /* POWMAN clamps VREG to 1.15 V unless the limit is explicitly
     * disabled — vreg_set_voltage alone was silently clamped, and
     * 300 MHz at 1.15 V garbled logic chip-wide (mangled UART bytes
     * at the correct baud). */
    vreg_disable_voltage_limit();
    vreg_set_voltage(VREG_VOLTAGE_1_30); /* 300 MHz wants headroom over
                                          * the 1.10 V default */
    sleep_ms(10); /* let the regulator settle before the PLL jump */
    set_sys_clock_khz(HIL_CLK_SYS_KHZ, true);
    /* set_sys_clock_khz points clk_peri at clk_sys with divider 1 —
     * but clk_peri is specced to 150 MHz, and at 300 the UART mangled
     * every byte in both directions (deterministic garble + marginal
     * bit flips: overclocked peripheral logic, not a baud mismatch).
     * RP2350 gave clk_peri a divider: run it at clk_sys/2 and let the
     * UART/SPI divisors derive from the in-spec 150 MHz. */
    clock_configure(clk_peri, 0,
                    CLOCKS_CLK_PERI_CTRL_AUXSRC_VALUE_CLK_SYS,
                    HIL_CLK_SYS_KHZ * 1000u, HIL_CLK_SYS_KHZ * 500u);
#if defined(ADAFRUIT_FEATHER_RP2350)
    overclock_psram_retiming();
#endif
    overclock_flash_retiming();
#else /* RP2040 (gamepico: 250 MHz) */
    vreg_set_voltage(VREG_VOLTAGE_1_25); /* 250 MHz headroom (1.10 V
                                          * default; 200 ran at 1.20) */
    sleep_ms(10);
    set_sys_clock_khz(HIL_CLK_SYS_KHZ, true);
    /* The RP2040 has NO clk_peri divider and its peripherals are not
     * rated for clk_sys speeds (the RP2350's UART at 2x taught that
     * lesson). USB is unused: repurpose pll_usb at 125 MHz for
     * clk_peri — the UART stays in spec and SPI0 lands exactly on the
     * ST7789V's 62.5 MHz serial-write ceiling (the Feather pulls the
     * same trick for clk_hstx). The game's PIO dividers (I2S pitch,
     * WS2811 bit clock) are anchored to clk_sys in fx.c — scaled
     * together with this number. */
    pll_init(pll_usb, 1, 1500 * MHZ, 6, 2); /* 125 MHz */
    clock_configure(clk_peri, 0,
                    CLOCKS_CLK_PERI_CTRL_AUXSRC_VALUE_CLKSRC_PLL_USB,
                    125 * MHZ, 125 * MHZ);
    overclock_flash_retiming_2040(); /* 125 MHz reads, resampled */
#endif
}
#endif

int main(void)
{
    /* stdio first: both overclocked boards keep clk_peri at its boot
     * frequency (feather 150 = 300/2; gamepico 125 via the repurposed
     * USB PLL), so the UART divisor stays valid across the switch and
     * the overclock itself can narrate. */
    stdio_init_all();
#if HIL_CLK_SYS_KHZ
    /* No prints DURING the clock dance: a byte in flight when
     * clk_peri switches wedges the UART state machine, and every
     * later printf then blocks on TXFF forever (an intermittent
     * boot hang bisected on gamepico silicon). Flush, switch, then
     * report. */
    printf("cpu0: booting system\n");
    stdio_flush();
    uart_default_tx_wait_blocking();
    overclock_init();
    printf("oc: clk_sys=%lu kHz clk_peri=%lu kHz\n",
           (unsigned long)(clock_get_hz(clk_sys) / 1000),
           (unsigned long)(clock_get_hz(clk_peri) / 1000));
#endif
#ifdef HIL_DEV_TESTS
    sleep_ms(3000); /* generous serial-attach window for capture scripts */
#else
    sleep_ms(500);
#endif

    /* Startup insurance: begin from a virgin DMA block. The SDK
     * runtime resets peripherals at boot, but a debugger-resumed or
     * wedged channel state has been seen to survive resets — nothing
     * owns a channel yet, so a block reset here is free. */
    dma_block_reset();

#if PICO_RP2350
    /* ACCESSCTRL: XIP_QMI and XIP_CTRL reset to 0xB8 — DMA access
     * FORBIDDEN (RP2350 datasheet section 10.6.2.1). Every machine
     * access to the QMI bus-faulted, which prompts/023 misread as a
     * hardware limitation. Open them like the other machine-visible
     * peripherals (0xFC: DBG|DMA|CORE1|CORE0|SP|SU) before the DMA
     * CPU runs, so it can drive flash itself (prompts/028). RP2040
     * has no ACCESSCTRL — its DMA already reaches everything. */
    accessctrl_hw->xip_qmi = ACCESSCTRL_PASSWORD_BITS | 0xFC;
    accessctrl_hw->xip_ctrl = ACCESSCTRL_PASSWORD_BITS | 0xFC;
    /* The scanout's line copier drains the XIP streamer through the
     * XIP_AUX port (prompts/036). */
    accessctrl_hw->xip_aux = ACCESSCTRL_PASSWORD_BITS | 0xFC;
#endif

#if defined(ADAFRUIT_FEATHER_RP2350)
    feather_video_init();
    /* Machine-driven SD (ksd.c): the ARM's whole role is this one-time
     * plumbing — mux the SPI pins, un-reset the block, park CS high.
     * The machine reprograms clocks and runs the protocol itself; the
     * mailbox SD ops (4/5) remain compiled as the fallback path. */
    spi_init(SD_SPI, 400 * 1000);
    gpio_set_function(SD_SCK, GPIO_FUNC_SPI);
    gpio_set_function(SD_MOSI, GPIO_FUNC_SPI);
    gpio_set_function(SD_MISO, GPIO_FUNC_SPI);
    gpio_init(SD_CS);
    gpio_set_dir(SD_CS, true);
    gpio_put(SD_CS, 1);
    gpio_pull_up(SD_MISO); /* DAT0 wants a pull during high-Z gaps */
    gpio_pull_up(SD_MOSI);
    /* Quietest pads that still clock the card: the SD lines run on
     * GPIO20/22/23, right beside the HSTX TMDS lanes (GPIO12-19), and
     * the borrow's gapless 25 MHz bursts at hot pads cost the display
     * its sync (bisected on silicon: machine-fed TX clean, wire-speed
     * borrow noisy at identical firmware). */
    gpio_set_drive_strength(SD_SCK, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_drive_strength(SD_MOSI, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_drive_strength(SD_CS, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_slew_rate(SD_SCK, GPIO_SLEW_RATE_SLOW);
    gpio_set_slew_rate(SD_MOSI, GPIO_SLEW_RATE_SLOW);
    gpio_set_slew_rate(SD_CS, GPIO_SLEW_RATE_SLOW);
    /* Blank the framebuffer: the display carries a clean 640x480@60
     * signal from here on, machine or not. */
    for (uint32_t a = HIL_XSH_FBBUF; a < HIL_XSH_FBBUF + VF_ROWS * VF_W; a += 4)
        *(volatile uint32_t *)a = 0;
    *(volatile uint32_t *)HIL_XSH_FBCTL = 0;
#if HIL_VIDEO_CPU_FEEDER
    /* Fallback: the core-1 CPU feeder (the 036 verdict's fix). */
    multicore_launch_core1(video_feeder);
#endif
    /* The pure-DMA scanout arms in xsh_start, AFTER every boot-time
     * flash staging pass: its table reads go through the XIP window,
     * which flash programming kills (video_dma_start / _stop). Core 1
     * is not launched and stays asleep in the bootrom's wfe loop. */
#endif

    /* GPIO2: input from the firmware's view; the DMA machine drives it
     * via IO_BANK0 overrides. gpio_init also clears RP2350 pad isolation. */
    gpio_init(2);
    gpio_set_dir(2, false);

    for (unsigned iter = 1;; iter++) {
        printf("dmacpu: sku=%s iter=%u bss_end=%p machine_ram=[0x%08lx,0x%08lx)\n",
               HIL_SKU, iter, (void *)&__bss_end__,
               (unsigned long)HIL_MACHINE_RAM_START,
               (unsigned long)HIL_MACHINE_RAM_END);
#if defined(HIL_XSH_FSSLOT) && HIL_XSH_FSSLOT
        extern char __flash_binary_end;
        if ((uintptr_t)&__flash_binary_end >= HIL_XSH_FSSLOT) {
            printf("FATAL: firmware overlaps the fs flash slot\n");
            sleep_ms(5000);
            continue;
        }
#endif
        if ((uintptr_t)&__bss_end__ >= HIL_MACHINE_RAM_START) {
            printf("FATAL: firmware bss overlaps machine RAM\n");
            sleep_ms(5000);
            continue;
        }
        /* The on-boot suite (devtests.c) is a development tool;
         * release builds (the default) boot straight to the payload.
         * Build with `make firmware HIL_DEV=1` to keep it. */
#ifdef HIL_DEV_TESTS
        devtests_run(iter);
#endif
#ifdef HIL_HAS_GAME
        game_start(); /* the machine IS the console from here */
#elif defined(HIL_HAS_XSH)
        xsh_start(); /* one validation pass, then the console belongs to xv6 sh */
#elif defined(HIL_HAS_SHELL) && defined(HIL_DEV_TESTS)
        shell_start();
#endif
        sleep_ms(2000);
    }
}
