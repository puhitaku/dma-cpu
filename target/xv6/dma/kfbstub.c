/* No-display stand-in for kfb.c/kfbcon.c, the kfsstub of the video
 * stack: lean bundles and non-XIP kernels link this instead of the
 * real driver (~25 KiB of machine text), keeping their narrow SRAM
 * layouts. The syscall face reports -ENODEV: fbtest/show install on
 * every board and print the miss themselves (PORT.md, "Device
 * absence"). */

#include "kernel/types.h"

int
kfb_init(void)
{
  return 0;
}

int
kfb_active(void)
{
  return 0;
}

uint
kfb_base(void)
{
  return 0;
}

int
kfb_w(void)
{
  return 0;
}

int
kfb_h(void)
{
  return 0;
}

uint
kfb_owner(void)
{
  return 0;
}

void
kfb_setowner(uint pid)
{
  (void)pid;
}

void
kfb_pause(void)
{
}

void
kfb_resume(void)
{
}

int
kfb_syscall(uint op, uint a1, uint pid, int badinfo)
{
  (void)op;
  (void)a1;
  (void)pid;
  (void)badinfo;
  return -ENODEV;
}

void
kfbcon_putc(int c)
{
  (void)c;
}

void
kfbcon_reset(void)
{
}

void
kfbcon_cursor(void)
{
}
