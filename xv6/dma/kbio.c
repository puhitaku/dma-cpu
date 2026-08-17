/* DMA-machine replacement for bio.c + log.c + virtio_disk.c
 * (xv6/PORT.md): the disk is a RAM-resident image and every access is
 * synchronous, so a buffer is a POINTER into the disk image — bread
 * copies nothing, writes land in place, and the log has no crashes to
 * recover from. The small buf pool only tracks refcounts so that
 * concurrently-held buffers (bmap's indirect block + the caller's)
 * never alias a recycled slot. */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "buf.h"

#define NBUFS 8
#define BSIZE 1024

uint dma_disk;     /* loader-patched: base of the fs image in RAM */
uint dma_disksize; /* loader-patched: bytes */

static struct buf bufs[NBUFS];

struct buf *
bread(uint dev, uint blockno)
{
  if (dma_disk == 0 || (blockno + 1) * BSIZE > dma_disksize)
    panic("bread");
  struct buf *free = 0;
  for (int i = 0; i < NBUFS; i++) {
    struct buf *b = &bufs[i];
    if (b->refcnt > 0 && b->blockno == blockno && b->dev == dev) {
      b->refcnt++;
      return b;
    }
    if (b->refcnt == 0 && !free)
      free = b;
  }
  if (!free)
    panic("bread: no buffers");
  free->dev = dev;
  free->blockno = blockno;
  free->refcnt = 1;
  free->data = (uchar *)(dma_disk + blockno * BSIZE);
  return free;
}

void
brelse(struct buf *b)
{
  if (b->refcnt <= 0)
    panic("brelse");
  b->refcnt--;
}

void
bwrite(struct buf *b)
{
  (void)b; /* the data already lives in the disk image */
}

void
log_write(struct buf *b)
{
  (void)b;
}

void
begin_op(void)
{
}

void
end_op(void)
{
}

void
initlog(int dev, struct superblock *sb)
{
  (void)dev;
  (void)sb;
}
