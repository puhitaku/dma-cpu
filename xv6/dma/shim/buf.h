/* DMA shim buf: the disk is RAM-resident and synchronous, so a buffer
 * is a POINTER into the disk image — bread never copies, bwrite has
 * nothing to do (kbio.c replaces bio.c; xv6/PORT.md). */
#ifndef DMA_SHIM_BUF_H
#define DMA_SHIM_BUF_H
struct buf {
  uint dev;
  uint blockno;
  int refcnt;
  uchar *data; /* points into the disk image */
};
#endif
