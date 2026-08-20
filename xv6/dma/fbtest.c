/* fbtest: the framebuffer test card as its own binary (split from
 * fbtools: exec copies text+data into the arena, and the 480p map
 * leaves ~50 KB — show and fbtest each fit alone where the combined
 * blob did not). Installed only on boards with FbBuf. */
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
int
main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  exit(t_fbtest());
}
