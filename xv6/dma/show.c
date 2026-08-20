/* show: the full-screen slide viewer as its own binary (split from
 * fbtools: exec copies text+data into the arena, and the 480p map
 * leaves ~50 KB — the viewer is the one binary that must run DURING
 * a presentation). Installed only on boards with FbBuf. */
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

/* --- deck (SLDK container): one file, multiple slide series ---
 * sldgen writes it (see cmd/sldgen): "SLDK", u32 version, u32
 * nseries, u32 bytes-per-slide, then 24-byte series entries
 * {name[12], count, offset, reserved}, then fixed-size slides. The
 * 169 series is pre-squeezed for displays that stretch 4:3 to 16:9. */
static int deckfd = -1;
static uint deckoff, decksz;

static uint
le32(const uchar *p)
{
  return p[0] | ((uint)p[1] << 8) | ((uint)p[2] << 16) | ((uint)p[3] << 24);
}

/* deck_open: selects series `want` (0 = the first) and returns its
 * slide count; 0 when fd is not a deck; -1 when the series is
 * missing. On success deckfd/deckoff/decksz are set and fd stays
 * open for seek()-based paging. */
static int
deck_open(int fd, const char *want)
{
  uchar h[16];
  if (seek(fd, 0) < 0 || read(fd, h, 16) != 16)
    return 0;
  if (h[0] != 'S' || h[1] != 'L' || h[2] != 'D' || h[3] != 'K')
    return 0;
  uint nser = le32(h + 8);
  decksz = le32(h + 12);
  if (decksz == 0 || nser == 0 || nser > 16)
    return 0;
  for (uint i = 0; i < nser; i++) {
    uchar e[24];
    if (read(fd, e, 24) != 24)
      return -1;
    char nm[13];
    for (int j = 0; j < 12; j++)
      nm[j] = (char)e[j];
    nm[12] = 0;
    if (want == 0 || streq(nm, want)) {
      deckoff = le32(e + 16);
      deckfd = fd;
      olen = 0;
      emitn(le32(e + 12));
      emit(" slides found (series ");
      emit(nm);
      emit(")\n");
      flush();
      return (int)le32(e + 12);
    }
  }
  return -1;
}

/* One log line to the console; the fbcon tee is muted while the fb
 * is acquired, so these reach the UART without touching the slide. */
static void
show_log(const char *a, const char *b, const char *c)
{
  emit(a);
  if (b)
    emit(b);
  if (c)
    emit(c);
  emit("\n");
  flush();
}

/* Pre-480p slides are 640x240 (each row was scanned twice): when a
 * load fills exactly half the framebuffer, expand it in place from
 * the bottom up, doubling each row — old decks keep working. */
static void
show_expand2x(uint fb, uint fbsz, uint got)
{
  if (got * 2 != fbsz)
    return;
  for (int y = (int)(got / 640) - 1; y >= 0; y--) {
    const uint *src = (const uint *)(fb + (uint)y * 640);
    uint *d0 = (uint *)(fb + (uint)(2 * y) * 640);
    uint *d1 = (uint *)(fb + (uint)(2 * y + 1) * 640);
    for (int i = 159; i >= 0; i--) {
      uint w = src[i];
      d1[i] = w;
      d0[i] = w;
    }
  }
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
  if (fd < 0) {
    show_log("show: cannot open ", path, 0);
    return;
  }
  show_log("Opened ", path, 0);
  show_log("Start drawing ", path, " on FB");
  uint got = 0;
  while (got < fbsz) {
    int r = read(fd, (void *)(fb + got), (int)(fbsz - got));
    if (r <= 0)
      break;
    got += (uint)r;
  }
  close(fd);
  show_expand2x(fb, fbsz, got);
  show_log("Done drawing ", path, 0);
}

/* show_slide: one slide onto the fb — deck index or named file. */
static void
show_slide(int deck, const char *dir, int cur, uint fb, uint fbsz)
{
  if (!deck) {
    show_load(dir, shownames[cur], fb, fbsz);
    return;
  }
  olen = 0;
  emit("Start drawing slide ");
  emitn((uint)cur + 1);
  emit(" on FB\n");
  flush();
  seek(deckfd, deckoff + (uint)cur * decksz);
  uint want = decksz < fbsz ? decksz : fbsz;
  uint got = 0;
  while (got < want) {
    int r = read(deckfd, (void *)(fb + got), (int)(want - got));
    if (r <= 0)
      break;
    got += (uint)r;
  }
  show_expand2x(fb, fbsz, got);
  olen = 0;
  emit("Done drawing slide ");
  emitn((uint)cur + 1);
  emit("\n");
  flush();
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
  int deck = 0;
  deckfd = -1;
  if (argc == 2 || argc == 3) { /* a deck? (argv[2] selects a series) */
    struct stat st;
    int fd = open(argv[1], 0);
    if (fd >= 0 && fstat(fd, &st) == 0 && st.type == T_FILE) {
      int n = deck_open(fd, argc == 3 ? argv[2] : 0);
      if (n > 0) {
        deck = 1;
        nshow = n;
      } else if (n < 0) {
        write(2, "show: no such series in deck\n", 29);
        close(fd);
        return 1;
      } else {
        close(fd); /* a plain file; the paths below reopen it */
      }
    } else if (fd >= 0) {
      close(fd);
    }
  }
  if (!deck && argc == 2) { /* a directory: every *.sld in it, sorted */
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
  } else if (!deck && argc > 2) {
    for (int a = 1; a < argc && nshow < 32; a++) {
      int i = 0;
      for (; argv[a][i] && i < 63; i++)
        shownames[nshow][i] = argv[a][i];
      shownames[nshow][i] = 0;
      nshow++;
    }
  }
  if (nshow == 0) {
    write(2, "show: no slides (usage: show DIR|FILE...|DECK [series])\n", 56);
    return 1;
  }
  if (!deck) { /* deck_open already announced its series */
    emitn((uint)nshow);
    emit(" slides found\n");
    flush();
  }
  if (fbctl(FB_ACQUIRE, 0) < 0) {
    write(2, "show: fb busy\n", 14);
    return 1;
  }
  ttyraw(1);
  uint fbsz = fi.h * fi.pitch;
  int cur = 0, prevmask = 0x1F; /* all released (pulled up) */
  show_slide(deck, dir, cur, fi.base, fbsz);
  int jlen = -1, jbad = 0; /* jump-command entry: -1 = not entering */
  uint jnum = 0;
  int jumpto = -1;
  for (;;) {
    int step = 0, quit = 0;
    char c;
    while (read_nb(0, &c, 1) == 1) {
      /* Page jump: digits then Enter. "5<Enter>" -> slide 5,
       * "1 1 <Enter>" -> slide 11; <=1 clamps to the first slide,
       * past the end clamps to the last; any non-digit typed during
       * entry invalidates the command (Enter then does nothing). A
       * "jump: " prompt with digit echo marks the mode on the UART. */
      if (jlen >= 0 || (c >= '0' && c <= '9')) {
        if (c >= '0' && c <= '9') {
          if (jlen < 0) {
            jlen = 0;
            jbad = 0;
            jnum = 0;
            emit("jump: ");
            flush();
          }
          if (jlen < 6) {
            jlen++;
            jnum = jnum * 10 + (uint)(c - '0');
          }
          obuf[olen++] = c; /* echo the digit */
          flush();
          continue;
        }
        if (c == '\r' || c == '\n') {
          emit("\n");
          if (!jbad && jlen > 0) {
            int tgt = (jnum <= 1) ? 0 : (int)jnum - 1;
            if (tgt >= nshow)
              tgt = nshow - 1;
            jumpto = tgt;
            emit("UART: jump -> ");
            emitn((uint)tgt + 1);
            emit("\n");
          } else {
            emit("jump: invalid\n");
          }
          flush();
          jlen = -1;
          continue;
        }
        /* a non-digit during entry: the command is spoiled */
        jbad = 1;
        continue;
      }
      if (c == '\r' || c == '\n')
        continue; /* Enter outside jump entry: nothing */
      if (c == 'q' || c == 3) {
        show_log("UART: quit", 0, 0);
        quit = 1;
      } else if (c == 'n' || c == ' ' || c == 'l') {
        show_log("UART: right", 0, 0);
        step = 1;
      } else if (c == 'p' || c == 'h') {
        show_log("UART: left", 0, 0);
        step = -1;
      } else if (c == 0x1B) { /* arrows: ESC [ C / D */
        char b1 = 0, b2 = 0;
        read_nb(0, &b1, 1);
        read_nb(0, &b2, 1);
        if (b1 == '[' && b2 == 'C') {
          show_log("UART: right", 0, 0);
          step = 1;
        } else if (b1 == '[' && b2 == 'D') {
          show_log("UART: left", 0, 0);
          step = -1;
        }
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
    if (fell & (1 << 0))
      show_log("Joystick: up", 0, 0);
    if (fell & (1 << 1))
      show_log("Joystick: down", 0, 0);
    if (fell & (1 << 2))
      show_log("Joystick: left", 0, 0);
    if (fell & (1 << 3))
      show_log("Joystick: right", 0, 0);
    if (fell & (1 << 4))
      show_log("Joystick: push", 0, 0);
    if (fell & ((1 << 1) | (1 << 3))) /* down or right */
      step = 1;
    else if (fell & ((1 << 0) | (1 << 2))) /* up or left */
      step = -1;
    if (fell & (1 << 4))
      quit = 1;
    if (quit)
      break;
    if (jumpto >= 0) {
      if (jumpto != cur) {
        cur = jumpto;
        show_slide(deck, dir, cur, fi.base, fbsz);
      }
      jumpto = -1;
    }
    if (step) {
      cur += step;
      if (cur < 0)
        cur = nshow - 1;
      if (cur >= nshow)
        cur = 0;
      show_slide(deck, dir, cur, fi.base, fbsz);
      pause(8); /* debounce the stick */
    }
    pause(2);
  }
  ttyraw(0);
  fbctl(FB_RELEASE, 0);
  if (deckfd >= 0) {
    close(deckfd);
    deckfd = -1;
  }
  return 0;
}

int
main(int argc, char **argv)
{
  exit(t_show(argc, argv));
}
