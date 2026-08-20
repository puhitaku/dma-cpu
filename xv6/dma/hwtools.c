/* hwtools: the hardware-facing commands (gpio, mux, blink) as their
 * own multi-call binary — the split criterion is xv6-vs-silicon: the
 * toolbox keeps the tools any xv6 has a use for; everything that
 * only means something on an RP2 pad lives here. Keeps each exec'd
 * image small (exec copies text+data into the arena). Printf-free. */
#include "kernel/types.h"
#include "user/user.h"

static int
streq(const char *a, const char *b)
{
  while (*a && *a == *b) {
    a++;
    b++;
  }
  return *a == *b;
}

/* --- gpio / mux / blink: the GPIO, pin-mux and PIO front ends
 * (prompts/034). Kernel-API manipulation, gpiod-style. --- */

static int
t_atoi(const char *s)
{
  int v = 0;
  while (*s >= '0' && *s <= '9')
    v = v * 10 + (*s++ - '0');
  return v;
}

static int
t_gpio(int argc, char **argv)
{
  if (argc >= 3 && streq(argv[1], "read")) {
    int v = gpioctl(GPIO_READ, t_atoi(argv[2]), 0);
    if (v < 0) {
      write(2, "gpio: bad pin\n", 14);
      return 1;
    }
    fputstr(1, v ? "1\n" : "0\n");
    return 0;
  }
  if (argc >= 4 && streq(argv[1], "write")) {
    if (gpioctl(GPIO_WRITE, t_atoi(argv[2]), t_atoi(argv[3])) < 0) {
      write(2, "gpio: bad pin\n", 14);
      return 1;
    }
    return 0;
  }
  write(2, "usage: gpio write PIN 0|1 | gpio read PIN\n", 42);
  return 1;
}

static int
t_mux(int argc, char **argv)
{
  /* FUNCSEL codes shared by both RP2 SKUs for 1..7; pio2 is the
   * third PIO block's code on parts that have one. */
  static const struct {
    const char *name;
    int func;
  } roles[] = {{"spi", 1},  {"uart", 2}, {"i2c", 3},  {"pwm", 4},
               {"sio", 5},  {"pio0", 6}, {"pio1", 7}, {"pio2", 8},
               {"none", 31}};
  if (argc >= 3) {
    int func = -1;
    if (argv[2][0] >= '0' && argv[2][0] <= '9')
      func = t_atoi(argv[2]);
    else
      for (int i = 0; i < (int)(sizeof(roles) / sizeof(roles[0])); i++)
        if (streq(argv[2], roles[i].name))
          func = roles[i].func;
    if (func >= 0) {
      if (pinmux(t_atoi(argv[1]), func) < 0) {
        write(2, "mux: bad pin or role\n", 21);
        return 1;
      }
      return 0;
    }
  }
  write(2, "usage: mux PIN spi|uart|i2c|pwm|sio|pio0|pio1|pio2|none|N\n", 58);
  return 1;
}

/* The PIO blink program, hand-assembled (origin 0):
 *   0 E081  set pindirs, 1
 *   1 E03F  set x, 31
 *   2 FF01  set pins, 1 [31]
 *   3 0042  jmp x--, 2
 *   4 E03F  set x, 31
 *   5 FF00  set pins, 0 [31]
 *   6 0045  jmp x--, 5
 *   7 0001  jmp 1
 * At clkdiv 65535 each phase is 32 iterations of 33 divided cycles:
 * ~0.45 s per half period at 150 MHz. */
static const uint blinkprog[8] = {0xE081, 0xE03F, 0xFF01, 0x0042,
                                  0xE03F, 0xFF00, 0x0045, 0x0001};

static int blink_pin = -1;

static void
blink_int(int sig)
{
  (void)sig;
  if (blink_pin >= 0)
    gpioctl(GPIO_WRITE, blink_pin, 0);
  exit(0);
}

static int
t_blink(int argc, char **argv)
{
  if (argc >= 3 && streq(argv[1], "gpio")) {
    int pin = t_atoi(argv[2]);
    blink_pin = pin;
    signal(SIGINT, blink_int); /* Ctrl-C: LED off, then die */
    fputstr(1, "blinking (soft loop); Ctrl-C stops\n");
    for (;;) {
      gpioctl(GPIO_WRITE, pin, 1);
      pause(300);
      gpioctl(GPIO_WRITE, pin, 0);
      pause(300);
    }
  }
  if (argc >= 3 && streq(argv[1], "pio")) {
    int pin = t_atoi(argv[2]);
    struct pio_prog pp;
    struct pio_smcfg c;
    pp.pio = 0;
    pp.origin = 0;
    pp.count = 8;
    for (int i = 0; i < 8; i++)
      pp.instr[i] = blinkprog[i];
    c.pio = 0;
    c.sm = 0;
    c.origin = 0;
    c.clkdiv = 0xFFFF0000u;    /* divide by 65535 */
    c.execctrl = 31u << 12;    /* wrap_top = 31 (unused; explicit jmps) */
    c.shiftctrl = 0;
    c.pinctrl = (1u << 26) | ((uint)pin << 5); /* SET count 1, base pin */
    if (pinmux(pin, 6 /* pio0 */) < 0 || pioctl(PIO_LOAD, (uint)&pp, 0) < 0 ||
        pioctl(PIO_INIT, (uint)&c, 0) < 0 || pioctl(PIO_GATE, 0, 1) < 0) {
      write(2, "blink: pio setup failed\n", 24);
      return 1;
    }
    fputstr(1, "blinking on pio0 sm0 (async); `blink stop PIN` stops\n");
    return 0;
  }
  if (argc >= 3 && streq(argv[1], "stop")) {
    int pin = t_atoi(argv[2]);
    pioctl(PIO_GATE, 0, 0);          /* sm0 off */
    gpioctl(GPIO_WRITE, pin, 0);     /* retake the pad, LED off */
    return 0;
  }
  write(2, "usage: blink gpio PIN | blink pio PIN | blink stop PIN\n", 55);
  return 1;
}

int
main(int argc, char **argv)
{
  const char *me = (argc > 0 && argv[0]) ? argv[0] : "";
  const char *base = me;
  for (const char *p = me; *p; p++) {
    if (*p == '/')
      base = p + 1;
  }
  if (streq(base, "gpio"))
    exit(t_gpio(argc, argv));
  if (streq(base, "mux"))
    exit(t_mux(argc, argv));
  if (streq(base, "blink"))
    exit(t_blink(argc, argv));
  write(2, "usage: gpio|mux|blink ...\n", 26);
  exit(1);
}
