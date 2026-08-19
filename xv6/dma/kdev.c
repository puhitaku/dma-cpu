/* devfs (prompts/034): a synthetic read-only filesystem at /dev that
 * lists the machine's resources as files, kfat-style — fabricated
 * struct inodes with dev == DEVDEV, dispatched by the vfs_* shims in
 * kfsglue.c. Manipulation stays a kernel API (SYS_gpio & friends);
 * these files are for looking:
 *
 *   console   the console device (open/read/write as usual)
 *   fat0      the raw vfat volume bytes, straight off XIP
 *   sd0       the raw SD card (boards with the ARM SD executor);
 *             size 0 until the card is up — the first read inits it
 *   gpio      one "NN=x" line per pad (input buffer level)
 *   pio0..2   the PIO block's enabled-SM mask
 *   apps      the exec registry: one runnable command name per line
 */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

#define DEVDEV 0xDE7u
#define NDEVNODE 8

extern uint fatvol;   /* kfsglue.c */
extern uint gpiopins; /* kgpio.c */
uint kgpio_peek(uint pin);
uint kpio_ctrl(uint pio);
int kfb_active(void); /* kfb.c */
int kfb_w(void);
int kfb_h(void);
uint kfb_owner(void);
uint fat_sd_bytes(void); /* kfat.c */
int fat_sd_rawread(uint dst, uint off, uint n);
const char *kimg_name(int i); /* kproc.c */

enum { DK_DIR, DK_CONSOLE, DK_FAT, DK_GPIO, DK_PIO, DK_FB, DK_SD, DK_APPS };

static const struct {
  const char *name;
  int kind;
  int arg;
} devtab[] = {
    {"console", DK_CONSOLE, 0}, {"fat0", DK_FAT, 0}, {"sd0", DK_SD, 0},
    {"gpio", DK_GPIO, 0},       {"pio0", DK_PIO, 0}, {"pio1", DK_PIO, 1},
    {"pio2", DK_PIO, 2},        {"fb0", DK_FB, 0},   {"apps", DK_APPS, 0},
};
#define NDEV ((int)(sizeof(devtab) / sizeof(devtab[0])))

static struct inode devnodes[NDEVNODE];

int
dev_is(struct inode *ip)
{
  return ip && ip->dev == DEVDEV;
}

/* fat0's size: total sectors from the BPB (0 when no volume). */
static uint
fat0_size(void)
{
  if (fatvol == 0)
    return 0;
  const uchar *b = (const uchar *)fatvol;
  uint ts = (uint)b[19] | ((uint)b[20] << 8);
  if (ts == 0)
    ts = (uint)b[32] | ((uint)b[33] << 8) | ((uint)b[34] << 16) |
         ((uint)b[35] << 24);
  return ts * 512u;
}

/* Generated file bodies land in here; tiny and rebuilt per read. */
static int
dev_text(int idx, char *buf, int cap)
{
  int kind = devtab[idx].kind, n = 0;
  if (kind == DK_APPS) {
    for (int i = 0;; i++) {
      const char *nm = kimg_name(i);
      if (!nm)
        break;
      for (int j = 0; nm[j] && j < 12 && n < cap; j++)
        buf[n++] = nm[j];
      if (n < cap)
        buf[n++] = '\n';
    }
  } else if (kind == DK_GPIO) {
    for (uint pin = 0; pin < gpiopins && n + 6 < cap; pin++) {
      buf[n++] = (char)('0' + pin / 10);
      buf[n++] = (char)('0' + pin % 10);
      buf[n++] = '=';
      buf[n++] = (char)('0' + (kgpio_peek(pin) & 1));
      buf[n++] = '\n';
    }
  } else if (kind == DK_PIO) {
    const char *p = "sm_enable=0x";
    while (*p && n < cap)
      buf[n++] = *p++;
    uint v = kpio_ctrl((uint)devtab[idx].arg);
    buf[n++] = (char)(v < 10 ? '0' + v : 'a' + v - 10);
    buf[n++] = '\n';
  } else if (kind == DK_FB) {
    if (!kfb_active()) {
      const char *p = "off\n";
      while (*p && n < cap)
        buf[n++] = *p++;
    } else {
      /* "640x480x8 owner=NN\n" */
      int w = kfb_w(), h = kfb_h();
      uint own = kfb_owner();
      char tmp[12];
      int t = 0;
      int vals[3] = {w, h, 8};
      for (int i = 0; i < 3; i++) {
        int v = vals[i];
        t = 0;
        do {
          tmp[t++] = (char)('0' + v % 10);
          v /= 10;
        } while (v);
        while (t > 0 && n < cap)
          buf[n++] = tmp[--t];
        if (i < 2 && n < cap)
          buf[n++] = 'x';
      }
      const char *p = " owner=";
      while (*p && n < cap)
        buf[n++] = *p++;
      t = 0;
      do {
        tmp[t++] = (char)('0' + own % 10);
        own /= 10;
      } while (own);
      while (t > 0 && n < cap)
        buf[n++] = tmp[--t];
      buf[n++] = '\n';
    }
  }
  return n;
}

static uint
dev_size(int idx)
{
  char tmp[400]; /* fits 24 registry names and the gpio table */
  switch (devtab[idx].kind) {
  case DK_FAT:
    return fat0_size();
  case DK_SD: /* no lazy init here: ls /dev must not probe the bus */
    return fat_sd_bytes();
  case DK_GPIO:
  case DK_PIO:
  case DK_FB:
  case DK_APPS:
    return (uint)dev_text(idx, tmp, sizeof(tmp));
  }
  return 0;
}

static struct inode *
dev_getnode(uint ident) /* ident: 0 = the /dev dir, 1+i = devtab[i] */
{
  struct inode *free = 0;
  for (int i = 0; i < NDEVNODE; i++) {
    if (devnodes[i].ref > 0 && devnodes[i].inum == ident) {
      devnodes[i].ref++;
      return &devnodes[i];
    }
    if (devnodes[i].ref == 0 && !free)
      free = &devnodes[i];
  }
  if (!free)
    return 0;
  free->dev = DEVDEV;
  free->inum = ident;
  free->ref = 1;
  free->nlink = 1;
  free->major = 0;
  if (ident == 0) {
    free->type = T_DIR;
    free->size = (uint)((NDEV + 2) * sizeof(struct dirent));
  } else {
    int idx = (int)ident - 1;
    if (devtab[idx].kind == DK_CONSOLE) {
      free->type = T_DEVICE;
      free->major = CONSOLE;
      free->size = 0;
    } else {
      free->type = T_FILE;
      free->size = dev_size(idx);
    }
  }
  return free;
}

struct inode *
dev_root(void)
{
  return dev_getnode(0);
}

void
dev_put(struct inode *ip)
{
  if (ip->ref > 0)
    ip->ref--;
}

void
dev_dup(struct inode *ip)
{
  ip->ref++;
}

struct inode *
dev_lookup(struct inode *dir, const char *name)
{
  if (dir->inum != 0)
    return 0;
  if ((name[0] == '.' && name[1] == 0))
    return dev_getnode(0);
  for (int i = 0; i < NDEV; i++) {
    const char *a = devtab[i].name, *b = name;
    while (*a && *a == *b) {
      a++;
      b++;
    }
    if (*a == 0 && *b == 0)
      return dev_getnode((uint)i + 1);
  }
  return 0;
}

int
dev_readi(struct inode *ip, uint dst, uint off, uint n)
{
  if (ip->inum == 0) { /* the directory: synthesize dirents */
    struct dirent de;
    uint made = 0, want = n / sizeof(de);
    uint start = off / sizeof(de);
    for (uint e = start; e < (uint)NDEV && made < want; e++) {
      de.inum = (ushort)(e + 1);
      for (int i = 0; i < DIRSIZ; i++)
        de.name[i] = 0;
      for (int i = 0; i < DIRSIZ && devtab[e].name[i]; i++)
        de.name[i] = devtab[e].name[i];
      memmove((void *)(dst + made * sizeof(de)), &de, sizeof(de));
      made++;
    }
    return (int)(made * sizeof(de));
  }
  int idx = (int)ip->inum - 1;
  if (devtab[idx].kind == DK_SD)
    return fat_sd_rawread(dst, off, n);
  if (devtab[idx].kind == DK_FAT) {
    uint size = fat0_size();
    if (off >= size)
      return 0;
    if (off + n > size)
      n = size - off;
    memmove((void *)dst, (const void *)(fatvol + off), n);
    return (int)n;
  }
  char tmp[400]; /* fits 24 registry names and the gpio table */
  int len = dev_text(idx, tmp, sizeof(tmp));
  if (off >= (uint)len)
    return 0;
  if (off + n > (uint)len)
    n = (uint)len - off;
  memmove((void *)dst, tmp + off, n);
  return (int)n;
}

void
dev_stati(struct inode *ip, struct stat *st)
{
  st->dev = (int)DEVDEV;
  st->ino = ip->inum;
  st->type = (short)ip->type;
  st->nlink = 1;
  st->size = ip->inum == 0 ? ip->size : dev_size((int)ip->inum - 1);
}
