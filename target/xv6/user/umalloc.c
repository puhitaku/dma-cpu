#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

typedef long Align;

union header {
  struct {
    union header *ptr;
    uint size;
  } s;
  Align x;
};

typedef union header Header;

static Header base;
static Header *freep;

void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header *)ap - 1;
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}

/* The first ask sizes the process's whole heap chunk (ksbrk allots
 * exactly one region, floored at its 16 KB HEAPCHUNK and halved
 * toward the ask under arena pressure). Apps that live in their
 * heap — vi's text buffer — raise the floor to claim real growth
 * room while the kernel's halving still lets them fit a tight
 * arena. */
uint __malloc_chunkunits = 512;

static Header *
morecore(uint nu)
{
  char *p;
  Header *hp;

  uint ask = nu;
  if (ask < __malloc_chunkunits)
    ask = __malloc_chunkunits;
  /* Halve a generous ask toward the true need when the arena cannot
   * seat it — the kernel's one-shot chunk makes the first ask the
   * process's whole heap, so aim high and degrade gracefully. */
  for (;;) {
    p = sbrk(ask * sizeof(Header));
    if (p != SBRK_ERROR)
      break;
    if (ask / 2 < nu)
      return 0;
    ask /= 2;
  }
  hp = (Header *)p;
  hp->s.size = ask;
  free((void *)(hp + 1));
  return freep;
}

void *
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
  if ((prevp = freep) == 0) {
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    if (p->s.size >= nunits) {
      if (p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
      if ((p = morecore(nunits)) == 0)
        return 0;
  }
}
