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

static uint
stick(int base)
{
  uint m = 0;
  for (int i = 0; i < 5; i++)
    if (!gpio_in_pu(base + i)) /* low = pressed */
      m |= 1u << i;
  return m;
}

void
in_poll(void)
{
  uint now = stick(PIN_JOYA_UP) | stick(PIN_JOYB_UP);
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
  uint now = now_us();
  if (next == 0 || now - next > us * 8)
    next = now;
  next += us;
  while ((int)(next - now_us()) > 0)
    ;
}
