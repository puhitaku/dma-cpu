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

#include "pico/stdlib.h"
#include "hardware/flash.h"
#include "hardware/gpio.h"
#include "hardware/pio.h"

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
/* Phase 5e (xv6/PORT.md): fork/exec/wait with the image loader IN the
 * kernel. Stages the hello blob at its registered RAM homes; pid 2
 * vforks, the child execs "hello" (the kernel places and relocates
 * it), the parent waits and reaps exit(7). The three lines between
 * the markers are written by SYS_write. */
static void stage_blob(uint32_t home, const uint8_t *src, size_t len)
{
    for (size_t i = 0; i < len; i += 4) {
        uint32_t w = (uint32_t)src[i] | ((uint32_t)src[i + 1] << 8) |
                     ((uint32_t)src[i + 2] << 16) | ((uint32_t)src[i + 3] << 24);
        reg_wr(home + i, w);
    }
}

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
static void __attribute__((noinline, section(".time_critical.park"))) park_forever(void)
{
    __asm volatile("cpsid i");
#ifdef HIL_XSH_FLASHREQ
    volatile uint32_t *req = (volatile uint32_t *)HIL_XSH_FLASHREQ; /* op,off,src,seq,ack */
    for (;;) {
        if (req[3] != req[4]) {
            uint32_t op = req[0], off = req[1], src = req[2];
            if (op == 1)
                flash_range_erase(off, 4096);
            else if (op == 2)
                flash_range_program(off, (const uint8_t *)src, 256);
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
static void xsh_start(void)
{
    machine_reset();
    uint32_t e;
    if (dmx_load(hil_xsh_kernel_dmx, sizeof hil_xsh_kernel_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_kernc_dmx, sizeof hil_xsh_kernc_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_sh_dmx, sizeof hil_xsh_sh_dmx, NULL, &e) != DMX_OK ||
        dmx_load(hil_xsh_idle_dmx, sizeof hil_xsh_idle_dmx, NULL, &e) != DMX_OK) {
        printf("XSH: FAIL load\n");
        return;
    }
    /* Stage the disk: a valid persistent slot (magic, size, word-sum
     * checksum, header written last by the kernel's sync) wins over
     * the golden image. */
    const uint32_t *hdr = (const uint32_t *)HIL_XSH_FSSLOT;
    int fromflash = 0;
    if (hdr[0] == 0x53464D44u && hdr[2] == HIL_XSH_DISK_LEN) {
        const uint32_t *img = (const uint32_t *)(HIL_XSH_FSSLOT + 0x1000);
        uint32_t sum = 0;
        for (uint32_t i = 0; i < HIL_XSH_DISK_LEN / 4; i++)
            sum += img[i];
        if (sum == hdr[3]) {
            for (uint32_t i = 0; i < HIL_XSH_DISK_LEN; i += 4)
                reg_wr(HIL_XSH_BLOB_DISK_HOME + i, img[i / 4]);
            fromflash = 1;
        }
    }
    if (!fromflash) {
        stage_blob(HIL_XSH_BLOB_DISK_HOME, hil_xsh_blob_disk, sizeof hil_xsh_blob_disk);
    }
    printf("=== handing console to UPSTREAM xv6 sh + fs, Tier-C compact "
           "(disk: %s gen %lu; ARM -> SRAM wfi; the $ prompt below is served "
           "entirely by the DMA controller) ===\n",
           fromflash ? "FLASH SLOT" : "golden", fromflash ? (unsigned long)hdr[1] : 0);
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

#ifdef HIL_SYM_cal_flash_g_calres
/* cal_flash2 (prompts/023): the MACHINE bit-bangs the QSPI pads and
 * drives QMI direct mode — the ARM must not fetch from flash while
 * that happens, so the wait loop lives in SRAM. If the machine fails
 * to restore XIP, the ARM crashes on return (observable silence) and
 * the calres words remain readable over SWD. */
static uint32_t __attribute__((noinline, section(".time_critical.calwait")))
calwait(volatile uint32_t *done)
{
    for (uint32_t i = 0; i < 400000000u; i++) {
        if (*done)
            return 1;
    }
    return 0;
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
        printf("CAL flash2: no image\n");
        return;
    }
    machine_reset();
    uint32_t entry = 0;
    if (dmx_load(t->dmx, t->dmx_len, NULL, &entry) != DMX_OK) {
        printf("CAL flash2: FAIL load\n");
        return;
    }
    printf("CAL flash2: machine takes the flash (ARM -> SRAM wait)\n");
    dmx_machine_cfg cfg = {0, 1, 2, HIL_SCRATCH, 0};
    if (dmx_start(&cfg, entry) != DMX_OK) {
        printf("CAL flash2: FAIL start\n");
        return;
    }
    uint32_t ok = calwait((volatile uint32_t *)(HIL_SYM_cal_flash_g_calres + 32));
    machine_reset();
    uint32_t ca = HIL_SYM_cal_flash_g_calres;
    printf("CAL flash2: %s phase=%lu jedec=%06lx sr=%02lx wel=%02lx base=%08lx "
           "erased=%08lx prog=%08lx xip=%08lx "
           "(want jedec!=ffffff/000000, wel=02, erased=ffffffff, prog=xip=c3c2c1c0)\n",
           ok ? "done" : "TIMEOUT",
           (unsigned long)reg_rd(ca), (unsigned long)reg_rd(ca + 4),
           (unsigned long)reg_rd(ca + 8), (unsigned long)reg_rd(ca + 12),
           (unsigned long)reg_rd(ca + 16), (unsigned long)reg_rd(ca + 20),
           (unsigned long)reg_rd(ca + 24), (unsigned long)reg_rd(ca + 28));
}
#endif

int main(void)
{
    stdio_init_all();
    sleep_ms(3000);

    /* GPIO2: input from the firmware's view; the DMA machine drives it
     * via IO_BANK0 overrides. gpio_init also clears RP2350 pad isolation. */
    gpio_init(2);
    gpio_set_dir(2, false);

    for (unsigned iter = 1;; iter++) {
        printf("=== DMA-HIL sku=%s iter=%u bss_end=%p machine_ram=[0x%08lx,0x%08lx)\n",
               HIL_SKU, iter, (void *)&__bss_end__,
               (unsigned long)HIL_MACHINE_RAM_START,
               (unsigned long)HIL_MACHINE_RAM_END);
#ifdef HIL_XSH_FSSLOT
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
#ifdef HIL_SYM_cal_flash_g_calres
        exp_calflash();
#endif
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
