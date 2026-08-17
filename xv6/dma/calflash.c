/* cal_flash2 driver program (prompts/023): runs the machine-only
 * flash probe (kflash.c's kflash_cal) as a standalone image. The
 * results land in the exported calres words; the firmware prints
 * them, and SWD can read them even if the machine wedges. */
#include "kernel/types.h"

extern void kflash_cal(volatile uint *r);

volatile uint calres[12];

/* kflash.c externs unused by the cal path. */
uint dma_disk;
uint dma_disksize;
uint fs_dirty;

int
main(void)
{
  kflash_cal(calres);
  return 0;
}
