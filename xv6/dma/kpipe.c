/* DMA-machine replacement for pipe.c (xv6/PORT.md): the kernel has no
 * per-process kernel stacks, so a blocked pipe end cannot loop inside
 * the kernel — instead the PEER completes it by deposit, exactly like
 * exit() completes wait():
 *  - a reader blocking on an empty pipe sleeps with its (buf, n) in
 *    its mailbox; the next writer copies directly into the sleeper's
 *    buffer and completes it.
 *  - a writer blocking on a full pipe first advances its mailbox to
 *    the unwritten remainder (progress accumulates in mail.done); the
 *    next reader drains the ring, then feeds the sleeping writer's
 *    remainder into the freed space, completing it when none is left.
 * Closing an end completes the peer's sleepers (EOF for readers,
 * short count for writers). The kproc.c helpers keep all scheduler
 * state on the other side of the fence. */
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

#define PIPESIZE 512
#define NPIPES 4

/* kproc.c scheduler fence (see there). */
extern int kfind_sleeper(uint chan);
extern uint kmail_get(int slot, int field); /* 1:a0 2:a1 3:a2 4:ret 5:done */
extern void kmail_set(int slot, int field, uint v);
extern void kcomplete(int slot, uint ret);
extern void kblock_current(uint chan);
extern int kblock_self_slot(void);

struct pipe {
  char data[PIPESIZE];
  uint nread, nwrite;
  int readopen, writeopen;
  int inuse;
};

static struct pipe pipes[NPIPES];

int
pipealloc(struct file **f0, struct file **f1)
{
  struct pipe *pi = 0;
  for (int i = 0; i < NPIPES; i++) {
    if (!pipes[i].inuse) {
      pi = &pipes[i];
      break;
    }
  }
  *f0 = *f1 = 0;
  if (pi == 0 || (*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) {
    if (*f0)
      fileclose(*f0);
    return -1;
  }
  pi->inuse = 1;
  pi->readopen = 1;
  pi->writeopen = 1;
  pi->nread = pi->nwrite = 0;
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = pi;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = pi;
  return 0;
}

/* Feed a sleeping writer's remainder into the ring; complete it when
 * everything it asked for has been written. */
static void
pull_writer(struct pipe *pi)
{
  int ws = kfind_sleeper((uint)&pi->nwrite);
  if (ws < 0)
    return;
  char *src = (char *)kmail_get(ws, 2);
  uint left = kmail_get(ws, 3);
  uint did = kmail_get(ws, 5);
  while (left > 0 && pi->nwrite - pi->nread < PIPESIZE) {
    pi->data[pi->nwrite % PIPESIZE] = *src++;
    pi->nwrite++;
    left--;
    did++;
  }
  if (left == 0) {
    kcomplete(ws, did);
  } else {
    kmail_set(ws, 2, (uint)src);
    kmail_set(ws, 3, left);
    kmail_set(ws, 5, did);
  }
}

int
piperead(struct pipe *pi, uint64 addr, int n)
{
  char *dst = (char *)addr;
  int got = 0;
  while (got < n && pi->nread != pi->nwrite) {
    *dst++ = pi->data[pi->nread % PIPESIZE];
    pi->nread++;
    got++;
  }
  pull_writer(pi); /* freed space: feed a blocked writer */
  if (got > 0)
    return got;
  if (!pi->writeopen)
    return 0; /* EOF */
  /* Block: the writer (or close) deposits into our mailbox. */
  kblock_current((uint)&pi->nread);
  return -3;
}

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
  char *src = (char *)addr;
  int done = 0;
  if (!pi->readopen)
    return -1;
  /* A reader may be blocked on the empty pipe: deposit directly. */
  int rs = kfind_sleeper((uint)&pi->nread);
  if (rs >= 0) {
    char *rdst = (char *)kmail_get(rs, 2);
    uint rmax = kmail_get(rs, 3);
    uint rgot = 0;
    while (rgot < rmax && done < n) {
      *rdst++ = src[done++];
      rgot++;
    }
    kcomplete(rs, rgot);
  }
  while (done < n && pi->nwrite - pi->nread < PIPESIZE) {
    pi->data[pi->nwrite % PIPESIZE] = src[done++];
    pi->nwrite++;
  }
  if (done == n)
    return n;
  if (!pi->readopen)
    return done;
  /* Ring full: sleep with the remainder in our mailbox; readers pull. */
  kmail_set(kblock_self_slot(), 2, (uint)(src + done));
  kmail_set(kblock_self_slot(), 3, (uint)(n - done));
  kmail_set(kblock_self_slot(), 5, (uint)done);
  kblock_current((uint)&pi->nwrite);
  return -3;
}

void
pipeclose(struct pipe *pi, int writable)
{
  int s;
  if (writable) {
    pi->writeopen = 0;
    /* EOF any blocked reader. */
    while ((s = kfind_sleeper((uint)&pi->nread)) >= 0)
      kcomplete(s, 0);
  } else {
    pi->readopen = 0;
    /* Short-count any blocked writer. */
    while ((s = kfind_sleeper((uint)&pi->nwrite)) >= 0)
      kcomplete(s, kmail_get(s, 5));
  }
  if (!pi->readopen && !pi->writeopen)
    pi->inuse = 0;
}
