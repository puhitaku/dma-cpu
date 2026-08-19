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
  write(2, "usage: mount [fat0 /dir | -u /dir]\n", 35);
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

/* fbtest: exercise the framebuffer API end to end — acquire, draw a
 * test card straight into PSRAM (16-color bars, R/G/B ramps, a gray
 * ramp, white border), verify a sample, hold it ~5 s, release. */
static int
t_fbtest(void)
{
  struct fbinfo fi;
  if (fbctl(FB_INFO, &fi) < 0) {
    write(2, "fbtest: no fb\n", 14);
    return 1;
  }
  if (fbctl(FB_ACQUIRE, 0) < 0) {
    write(2, "fbtest: busy\n", 13);
    return 1;
  }
  /* RGB332 bands: 16 color bars, then red/green/blue ramps, then a
   * gray ramp; single-pixel white border as a geometry check. Each
   * band's row is built once (segment counters, no divisions — a
   * divide is a runtime loop on this machine) and blasted per row. */
  static const uchar bars[16] = {0x00, 0x80, 0x10, 0x90, 0x02, 0x82,
                                 0x12, 0xDB, 0x92, 0xE0, 0x1C, 0xFC,
                                 0x03, 0xE3, 0x1F, 0xFF};
  volatile uint *fb = (volatile uint *)fi.base;
  uint wpr = fi.pitch / 4; /* words per row */
  static uchar tmpl[640];
  uint bandy[5];
  for (uint i = 0; i < 5; i++)
    bandy[i] = (i + 1) * (fi.h / 5);
  bandy[4] = fi.h;
  int ok = 1;
  for (uint band = 0; band < 5; band++) {
    /* Build the band's template row. */
    uint x = 0, seg = 0, step, left;
    step = band == 0 ? (fi.w / 16) : (band == 3 ? fi.w / 4 : fi.w / 8);
    left = step;
    while (x < fi.w) {
      uchar c;
      if (band == 0)
        c = bars[seg];
      else if (band == 1)
        c = (uchar)(seg << 5); /* red ramp */
      else if (band == 2)
        c = (uchar)(seg << 2); /* green ramp */
      else if (band == 3)
        c = (uchar)seg; /* blue ramp */
      else
        c = (uchar)((seg << 5) | (seg << 2) | (seg >> 1)); /* gray */
      tmpl[x++] = c;
      if (--left == 0) {
        left = step;
        seg++;
      }
    }
    tmpl[0] = 0xFF;
    tmpl[fi.w - 1] = 0xFF; /* border columns */
    uint y0 = band ? bandy[band - 1] : 0;
    for (uint y = y0; y < bandy[band]; y++) {
      volatile uint *row = fb + y * wpr;
      const uint *tw = (const uint *)tmpl;
      for (uint i = 0; i < wpr; i++)
        row[i] = tw[i];
    }
  }
  /* Border rows, and verify a sample. */
  for (uint i = 0; i < wpr; i++) {
    fb[i] = 0xFFFFFFFFu;
    fb[(fi.h - 1) * wpr + i] = 0xFFFFFFFFu;
  }
  ok = fb[0] == 0xFFFFFFFFu && (fb[wpr] & 0xFF) == 0xFF &&
       (uchar)(fb[wpr * 100] >> 8) == bars[0];
  fputstr(1, "fbtest: test card up (5 s)\n");
  pause(1000); /* ~5 s of ticks: admire / scope the card */
  fbctl(FB_RELEASE, 0);
  if (!ok) {
    write(2, "fbtest: verify FAIL\n", 20);
    return 1;
  }
  fputstr(1, "fb ok ");
  fputnum(1, (int)fi.w);
  fputstr(1, "x");
  fputnum(1, (int)fi.h);
  fputstr(1, "x");
  fputnum(1, (int)fi.bpp);
  fputstr(1, "\n");
  return 0;
}

/* show: the full-screen slide viewer (prompts/037). Slides are raw
 * framebuffer images (fi.w * fi.h RGB332 bytes, .sld). Navigation:
 * UART keys n/space/l or Right-arrow = next, p/h or Left-arrow =
 * prev, q = quit; and a self-pulled-up digital joystick on GPIO
 * 26(up) 27(down) 28(left) 29(right) 24(press), active low —
 * right/down = next, left/up = prev, press = quit. */
#define JOY_UP 26
#define JOY_DOWN 27
#define JOY_LEFT 28
#define JOY_RIGHT 29
#define JOY_PRESS 24

static char shownames[32][64];
static int nshow;

static int
sldsuffix(const char *n)
{
  int l = 0;
  while (n[l])
    l++;
  if (l < 4)
    return 0;
  const char *e = n + l - 4;
  return e[0] == '.' && (e[1] == 's' || e[1] == 'S') &&
         (e[2] == 'l' || e[2] == 'L') && (e[3] == 'd' || e[3] == 'D');
}

static void
show_load(const char *dir, const char *name, uint fb, uint fbsz)
{
  char path[96];
  int n = 0;
  if (dir) {
    for (int i = 0; dir[i]; i++)
      path[n++] = dir[i];
    if (n && path[n - 1] != '/')
      path[n++] = '/';
  }
  for (int i = 0; name[i] && n < 94; i++)
    path[n++] = name[i];
  path[n] = 0;
  int fd = open(path, 0);
  if (fd < 0)
    return;
  uint got = 0;
  while (got < fbsz) {
    int r = read(fd, (void *)(fb + got), (int)(fbsz - got));
    if (r <= 0)
      break;
    got += (uint)r;
  }
  close(fd);
}

static int
t_show(int argc, char **argv)
{
  struct fbinfo fi;
  if (fbctl(FB_INFO, &fi) < 0) {
    write(2, "show: no fb\n", 12);
    return 1;
  }
  const char *dir = 0;
  nshow = 0;
  if (argc == 2) { /* a directory: every *.sld in it, sorted */
    struct stat st;
    int fd = open(argv[1], 0);
    if (fd < 0 || fstat(fd, &st) < 0) {
      write(2, "show: cannot open\n", 18);
      return 1;
    }
    if (st.type == T_DIR) {
      dir = argv[1];
      struct dirent de;
      while (read(fd, &de, sizeof(de)) == sizeof(de)) {
        if (de.inum == 0 || !sldsuffix(de.name))
          continue;
        if (de.name[0] == '.') /* dotfiles: macOS ._* AppleDouble
                                * droppings match *.sld and sort FIRST */
          continue;
        if (nshow < 32) {
          for (int i = 0; i < 62; i++)
            shownames[nshow][i] = de.name[i];
          shownames[nshow][62] = 0;
          nshow++;
        }
      }
      close(fd);
      /* insertion sort by name: the converter numbers slides */
      for (int i = 1; i < nshow; i++) {
        char tmp[64];
        for (int k = 0; k < 64; k++)
          tmp[k] = shownames[i][k];
        int j = i - 1;
        while (j >= 0 && strcmp(shownames[j], tmp) > 0) {
          for (int k = 0; k < 64; k++)
            shownames[j + 1][k] = shownames[j][k];
          j--;
        }
        for (int k = 0; k < 64; k++)
          shownames[j + 1][k] = tmp[k];
      }
    } else {
      close(fd);
      for (int i = 0; argv[1][i] && i < 63; i++)
        shownames[0][i] = argv[1][i];
      nshow = 1;
    }
  } else if (argc > 2) {
    for (int a = 1; a < argc && nshow < 32; a++) {
      int i = 0;
      for (; argv[a][i] && i < 63; i++)
        shownames[nshow][i] = argv[a][i];
      shownames[nshow][i] = 0;
      nshow++;
    }
  }
  if (nshow == 0) {
    write(2, "show: no slides (usage: show DIR | show FILE...)\n", 49);
    return 1;
  }
  if (fbctl(FB_ACQUIRE, 0) < 0) {
    write(2, "show: fb busy\n", 14);
    return 1;
  }
  ttyraw(1);
  uint fbsz = fi.h * fi.pitch;
  int cur = 0, prevmask = 0x1F; /* all released (pulled up) */
  show_load(dir, shownames[cur], fi.base, fbsz);
  for (;;) {
    int step = 0, quit = 0;
    char c;
    while (read_nb(0, &c, 1) == 1) {
      if (c == 'q' || c == 3)
        quit = 1;
      else if (c == 'n' || c == ' ' || c == 'l')
        step = 1;
      else if (c == 'p' || c == 'h')
        step = -1;
      else if (c == 0x1B) { /* arrows: ESC [ C / D */
        char b1 = 0, b2 = 0;
        read_nb(0, &b1, 1);
        read_nb(0, &b2, 1);
        if (b1 == '[' && b2 == 'C')
          step = 1;
        else if (b1 == '[' && b2 == 'D')
          step = -1;
      }
    }
    int mask = 0; /* op 2: read with pull-up — unwired pins idle 1 */
    mask |= gpioctl(2, JOY_UP, 0) << 0;
    mask |= gpioctl(2, JOY_DOWN, 0) << 1;
    mask |= gpioctl(2, JOY_LEFT, 0) << 2;
    mask |= gpioctl(2, JOY_RIGHT, 0) << 3;
    mask |= gpioctl(2, JOY_PRESS, 0) << 4;
    int fell = prevmask & ~mask; /* 1 -> 0 transitions (active low) */
    prevmask = mask;
    if (fell & ((1 << 1) | (1 << 3))) /* down or right */
      step = 1;
    else if (fell & ((1 << 0) | (1 << 2))) /* up or left */
      step = -1;
    if (fell & (1 << 4))
      quit = 1;
    if (quit)
      break;
    if (step) {
      cur += step;
      if (cur < 0)
        cur = nshow - 1;
      if (cur >= nshow)
        cur = 0;
      show_load(dir, shownames[cur], fi.base, fbsz);
      pause(8); /* debounce the stick */
    }
    pause(2);
  }
  ttyraw(0);
  fbctl(FB_RELEASE, 0);
  return 0;
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
  if (streq(base, "fbtest"))
    exit(t_fbtest());
  if (streq(base, "show"))
    exit(t_show(argc, argv));
  write(2, "toolbox: kill spin trap free sync mount umount wc mkdir rm "
           "gpio mux blink fbtest show\n", 87);
  exit(1);
}
