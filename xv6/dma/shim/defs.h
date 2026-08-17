/* DMA shim defs.h: only what the verbatim-compiled fs layer (fs.c,
 * file.c) needs; implementations live in xv6/dma/kfsglue.c, kbio.c,
 * kpipe.c and kernel/string.c (xv6/PORT.md). */
#ifndef DMA_SHIM_DEFS_H
#define DMA_SHIM_DEFS_H

struct buf;
struct inode;
struct file;
struct stat;
struct pipe;
struct spinlock;
struct sleeplock;
struct superblock;

// kbio.c (replaces bio.c/log.c/virtio_disk.c: RAM disk, no log)
struct buf *bread(uint dev, uint blockno);
void brelse(struct buf *b);
void bwrite(struct buf *b);
void log_write(struct buf *b);
void begin_op(void);
void end_op(void);

// kfsglue.c
void panic(const char *s) __attribute__((noreturn));
void acquire(struct spinlock *lk);
void release(struct spinlock *lk);
void initlock(struct spinlock *lk, char *name);
void initsleeplock(struct sleeplock *lk, char *name);
void acquiresleep(struct sleeplock *lk);
void releasesleep(struct sleeplock *lk);
int holdingsleep(struct sleeplock *lk);
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int either_copyin(void *dst, int user_src, uint64 src, uint64 len);
int copyout(pagetable_t pt, uint64 sz, uint64 dstva, char *src, uint64 len);
int copyin(pagetable_t pt, char *dst, uint64 srcva, uint64 len);
struct proc *myproc(void);

// kernel/string.c
void *memmove(void *dst, const void *src, uint n);
void *memset(void *dst, int c, uint n);
int strncmp(const char *p, const char *q, uint n);
char *strncpy(char *s, const char *t, int n);

// kpipe.c (replaces pipe.c: deposit-rendezvous pipes)
int pipealloc(struct file **f0, struct file **f1);
void pipeclose(struct pipe *pi, int writable);
int piperead(struct pipe *pi, uint64 addr, int n);
int pipewrite(struct pipe *pi, uint64 addr, int n);

// printk.c / log.c (kfsglue.c provides printk over the console;
// initlog is a no-op — the RAM disk needs no crash recovery)
void printk(char *fmt, ...);
void initlog(int dev, struct superblock *sb);

// fs.c
void fsinit(int dev);
void ireclaim(int dev);
int dirlink(struct inode *dp, char *name, uint inum);
struct inode *dirlookup(struct inode *dp, char *name, uint *poff);
struct inode *ialloc(uint dev, short type);
struct inode *idup(struct inode *ip);
void iinit(void);
void ilock(struct inode *ip);
void iput(struct inode *ip);
void iunlock(struct inode *ip);
void iunlockput(struct inode *ip);
void iupdate(struct inode *ip);
int namecmp(const char *s, const char *t);
struct inode *namei(char *path);
struct inode *nameiparent(char *path, char *name);
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n);
void stati(struct inode *ip, struct stat *st);
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n);
void itrunc(struct inode *ip);

// file.c
struct file *filealloc(void);
void fileclose(struct file *f);
struct file *filedup(struct file *f);
void fileinit(void);
int fileread(struct file *f, uint64 addr, int n);
int filestat(struct file *f, uint64 addr);
int filewrite(struct file *f, uint64 addr, int n);

#endif

/* vfat dispatch (prompts/029): when compiling the VERBATIM file.c
 * (Makefile passes -DDMA_VFS_CALLS), its inode calls are renamed to
 * the vfs_* shims in kfsglue.c, which route FAT nodes to kfat.c and
 * everything else to the real fs.c functions declared above. The
 * defines sit below the declarations so those keep their real names;
 * the shims' own prototypes match by construction. */
#ifdef DMA_VFS_CALLS
#define readi vfs_readi
#define writei vfs_writei
#define ilock vfs_ilock
#define iunlock vfs_iunlock
#define iput vfs_iput
#define stati vfs_stati
int vfs_readi(struct inode *, int, uint64, uint, uint);
int vfs_writei(struct inode *, int, uint64, uint, uint);
void vfs_ilock(struct inode *);
void vfs_iunlock(struct inode *);
void vfs_iput(struct inode *);
void vfs_stati(struct inode *, struct stat *);
#endif
