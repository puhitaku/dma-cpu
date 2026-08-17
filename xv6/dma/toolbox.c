/* toolbox: the dma utilities as ONE multi-call binary, dispatched on
 * argv[0] busybox-style — the disk stores a single blob with hard
 * links named kill, spin, trap, free, sync, mount, umount (fsimg
 * AddLink), so usys/ulib are paid for once instead of per tool
 * (prompts/029; the disk budget is real memory too). Printf-free. */
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
  if (streq(base, "mount"))
    exit(t_mount(argc, argv));
  if (streq(base, "umount"))
    exit(t_umount(argc, argv));
  if (streq(base, "wc"))
    exit(t_wc(argc, argv));
  if (streq(base, "mkdir"))
    exit(t_mkdir(argc, argv));
  write(2, "toolbox: kill spin trap free sync mount umount wc mkdir\n", 56);
  exit(1);
}
