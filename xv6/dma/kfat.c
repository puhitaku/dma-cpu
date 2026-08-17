/* Read-only FAT32 (vfat) driver over an XIP-resident volume
 * (prompts/029). The mount mechanism lives in kfsglue.c: paths under
 * the mount point route here instead of namei, and file.c's verbatim
 * fd operations reach these nodes through the vfs_* dispatch shims
 * (shim defs.h renames its calls when compiling file.c). FAT nodes
 * masquerade as struct inode (dev == FATDEV) so struct file carries
 * them unchanged; directory reads synthesize xv6-format dirents so
 * upstream ls works untouched.
 *
 * Reads trust the BPB (bytes/sector must be 512): sectors-per-
 * cluster, reserved sectors, FAT count/size and the root cluster all
 * come from it, so real PC-formatted volumes (and SD cards later)
 * parse the same as fsimg's small test images. Long names (VFAT LFN
 * entries) are assembled for lookup and listing; with DIRSIZ grown
 * to 62 they list in full (the 8.3 form remains an internal lookup
 * alias, and the fallback for names past 62). */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

#define FATDEV 0xFA7u
#define NFATNODE 16
#define ATTR_DIR 0x10
#define ATTR_LFN 0x0F

static uint fbase;    /* XIP address of the volume; 0 = not mounted */
static uint secsz;    /* 512 */
static uint clussz;   /* bytes per cluster */
static uint fatoff;   /* byte offset of the FAT */
static uint dataoff;  /* byte offset of cluster 2 */
static uint rootclus;

struct fatmeta {
  uint clus;  /* first cluster (0 = empty file) */
  uint size;  /* bytes (dirs: 0 on disk, iterated by chain) */
};
static struct inode fatnodes[NFATNODE];
static struct fatmeta fatmeta[NFATNODE];

int
fat_is(struct inode *ip)
{
  return ip && ip->dev == FATDEV;
}

int
fat_active(void)
{
  return fbase != 0;
}

static uint
rd8(uint a)
{
  return *(volatile uchar *)a;
}
static uint
rd16(uint a)
{
  return rd8(a) | (rd8(a + 1) << 8);
}
static uint
rd32(uint a)
{
  return rd16(a) | (rd16(a + 2) << 16);
}

/* Parse + validate the BPB; returns 0 on success. */
int
fat_mount(uint xipbase)
{
  uint b = xipbase;
  if (rd16(b + 510) != 0xAA55)
    return -1;
  secsz = rd16(b + 11);
  uint spc = rd8(b + 13);
  uint rsvd = rd16(b + 14);
  uint nfats = rd8(b + 16);
  uint fatsz = rd32(b + 36);
  rootclus = rd32(b + 44);
  if (secsz != 512 || spc == 0 || nfats == 0 || fatsz == 0 || rootclus < 2)
    return -1;
  clussz = secsz * spc;
  fatoff = rsvd * secsz;
  dataoff = (rsvd + nfats * fatsz) * secsz;
  fbase = xipbase;
  for (int i = 0; i < NFATNODE; i++)
    fatnodes[i].ref = 0;
  return 0;
}

/* Any node still referenced (open fd, cwd)? */
int
fat_busy(void)
{
  for (int i = 0; i < NFATNODE; i++) {
    if (fatnodes[i].ref > 0)
      return 1;
  }
  return 0;
}

void
fat_unmount(void)
{
  fbase = 0;
}

static uint
fat_next(uint cl)
{
  return rd32(fbase + fatoff + cl * 4) & 0x0FFFFFFFu;
}

static uint
clusaddr(uint cl)
{
  return fbase + dataoff + (cl - 2) * clussz;
}

/* A directory's total byte size = chain length * cluster size. */
static uint
chainsize(uint cl)
{
  uint n = 0;
  while (cl >= 2 && cl < 0x0FFFFFF8u) {
    n += clussz;
    cl = fat_next(cl);
  }
  return n;
}

static struct inode *
fat_getnode(uint clus, uint size, int isdir, uint ident)
{
  struct inode *free = 0;
  for (int i = 0; i < NFATNODE; i++) {
    if (fatnodes[i].ref > 0 && fatnodes[i].inum == ident) {
      fatnodes[i].ref++;
      return &fatnodes[i];
    }
    if (fatnodes[i].ref == 0 && !free)
      free = &fatnodes[i];
  }
  if (!free)
    return 0;
  int idx = (int)(free - fatnodes);
  free->dev = FATDEV;
  free->inum = ident;
  free->ref = 1;
  free->type = isdir ? T_DIR : T_FILE;
  free->nlink = 1;
  free->size = isdir ? chainsize(clus) : size;
  fatmeta[idx].clus = clus;
  fatmeta[idx].size = free->size;
  return free;
}

struct inode *
fat_root(void)
{
  return fat_getnode(rootclus, 0, 1, rootclus);
}

void
fat_put(struct inode *ip)
{
  if (ip->ref > 0)
    ip->ref--;
}

void
fat_dup(struct inode *ip)
{
  ip->ref++;
}

/* Read the n-th 32-byte raw entry of a directory chain; returns its
 * XIP address or 0 past the end. */
static uint
dirent_at(uint cl, uint n)
{
  uint per = clussz / 32;
  while (cl >= 2 && cl < 0x0FFFFFF8u) {
    if (n < per)
      return clusaddr(cl) + n * 32;
    n -= per;
    cl = fat_next(cl);
  }
  return 0;
}

/* Iterate a directory: fills name (the long name when present, up to
 * 64 bytes) and shortnm (the 8.3 form, always, lowercased "name.ext"
 * in at most 13 bytes), *clusp, *sizep, *dirp; *idx advances past
 * the consumed entries. Returns 1, or 0 at the end. */
static int
fat_iter(uint dircl, uint *idx, char *name, char *shortnm, uint *clusp,
         uint *sizep, int *dirp)
{
  char lfn[64];
  int havelfn = 0;
  for (;;) {
    uint e = dirent_at(dircl, *idx);
    if (e == 0)
      return 0;
    (*idx)++;
    uint b0 = rd8(e);
    if (b0 == 0)
      return 0; /* end marker */
    if (b0 == 0xE5) {
      havelfn = 0;
      continue; /* deleted */
    }
    uint attr = rd8(e + 11);
    if (attr == ATTR_LFN) {
      uint seq = (b0 & 0x1F);
      if (seq >= 1 && seq * 13 <= 63) {
        static const uint slots[13] = {1, 3, 5, 7, 9, 14, 16, 18, 20, 22, 24, 28, 30};
        for (uint j = 0; j < 13; j++) {
          uint u = rd16(e + slots[j]);
          uint pos = (seq - 1) * 13 + j;
          if (pos < 63)
            lfn[pos] = (u == 0 || u == 0xFFFF) ? 0 : (char)u;
        }
        lfn[63] = 0;
        havelfn = 1;
      }
      continue;
    }
    if (attr & 0x08) { /* volume label */
      havelfn = 0;
      continue;
    }
    /* 8.3: "NAME    EXT" -> "name.ext" (lowercased: the common
     * mkfs style stores uppercase; lookup is case-insensitive). */
    {
      int n = 0;
      for (int i = 0; i < 8 && rd8(e + i) != ' '; i++) {
        char c = (char)rd8(e + i);
        shortnm[n++] = (c >= 'A' && c <= 'Z') ? c + 32 : c;
      }
      if (rd8(e + 8) != ' ') {
        shortnm[n++] = '.';
        for (int i = 8; i < 11 && rd8(e + i) != ' '; i++) {
          char c = (char)rd8(e + i);
          shortnm[n++] = (c >= 'A' && c <= 'Z') ? c + 32 : c;
        }
      }
      shortnm[n] = 0;
    }
    if (havelfn) {
      for (int i = 0; i < 64; i++)
        name[i] = lfn[i];
      name[63] = 0;
    } else {
      int i = 0;
      for (; shortnm[i]; i++)
        name[i] = shortnm[i];
      name[i] = 0; /* the terminator too — nm is reused across entries */
    }
    *clusp = (rd16(e + 20) << 16) | rd16(e + 26);
    *sizep = rd32(e + 28);
    *dirp = (attr & ATTR_DIR) != 0;
    return 1;
  }
}

static int
nameq(const char *a, const char *b)
{
  for (;; a++, b++) {
    char ca = *a, cb = *b;
    if (ca >= 'A' && ca <= 'Z')
      ca += 32;
    if (cb >= 'A' && cb <= 'Z')
      cb += 32;
    if (ca != cb)
      return 0;
    if (ca == 0)
      return 1;
  }
}

/* One-component lookup in a FAT directory node. */
struct inode *
fat_lookup(struct inode *dp, const char *name)
{
  int idx0 = (int)(dp - fatnodes);
  uint dircl = fatmeta[idx0].clus;
  if (nameq(name, ".") || (nameq(name, "..") && fatmeta[idx0].clus == rootclus)) {
    fat_dup(dp);
    return dp;
  }
  uint idx = 0, clus, size;
  int isdir;
  char nm[64], snm[16];
  while (fat_iter(dircl, &idx, nm, snm, &clus, &size, &isdir)) {
    if (nameq(nm, name) || nameq(snm, name)) {
      if (nameq(name, "..") && clus == 0)
        return fat_root(); /* ".." of a first-level subdir */
      uint ident = clus ? clus : (0x80000000u | (dircl << 8) | idx);
      return fat_getnode(clus ? clus : 0, size, isdir, ident);
    }
  }
  return 0;
}

/* Multi-component walk from a FAT directory ("a/b/c"; empty = dup). */
struct inode *
fat_walk(struct inode *from, const char *path)
{
  struct inode *ip = from;
  fat_dup(ip);
  char comp[64];
  while (*path) {
    while (*path == '/')
      path++;
    if (*path == 0)
      break;
    int n = 0;
    while (*path && *path != '/' && n < 63)
      comp[n++] = *path++;
    comp[n] = 0;
    if (ip->type != T_DIR) {
      fat_put(ip);
      return 0;
    }
    struct inode *nxt = fat_lookup(ip, comp);
    fat_put(ip);
    if (nxt == 0)
      return 0;
    ip = nxt;
  }
  return ip;
}

/* File read (chain walk); dir read synthesizes xv6 dirents so
 * upstream ls iterates a FAT directory unchanged. */
int
fat_readi(struct inode *ip, uint dst, uint off, uint n)
{
  int idx0 = (int)(ip - fatnodes);
  if (ip->type == T_DIR) {
    struct dirent de;
    uint made = 0, want = n / sizeof(de);
    uint start = off / sizeof(de);
    uint it = 0, clus, size;
    int isdir;
    char nm[64], snm[16];
    uint count = 0;
    while (made < want &&
           fat_iter(fatmeta[idx0].clus, &it, nm, snm, &clus, &size, &isdir)) {
      if (count++ < start)
        continue;
      uint len = 0;
      while (nm[len])
        len++;
      const char *use = len <= DIRSIZ ? nm : snm; /* stat-able either way */
      de.inum = (ushort)(clus ? clus : 0xFFFF);
      for (int i = 0; i < DIRSIZ; i++)
        de.name[i] = 0;
      for (int i = 0; i < DIRSIZ && use[i]; i++)
        de.name[i] = use[i];
      memmove((void *)(dst + made * sizeof(de)), &de, sizeof(de));
      made++;
    }
    return (int)(made * sizeof(de));
  }
  uint size = fatmeta[idx0].size;
  if (off >= size)
    return 0;
  if (off + n > size)
    n = size - off;
  uint cl = fatmeta[idx0].clus;
  uint skip = off / clussz;
  while (skip-- && cl >= 2 && cl < 0x0FFFFFF8u)
    cl = fat_next(cl);
  uint done = 0, pos = off % clussz;
  while (done < n && cl >= 2 && cl < 0x0FFFFFF8u) {
    uint take = clussz - pos;
    if (take > n - done)
      take = n - done;
    memmove((void *)(dst + done), (const void *)(clusaddr(cl) + pos), take);
    done += take;
    pos = 0;
    cl = fat_next(cl);
  }
  return (int)done;
}

void
fat_stati(struct inode *ip, struct stat *st)
{
  st->dev = (int)FATDEV;
  st->ino = ip->inum;
  st->type = (short)ip->type;
  st->nlink = 1;
  st->size = ip->size;
}