/* input.c: joystick polling and the RNG. Both sticks are merged (a
 * press on either counts); buttons are active-low behind pull-ups, so
 * an unwired stick reads all-released. The RNG is xorshift32 seeded
 * by the free-running us counter at every input edge — human timing
 * is the entropy source this machine has. */
#include "g.h"

uint in_down;
uint in_edge;

static uint rng_state = 0x9E3779B9u;
static uint in_prev;
static int in_primed; /* first poll only baselines (no phantom edges) */

/* Per-stick pin tables in BTN bit order (up, down, left, right,
 * press) — the harness wires roles out of GPIO order (g.h). The
 * poll runs every frame at 60 fps, so the GPIO STATUS addresses are
 * precomputed and read inline: no per-pin call, no address math. */
static const uchar joyA[5] = {3, 4, 2, 5, 6};
static const uchar joyB[5] = {8, 9, 7, 10, 11};
#define GSTAT(pin) (IOBANK0 + 8u * (pin))
static const uint joyAaddr[5] = {GSTAT(3), GSTAT(4), GSTAT(2), GSTAT(5),
                                 GSTAT(6)};
static const uint joyBaddr[5] = {GSTAT(8), GSTAT(9), GSTAT(7), GSTAT(10),
                                 GSTAT(11)};

static uint
stick(const uint *addrs)
{
  uint m = 0, bit = 1;
  for (int i = 0; i < 5; i++, bit <<= 1)
    if (!(W32(addrs[i]) & 0x20000u)) /* low = pressed */
      m |= bit;
  return m;
}

void
in_poll(void)
{
  if (!in_primed) { /* pull-ups on before the first read */
    for (int i = 0; i < 5; i++) {
      gpio_in_init(joyA[i]);
      gpio_in_init(joyB[i]);
    }
  }
  uint now = stick(joyAaddr) | stick(joyBaddr);
  if (!in_primed) {
    in_primed = 1;
    in_prev = now;
    in_down = now;
    in_edge = 0;
    return;
  }
  in_edge = now & ~in_prev;
  in_down = now;
  in_prev = now;
  if (in_edge)
    rng_state ^= now_us();
}

uint
rng(void)
{
  uint x = rng_state;
  x ^= x << 13;
  x ^= x >> 17;
  x ^= x << 5;
  rng_state = x;
  return x;
}

uint
rng_below(uint n)
{
  return rng() % n;
}

/* frame_sync: sleep until the next us-tick boundary; resets its phase
 * after a long stall (a game that blew its budget just runs flat out).
 * Doubles as the sound engine's clock — every paced loop ticks it. */
void
frame_sync(uint us)
{
  static uint next;
  snd_tick();
  led_tick();
  pcm_tick();
  uint now = now_us();
  if (next == 0 || now - next > us * 8)
    next = now;
  next += us;
  while ((int)(next - now_us()) > 0)
    ;
}
