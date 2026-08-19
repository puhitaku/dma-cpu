/* DMA-machine HIL (hardware-in-the-loop) runner.
 *
 * Loads the dmxgen-generated test images through the DMX loader, runs them
 * on the real DMA machine, and prints expected-vs-observed results over
 * UART (115200, default pins — routed to the Debug Probe). Also runs the
 * C-side calibration experiments for the emulator's marked unknowns
 * (TODO(hw-calibration) sites). A FAIL means silicon and emulator
 * disagree: that is the finding, not necessarily a bug on either side —
 * see prompts/004-hw-calibration.md.
 *
 * Output format, one line each, repeated every few seconds:
 *   TEST <name>: PASS|FAIL <detail>
 *   CAL <name>: <observations>
 */
#include <stdio.h>
#include <string.h>

#include "pico/stdlib.h"
#include "pico/bootrom.h"
#include "hardware/flash.h"
#if PICO_RP2350
#include "hardware/structs/accessctrl.h"
#endif
#include "hardware/sync.h"
#include "hardware/gpio.h"
#include "hardware/pio.h"

#if defined(ADAFRUIT_FEATHER_RP2350)
#include "hardware/clocks.h"
#include "hardware/pll.h"
#include "hardware/psram.h"
#include "hardware/structs/hstx_ctrl.h"
#include "hardware/structs/hstx_fifo.h"
#include "hardware/structs/qmi.h"
#include "hardware/spi.h"
#include "pico/multicore.h"
#endif

#include "dmx.h"
#include "images.h"

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

static inline void reg_wr(uint32_t addr, uint32_t val)
{
    *(volatile uint32_t *)(uintptr_t)addr = val;
}

static inline uint32_t reg_rd(uint32_t addr)
{
    return *(volatile uint32_t *)(uintptr_t)addr;
}

static inline uint32_t cal_reg(uint32_t off) { return HIL_CAL_CH_BASE + off; }

/* Scratch words inside the reserved machine region, used by the C-side
 * calibration experiments (the DMX images are not loaded while these
 * run). */
#define CAL_SRC (HIL_MACHINE_RAM_START + 0x0u)
#define CAL_DST (HIL_MACHINE_RAM_START + 0x100u)

static void machine_reset(void)
{
    reg_wr(HIL_CHAN_ABORT_ADDR, (1u << HIL_NCHANNELS) - 1);
    busy_wait_us(10);
    for (int ch = 0; ch < HIL_NCHANNELS; ch++) {
        reg_wr(0x50000000u + (uint32_t)ch * 0x40u + CH_AL1_CTRL, 0);
    }
    reg_wr(HIL_INTR_ADDR, 0xFFFFu); /* write-1-to-clear raw status */
    reg_wr(HIL_SNIFF_CTRL_ADDR, 0);
    reg_wr(HIL_SNIFF_DATA_ADDR, 0);
    reg_wr(HIL_TIMER0_ADDR, 0);
}

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

static inline uint32_t chreg(int ch, uint32_t off)
{
    return 0x50000000u + (uint32_t)ch * 0x40u + off;
}

/* Phase 5a (prompts/012): the preemptive round-robin proto-kernel. Two
 * relocated instances of the same compiled C program are scheduled by
 * kernel.dasm; a two-injector chain patches both dispatch words on
 * every pacing-timer tick, and the running process detours into the
 * scheduler at its next safepoint. The images arrive pre-wired from
 * dmxgen; this only loads, arms, starts A, and samples the counters. */
static void arm_tick_ch(int ch, uint32_t vec, uint32_t disp0, uint32_t ctrl)
{
    reg_wr(HIL_TIMER0_ADDR + 4, (1u << 16) | 15000u); /* TIMER1 tick */
    reg_wr(chreg(ch, CH_AL1_READ_ADDR), vec);
    reg_wr(chreg(ch, CH_AL1_WRITE_ADDR), disp0);
    reg_wr(chreg(ch, CH_TRANS_COUNT), 1);
    reg_wr(chreg(ch, CH_CTRL_TRIG), ctrl);
}

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
 * channel bank with static CTRLs; mode switch = one record rewriting
 * the fix channel's scratch word; the all-zero record is HALT (null
 * WRITE_ADDR trigger). Mirrors the emulator's TestCompactMachineRaw —
 * the load-bearing semantics are TRANS_COUNT reload on WRITE_ADDR
 * triggers, CTRL persistence, and exact data delivery on a sniffed read
 * of SNIFF_DATA. */
static void cal_compact(void)
{
    machine_reset();
    const int eP = HIL_CMP_EPLAIN, eS = HIL_CMP_ESNIFF, eB = HIL_CMP_EBSWAP;
    const int cf = HIL_CMP_FETCH, cx = HIL_CMP_FIX;
    const uint32_t text = HIL_MACHINE_RAM_START + 0x8000u;
    const uint32_t data = HIL_MACHINE_RAM_START + 0x9000u;
    const uint32_t scr = HIL_MACHINE_RAM_START + 0x9F00u;
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
        {aWb, scr},                  /* switch -> bswap bank */
        {aB, dst1},                  /* E-bswap: dst1 = bswap(B) */
        {aWpSw, scr},                /* switch -> plain (pre-swapped literal) */
        {dst0, dst2},                /* dst2 = dst0 */
        {aSeed, HIL_SNIFF_DATA_ADDR},/* accumulator = 0x1000 (unsniffed) */
        {aWs, scr},                  /* switch -> sniff bank */
        {aAdd, nul},                 /* accumulator += 0xF00D */
        {HIL_SNIFF_DATA_ADDR, sum},  /* sum read on the sniff channel */
        {aWp, scr},                  /* switch -> plain (dead pollution) */
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

    reg_wr(scr, win_p);
    reg_wr(chreg(cx, CH_AL1_READ_ADDR), scr);
    reg_wr(chreg(cx, CH_AL1_WRITE_ADDR), chreg(cf, CH_AL2_WRITE_ADDR_TRIG));
    reg_wr(chreg(cx, CH_AL2_TRANS_COUNT), 1);
    reg_wr(chreg(cx, CH_AL1_CTRL), HIL_CMP_CTRL_FIX);

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

extern char __bss_end__;

#ifdef HIL_HAS_SYSCALL
/* Phase 5c (xv6/PORT.md): xv6 syscalls on silicon. Two instances of
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

/* Copies a build-embedded blob to its registered RAM home, word-wise
 * through the machine's bus view (shared by the exec/shell demos and
 * the xsh disk staging). */
static void __attribute__((unused)) stage_blob(uint32_t home, const uint8_t *src, size_t len)
{
    for (size_t i = 0; i < len; i += 4) {
        uint32_t w = (uint32_t)src[i] | ((uint32_t)src[i + 1] << 8) |
                     ((uint32_t)src[i + 2] << 16) | ((uint32_t)src[i + 3] << 24);
        reg_wr(home + i, w);
    }
}

#ifdef HIL_HAS_EXEC
/* Phase 5e (xv6/PORT.md): fork/exec/wait with the image loader IN the
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
static void shell_start(void)
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

/* The ARM's final state: an SRAM-resident loop with interrupts masked
 * that serves as the machine's flash executor (prompts/022): the
 * kernel's sync posts erase/program requests to a mailbox and the ARM
 * runs the SDK's XIP-safe routines (they handle the quad-mode
 * exit-XIP dance the machine cannot). Between requests the loop just
 * spins in SRAM — the ARM never fetches from flash again. */
#if defined(ADAFRUIT_FEATHER_RP2350)
/* The bootrom's fast M0 window config, snapshotted at boot for the
 * executor's end-of-sync restore (feather_video_init fills it). */
static volatile uint32_t boot_m0[3];
static volatile uint32_t boot_m0_saved;

/* --- MicroSD in SPI mode (prompts/037). ---
 * Wiring: SCK=GPIO22, MOSI=GPIO23, MISO=GPIO20 (the Feather's SPI0
 * pins), CS=GPIO10 (D10, the Adalogger FeatherWing convention). The
 * machine's kernel reads the card one 512-byte sector at a time
 * through the park executor's mailbox (op 4; op 5 initializes),
 * and mounts the vfat partition with its own read-only driver. */
#define SD_SPI  spi0
#define SD_SCK  22
#define SD_MOSI 23
#define SD_MISO 20
#define SD_CS   10

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

static int sd_hc; /* SDHC/SDXC: block addressing */

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
 * framebuffer is 640x240 bytes at HIL_XSH_FBBUF; every row is
 * scanned twice. */
#define VF_W      640
#define VF_ROWS   240
#define VF_LINES  480
#define VF_CMD_RAW_REPEAT (0x1u << 12)
#define VF_CMD_TMDS       (0x2u << 12)
#define VF_CMD_NOP        (0xFu << 12)
#define VF_CTRL_00 0x354u
#define VF_CTRL_01 0x0ABu
#define VF_CTRL_10 0x154u
#define VF_CTRL_11 0x2ABu
#define VF_L12 (VF_CTRL_00 << 10 | VF_CTRL_00 << 20)

static void __attribute__((noinline, section(".time_critical.vfeed"))) video_feeder(void)
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
            uint32_t row = (line >> 1) + *ctl;
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
#endif

static void __attribute__((noinline, section(".time_critical.park"))) park_forever(void)
{
    __asm volatile("cpsid i");
#ifdef HIL_XSH_FLASHREQ
    volatile uint32_t *req = (volatile uint32_t *)HIL_XSH_FLASHREQ; /* op,off,src,seq,ack */
    for (;;) {
        if (req[3] != req[4]) {
            uint32_t op = req[0], off = req[1], src = req[2];
            if (op == 1) {
                flash_range_erase(off, 4096);
            } else if (op == 2) {
                flash_range_program(off, (const uint8_t *)src, 256);
#if defined(ADAFRUIT_FEATHER_RP2350)
            } else if (op == 4) { /* SD: read sector `off` to `src` */
                if (sd_read_sector(off, (uint8_t *)src) != 0)
                    for (int i = 0; i < 512; i++) /* poison, never stale */
                        ((uint8_t *)src)[i] = 0xFF;
            } else if (op == 5) { /* SD: (re)initialize; {status,0} at src */
                ((uint32_t *)src)[0] = (uint32_t)sd_init_card();
                ((uint32_t *)src)[1] = 0;
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
static uint8_t stage_sect[4096]; /* shared with the fat-golden staging */

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
    printf("=== handing console to UPSTREAM xv6 sh + fs, Tier-C compact "
           "(disk: %s gen %lu; ARM -> SRAM wfi; the $ prompt below is served "
           "entirely by the DMA controller) ===\n",
           fromflash ? "FLASH SLOT" : "golden", (unsigned long)slotgen);
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 1}; /* compact machine */
    if (dmx_start(&cfg, HIL_XSH_ENTRY) != DMX_OK) {
        printf("XSH: FAIL start\n");
        return;
    }
    for (int i = 0; i < 5; i++) /* clear the flash-request mailbox */
        reg_wr(HIL_XSH_FLASHREQ + 4u * i, 0);
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
 *    stays at the machine's calibrated 150 MHz and clk_peri stays on
 *    clk_sys, so the UART is unaffected (clk_usb/clk_adc die: unused).
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

    hstx_ctrl_hw->expand_tmds =
        2u << HSTX_CTRL_EXPAND_TMDS_L2_NBITS_LSB |
        0u << HSTX_CTRL_EXPAND_TMDS_L2_ROT_LSB |
        2u << HSTX_CTRL_EXPAND_TMDS_L1_NBITS_LSB |
        29u << HSTX_CTRL_EXPAND_TMDS_L1_ROT_LSB |
        1u << HSTX_CTRL_EXPAND_TMDS_L0_NBITS_LSB |
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

int main(void)
{
    stdio_init_all();
    sleep_ms(3000);

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
    /* Blank the framebuffer and start the core-1 feeder: the display
     * carries a clean 640x480@60 signal from here on, machine or not. */
    for (uint32_t a = HIL_XSH_FBBUF; a < HIL_XSH_FBBUF + VF_ROWS * VF_W; a += 4)
        *(volatile uint32_t *)a = 0;
    *(volatile uint32_t *)HIL_XSH_FBCTL = 0;
    multicore_launch_core1(video_feeder);
#endif

    /* GPIO2: input from the firmware's view; the DMA machine drives it
     * via IO_BANK0 overrides. gpio_init also clears RP2350 pad isolation. */
    gpio_init(2);
    gpio_set_dir(2, false);

    for (unsigned iter = 1;; iter++) {
        printf("=== DMA-HIL sku=%s iter=%u bss_end=%p machine_ram=[0x%08lx,0x%08lx)\n",
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
        printf("=== END iter=%u\n", iter);
#ifdef HIL_HAS_XSH
        xsh_start(); /* one validation pass, then the console belongs to xv6 sh */
#elif defined(HIL_HAS_SHELL)
        shell_start();
#endif
        sleep_ms(2000);
    }
}
