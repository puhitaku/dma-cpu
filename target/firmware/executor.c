/* The ARM's terminal state, one of exactly two:
 *
 *  - HIL_ARM_HALT (gamepico, feather — the deployed boards): the ARM
 *    has no job left once the machine is running, so park_forever
 *    masks interrupts and writes its own PSM FRCE_OFF bit. Core 0
 *    goes into reset and stays there: no wfi loop, no instruction
 *    fetches, no bus traffic competing with the machine, and the
 *    firmware's RAM (the scratch banks, CMakeLists) is never touched
 *    again. The machine owns everything from 0x20000000 up.
 *  - HIL_ARM_MAILBOX (the plain-pico bench): the ARM stays alive as
 *    the machine's flash executor (prompts/022). The kernel's sync
 *    posts erase/program requests to a mailbox and the ARM runs the
 *    SDK's XIP-safe routines — they handle the quad-mode exit-XIP
 *    dance the machine cannot. Between requests the loop spins in
 *    SRAM; the ARM never fetches from flash again. That board is the
 *    only reason this path still exists.
 *
 * The feather's SD driver used to live here too, as a mailbox
 * fallback behind the kernel's own ksd.c. With the mailbox gone it
 * had no caller and is deleted; the machine drives the card. */
#include "hil.h"

#if HIL_ARM_MAILBOX
#include "hardware/flash.h"
#endif
#if defined(HIL_ARM_HALT)
#include "hardware/structs/psm.h"
#endif

#if defined(ADAFRUIT_FEATHER_RP2350) && HIL_VIDEO_CPU_FEEDER
#include "hardware/structs/hstx_fifo.h"

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
#endif /* ADAFRUIT_FEATHER_RP2350 && HIL_VIDEO_CPU_FEEDER */

void __attribute__((noinline, section(".time_critical.park"))) park_forever(void)
{
    __asm volatile("cpsid i");
#if defined(HIL_ARM_HALT)
    /* Switch core 0 off at the power/reset controller — the same
     * FRCE_OFF register multicore_reset_core1 uses for PROC1, aimed at
     * PROC0 instead, and never cleared. From the store onwards the
     * core is held in reset: it fetches nothing, arbitrates for
     * nothing, and cannot wake (there is no wfi to wake FROM). Only a
     * chip reset brings it back, which is exactly the handover
     * contract: the machine now owns the board.
     *
     * This function is .time_critical (SRAM): the store must not
     * depend on an XIP fetch that the machine could stall. */
    hw_set_bits(&psm_hw->frce_off, PSM_FRCE_OFF_PROC0_BITS);
    for (;;) /* never reached: the reset lands within a few cycles */
        __asm volatile("wfi");
#elif HIL_ARM_MAILBOX
    volatile uint32_t *req = (volatile uint32_t *)HIL_XSH_FLASHREQ; /* op,off,src,seq,ack */
    for (;;) {
        if (req[3] != req[4]) {
            uint32_t op = req[0], off = req[1], src = req[2];
            if (op == 1) {
                flash_range_erase(off, 4096);
            } else if (op == 2) {
                flash_range_program(off, (const uint8_t *)src, 256);
            } else if (op == 3) {
                /* End-of-sync XIP restore, once per sync. The SDK's
                 * per-op path leaves XIP in the bootrom's slow serial
                 * command mode (fine while the machine waits in
                 * .ramtext); flash_start_xip makes XIP valid again. */
                flash_start_xip();
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
