/* On-boot development test battery (split from main.c): the
 * expected-vs-observed TEST suite, the CAL calibration experiments,
 * the interrupt-approach EXP battery, the PSRAM probes and the legacy
 * dma-sh demo. Compiled only into HIL_DEV=1 builds; release builds
 * get an empty translation unit and boot straight to the payload. */
#include "hardware/gpio.h"
#include "hardware/pio.h"
#include "hardware/sync.h"
#include "hardware/flash.h"

#include "hil.h"

#ifdef HIL_DEV_TESTS

static inline uint32_t cal_reg(uint32_t off) { return HIL_CAL_CH_BASE + off; }

/* Scratch words inside the reserved machine region, used by the C-side
 * calibration experiments (the DMX images are not loaded while these
 * run). */
#define CAL_SRC (HIL_MACHINE_RAM_START + 0x0u)
#define CAL_DST (HIL_MACHINE_RAM_START + 0x100u)

#if defined(ADAFRUIT_FEATHER_RP2350)
/* --- PSRAM probes (prompts/036 follow-up) ------------------------------
 * The recorded ~1 ms/word machine-access figure was measured in the
 * PSRAM-framebuffer era, with the line copier saturating CS1; the
 * intrinsic DMA-master cost on today's quiet QMI was never separated
 * from that contention. These probes decompose it:
 *   psram_arm     ARM window baselines (the QSPI-transaction floor)
 *   psram_dma     DMA-channel window access: burst and single-beat
 *                 (machine-record-like), vs an SRAM-target control
 *   psram_stream  the QMI XIP streamer against CS1 addresses — the
 *                 flash-exec mechanism, maybe extended to PSRAM
 *   psram_bw      sustained streamer bandwidth vs the 18.4 MB/s
 *                 640x480@60 framebuffer refresh budget
 *   psram_display announced phases while the scanout runs: the
 *                 operator's eyes judge which traffic classes the
 *                 display tolerates
 * All figures are silicon-only (CAL lines, no emulator expectation).
 * RP2350 encodings below match host/emu/{regs,variant}.go. */
#define PSRAM_UC 0x15100000u /* uncached CS1 alias, 1 MiB in */
#define PSRAM_C 0x14100000u  /* cached CS1 alias, same words */
#define PROBE_CH 11u         /* kdma's channel: free during dev tests */
#define PROBE_REG(off) (0x50000000u + PROBE_CH * 0x40u + (off))
#define PROBE_SRAM (HIL_MACHINE_RAM_START + 0x1000u) /* pre-machine scratch */
#define P_TREQ_PERM (0x3Fu << 17)
#define P_TREQ_XSTREAM (49u << 17)
#define P_QUIET (1u << 23)
#define P_CHAIN_SELF (PROBE_CH << 13) /* chain-to-self = no chain */
#define P_SIZE32 (2u << 2)
#define P_INCR_R (1u << 4)
#define P_INCR_W (1u << 6)
#define P_BUSY (1u << 26)
#define QMI_STREAM_ADDR 0x400C8014u
#define QMI_STREAM_CTR 0x400C8018u
#define XIP_AUX_PORT 0x50500000u

/* One timed channel run; returns elapsed us, or 0 on timeout (channel
 * aborted). The wait polls BUSY from the ARM — its bus traffic is APB
 * register reads, not a stall on the measured port. */
static uint32_t probe_run(uint32_t src, uint32_t dst, uint32_t n,
                          uint32_t ctrl, uint32_t timeout_us)
{
    reg_wr(PROBE_REG(CH_AL1_READ_ADDR), src);
    reg_wr(PROBE_REG(CH_AL1_WRITE_ADDR), dst);
    reg_wr(PROBE_REG(CH_AL1_CTRL), ctrl);
    uint32_t t0 = time_us_32();
    reg_wr(PROBE_REG(CH_AL1_TRANS_COUNT_TRIG), n);
    while (reg_rd(PROBE_REG(CH_AL1_CTRL)) & P_BUSY) {
        if (time_us_32() - t0 > timeout_us) {
            reg_wr(HIL_CHAN_ABORT_ADDR, 1u << PROBE_CH);
            busy_wait_us(100);
            reg_wr(PROBE_REG(CH_AL1_CTRL), 0);
            return 0;
        }
    }
    uint32_t dt = time_us_32() - t0;
    return dt ? dt : 1;
}

/* Stop the streamer and drain its FIFO without ever touching the AUX
 * port from the ARM while it might be empty (an empty-port read could
 * stall the bus): DREQ-paced one-word drains simply time out clean. */
static void stream_quiesce(void)
{
    reg_wr(QMI_STREAM_CTR, 0);
    for (int i = 0; i < 64; i++) {
        if (!probe_run(XIP_AUX_PORT, PROBE_SRAM, 1,
                       1u | P_SIZE32 | P_INCR_W | P_TREQ_XSTREAM | P_QUIET |
                           P_CHAIN_SELF,
                       500))
            break;
    }
}

static void cal_psram(void)
{
    machine_reset();
    volatile uint32_t *uc = (volatile uint32_t *)PSRAM_UC;
    volatile uint32_t *cc = (volatile uint32_t *)PSRAM_C;
    enum { N = 256 };

    /* Canary: the window works at all (ARM write, ARM read back). */
    for (uint32_t i = 0; i < N; i++)
        uc[i] = 0xA5000000u | i;
    uint32_t bad = 0;
    for (uint32_t i = 0; i < N; i++)
        if (uc[i] != (0xA5000000u | i))
            bad++;
    printf("CAL psram_canary: bad=%lu/%u\n", (unsigned long)bad, N);

    /* A: ARM baselines, ns/word. */
    uint32_t t0 = time_us_32();
    for (uint32_t i = 0; i < N; i++)
        uc[i] = i;
    uint32_t wr = time_us_32() - t0;
    uint32_t acc = 0;
    t0 = time_us_32();
    for (uint32_t i = 0; i < N; i++)
        acc += uc[i];
    uint32_t rd_uc = time_us_32() - t0;
    t0 = time_us_32();
    for (uint32_t i = 0; i < N; i++)
        acc += cc[i];
    uint32_t rd_c = time_us_32() - t0;
    printf("CAL psram_arm: wr=%lu rd_uc=%lu rd_cached=%lu ns/word (acc=%08lx)\n",
           (unsigned long)(wr * 1000u / N), (unsigned long)(rd_uc * 1000u / N),
           (unsigned long)(rd_c * 1000u / N), (unsigned long)acc);

    /* B: DMA-channel window access. Burst (count=N, the per-beat QMI
     * cost) and single-beat retrigger (a machine record's shape), each
     * against an SRAM-target control that prices the channel overhead.
     * Reads use INCR_READ only (fixed SRAM sink) so only the measured
     * port varies; 30 s timeout rides out even a true 1 ms/word. */
    for (uint32_t i = 0; i < N; i++)
        uc[i] = 0xB0000000u | i;
    uint32_t ctrl_rd = 1u | P_SIZE32 | P_INCR_R | P_TREQ_PERM | P_QUIET | P_CHAIN_SELF;
    uint32_t ctrl_wr = 1u | P_SIZE32 | P_INCR_W | P_TREQ_PERM | P_QUIET | P_CHAIN_SELF;
    uint32_t b_sram = probe_run(PROBE_SRAM + 0x800, PROBE_SRAM, N, ctrl_rd, 30000000u);
    uint32_t b_rd = probe_run(PSRAM_UC, PROBE_SRAM, N, ctrl_rd, 30000000u);
    uint32_t b_wr = probe_run(PROBE_SRAM, PSRAM_UC, N, ctrl_wr, 30000000u);
    printf("CAL psram_dma_burst: rd=%lu wr=%lu sram=%lu us /%u words"
           " (rd %lu ns/w over control)\n",
           (unsigned long)b_rd, (unsigned long)b_wr, (unsigned long)b_sram, N,
           (unsigned long)(b_rd > b_sram ? (b_rd - b_sram) * 1000u / N : 0));
    enum { NS = 64 };
    uint32_t s_sram = 0, s_rd = 0;
    t0 = time_us_32();
    for (uint32_t i = 0; i < NS; i++)
        if (!probe_run(PROBE_SRAM + 0x800, PROBE_SRAM, 1, ctrl_rd, 1000000u))
            break;
    s_sram = time_us_32() - t0;
    t0 = time_us_32();
    for (uint32_t i = 0; i < NS; i++)
        if (!probe_run(PSRAM_UC + 4 * i, PROBE_SRAM, 1, ctrl_rd, 1000000u))
            break;
    s_rd = time_us_32() - t0;
    printf("CAL psram_dma_single: rd=%lu sram=%lu us /%u beats (%lu ns/beat over control)\n",
           (unsigned long)s_rd, (unsigned long)s_sram, NS,
           (unsigned long)(s_rd > s_sram ? (s_rd - s_sram) * 1000u / NS : 0));

    /* C: the XIP streamer against CS1 — try both aliases; verify data. */
    for (uint32_t i = 0; i < N; i++)
        uc[i] = 0xC0DE0000u | i;
    __compiler_memory_barrier();
    static const uint32_t bases[2] = {PSRAM_UC, PSRAM_C};
    for (int v = 0; v < 2; v++) {
        stream_quiesce();
        reg_wr(QMI_STREAM_ADDR, bases[v]);
        reg_wr(QMI_STREAM_CTR, N);
        uint32_t ctrl = 1u | P_SIZE32 | P_INCR_W | P_TREQ_XSTREAM | P_QUIET | P_CHAIN_SELF;
        uint32_t us = probe_run(XIP_AUX_PORT, PROBE_SRAM, N, ctrl, 2000000u);
        uint32_t ok = 0;
        if (us) {
            ok = 1;
            for (uint32_t i = 0; i < N; i++)
                if (reg_rd(PROBE_SRAM + 4 * i) != (0xC0DE0000u | i))
                    ok = 0;
        }
        printf("CAL psram_stream addr=%08lx: %s us=%lu (%lu ns/word)\n",
               (unsigned long)bases[v], us ? (ok ? "OK" : "BAD DATA") : "TIMEOUT",
               (unsigned long)us, (unsigned long)(us * 1000u / N));
        stream_quiesce();
    }

    /* D: sustained streamer bandwidth, 256 KiB (fixed SRAM sink), vs
     * the 18.4 MB/s 640x480@60 refresh budget. */
    {
        enum { NW = 65536 };
        stream_quiesce();
        reg_wr(QMI_STREAM_ADDR, PSRAM_UC);
        reg_wr(QMI_STREAM_CTR, NW);
        uint32_t ctrl = 1u | P_SIZE32 | P_TREQ_XSTREAM | P_QUIET | P_CHAIN_SELF;
        uint32_t us = probe_run(XIP_AUX_PORT, PROBE_SRAM, NW, ctrl, 5000000u);
        if (us)
            printf("CAL psram_bw: 256KiB in %lu us = %lu KB/s (fb refresh needs 18432)\n",
                   (unsigned long)us, (unsigned long)(262144000u / us));
        else
            printf("CAL psram_bw: TIMEOUT\n");
        stream_quiesce();
    }

#if defined(HIL_XSH_DTAB_RAM) && HIL_XSH_DTAB_RAM
    /* E: the operator watches the screen. Stage the scanout table and
     * run the display through four announced traffic phases; sync loss
     * (or not) tells us which access classes coexist with video. No
     * flash op runs anywhere in this window, so arming here is safe. */
    printf("CAL psram_display: arming scanout — watch the screen\n");
    memcpy((void *)(uintptr_t)HIL_XSH_DTAB_RAM, hil_xsh_blob_dtab,
           sizeof hil_xsh_blob_dtab);
    video_dma_start();
    sleep_ms(2000);
    printf("CAL psram_display phase=0 idle 4s: expect stable black\n");
    sleep_ms(4000);
    printf("CAL psram_display phase=1 ARM window writes 4s\n");
    t0 = time_us_32();
    while (time_us_32() - t0 < 4000000u)
        for (uint32_t i = 0; i < N; i++)
            uc[i] = i;
    printf("CAL psram_display phase=2 streamer drains 4s\n");
    t0 = time_us_32();
    while (time_us_32() - t0 < 4000000u) {
        stream_quiesce();
        reg_wr(QMI_STREAM_ADDR, PSRAM_UC);
        reg_wr(QMI_STREAM_CTR, 4096);
        probe_run(XIP_AUX_PORT, PROBE_SRAM, 4096,
                  1u | P_SIZE32 | P_TREQ_XSTREAM | P_QUIET | P_CHAIN_SELF,
                  1000000u);
    }
    stream_quiesce();
    printf("CAL psram_display phase=3 DMA window reads 4s (predicted: sync loss)\n");
    t0 = time_us_32();
    while (time_us_32() - t0 < 4000000u)
        probe_run(PSRAM_UC, PROBE_SRAM, 64,
                  1u | P_SIZE32 | P_INCR_R | P_TREQ_PERM | P_QUIET | P_CHAIN_SELF,
                  3000000u);
    printf("CAL psram_display phase=4 recovery 4s: expect stable black again\n");
    sleep_ms(4000);
    video_dma_stop();
    printf("CAL psram_display: done, scanout disarmed\n");
#endif
    machine_reset();
}
#endif /* ADAFRUIT_FEATHER_RP2350 */

static void run_test(const hil_test *t)
{
    machine_reset();
    uint32_t entry = 0;
    int rc = dmx_load(t->dmx, t->dmx_len, NULL, &entry);
    if (rc != DMX_OK) {
        printf("TEST %s: FAIL dmx_load rc=%d\n", t->name, rc);
        return;
    }
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, t->compact};
    rc = dmx_start(&cfg, entry);
    if (rc != DMX_OK) {
        printf("TEST %s: FAIL dmx_start rc=%d\n", t->name, rc);
        return;
    }

    if (t->done_addr == 0) { /* perf: run for 100 ms, abort, report rate */
        sleep_ms(100);
        uint32_t count = reg_rd(t->perf_counter_addr);
        machine_reset();
        uint64_t rate = (uint64_t)count * t->blocks_per_iter * 10u;
        printf("TEST %s: %s count=%lu rate=%llu blocks/s\n", t->name,
               count > 0 ? "PASS" : "FAIL", (unsigned long)count,
               (unsigned long long)rate);
        return;
    }

    uint64_t deadline = time_us_64() + 500u * 1000u;
    while (reg_rd(t->done_addr) == 0) {
        if (time_us_64() > deadline) {
            printf("TEST %s: FAIL timeout waiting for done\n", t->name);
            machine_reset();
            return;
        }
    }

    int pass = 1;
    for (int i = 0; i < t->n_checks; i++) {
        const hil_check *c = &t->checks[i];
        uint32_t got = c->kind == 0 ? reg_rd(c->addr) : (uint32_t)gpio_get(c->addr);
        if (got != c->want) {
            printf("TEST %s: FAIL %s got=0x%08lx want=0x%08lx\n", t->name,
                   c->what, (unsigned long)got, (unsigned long)c->want);
            pass = 0;
        }
    }
    if (pass) {
        printf("TEST %s: PASS\n", t->name);
    }
    machine_reset();
}

/* --- Calibration experiments (see the emulator's TODO(hw-calibration)
 * sites). Each prints raw observations plus the emulator's behaviour. --- */

/* Emulator: a trigger arriving while EN=0 is dropped, and enabling the
 * channel later does not revive it. Load-bearing for the interrupt design
 * (prompts/overview.md §3.3). */
static void cal_trig_while_disabled(void)
{
    machine_reset();
    reg_wr(CAL_SRC, 0xAAu);
    reg_wr(CAL_DST, 0);
    reg_wr(cal_reg(CH_READ_ADDR), CAL_SRC);
    reg_wr(cal_reg(CH_WRITE_ADDR), CAL_DST);
    reg_wr(cal_reg(CH_AL1_CTRL), HIL_CAL_CTRL_BASIC_NOEN);
    reg_wr(cal_reg(CH_AL1_TRANS_COUNT_TRIG), 1); /* trigger while disabled */
    uint32_t busy0 = reg_rd(cal_reg(CH_AL1_CTRL)) & HIL_CTRL_BUSY_MASK;
    reg_wr(cal_reg(CH_AL1_CTRL), HIL_CAL_CTRL_BASIC); /* now enable (no trigger) */
    busy_wait_us(10);
    uint32_t busy1 = reg_rd(cal_reg(CH_AL1_CTRL)) & HIL_CTRL_BUSY_MASK;
    printf("CAL trig_while_disabled: busy0=%d busy1=%d dst=0x%02lx (emu: dst=0)\n",
           busy0 != 0, busy1 != 0, (unsigned long)reg_rd(CAL_DST));
}

/* Silicon (and emulator, since calibration): a null write to CTRL_TRIG
 * zeroes CTRL but still raises the quiet-mode null-trigger IRQ, judged on
 * the pre-write CTRL. */
static void cal_null_ctrl_trig(void)
{
    machine_reset();
    reg_wr(cal_reg(CH_AL1_CTRL), HIL_CAL_CTRL_BASIC); /* quiet=1 */
    reg_wr(cal_reg(CH_CTRL_TRIG), 0);                 /* null trigger */
    uint32_t irq = (reg_rd(HIL_INTR_ADDR) >> HIL_CAL_CH) & 1u;
    printf("CAL null_ctrl_trig: irq=%lu (emu: 1)\n", (unsigned long)irq);
}

/* Emulator: a null write to a non-CTRL trigger register leaves CTRL (and
 * its IRQ_QUIET) intact, so the quiet-mode null-trigger IRQ fires. */
static void cal_null_count_trig(void)
{
    machine_reset();
    reg_wr(cal_reg(CH_AL1_CTRL), HIL_CAL_CTRL_BASIC); /* quiet=1 */
    reg_wr(cal_reg(CH_AL1_TRANS_COUNT_TRIG), 0);      /* null trigger */
    uint32_t irq = (reg_rd(HIL_INTR_ADDR) >> HIL_CAL_CH) & 1u;
    printf("CAL null_count_trig: irq=%lu (emu: 1)\n", (unsigned long)irq);
}

/* Silicon (and emulator, since calibration): a TRANS_COUNT == 0 trigger
 * completes immediately — no transfer, but the completion IRQ (loud
 * channel) and chain fire. */
static void cal_zero_count(void)
{
    machine_reset();
    reg_wr(CAL_SRC, 0xBBu);
    reg_wr(CAL_DST, 0);
    reg_wr(cal_reg(CH_READ_ADDR), CAL_SRC);
    reg_wr(cal_reg(CH_WRITE_ADDR), CAL_DST);
    reg_wr(cal_reg(CH_TRANS_COUNT), 0);
    reg_wr(cal_reg(CH_CTRL_TRIG), HIL_CAL_CTRL_BASIC_LOUD); /* count=0 trigger */
    busy_wait_us(10);
    uint32_t busy = reg_rd(cal_reg(CH_AL1_CTRL)) & HIL_CTRL_BUSY_MASK;
    uint32_t irq = (reg_rd(HIL_INTR_ADDR) >> HIL_CAL_CH) & 1u;
    printf("CAL zero_count: busy=%d dst=0x%02lx irq=%lu (emu: busy=0 dst=0 irq=1)\n",
           busy != 0, (unsigned long)reg_rd(CAL_DST), (unsigned long)irq);
}

/* Silicon (and emulator, since calibration): banked DREQ credit does not
 * survive into a new trigger — after idling next to a running pacing
 * timer, a fresh 4-transfer sequence paces from the next tick (~300-400
 * us at one pulse per 100 us), it does not complete instantly. */
static void cal_idle_credit(void)
{
    machine_reset();
    reg_wr(CAL_SRC, 0xCCu);
    reg_wr(HIL_TIMER0_ADDR, (1u << 16) | 15000u);
    reg_wr(cal_reg(CH_READ_ADDR), CAL_SRC);
    reg_wr(cal_reg(CH_WRITE_ADDR), CAL_DST);
    reg_wr(cal_reg(CH_AL1_CTRL), HIL_CAL_CTRL_TIMER0); /* armed, not triggered */
    busy_wait_us(1000);
    uint32_t t0 = time_us_32();
    reg_wr(cal_reg(CH_AL1_TRANS_COUNT_TRIG), 4);
    while (reg_rd(cal_reg(CH_AL1_CTRL)) & HIL_CTRL_BUSY_MASK) {
        if (time_us_32() - t0 > 10000u) {
            break;
        }
    }
    uint32_t elapsed = time_us_32() - t0;
    reg_wr(HIL_TIMER0_ADDR, 0);
    printf("CAL idle_credit: elapsed_us=%lu (emu: paced, ~300-400)\n",
           (unsigned long)elapsed);
}

/* Sniffer checksum bit/byte order vs the emulator's implementation. */
static void cal_sniff(const char *name, uint32_t sniff_ctrl, uint32_t seed,
                      uint32_t word, uint32_t expect)
{
    machine_reset();
    reg_wr(CAL_SRC, word);
    reg_wr(HIL_SNIFF_CTRL_ADDR, sniff_ctrl);
    reg_wr(HIL_SNIFF_DATA_ADDR, seed);
    reg_wr(cal_reg(CH_READ_ADDR), CAL_SRC);
    reg_wr(cal_reg(CH_WRITE_ADDR), CAL_DST);
    reg_wr(cal_reg(CH_TRANS_COUNT), 1);
    reg_wr(cal_reg(CH_CTRL_TRIG), HIL_CAL_CTRL_SNIFF);
    busy_wait_us(10);
    uint32_t got = reg_rd(HIL_SNIFF_DATA_ADDR);
    printf("CAL %s: %s got=0x%08lx emu=0x%08lx\n", name,
           got == expect ? "MATCH" : "DIFF", (unsigned long)got,
           (unsigned long)expect);
}

/* --- Phase 3: interrupt-approach experiments (prompts/006) --- */

static void arm_tick(uint32_t vec, uint32_t disp0, uint32_t ctrl)
{
    arm_tick_ch(3, vec, disp0, ctrl);
}

static void exp_sched(void)
{
    machine_reset();
    uint32_t e;
    if (dmx_load(hil_sched_kernel_dmx, sizeof hil_sched_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sched_kernc_dmx, sizeof hil_sched_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sched_proca_dmx, sizeof hil_sched_proca_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sched_procb_dmx, sizeof hil_sched_procb_dmx, NULL, &e) != DMX_OK) {
        printf("EXP sched: FAIL load\n");
        return;
    }
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, HIL_SCHED_ENTRY) != DMX_OK) {
        printf("EXP sched: FAIL start\n");
        return;
    }
    arm_tick(HIL_SCHED_VEC, HIL_SCHED_DISP0, HIL_SCHED_INJ_CTRL);
    sleep_ms(20);
    uint32_t a1 = reg_rd(HIL_SCHED_COUNTER_A), b1 = reg_rd(HIL_SCHED_COUNTER_B);
    uint32_t t1 = reg_rd(HIL_SCHED_TICKS);
    sleep_ms(80);
    uint32_t a2 = reg_rd(HIL_SCHED_COUNTER_A), b2 = reg_rd(HIL_SCHED_COUNTER_B);
    uint32_t t2 = reg_rd(HIL_SCHED_TICKS);
    machine_reset();
    int ok = t1 >= 1 && t2 > t1 && a2 > a1 && b2 > b1;
    printf("EXP sched: %s ticks=%lu->%lu counterA=%lu->%lu counterB=%lu->%lu\n",
           ok ? "PASS" : "FAIL",
           (unsigned long)t1, (unsigned long)t2, (unsigned long)a1,
           (unsigned long)a2, (unsigned long)b1, (unsigned long)b2);
}

/* Tier-C compact machine (prompts/010): 8-byte records fetched into a
 * channel bank with static CTRLs; the all-zero record is HALT (null
 * WRITE_ADDR trigger). No fix channel: fetch's 8-byte write ring keeps
 * its write pointer on the current bank window (every window is 8-byte
 * aligned) and the banks chain straight back to fetch; a mode switch is
 * one record rewriting fetch's WRITE_ADDR through the AL3 non-trigger
 * alias. Mirrors the emulator's TestCompactMachineRaw — the
 * load-bearing semantics are TRANS_COUNT reload on triggers (chain and
 * WRITE_ADDR alike), the write ring wrap, CTRL persistence, and exact
 * data delivery on a sniffed read of SNIFF_DATA. */
static void cal_compact(void)
{
    machine_reset();
    const int eP = HIL_CMP_EPLAIN, eS = HIL_CMP_ESNIFF, eB = HIL_CMP_EBSWAP;
    const int cf = HIL_CMP_FETCH;
    const uint32_t text = HIL_MACHINE_RAM_START + 0x8000u;
    const uint32_t data = HIL_MACHINE_RAM_START + 0x9000u;
    const uint32_t fwa = chreg(cf, CH_AL3_WRITE_ADDR);
    const uint32_t win_p = chreg(eP, CH_AL2_READ_ADDR);
    const uint32_t win_s = chreg(eS, CH_AL2_READ_ADDR);
    const uint32_t win_b = chreg(eB, CH_AL2_READ_ADDR);

    uint32_t d = data;
#define CMPW(val) (reg_wr(d, (val)), d += 4, d - 4)
    uint32_t aA = CMPW(0x11223344u);
    uint32_t aB = CMPW(0xAABBCCDDu);
    uint32_t aSeed = CMPW(0x1000u);
    uint32_t aAdd = CMPW(0xF00Du);
    uint32_t aWs = CMPW(win_s);
    uint32_t aWb = CMPW(win_b);
    uint32_t aWp = CMPW(win_p);
    uint32_t aWpSw = CMPW(__builtin_bswap32(win_p));
    uint32_t dst0 = CMPW(0), dst1 = CMPW(0), dst2 = CMPW(0);
    uint32_t nul = CMPW(0), sum = CMPW(0);
#undef CMPW

    const uint32_t recs[][2] = {
        {aA, dst0},                  /* E-plain: dst0 = A */
        {aWb, fwa},                  /* switch -> bswap bank */
        {aB, dst1},                  /* E-bswap: dst1 = bswap(B) */
        {aWpSw, fwa},                /* switch -> plain (pre-swapped literal) */
        {dst0, dst2},                /* dst2 = dst0 */
        {aSeed, HIL_SNIFF_DATA_ADDR},/* accumulator = 0x1000 (unsniffed) */
        {aWs, fwa},                  /* switch -> sniff bank */
        {aAdd, nul},                 /* accumulator += 0xF00D */
        {HIL_SNIFF_DATA_ADDR, sum},  /* sum read on the sniff channel */
        {aWp, fwa},                  /* switch -> plain (dead pollution) */
        {0, 0},                      /* HALT: null trigger */
    };
    uint32_t pp = text;
    for (unsigned i = 0; i < sizeof recs / sizeof recs[0]; i++) {
        reg_wr(pp, recs[i][0]);
        reg_wr(pp + 4, recs[i][1]);
        pp += 8;
    }

    reg_wr(HIL_SNIFF_CTRL_ADDR, HIL_CMP_SNIFF_CTRL);
    reg_wr(HIL_SNIFF_DATA_ADDR, 0);

    reg_wr(chreg(eP, CH_AL1_CTRL), HIL_CMP_CTRL_PLAIN);
    reg_wr(chreg(eP, CH_AL2_TRANS_COUNT), 1);
    reg_wr(chreg(eS, CH_AL1_CTRL), HIL_CMP_CTRL_SNIFF);
    reg_wr(chreg(eS, CH_AL2_TRANS_COUNT), 1);
    reg_wr(chreg(eB, CH_AL1_CTRL), HIL_CMP_CTRL_BSWAP);
    reg_wr(chreg(eB, CH_AL2_TRANS_COUNT), 1);

    reg_wr(chreg(cf, CH_READ_ADDR), text);
    reg_wr(chreg(cf, CH_WRITE_ADDR), win_p);
    reg_wr(chreg(cf, CH_TRANS_COUNT), 2);
    reg_wr(chreg(cf, CH_CTRL_TRIG), HIL_CMP_FETCH_CTRL);
    busy_wait_us(100);

    uint32_t g0 = reg_rd(dst0), g1 = reg_rd(dst1), g2 = reg_rd(dst2);
    uint32_t gs = reg_rd(sum);
    uint32_t irq = (reg_rd(HIL_INTR_ADDR) >> eP) & 1u;
    int ok = g0 == 0x11223344u && g1 == 0xDDCCBBAAu && g2 == 0x11223344u &&
             gs == 0x1000u + 0xF00Du && irq == 1u;
    printf("CAL compact: %s dst0=%08lx dst1=%08lx dst2=%08lx sum=%08lx irq=%lu"
           " (emu: 11223344 ddccbbaa 11223344 0001000d 1)\n",
           ok ? "MATCH" : "DIFF", (unsigned long)g0, (unsigned long)g1,
           (unsigned long)g2, (unsigned long)gs, (unsigned long)irq);
    machine_reset();
}

static const hil_test *find_test(const char *name)
{
    for (int i = 0; i < HIL_N_TESTS; i++) {
        for (int j = 0;; j++) {
            if (hil_tests[i].name[j] != name[j]) {
                break;
            }
            if (name[j] == 0) {
                return &hil_tests[i];
            }
        }
    }
    return NULL;
}

static bool load_start(const hil_test *t)
{
    machine_reset();
    uint32_t entry = 0;
    if (dmx_load(t->dmx, t->dmx_len, NULL, &entry) != DMX_OK) {
        return false;
    }
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH};
    return dmx_start(&cfg, entry) == DMX_OK;
}

static void arm_injector(uint32_t ctrl)
{
    reg_wr(HIL_INJ_CH_BASE + CH_AL1_CTRL, 0);
    reg_wr(chreg(3, 0x14), HIL_SYM_irq_isrvec);   /* AL1_READ_ADDR */
    reg_wr(chreg(3, 0x18), HIL_SYM_irq_dispatch); /* AL1_WRITE_ADDR */
    reg_wr(HIL_INJ_CH_BASE + CH_TRANS_COUNT, 1);
    reg_wr(HIL_INJ_CH_BASE + CH_CTRL_TRIG, ctrl);
}

/* PIO0 SM0 GPIO-edge -> DREQ bridge: wait for a rising edge on the pin,
 * push one word (raising DREQ_PIO0_RX0), wait for the falling edge.
 * The pin is driven by this firmware over SIO — an internal loopback, so
 * no external wiring is needed. */
#define IRQ_PIN 3

static void pio_bridge_init(void)
{
    static bool ready;
    if (ready) {
        return;
    }
    ready = true;
    static const uint16_t insns[] = {
        0x20a0, /* wait 1 pin 0 */
        0x8020, /* push block   */
        0x2020, /* wait 0 pin 0 */
    };
    struct pio_program p = {.instructions = insns, .length = 3, .origin = -1};
    uint off = pio_add_program(pio0, &p);
    pio_sm_config c = pio_get_default_sm_config();
    sm_config_set_in_pins(&c, IRQ_PIN);
    sm_config_set_wrap(&c, off, off + 2);
    pio_sm_init(pio0, 0, off, &c);
    pio_sm_set_enabled(pio0, 0, true);
    gpio_init(IRQ_PIN);
    gpio_set_dir(IRQ_PIN, true);
    gpio_put(IRQ_PIN, 0);
}

/* Steady-state loop throughput of the two interruptible programs (B's
 * safepoint loop vs A's polling loop), no interrupts delivered. */
static void exp_throughput(void)
{
    const char *names[] = {"irq", "poll"};
    uint32_t syms[] = {HIL_SYM_irq_counter, HIL_SYM_poll_counter};
    for (int i = 0; i < 2; i++) {
        load_start(find_test(names[i]));
        sleep_ms(100);
        uint32_t iters = reg_rd(syms[i]);
        machine_reset();
        printf("EXP throughput_%s: %lu iters in 100 ms (%lu/s)\n", names[i],
               (unsigned long)iters, (unsigned long)(iters * 10u));
    }
}

/* Approach B with a pacing-timer tick at several rates, 100 ms each.
 * Compares delivered ISR count against the tick count to characterize
 * delivery loss (fixed per-delivery cost vs systematic fraction). */
static void exp_irq_timer(void)
{
    static const struct { uint32_t y, expect; } rates[] = {
        {15000, 1000}, /* 10 kHz  */
        {30000, 500},  /* 5 kHz   */
        {60000, 250},  /* 2.5 kHz */
    };
    for (unsigned r = 0; r < 3; r++) {
        load_start(find_test("irq"));
        reg_wr(HIL_TIMER0_ADDR + 4, (1u << 16) | rates[r].y); /* TIMER1 */
        arm_injector(HIL_INJ_CTRL_TIMER1);
        sleep_ms(100);
        uint32_t isr = reg_rd(HIL_SYM_irq_isrcount);
        uint32_t ctr = reg_rd(HIL_SYM_irq_counter);
        reg_wr(HIL_TIMER0_ADDR + 4, 0);
        machine_reset();
        printf("EXP irq_timer y=%lu: isr=%lu/%lu counter=%lu\n",
               (unsigned long)rates[r].y, (unsigned long)isr,
               (unsigned long)rates[r].expect, (unsigned long)ctr);
    }
}

/* Approach B with a GPIO edge through the PIO bridge: delivery latency
 * distribution over 1000 edges, plus a 3-edge burst (FIFO queueing). */
static void exp_irq_gpio(void)
{
    pio_bridge_init();
    load_start(find_test("irq"));
    arm_injector(HIL_INJ_CTRL_PIO0RX0);
    pio_sm_clear_fifos(pio0, 0);
    busy_wait_us(100);

    uint32_t hist[5] = {0}; /* latency in us: 0,1,2,3,>=4 */
    uint32_t miss = 0;
    for (int i = 0; i < 1000; i++) {
        uint32_t base = reg_rd(HIL_SYM_irq_isrcount);
        uint32_t t0 = time_us_32();
        gpio_put(IRQ_PIN, 1);
        uint32_t d;
        for (;;) {
            if (reg_rd(HIL_SYM_irq_isrcount) != base) {
                d = time_us_32() - t0;
                break;
            }
            if (time_us_32() - t0 > 1000u) {
                d = 1000;
                miss++;
                break;
            }
        }
        gpio_put(IRQ_PIN, 0);
        hist[d < 4 ? d : 4]++;
        busy_wait_us(5);
    }
    /* Burst: three fast edges; the PIO FIFO queues them. */
    uint32_t base = reg_rd(HIL_SYM_irq_isrcount);
    for (int i = 0; i < 3; i++) {
        gpio_put(IRQ_PIN, 1);
        busy_wait_us(1);
        gpio_put(IRQ_PIN, 0);
        busy_wait_us(1);
    }
    busy_wait_us(200);
    uint32_t burst = reg_rd(HIL_SYM_irq_isrcount) - base;
    machine_reset();
    printf("EXP irq_gpio: lat_us[0,1,2,3,>=4]=%lu,%lu,%lu,%lu,%lu miss=%lu burst3=%lu\n",
           (unsigned long)hist[0], (unsigned long)hist[1], (unsigned long)hist[2],
           (unsigned long)hist[3], (unsigned long)hist[4], (unsigned long)miss,
           (unsigned long)burst);
}

/* Approach A latency: raise by writing -1 to `pending`. */
static void exp_poll_latency(void)
{
    load_start(find_test("poll"));
    uint32_t hist[5] = {0};
    uint32_t miss = 0;
    for (int i = 0; i < 1000; i++) {
        uint32_t base = reg_rd(HIL_SYM_poll_isrcount);
        uint32_t t0 = time_us_32();
        reg_wr(HIL_SYM_poll_pending, 0xFFFFFFFFu);
        uint32_t d;
        for (;;) {
            if (reg_rd(HIL_SYM_poll_isrcount) != base) {
                d = time_us_32() - t0;
                break;
            }
            if (time_us_32() - t0 > 1000u) {
                d = 1000;
                miss++;
                break;
            }
        }
        hist[d < 4 ? d : 4]++;
        busy_wait_us(5);
    }
    machine_reset();
    printf("EXP poll_latency: lat_us[0,1,2,3,>=4]=%lu,%lu,%lu,%lu,%lu miss=%lu\n",
           (unsigned long)hist[0], (unsigned long)hist[1], (unsigned long)hist[2],
           (unsigned long)hist[3], (unsigned long)hist[4], (unsigned long)miss);
}

/* Approach C: asynchronous freeze/thaw via EN clear/set on channels 0-2.
 * The emulator predicts ~35% of offsets wedge on a dropped trigger. */
static void exp_freeze(void)
{
    const hil_test *t = find_test("irq");
    load_start(t);
    uint32_t wedges = 0, notfrozen = 0;
    for (int i = 0; i < 500; i++) {
        busy_wait_us(3 + (i % 17)); /* stagger the freeze phase */
        for (int ch = 0; ch < 3; ch++) {
            reg_wr(0x50000000u + 0x3000u + (uint32_t)ch * 0x40u + CH_AL1_CTRL, 1u); /* CLR EN */
        }
        busy_wait_us(5);
        uint32_t c1 = reg_rd(HIL_SYM_irq_counter);
        busy_wait_us(20);
        if (reg_rd(HIL_SYM_irq_counter) != c1) {
            notfrozen++;
        }
        for (int ch = 2; ch >= 0; ch--) {
            reg_wr(0x50000000u + 0x2000u + (uint32_t)ch * 0x40u + CH_AL1_CTRL, 1u); /* SET EN */
        }
        busy_wait_us(50);
        if (reg_rd(HIL_SYM_irq_counter) == c1) {
            wedges++;
            load_start(t); /* recover */
        }
    }
    machine_reset();
    printf("EXP freeze: wedges=%lu/500 notfrozen=%lu\n",
           (unsigned long)wedges, (unsigned long)notfrozen);
}

/* Approach D: abort-and-divert. CHAN_ABORT the machine, realign the PC,
 * jam the ISR, let it return. Counts PC misalignment (aborted mid block
 * fetch) and exec-busy-at-abort (replay hazard) — the two reasons D
 * cannot resume correctly in general. */
static void exp_abort(void)
{
    const hil_test *t = find_test("irq");
    load_start(t);
    uint32_t mis = 0, execbusy = 0, wedges = 0;
    for (int i = 0; i < 500; i++) {
        busy_wait_us(3 + (i % 17));
        uint32_t eb = reg_rd(chreg(1, CH_AL1_CTRL)) & HIL_CTRL_BUSY_MASK;
        reg_wr(HIL_CHAN_ABORT_ADDR, 0x7);
        busy_wait_us(2);
        if (eb) {
            execbusy++;
        }
        uint32_t pc = reg_rd(chreg(0, CH_READ_ADDR));
        if (pc & 0xFu) {
            mis++;
        }
        pc &= ~0xFu;
        reg_wr(HIL_SYM_irq_irqresume, pc);
        uint32_t isr0 = reg_rd(HIL_SYM_irq_isrcount);
        reg_wr(chreg(0, CH_READ_ADDR), reg_rd(HIL_SYM_irq_isrvec));
        reg_wr(chreg(0, CH_WRITE_ADDR), HIL_EXEC_REGS);
        reg_wr(chreg(0, CH_TRANS_COUNT), 4);
        reg_wr(chreg(0, CH_CTRL_TRIG), HIL_FETCH_CTRL);
        busy_wait_us(20);
        uint32_t c1 = reg_rd(HIL_SYM_irq_counter);
        busy_wait_us(30);
        if (reg_rd(HIL_SYM_irq_isrcount) == isr0 ||
            reg_rd(HIL_SYM_irq_counter) == c1) {
            wedges++;
            load_start(t);
        }
    }
    machine_reset();
    printf("EXP abort: misaligned_pc=%lu/500 exec_busy=%lu/500 wedges=%lu/500\n",
           (unsigned long)mis, (unsigned long)execbusy, (unsigned long)wedges);
}

#ifdef HIL_HAS_SYSCALL
/* Phase 5c (target/xv6/PORT.md): xv6 syscalls on silicon. Two instances of
 * the syscall exerciser run under the tick scheduler; pid 1's
 * SYS_write lines appear directly on the UART between the markers.
 * Same start-then-arm ordering as shell_start (the tick-arming race
 * was diagnosed on silicon in prompts/013). */
#ifdef HIL_SYM_cal_flash_g_calres
/* cal_flash (prompts/028): the MACHINE bit-bangs the QSPI pads and
 * drives QMI direct mode — the ARM must not fetch from flash while
 * that happens, so the wait loop lives in SRAM. If the machine fails
 * to restore XIP, the ARM crashes on return (observable silence) and
 * the calres words remain readable over SWD. */
static uint32_t __attribute__((noinline, section(".time_critical.calwait")))
calwait(volatile uint32_t *done, volatile uint32_t *go)
{
    volatile uint32_t *rawl = (volatile uint32_t *)0x400b0028; /* us timer */
    *go = 0x600D600Du; /* written from SRAM: the machine may now take
                        * the flash away */
    uint32_t start = *rawl;
    for (;;) {
        if (*done)
            return 1;
        if (*rawl - start > 8000000u) /* 8 s real-time cap */
            return 0;
    }
}

static void exp_calflash(void)
{
    const hil_test *t = 0;
    for (int i = 0; i < HIL_N_TESTS; i++) {
        if (hil_tests[i].name[0] == 'c' && hil_tests[i].name[1] == 'a' &&
            hil_tests[i].name[2] == 'l' && hil_tests[i].name[3] == '_') {
            t = &hil_tests[i];
        }
    }
    if (!t) {
        printf("CAL flash: no image\n");
        return;
    }
    machine_reset();
    uint32_t entry = 0;
    if (dmx_load(t->dmx, t->dmx_len, NULL, &entry) != DMX_OK) {
        printf("CAL flash: FAIL load\n");
        return;
    }
    printf("CAL flash: machine takes the flash (ARM -> SRAM wait)\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, entry) != DMX_OK) {
        printf("CAL flash: FAIL start\n");
        return;
    }
    uint32_t ca = HIL_SYM_cal_flash_g_calres;
    /* No interrupts while the flash is out of XIP: a vector fetch
     * from flash during the machine's direct-mode session is an
     * instruction bus error straight into lockup. */
    uint32_t irqs = save_and_disable_interrupts();
    uint32_t ok = calwait((volatile uint32_t *)(ca + 32),
                          (volatile uint32_t *)(ca + 48));
    restore_interrupts(irqs);
    uint32_t phase = reg_rd(ca), csr = reg_rd(ca + 4);
    uint32_t jedec = reg_rd(ca + 8), sr = reg_rd(ca + 12), wel = reg_rd(ca + 16);
    uint32_t erased = reg_rd(ca + 20), prog = reg_rd(ca + 24), xip = reg_rd(ca + 28);
    uint32_t t0 = reg_rd(ca + 36), t1 = reg_rd(ca + 40), t2 = reg_rd(ca + 44);
    machine_reset();
    printf("CAL flash: %s phase=%lu csr=%08lx timer n/EN/after=%08lx/%08lx/%08lx\n",
           ok ? "done" : "TIMEOUT", (unsigned long)phase, (unsigned long)csr,
           (unsigned long)t0, (unsigned long)t1, (unsigned long)t2);
    printf("CAL flash: jedec=%06lx sr=%02lx wel=%02lx erased=%08lx prog=%08lx xip=%08lx"
           " -> machine-only flash %s\n",
           (unsigned long)jedec, (unsigned long)sr, (unsigned long)wel,
           (unsigned long)erased, (unsigned long)prog, (unsigned long)xip,
           (erased == 0xFFFFFFFFu && prog == 0x0DA0CE11u && xip == 0x0DA0CE11u)
               ? "WORKS" : "still blocked?");
    /* Leave the flash consistent for the rest of the suite. */
    flash_flush_cache();
}
#endif

static void exp_syscall(void)
{
    machine_reset();
    uint32_t e;
    if (dmx_load(hil_sys_kernel_dmx, sizeof hil_sys_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sys_kernc_dmx, sizeof hil_sys_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sys_proca_dmx, sizeof hil_sys_proca_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_sys_procb_dmx, sizeof hil_sys_procb_dmx, NULL, &e) != DMX_OK) {
        printf("EXP syscall: FAIL load\n");
        return;
    }
    printf("EXP syscall: start (pid 1 speaks via SYS_write)\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, HIL_SYS_ENTRY) != DMX_OK) {
        printf("EXP syscall: FAIL start\n");
        return;
    }
    arm_tick(HIL_SYS_VEC, HIL_SYS_DISP0, HIL_SYS_INJ_CTRL);

    /* Wait for pid 1's exit (donetick goes nonzero right before it). */
    uint32_t waited = 0;
    while (reg_rd(HIL_SYS_DONETICK_A) == 0 && waited < 2000) {
        sleep_ms(1);
        waited++;
    }
    sleep_ms(20);
    uint32_t bg1 = reg_rd(HIL_SYS_BGCOUNT_B);
    sleep_ms(100);
    uint32_t bg2 = reg_rd(HIL_SYS_BGCOUNT_B);
    uint32_t ticks = reg_rd(HIL_SYS_TICKS);
    uint32_t done = reg_rd(HIL_SYS_DONETICK_A);
    uint32_t est = reg_rd(HIL_SYS_EXITSTATUS_A);
    machine_reset();
    int ok = done > 0 && est == 0 && bg2 > bg1 && ticks > 0;
    printf("\nEXP syscall: %s ticks=%lu donetick=%lu exit=%lu bgcount=%lu->%lu\n",
           ok ? "PASS" : "FAIL", (unsigned long)ticks, (unsigned long)done,
           (unsigned long)est, (unsigned long)bg1, (unsigned long)bg2);
}
#endif

#ifdef HIL_HAS_EXEC
/* Phase 5e (target/xv6/PORT.md): fork/exec/wait with the image loader IN the
 * kernel. Stages the hello blob at its registered RAM homes; pid 2
 * vforks, the child execs "hello" (the kernel places and relocates
 * it), the parent waits and reaps exit(7). The three lines between
 * the markers are written by SYS_write. */

static void exp_exec(void)
{
    machine_reset();
    uint32_t e;
    if (dmx_load(hil_exec_kernel_dmx, sizeof hil_exec_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_exec_kernc_dmx, sizeof hil_exec_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_exec_idle_dmx, sizeof hil_exec_idle_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_exec_parent_dmx, sizeof hil_exec_parent_dmx, NULL, &e) != DMX_OK) {
        printf("EXP exec: FAIL load\n");
        return;
    }
    stage_blob(HIL_EXEC_BLOB_HELLO_TEXT_HOME, hil_exec_blob_hello_text, sizeof hil_exec_blob_hello_text);
    stage_blob(HIL_EXEC_BLOB_HELLO_DATA_HOME, hil_exec_blob_hello_data, sizeof hil_exec_blob_hello_data);
    stage_blob(HIL_EXEC_BLOB_HELLO_RELOCS_HOME, hil_exec_blob_hello_relocs, sizeof hil_exec_blob_hello_relocs);
    printf("EXP exec: start (the kernel loads \"hello\" itself)\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, HIL_EXEC_ENTRY) != DMX_OK) {
        printf("EXP exec: FAIL start\n");
        return;
    }
    arm_tick(HIL_EXEC_VEC, HIL_EXEC_DISP0, HIL_EXEC_INJ_CTRL);
    uint32_t waited = 0;
    while (reg_rd(HIL_EXEC_REAP_PID) == 0 && waited < 2000) {
        sleep_ms(1);
        waited++;
    }
    uint32_t sp = reg_rd(HIL_EXEC_SPAWN_PID), rp = reg_rd(HIL_EXEC_REAP_PID);
    uint32_t st = reg_rd(HIL_EXEC_REAP_STATUS);
    uint32_t id1 = reg_rd(HIL_EXEC_IDLECOUNT);
    sleep_ms(50);
    uint32_t id2 = reg_rd(HIL_EXEC_IDLECOUNT);
    machine_reset();
    int ok = sp == 3 && rp == 3 && st == 7 && id2 > id1;
    printf("\nEXP exec: %s spawn=%lu reap=%lu status=%lu idle=%lu->%lu\n",
           ok ? "PASS" : "FAIL", (unsigned long)sp, (unsigned long)rp,
           (unsigned long)st, (unsigned long)id1, (unsigned long)id2);
}
#endif

#ifdef HIL_HAS_SHELL
/* Phase 5b (prompts/013): hand the console to dma-sh. Loads the
 * pre-wired bundle (kernel + shell as process A + counter as process
 * B), arms the tick chain, starts the shell, and parks the ARM — from
 * here on the UART belongs to the DMA machine, both TX and RX (pico
 * stdio leaves the RX FIFO untouched unless getchar is called). */
void shell_start(void)
{
    machine_reset();
    uint32_t e;
    if (dmx_load(hil_shell_kernel_dmx, sizeof hil_shell_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_shell_kernc_dmx, sizeof hil_shell_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_shell_sh_dmx, sizeof hil_shell_sh_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_shell_procb_dmx, sizeof hil_shell_procb_dmx, NULL, &e) != DMX_OK) {
        printf("SHELL: FAIL load\n");
        return;
    }
    /* Banner BEFORE starting anything: printf takes ~10 ms of UART
     * time, and a tick arriving between arming and dmx_start patches
     * the shell's dispatch before crt0 exists to keep it — the
     * injector then never gets re-armed (diagnosed on silicon with the
     * shell's own peek command). Order: banner, start the shell, then
     * arm the tick chain onto the already-running process. */
    stage_blob(HIL_SHELL_BLOB_ECHO_TEXT_HOME, hil_shell_blob_echo_text, sizeof hil_shell_blob_echo_text);
    stage_blob(HIL_SHELL_BLOB_ECHO_DATA_HOME, hil_shell_blob_echo_data, sizeof hil_shell_blob_echo_data);
    stage_blob(HIL_SHELL_BLOB_ECHO_RELOCS_HOME, hil_shell_blob_echo_relocs, sizeof hil_shell_blob_echo_relocs);
    stage_blob(HIL_SHELL_BLOB_HELLO_TEXT_HOME, hil_shell_blob_hello_text, sizeof hil_shell_blob_hello_text);
    stage_blob(HIL_SHELL_BLOB_HELLO_DATA_HOME, hil_shell_blob_hello_data, sizeof hil_shell_blob_hello_data);
    stage_blob(HIL_SHELL_BLOB_HELLO_RELOCS_HOME, hil_shell_blob_hello_relocs, sizeof hil_shell_blob_hello_relocs);
    printf("=== handing console to dma-sh (ARM parked; the prompt below is "
           "served entirely by the DMA controller) ===\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, HIL_SHELL_ENTRY) != DMX_OK) {
        printf("SHELL: FAIL start\n");
        return;
    }
    arm_tick(HIL_SHELL_VEC, HIL_SHELL_DISP0, HIL_SHELL_INJ_CTRL);
    for (;;) {
        tight_loop_contents();
    }
}
#endif

/* One full pass of the suite, in the historical order. */
void devtests_run(unsigned iter)
{
        for (int i = 0; i < HIL_N_TESTS; i++) {
            if (hil_tests[i].name[0] == 'c' && hil_tests[i].name[1] == 'a' &&
                hil_tests[i].name[2] == 'l' && hil_tests[i].name[3] == '_') {
                continue; /* cal_flash: needs the SRAM-wait exp below */
            }
            run_test(&hil_tests[i]);
        }
        cal_trig_while_disabled();
        cal_null_ctrl_trig();
        cal_null_count_trig();
        cal_zero_count();
        cal_idle_credit();
        cal_sniff("sniff_sum", HIL_CAL_SNIFF_SUM, 0x1000, 0x234, HIL_CAL_EXPECT_SUM);
        cal_sniff("sniff_crc32", HIL_CAL_SNIFF_CRC32, 0xFFFFFFFFu, 0x12345678u,
                  HIL_CAL_EXPECT_CRC32);
        cal_compact();
        exp_sched();
        exp_throughput();
        exp_irq_timer();
        exp_irq_gpio();
        exp_poll_latency();
        exp_freeze();
        exp_abort();
#ifdef HIL_SYM_cal_flash_g_calres
        exp_calflash();
#endif
#ifdef HIL_HAS_SYSCALL
        exp_syscall();
#endif
#ifdef HIL_HAS_EXEC
        exp_exec();
#endif
#if defined(ADAFRUIT_FEATHER_RP2350)
        cal_psram();
#endif
        printf("=== END iter=%u\n", iter);
}

#endif /* HIL_DEV_TESTS */
