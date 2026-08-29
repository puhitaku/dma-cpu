/* bench.c: how fast is this CPU, really? A fixed-work integer suite.
 *
 * MIPS is ill-defined on a machine whose op costs span ~500x (ALU a
 * few records, mul ~900, div ~1800), so the suite reports two layers:
 *
 *  - "bogo": a calibrated counting loop, the BogoMIPS idea. With no
 *    cache, no branch prediction and no OoO, the loop's cost is
 *    EXACTLY deterministic, so iterations/s times the loop's known
 *    instruction count is a real ISA-MIPS figure, not a bogus one.
 *    The Linux-convention BogoMIPS (loops/s / 500k) is shown too.
 *  - six kernels, one per operation class, each a classic algorithm
 *    (implemented from the algorithm, not from benchmark sources):
 *    sieve of Eratosthenes (branch + byte memory), insertion sort
 *    (compare/move), 12x12 matrix multiply (mul), Euclid gcd (div),
 *    xorshift32 (shifts - the machine's weak spot: >> is a runtime
 *    loop), and gdma copy/fill (native DMA - the superpower).
 *
 * Kernels are fixed-work and read no timers inside, so the emulator
 * and silicon execute the identical record stream; each prints a
 * checksum the golden test pins against a host-Go reference. Timing
 * uses the hardware us counter, valid on silicon only (the emulated
 * timer free-runs; the test checks sums and rendering, not rates). */
#include "g.h"

#define C_BG RGB(10, 14, 30)
#define C_TITLE RGB(255, 210, 60)
#define C_TEXT RGB(180, 190, 215)
#define C_DIM RGB(105, 112, 140)
#define C_LIVE RGB(90, 240, 140)

#define LOOP_N 65536u
/* dmaasm instructions per bogo iteration, counted from the compiled
 * .dasm listing (dmacc -entry gmain -nosafepoints -o): 13 in the loop
 * body (volatile store/loads, s+=i, i-1, outlined-compare site, jumps)
 * plus 4 in the __cw_eqz millicode not-taken path (sub, or, jsign,
 * jumpr). TestGameBench pins the loop's per-iteration record cost so
 * compiler drift here fails loudly - re-count on drift. */
#define LOOP_INSTR 17u

#define SIEVE_N 4096
#define SORT_N 128
#define SORT_ROUNDS 4
#define MAT_N 12
#define DIV_N 96
#define RAND_N 2048
#define SHR_N 1024
#define MEM_WORDS 1024
#define MEM_ROUNDS 8

/* Working buffers live in free SRAM, NOT in .data: the game's data
 * segment once ended just under the old drum arena (0x2002E000), and
 * ~10 KiB of bench statics pushed it straight into the ring — a menu
 * blip then overwrote live data words (the emulator crashed on a PC
 * of replicated audio samples). 0x2003C000..0x2003FE00 is unclaimed
 * (the ARM's park stamp moved to 0x2003FF00, past the compact
 * machine's scratch word at 0x2003FE00, to make room contiguous for
 * the radiosity patch state). Bench keeps its old base and uses
 * 9.7 KiB; the two apps never run together. */
#define BENCH_RAM 0x2003D100u
#define flags ((uchar *)BENCH_RAM)                    /* 4 KiB; mem dst */
#define scratch ((uint *)(BENCH_RAM + 0x1000))        /* 4 KiB */
#define ma ((uint *)(BENCH_RAM + 0x2000))             /* 576 B */
#define mb ((uint *)(BENCH_RAM + 0x2000 + 576))       /* 576 B */
#define mc ((uint *)(BENCH_RAM + 0x2000 + 1152))      /* 576 B, ends 0x2003F7C0 */

static uint xs; /* xorshift32 state (Marsaglia) */

static uint
xrand(void)
{
  xs ^= xs << 13;
  xs ^= xs >> 17;
  xs ^= xs << 5;
  return xs;
}

/* --- kernels: each returns a checksum, counts its ops itself --- */

static volatile uint bogo_i; /* volatile: the loop must stay real */

static uint
k_bogo(uint *ops)
{
  uint s = 0;
  for (bogo_i = LOOP_N; bogo_i != 0; bogo_i--)
    s += bogo_i;
  *ops = LOOP_N;
  return s; /* N(N+1)/2 mod 2^32 */
}

static uint
k_sieve(uint *ops)
{
  uint marks = 0, primes = 0;
  for (int pass = 0; pass < 2; pass++) {
    for (int i = 0; i < SIEVE_N; i++)
      flags[i] = 1;
    for (int i = 2; i < SIEVE_N; i++) {
      if (flags[i]) {
        primes++;
        for (int k = i + i; k < SIEVE_N; k += i) {
          flags[k] = 0;
          marks++;
        }
      }
    }
  }
  *ops = marks;
  return primes; /* 2 * pi(SIEVE_N - 1) */
}

static uint
k_sort(uint *ops)
{
  uint cmps = 0, sum = 0;
  for (int r = 0; r < SORT_ROUNDS; r++) {
    uint *a = scratch + 512;
    gdma_copy((uint)a, (uint)(scratch + r * SORT_N), SORT_N * 4);
    for (int i = 1; i < SORT_N; i++) {
      uint v = a[i];
      int j = i;
      while (j > 0) {
        cmps++;
        if (a[j - 1] <= v)
          break;
        a[j] = a[j - 1];
        j--;
      }
      a[j] = v;
    }
    sum += a[0] + a[SORT_N / 2] + a[SORT_N - 1] + (uint)r * a[7];
  }
  *ops = cmps;
  return sum;
}

static uint
k_mul(uint *ops)
{
  /* indices maintained by addition, so the ONLY multiplies measured
   * are the MAT_N^3 data ones (an i*MAT_N per element would pollute
   * the count with indexing multiplies) */
  int arow = 0; /* == i * MAT_N */
  for (int i = 0; i < MAT_N; i++) {
    for (int j = 0; j < MAT_N; j++) {
      uint acc = 0;
      int aidx = arow, bidx = j;
      for (int k = 0; k < MAT_N; k++) {
        acc += ma[aidx] * mb[bidx];
        aidx++;
        bidx += MAT_N;
      }
      mc[arow + j] = acc;
    }
    arow += MAT_N;
  }
  *ops = MAT_N * MAT_N * MAT_N; /* multiplies */
  uint sum = 0;
  for (int i = 0; i < MAT_N * MAT_N; i++)
    sum += mc[i];
  return sum;
}

static uint
k_div(uint *ops)
{
  uint steps = 0, sum = 0;
  uint *p = scratch + 640; /* DIV_N pairs, pre-seeded */
  for (int i = 0; i < DIV_N; i++) {
    uint a = p[i * 2], b = p[i * 2 + 1];
    while (b != 0) {
      uint t = a % b;
      a = b;
      b = t;
      steps++;
    }
    sum += a;
  }
  *ops = steps; /* one modulo per step */
  return sum;
}

static uint
k_rand(uint *ops)
{
  uint s = 0;
  xs = 0x1234567u;
  for (int i = 0; i < RAND_N; i++)
    s += xrand();
  *ops = RAND_N;
  return s;
}

static uint
k_shr1(uint *ops)
{
  /* the small-count shift: >>1 takes rt_lshr's bit-reversal path —
   * reverse, one left double, reverse back — where >>17 in the rand
   * kernel falls to the MSB-first rebuild loop. One >>1 plus one add
   * per step. */
  uint v = 0xDEADBEEFu, s = 0;
  for (int i = 0; i < SHR_N; i++) {
    s += v >> 1;
    v += 0x9E3779B9u;
  }
  *ops = SHR_N;
  return s;
}

static uint
k_mem(uint *ops)
{
  for (int r = 0; r < MEM_ROUNDS; r++) {
    gdma_fill((uint)scratch, 0xA5A5A5A5u + (uint)r, MEM_WORDS * 4);
    gdma_copy((uint)flags, (uint)scratch, SIEVE_N);
  }
  *ops = MEM_ROUNDS * (MEM_WORDS + SIEVE_N / 4); /* words moved */
  return scratch[1] + ((uint *)flags)[SIEVE_N / 4 - 1];
}

/* --- formatting --- */

static void
rate_str(char *b, uint v) /* ops per second -> "9.99M" / "999k" / "999" */
{
  if (v >= 1000000u) {
    uint q = v / 100000u; /* tenths of a million */
    b[0] = (char)('0' + q / 10 % 10);
    b[1] = '.';
    b[2] = (char)('0' + q % 10);
    b[3] = 'M';
    b[4] = 0;
    if (q >= 100) { /* 10.0M+ : drop the fraction */
      numsp(b, 3, v / 1000000u);
      b[3] = 'M';
      b[4] = 0;
    }
  } else if (v >= 1000u) {
    numsp(b, 3, v / 1000u);
    b[3] = 'k';
    b[4] = 0;
  } else {
    numsp(b, 3, v);
    b[3] = ' ';
    b[4] = 0;
  }
}

typedef uint (*kfn)(uint *ops);

static const char *knames[8] = {"bogo ", "sieve", "sort ", "mul  ",
                                "div  ", "rand ", "shr1 ", "mem  "};
static const char *kunit[8] = {"loop/s", "mark/s", "cmp/s ", "mul/s ",
                               "div/s ", "rnd/s ", "shr/s ", "word/s"};

void
bench_run(void)
{
  uputs("bench: up\n");
  led(LED_DIM(0xFF8000), LED_DIM(0xFF8000));
  gfx_clear(C_BG);
  gfx_text2(48, 8, "BENCHMARK", C_TITLE, C_BG);
  gfx_text(8, 32, "fixed work, hardware timer", C_DIM, C_BG);
  gfx_present();

  /* seed everything OUTSIDE the timed regions */
  xs = 0xC0FFEE01u;
  for (int i = 0; i < 512; i++) /* sort pregen: 4 rounds x 128 */
    scratch[i] = xrand();
  for (int i = 0; i < MAT_N * MAT_N; i++) {
    ma[i] = xrand() & 0xFF;
    mb[i] = xrand() & 0xFF;
    mc[i] = 0;
  }
  for (int i = 0; i < DIV_N * 2; i++)
    scratch[640 + i] = xrand() | 1u;

  static const kfn kf[8] = {k_bogo, k_sieve, k_sort, k_mul,
                            k_div,  k_rand,  k_shr1, k_mem};
  uint kus[8];
  uint krate[8];
  char line[32];
  for (int k = 0; k < 8; k++) {
    int y = 48 + k * 13;
    gfx_text(8, y, knames[k], C_TEXT, C_BG);
    gfx_text(56, y, "...", C_DIM, C_BG);
    gfx_present();

    uint ops = 0;
    uint t0 = now_us();
    uint sum = kf[k](&ops);
    uint us = now_us() - t0;
    if (us == 0)
      us = 1;
    kus[k] = us;

    /* UART: machine-readable for HIL and the golden test */
    uputs("BENCH ");
    uputs(knames[k]);
    uputs(" ops=");
    uputn(ops);
    uputs(" us=");
    uputn(us);
    uputs(" sum=");
    uputhex(sum);
    uputs("\n");

    /* LCD: "sieve  102ms  93.4k mark/s" */
    uint ms = us / 1000u;
    if (ms == 0)
      ms = 1;
    uint rate = ops / ms * 1000u + ops % ms * 1000u / ms;
    krate[k] = rate;
    gfx_fill(56, y, 176, 12, C_BG);
    numsp(line, 5, ms);
    line[5] = 0;
    gfx_text(56, y, line, C_TEXT, C_BG);
    gfx_text(96, y, "ms", C_DIM, C_BG);
    rate_str(line, rate);
    gfx_text(128, y, line, C_LIVE, C_BG);
    gfx_text(172, y, kunit[k], C_DIM, C_BG);
    gfx_present();
  }

  /* headline: the composite score. The bogo MIPS figure is one
   * kernel's result, not a summary of the others, so every kernel
   * counts as its own term: the seven compute rates in k-ops/s plus
   * the memory stream per 100k words/s. */
  uint score = (krate[0] + krate[1] + krate[2] + krate[3] + krate[4] +
                krate[5] + krate[6]) /
                   1000u +
               krate[7] / 100000u;
  uint mips100 = LOOP_N / 100u * LOOP_INSTR * 10000u / kus[0];
  uint bogo100 = LOOP_N * 200u / kus[0]; /* Linux: loops/s / 500k */
  char m[16];
  numsp(m, 5, score);
  gfx_text2(8, 160, m, C_LIVE, C_BG);
  gfx_text2(112, 160, "SCORE", C_TITLE, C_BG);
  gfx_text(8, 184, "kernel rates/1k + mem/100k", C_DIM, C_BG);
  numsp(m, 3, mips100 / 100);
  m[3] = '.';
  m[4] = (char)('0' + mips100 / 10 % 10);
  m[5] = (char)('0' + mips100 % 10);
  m[6] = 0;
  gfx_text(8, 198, "MIPS (bogo loop):", C_DIM, C_BG);
  gfx_text(184, 198, m, C_TEXT, C_BG);
  numsp(m, 3, bogo100 / 100);
  m[3] = '.';
  m[4] = (char)('0' + bogo100 / 10 % 10);
  m[5] = (char)('0' + bogo100 % 10);
  m[6] = 0;
  gfx_text(8, 212, "BogoMIPS (linux conv):", C_DIM, C_BG);
  gfx_text(184, 212, m, C_TEXT, C_BG);
  gfx_text(8, 226, "press: back", C_DIM, C_BG);
  gfx_present();

  uputs("BENCH score=");
  uputn(score);
  uputs("\nBENCH mips100=");
  uputn(mips100);
  uputs(" bogo100=");
  uputn(bogo100);
  uputs("\nbench done\n");
  led(LED_DIM(0x00FF40), LED_DIM(0x00FF40));
  /* finish jingle: a short E5->G5, hardware-timed like the menu
   * fanfare (a frame-counted tone would drone for seconds here) */
  snd_play(659, 55, 255);
  delay_us(60000);
  snd_play(784, 55, 255);
  delay_us(90000);
  snd_off();

  for (;;) {
    frame_sync(33000);
    in_poll();
    if (in_edge & (BTN_A | BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)) {
      led(0, 0);
      uputs("bench: back\n");
      return;
    }
  }
}
