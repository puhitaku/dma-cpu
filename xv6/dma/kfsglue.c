/* DMA-machine glue for the verbatim-compiled fs layer (xv6/PORT.md):
 * no-op locks (single hart, run-to-completion kernel), flat-memory
 * copy shims, the fs-facing proc view (fsproc), the console device,
 * and the fd-level operations kproc.c's syscall handlers call —
 * everything sysfile.c did, reshaped for the mailbox ABI. */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "file.h"
#include "fcntl.h"

/* kproc.c scheduler fence. */
extern uint curr;
void vfs_iput(struct inode *ip); /* defined with the vfat block below */
extern void kconswrite(const char *s, int n);
extern int kconsread(uint dst, int n); /* -2 when no cooked line yet */

/* --- locks: intact API, no-op bodies --- */
void
initlock(struct spinlock *lk, char *name)
{
  (void)lk;
  (void)name;
}
void
acquire(struct spinlock *lk)
{
  (void)lk;
}
void
release(struct spinlock *lk)
{
  (void)lk;
}
void
initsleeplock(struct sleeplock *lk, char *name)
{
  (void)lk;
  (void)name;
}
void
acquiresleep(struct sleeplock *lk)
{
  (void)lk;
}
void
releasesleep(struct sleeplock *lk)
{
  (void)lk;
}
int
holdingsleep(struct sleeplock *lk)
{
  (void)lk;
  return 1;
}

/* --- console + panic --- */
void
printk(char *fmt, ...)
{
  /* The fs layer only printk's short diagnostics; print the format
   * string itself (no formatting) — enough to identify the message. */
  int n = 0;
  while (fmt[n])
    n++;
  kconswrite(fmt, n);
}

void
panic(const char *s)
{
  kconswrite("panic: ", 7);
  int n = 0;
  while (s[n])
    n++;
  kconswrite(s, n);
  kconswrite("\n", 1);
  for (;;)
    ;
}

/* --- flat memory: every copy is a memmove --- */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  (void)user_dst;
  memmove((void *)dst, src, len);
  return 0;
}
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  (void)user_src;
  memmove(dst, (void *)src, len);
  return 0;
}
int
copyout(pagetable_t pt, uint64 sz, uint64 dstva, char *src, uint64 len)
{
  (void)pt;
  (void)sz;
  memmove((void *)dstva, src, len);
  return 0;
}
int
copyin(pagetable_t pt, char *dst, uint64 srcva, uint64 len)
{
  (void)pt;
  memmove(dst, (void *)srcva, len);
  return 0;
}

/* --- the fs-facing proc view --- */
#define KNPROC 8
struct proc fsproc[KNPROC];

struct proc *
myproc(void)
{
  return &fsproc[curr];
}

/* --- console device (devsw[CONSOLE]) --- */
static int
consoleread(int user_dst, uint64 addr, int n)
{
  (void)user_dst;
  return kconsread((uint)addr, n);
}

static int
consolewrite(int user_src, uint64 addr, int n)
{
  (void)user_src;
  kconswrite((const char *)addr, n);
  return n;
}

/* --- lifecycle: called by kproc.c --- */
uint fsready;

static struct inode *create(char *path, short type, short major, short minor);
static char devmnt[8]; /* "/dev" once kfs_start wires it; "" before */
static uint devmnt_dev = (uint)-1, devmnt_inum;

/* Mounts the RAM disk, installs the console device, and gives every
 * live process a root cwd and console fds 0/1/2. */
void
kfs_start(void)
{
  fsinit(ROOTDEV);
  fileinit();
  devsw[CONSOLE].read = consoleread;
  devsw[CONSOLE].write = consolewrite;
  /* fds 0/1/2 come from the disk's console device inode, exactly as
   * upstream init does with open("console") — so fileclose's iput has
   * a real inode to release. */
  struct inode *cons = namei("/console");
  if (cons == 0)
    panic("kfs_start: no console");
  /* devfs: ensure the /dev mountpoint exists on the RAM disk, then
   * record its identity so vfs_resolve crosses into kdev.c. */
  {
    struct inode *dp = namei("/dev");
    if (dp == 0) {
      dp = create("/dev", T_DIR, 0, 0);
      if (dp)
        iunlock(dp);
    }
    if (dp) {
      devmnt_dev = dp->dev;
      devmnt_inum = dp->inum;
      iput(dp);
      devmnt[0] = '/';
      devmnt[1] = 'd';
      devmnt[2] = 'e';
      devmnt[3] = 'v';
      devmnt[4] = 0;
    }
  }
  for (int i = 0; i < KNPROC; i++) {
    struct proc *p = &fsproc[i];
    p->sz = (uint64)-1;
    p->cwd = namei("/");
    for (int fd = 0; fd < 3; fd++) {
      struct file *f = filealloc();
      f->type = FD_DEVICE;
      f->major = CONSOLE;
      f->readable = 1;
      f->writable = 1;
      f->ip = idup(cons);
      p->ofile[fd] = f;
    }
  }
  iput(cons);
  fsready = 1;
}

void
kfs_forkcopy(int parent, int child)
{
  struct proc *pp = &fsproc[parent], *cp = &fsproc[child];
  cp->sz = pp->sz;
  for (int i = 0; i < NOFILE; i++)
    cp->ofile[i] = pp->ofile[i] ? filedup(pp->ofile[i]) : 0;
  cp->cwd = pp->cwd ? idup(pp->cwd) : 0;
}

void
kfs_exit(int slot)
{
  struct proc *p = &fsproc[slot];
  for (int i = 0; i < NOFILE; i++) {
    if (p->ofile[i]) {
      fileclose(p->ofile[i]);
      p->ofile[i] = 0;
    }
  }
  if (p->cwd) {
    vfs_iput(p->cwd);
    p->cwd = 0;
  }
}

/* --- vfat mount (prompts/029) ---
 * One mount point. Paths under it (and relative paths while the cwd
 * is a FAT directory) route to kfat.c instead of namei; file.c's
 * verbatim fd operations reach FAT nodes through the vfs_* shims
 * below (shim defs.h renames its calls when compiling file.c with
 * DMA_VFS_CALLS). Read-only: create/link/unlink/mkdir and write
 * opens under the mount are refused. */
extern int fat_is(struct inode *ip);
extern int fat_active(void);
extern int fat_mount(uint xipbase);
extern int fat_busy(void);
extern void fat_unmount(void);
extern struct inode *fat_root(void);
extern struct inode *fat_walk(struct inode *from, const char *path);
extern struct inode *fat_lookup(struct inode *dp, const char *name);
extern void fat_dup(struct inode *ip);
/* devfs (kdev.c): the second synthetic backend, mounted at /dev. */
int dev_is(struct inode *ip);
struct inode *dev_root(void);
struct inode *dev_lookup(struct inode *dir, const char *name);
int dev_readi(struct inode *ip, uint dst, uint off, uint n);
void dev_stati(struct inode *ip, struct stat *st);
void dev_put(struct inode *ip);
void dev_dup(struct inode *ip);

extern int fat_readi(struct inode *ip, uint dst, uint off, uint n);
extern void fat_stati(struct inode *ip, struct stat *st);
extern void fat_put(struct inode *ip);

uint fatvol; /* loader-patched: XIP address of the vfat volume; 0 = none */
static char fatmnt[28]; /* mount point path ("" = not mounted) */
static uint fatmnt_dev = (uint)-1, fatmnt_inum; /* the mountpoint inode:
             * any path resolution landing on it crosses into the
             * volume, so relative paths ("ls mnt", "cd ./mnt") mount-
             * cross exactly like the absolute prefix */

int
vfs_readi(struct inode *ip, int u, uint64 dst, uint off, uint n)
{
  if (fat_is(ip))
    return fat_readi(ip, (uint)dst, off, n);
  if (dev_is(ip))
    return dev_readi(ip, (uint)dst, off, n);
  return readi(ip, u, dst, off, n);
}
int
vfs_writei(struct inode *ip, int u, uint64 src, uint off, uint n)
{
  return (fat_is(ip) || dev_is(ip)) ? -1 : writei(ip, u, src, off, n);
}
void
vfs_ilock(struct inode *ip)
{
  if (!fat_is(ip) && !dev_is(ip))
    ilock(ip);
}
void
vfs_iunlock(struct inode *ip)
{
  if (!fat_is(ip) && !dev_is(ip))
    iunlock(ip);
}
void
vfs_iput(struct inode *ip)
{
  if (fat_is(ip))
    fat_put(ip);
  else if (dev_is(ip))
    dev_put(ip);
  else
    iput(ip);
}
void
vfs_stati(struct inode *ip, struct stat *st)
{
  if (fat_is(ip))
    fat_stati(ip, st);
  else if (dev_is(ip))
    dev_stati(ip, st);
  else
    stati(ip, st);
}

/* Does path fall under the mount point? Returns the remainder ("" for
 * the mount point itself), or 0. */
static const char *
fat_prefix(const char *path)
{
  if (fatmnt[0] == 0 || path[0] != '/')
    return 0;
  int i = 0;
  while (fatmnt[i] && path[i] == fatmnt[i])
    i++;
  if (fatmnt[i] != 0)
    return 0;
  if (path[i] == 0)
    return path + i;
  if (path[i] == '/')
    return path + i + 1;
  return 0;
}

static const char *
dev_prefix(const char *path)
{
  if (devmnt[0] == 0 || path[0] != '/')
    return 0;
  int i = 0;
  while (devmnt[i] && path[i] == devmnt[i])
    i++;
  if (devmnt[i] != 0)
    return 0;
  if (path[i] == 0)
    return path + i;
  if (path[i] == '/')
    return path + i + 1;
  return 0;
}

/* Path resolution honoring the mount: a component walk (the exported
 * dirlookup does the xv6 steps) that crosses into the FAT volume
 * whenever a step lands on the MOUNTPOINT INODE — so "ls mnt",
 * "cd ./mnt" and absolute paths all behave alike — and hands the
 * remaining components to the FAT driver once inside. */
static const char *
pathelem(const char *path, char *name)
{
  while (*path == '/')
    path++;
  if (*path == 0)
    return 0;
  int n = 0;
  while (*path && *path != '/') {
    if (n < 63)
      name[n++] = *path;
    path++;
  }
  name[n] = 0;
  return path;
}

static struct inode *
vfs_walk(char *path)
{
  struct proc *p = myproc();
  struct inode *ip;
  if (path[0] == '/' || p->cwd == 0) {
    ip = namei("/");
  } else if (fat_is(p->cwd)) {
    ip = p->cwd;
    fat_dup(ip);
  } else if (dev_is(p->cwd)) {
    ip = p->cwd;
    dev_dup(ip);
  } else {
    ip = idup(p->cwd);
  }
  if (ip == 0)
    return 0;
  char name[64];
  const char *rest = path;
  while ((rest = pathelem(rest, name)) != 0) {
    struct inode *nxt;
    if (fat_is(ip)) {
      nxt = ip->type == T_DIR ? fat_lookup(ip, name) : 0;
      fat_put(ip);
      if (nxt == 0)
        return 0;
      ip = nxt;
      continue;
    }
    if (dev_is(ip)) {
      nxt = ip->type == T_DIR ? dev_lookup(ip, name) : 0;
      dev_put(ip);
      if (nxt == 0)
        return 0;
      ip = nxt;
      continue;
    }
    ilock(ip);
    if (ip->type != T_DIR) {
      iunlockput(ip);
      return 0;
    }
    nxt = dirlookup(ip, name, 0);
    iunlockput(ip);
    if (nxt == 0)
      return 0;
    if (nxt->dev == fatmnt_dev && nxt->inum == fatmnt_inum) {
      iput(nxt); /* cross into the volume */
      nxt = fat_root();
      if (nxt == 0)
        return 0;
    } else if (nxt->dev == devmnt_dev && nxt->inum == devmnt_inum) {
      iput(nxt); /* cross into /dev */
      nxt = dev_root();
      if (nxt == 0)
        return 0;
    }
    ip = nxt;
  }
  return ip;
}

/* namei-first resolution: the plain-fs corners (a deleted cwd's
 * dangling "..", usertests' unlinkcwd) behave exactly as upstream,
 * because the component walk above only runs where a synthetic fs can
 * be involved — a synthetic cwd, a mount-prefixed absolute path, a
 * namei result that IS a mountpoint (swap to the synthetic root), or
 * a namei failure that might be a mid-path crossing ("ls dev/gpio"
 * relative to /). */
static struct inode *
vfs_resolve(char *path)
{
  struct proc *p = myproc();
  if (fatmnt[0] == 0 && devmnt[0] == 0 &&
      !(p->cwd && (fat_is(p->cwd) || dev_is(p->cwd))))
    return namei(path);
  if (p->cwd && (fat_is(p->cwd) || dev_is(p->cwd)))
    return vfs_walk(path);
  if (path[0] == '/' && (fat_prefix(path) || dev_prefix(path)))
    return vfs_walk(path);
  struct inode *ip = namei(path);
  if (ip == 0) {
    /* namei said no. The only reason to try harder is a mid-path
     * crossing into a synthetic fs ("ls dev/gpio" relative to /) —
     * so only a synthetic result counts. A regular-inode result
     * must NOT override namei: the walk lacks namex's corner
     * handling (unlinked dirs, dangling ".."), and returning its
     * inode can ilock a freed dinode. */
    ip = vfs_walk(path);
    if (ip && !fat_is(ip) && !dev_is(ip)) {
      iput(ip);
      return 0;
    }
    return ip;
  }
  if (ip->dev == fatmnt_dev && ip->inum == fatmnt_inum) {
    iput(ip);
    return fat_root();
  }
  if (ip->dev == devmnt_dev && ip->inum == devmnt_inum) {
    iput(ip);
    return dev_root();
  }
  return ip;
}

/* Refuse writes anywhere a path would land in the FAT world. */
static int
fat_writepath(const char *path)
{
  if (fat_prefix(path) || dev_prefix(path))
    return 1;
  struct proc *p = myproc();
  return path[0] != '/' && p->cwd && (fat_is(p->cwd) || dev_is(p->cwd));
}

int
kfs_mount(uint srcaddr, uint tgtaddr)
{
  if (srcaddr == 0) { /* list: write the table into tgtaddr */
    char *o = (char *)tgtaddr;
    int n = 0;
    if (fatmnt[0]) {
      const char *a = "fat0 on ";
      while (*a)
        o[n++] = *a++;
      for (int i = 0; fatmnt[i]; i++)
        o[n++] = fatmnt[i];
      const char *b = " type vfat (ro)\n";
      while (*b)
        o[n++] = *b++;
    }
    if (devmnt[0]) {
      const char *d = "devfs on /dev type devfs (ro)\n";
      while (*d)
        o[n++] = *d++;
    }
    o[n] = 0;
    return n;
  }
  const char *src = (const char *)srcaddr;
  char *tgt = (char *)tgtaddr;
  if (fatvol == 0 || fatmnt[0] != 0)
    return -1;
  if (!(src[0] == 'f' && src[1] == 'a' && src[2] == 't' && src[3] == '0' &&
        src[4] == 0))
    return -1;
  if (tgt[0] != '/' || tgt[1] == 0)
    return -1;
  struct inode *mp = namei(tgt); /* the mount point must exist */
  if (mp == 0)
    return -1;
  ilock(mp);
  int isdir = mp->type == T_DIR;
  uint mdev = mp->dev, minum = mp->inum;
  iunlockput(mp);
  if (!isdir)
    return -1;
  if (fat_mount(fatvol) < 0)
    return -1;
  fatmnt_dev = mdev;
  fatmnt_inum = minum;
  int i = 0;
  while (tgt[i] && tgt[i] != ' ' && i < 26) {
    fatmnt[i] = tgt[i];
    i++;
  }
  while (i > 1 && fatmnt[i - 1] == '/')
    i--; /* strip trailing slash */
  fatmnt[i] = 0;
  return 0;
}

int
kfs_umount(uint tgtaddr)
{
  const char *tgt = (const char *)tgtaddr;
  if (fatmnt[0] == 0)
    return -1;
  int i = 0;
  while (fatmnt[i] && tgt[i] == fatmnt[i])
    i++;
  if (fatmnt[i] != 0 || (tgt[i] != 0 && !(tgt[i] == '/' && tgt[i + 1] == 0)))
    return -1;
  if (fat_busy())
    return -1; /* open files or cwds still inside */
  fat_unmount();
  fatmnt[0] = 0;
  fatmnt_dev = (uint)-1;
  return 0;
}

/* --- fd-level syscall bodies (sysfile.c reshaped) --- */
static int
fdalloc(struct file *f)
{
  struct proc *p = myproc();
  for (int fd = 0; fd < NOFILE; fd++) {
    if (p->ofile[fd] == 0) {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

static struct file *
fdget(int fd)
{
  if (fd < 0 || fd >= NOFILE)
    return 0;
  return myproc()->ofile[fd];
}

int
kfs_read(int fd, uint addr, int n)
{
  struct file *f = fdget(fd);
  if (!f)
    return -1;
  return fileread(f, addr, n);
}

int
kfs_write(int fd, uint addr, int n)
{
  struct file *f = fdget(fd);
  if (!f)
    return -1;
  return filewrite(f, addr, n);
}

int
kfs_close(int fd)
{
  struct file *f = fdget(fd);
  if (!f)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

int
kfs_dup(int fd)
{
  struct file *f = fdget(fd);
  if (!f)
    return -1;
  int nfd = fdalloc(f);
  if (nfd < 0)
    return -1;
  filedup(f);
  return nfd;
}

int
kfs_fstat(int fd, uint staddr)
{
  struct file *f = fdget(fd);
  if (!f)
    return -1;
  return filestat(f, staddr);
}

int
kfs_pipe(uint fdarray)
{
  struct file *rf, *wf;
  if (pipealloc(&rf, &wf) < 0)
    return -1;
  int fd0 = fdalloc(rf);
  int fd1 = fd0 >= 0 ? fdalloc(wf) : -1;
  if (fd0 < 0 || fd1 < 0) {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  int *out = (int *)fdarray;
  out[0] = fd0;
  out[1] = fd1;
  return 0;
}

/* sysfile.c's create(), reshaped. */
static struct inode *
create(char *path, short type, short major, short minor)
{
  char name[DIRSIZ];
  struct inode *dp = nameiparent(path, name);
  if (dp == 0)
    return 0;
  ilock(dp);
  struct inode *ip = dirlookup(dp, name, 0);
  if (ip) {
    iunlockput(dp);
    ilock(ip);
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    iunlockput(ip);
    return 0;
  }
  if ((ip = ialloc(dp->dev, type)) == 0) {
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  if (type == T_DIR) {
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  if (dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  if (type == T_DIR) {
    dp->nlink++; /* for ".." */
    iupdate(dp);
  }
  iunlockput(dp);
  return ip;
}

int
kfs_open(uint pathaddr, int omode)
{
  char *path = (char *)pathaddr;
  struct inode *ip;
  if (omode & O_CREATE) {
    if (fat_writepath(path))
      return -1; /* the FAT mount is read-only */
    ip = create(path, T_FILE, 0, 0);
    if (ip == 0)
      return -1;
  } else if (fat_writepath(path) && omode != O_RDONLY) {
    return -1;
  } else {
    if ((ip = vfs_resolve(path)) == 0)
      return -1;
    if (fat_is(ip) || dev_is(ip)) {
      struct file *ff = filealloc();
      int ffd = ff ? fdalloc(ff) : -1;
      if (ff == 0 || ffd < 0) {
        if (ff)
          fileclose(ff);
        vfs_iput(ip);
        return -1;
      }
      if (dev_is(ip) && ip->type == T_DEVICE) {
        /* /dev/console: the real console device, read-write */
        ff->type = FD_DEVICE;
        ff->major = ip->major;
        ff->ip = ip;
        ff->readable = !(omode & O_WRONLY);
        ff->writable = (omode & O_WRONLY) || (omode & O_RDWR);
        return ffd;
      }
      ff->type = FD_INODE;
      ff->off = 0;
      ff->ip = ip;
      ff->readable = 1;
      ff->writable = 0;
      return ffd;
    }
    ilock(ip);
    if (ip->type == T_DIR && omode != O_RDONLY) {
      iunlockput(ip);
      return -1;
    }
  }
  struct file *f = filealloc();
  int fd = f ? fdalloc(f) : -1;
  if (f == 0 || fd < 0) {
    if (f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  if (ip->type == T_DEVICE) {
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  if ((omode & O_TRUNC) && ip->type == T_FILE)
    itrunc(ip);
  iunlock(ip);
  return fd;
}

int
kfs_chdir(uint pathaddr)
{
  struct proc *p = myproc();
  struct inode *ip = vfs_resolve((char *)pathaddr);
  if (ip == 0)
    return -1;
  if (fat_is(ip)) {
    if (ip->type != T_DIR) {
      fat_put(ip);
      return -1;
    }
  } else {
    ilock(ip);
    if (ip->type != T_DIR) {
      iunlockput(ip);
      return -1;
    }
    iunlock(ip);
  }
  if (p->cwd)
    vfs_iput(p->cwd);
  p->cwd = ip;
  return 0;
}

int
kfs_mkdir(uint pathaddr)
{
  if (fat_writepath((const char *)pathaddr))
    return -1;
  struct inode *ip = create((char *)pathaddr, T_DIR, 0, 0);
  if (ip == 0)
    return -1;
  iunlockput(ip);
  return 0;
}

/* sysfile.c's sys_link/sys_unlink, reshaped (paths arrive as flat
 * pointers instead of argstr copies). */
int
kfs_link(uint oldaddr, uint newaddr)
{
  if (fat_writepath((const char *)oldaddr) ||
      fat_writepath((const char *)newaddr))
    return -1;
  char name[DIRSIZ];
  struct inode *ip = namei((char *)oldaddr);
  if (ip == 0)
    return -1;
  ilock(ip);
  if (ip->type == T_DIR) {
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);
  struct inode *dp = nameiparent((char *)newaddr, name);
  if (dp) {
    ilock(dp);
    if (dp->dev == ip->dev && dirlink(dp, name, ip->inum) >= 0) {
      iunlockput(dp);
      iput(ip);
      return 0;
    }
    iunlockput(dp);
  }
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
}

static int
isdirempty(struct inode *dp)
{
  struct dirent de;
  for (uint off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if (de.inum != 0)
      return 0;
  }
  return 1;
}

int
kfs_unlink(uint pathaddr)
{
  if (fat_writepath((const char *)pathaddr))
    return -1;
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;
  if ((dp = nameiparent((char *)pathaddr, name)) == 0)
    return -1;
  ilock(dp);
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;
  if ((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);
  if (ip->nlink < 1)
    panic("unlink: nlink < 1");
  if (ip->type == T_DIR && !isdirempty(ip)) {
    iunlockput(ip);
    goto bad;
  }
  memset(&de, 0, sizeof(de));
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if (ip->type == T_DIR) {
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
bad:
  iunlockput(dp);
  return -1;
}

/* --- executable files: exec's inode-backed loader interface --- */
uint
kfs_iopen(const char *path)
{
  /* exec's image lookup. Relative program names fall back to the
   * xv6 root when the cwd cannot serve them — a FAT cwd holds no DMX
   * executables (and must not leak into namei), and `cd somedir; ls`
   * should keep working from any directory (PATH=/ semantics). */
  struct proc *p = myproc();
  char rooted[64];
  int n = 0;
  rooted[n++] = '/';
  while (path[n - 1] && n < 63) {
    rooted[n] = path[n - 1];
    n++;
  }
  rooted[n] = 0;
  struct inode *ip = 0;
  if (path[0] == '/' || (p->cwd && !fat_is(p->cwd)))
    ip = namei((char *)path);
  if (ip == 0 && path[0] != '/')
    ip = namei(rooted);
  if (ip == 0)
    return 0;
  ilock(ip);
  if (ip->type != T_FILE) {
    iunlockput(ip);
    return 0;
  }
  return (uint)ip;
}

int
kfs_iread(uint ipu, uint off, uint dst, uint n)
{
  return readi((struct inode *)ipu, 0, dst, off, n);
}

void
kfs_iclose(uint ipu)
{
  iunlockput((struct inode *)ipu);
}
