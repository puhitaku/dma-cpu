/* toolbox: the dma utilities as ONE multi-call binary, dispatched on
 * argv[0] busybox-style — the disk stores a single blob with hard
 * links named kill, spin, trap, free, sync, mount, umount (fsimg
 * AddLink), so usys/ulib are paid for once instead of per tool
 * (prompts/029; the disk budget is real memory too). Printf-free. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
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

static char obuf[256];
static int olen;

static void
emit(const char *s)
{
  while (*s)
    obuf[olen++] = *s++;
}

static void
emitn(uint v)
{
  char d[12];
  int i = 0;
  do {
    d[i++] = '0' + v % 10;
    v /= 10;
  } while (v);
  while (i)
    obuf[olen++] = d[--i];
}

static void
flush(void)
{
  write(1, obuf, olen);
  olen = 0;
}

/* --- kill: the user/kill.c behavior without its printf tax --- */
static int
t_kill(int argc, char **argv)
{
  if (argc < 2) {
    write(2, "usage: kill pid...\n", 19);
    return 1;
  }
  for (int i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  return 0;
}

/* --- spin: visible background victim for the kill demo --- */
static int
t_spin(void)
{
  emit("spin: pid ");
  emitn((uint)getpid());
  emit("\n");
  flush();
  for (;;) {
    pause(20);
    write(1, ".", 1);
  }
}

/* --- trap: SIGINT handler demo (bows out politely on Ctrl-C) --- */
static void
onint(int sig)
{
  (void)sig;
  write(1, "\ncaught SIGINT; exiting politely\n", 33);
  exit(0);
}

static int
t_trap(void)
{
  signal(SIGINT, onint);
  write(1, "trap: Ctrl-C me\n", 16);
  for (;;) {
    pause(20);
    write(1, ".", 1);
  }
}

/* --- free: real memory consumption (SYS_meminfo) --- */
static int
t_free(void)
{
  uint mi[8];
  if (meminfo(mi) < 0) {
    write(2, "free: meminfo failed\n", 21);
    return 1;
  }
  emit("arena: total ");
  emitn(mi[0]);
  emit("  used ");
  emitn(mi[0] - mi[1]);
  emit("  free ");
  emitn(mi[1]);
  emit("  largest ");
  emitn(mi[2]);
  emit("\nof it: heap ");
  emitn(mi[3]);
  emit("  exec ");
  emitn(mi[4]);
  emit("\nprocs: ");
  emitn(mi[5]);
  emit("/");
  emitn(mi[6]);
  emit("  uptime ");
  emitn(mi[7]);
  emit(" ticks\n");
  flush();
  return 0;
}

/* --- sync: burn the RAM disk into the flash slot --- */
static int
t_sync(void)
{
  if (sync() < 0) {
    write(2, "sync: not supported\n", 20);
    return 1;
  }
  return 0;
}

/* --- wc: upstream user/wc.c's counting and output shape, printf-free
 * (the standalone upstream binary is a 24 KB printf tax) --- */
static void
wc_one(int fd, const char *name)
{
  static char buf[512];
  int l = 0, w = 0, c = 0, inword = 0, n;
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    for (int i = 0; i < n; i++) {
      c++;
      if (buf[i] == '\n')
        l++;
      if (buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == '\r')
        inword = 0;
      else if (!inword) {
        w++;
        inword = 1;
      }
    }
  }
  emitn((uint)l);
  emit(" ");
  emitn((uint)w);
  emit(" ");
  emitn((uint)c);
  emit(" ");
  emit(name);
  emit("\n");
  flush();
}

static int
t_wc(int argc, char **argv)
{
  if (argc <= 1) {
    wc_one(0, "");
    return 0;
  }
  for (int i = 1; i < argc; i++) {
    int fd = open(argv[i], 0);
    if (fd < 0) {
      write(2, "wc: cannot open\n", 16);
      return 1;
    }
    wc_one(fd, argv[i]);
    close(fd);
  }
  return 0;
}

/* --- mkdir: upstream user/mkdir.c, printf-free --- */
static int
t_mkdir(int argc, char **argv)
{
  if (argc < 2) {
    write(2, "usage: mkdir dir...\n", 20);
    return 1;
  }
  for (int i = 1; i < argc; i++) {
    if (mkdir(argv[i]) < 0) {
      write(2, "mkdir: failed\n", 14);
      return 1;
    }
  }
  return 0;
}

/* --- rm: upstream user/rm.c, printf-free --- */
static int
t_rm(int argc, char **argv)
{
  if (argc < 2) {
    write(2, "usage: rm file...\n", 18);
    return 1;
  }
  for (int i = 1; i < argc; i++) {
    if (unlink(argv[i]) < 0) {
      write(2, "rm: failed\n", 11);
      return 1;
    }
  }
  return 0;
}

/* --- help: what can be run --- The commands live in the flash
 * image registry, not on any disk (ls cannot see them), so this
 * lists /dev/apps in columns. */
static int
t_help(void)
{
  write(1, "builtin: cd\ncommands (flash registry, /dev/apps):\n", 50);
  int fd = open("/dev/apps", 0);
  if (fd < 0) {
    write(2, "help: no /dev/apps\n", 19);
    return 1;
  }
  char buf[400];
  int n = read(fd, buf, sizeof(buf));
  close(fd);
  char line[80];
  int col = 0, ln = 0;
  for (int i = 0; i <= n; i++) {
    char c = (i < n) ? buf[i] : '\n';
    if (c != '\n') {
      if (ln < 78)
        line[ln++] = c;
      continue;
    }
    if (ln == 0 && col == 0)
      continue;
    col++;
    if (col == 6) { /* six 13-char columns per row */
      line[ln++] = '\n';
      write(1, line, ln);
      col = ln = 0;
    } else {
      while (ln % 13)
        line[ln++] = ' ';
    }
  }
  if (ln) {
    line[ln++] = '\n';
    write(1, line, ln);
  }
  return 0;
}

/* --- mount/umount: the vfat volume --- */
static int
t_mount(int argc, char **argv)
{
  if (argc == 1) {
    char buf[64];
    int n = mount(0, (const char *)buf);
    if (n > 0)
      write(1, buf, n);
    return 0;
  }
  if (argc == 3 && streq(argv[1], "-u")) {
    if (umount(argv[2]) < 0) {
      write(2, "umount: failed (busy or not mounted)\n", 37);
      return 1;
    }
    return 0;
  }
  if (argc == 3) {
    if (mount(argv[1], argv[2]) < 0) {
      write(2, "mount: failed\n", 14);
      return 1;
    }
    return 0;
  }
  write(2, "usage: mount [fat0|sd0 DIR | -u DIR]\n", 37);
  return 1;
}

static int
t_umount(int argc, char **argv)
{
  if (argc != 2) {
    write(2, "usage: umount /dir\n", 19);
    return 1;
  }
  if (umount(argv[1]) < 0) {
    write(2, "umount: failed (busy or not mounted)\n", 37);
    return 1;
  }
  return 0;
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
  /* Dispatch on the basename of argv[0]. */
  const char *base = me;
  for (const char *p = me; *p; p++) {
    if (*p == '/')
      base = p + 1;
  }
  if (streq(base, "kill"))
    exit(t_kill(argc, argv));
  if (streq(base, "spin"))
    exit(t_spin());
  if (streq(base, "trap"))
    exit(t_trap());
  if (streq(base, "free"))
    exit(t_free());
  if (streq(base, "sync"))
    exit(t_sync());
  if (streq(base, "help"))
    exit(t_help());
  if (streq(base, "mount"))
    exit(t_mount(argc, argv));
  if (streq(base, "umount"))
    exit(t_umount(argc, argv));
  if (streq(base, "wc"))
    exit(t_wc(argc, argv));
  if (streq(base, "mkdir"))
    exit(t_mkdir(argc, argv));
  if (streq(base, "rm"))
    exit(t_rm(argc, argv));
  if (streq(base, "gpio"))
    exit(t_gpio(argc, argv));
  if (streq(base, "mux"))
    exit(t_mux(argc, argv));
  if (streq(base, "blink"))
    exit(t_blink(argc, argv));
  write(2, "toolbox: kill spin trap free sync mount umount wc mkdir rm "
           "gpio mux blink fbtest show\n", 87);
  exit(1);
}
