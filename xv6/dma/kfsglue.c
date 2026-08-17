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

/* Mounts the RAM disk, installs the console device, and gives every
 * live process a root cwd and console fds 0/1/2. */
void
kfs_start(void)
{
  fsinit(ROOTDEV);
  fileinit();
  devsw[CONSOLE].read = consoleread;
  devsw[CONSOLE].write = consolewrite;
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
      p->ofile[fd] = f;
    }
  }
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
    iput(p->cwd);
    p->cwd = 0;
  }
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
    ip = create(path, T_FILE, 0, 0);
    if (ip == 0)
      return -1;
  } else {
    if ((ip = namei(path)) == 0)
      return -1;
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
  struct inode *ip = namei((char *)pathaddr);
  if (ip == 0)
    return -1;
  ilock(ip);
  if (ip->type != T_DIR) {
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  if (p->cwd)
    iput(p->cwd);
  p->cwd = ip;
  return 0;
}

int
kfs_mkdir(uint pathaddr)
{
  struct inode *ip = create((char *)pathaddr, T_DIR, 0, 0);
  if (ip == 0)
    return -1;
  iunlockput(ip);
  return 0;
}

/* --- executable files: exec's inode-backed loader interface --- */
uint
kfs_iopen(const char *path)
{
  struct inode *ip = namei((char *)path);
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
