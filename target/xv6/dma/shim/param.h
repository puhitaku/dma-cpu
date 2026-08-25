#ifndef DMA_SHIM_PARAM_H
#define DMA_SHIM_PARAM_H
/* Shim override of kernel/param.h (shim-first include order): the
 * upstream limits are sized for a multi-user teaching machine; this
 * single-console system trims the static tables to what it can ever
 * use — measured off the feather RAM map, where kernel data was the
 * fullest window (NFILE 100->32: ~28 B each; NINODE 50->24: ~84 B
 * each; everything else upstream). */
#include "../kernel/param.h"
#undef NFILE
#undef NINODE
#define NFILE 32
#define NINODE 24
#endif
