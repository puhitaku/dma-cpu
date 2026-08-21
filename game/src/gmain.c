/* gmain.c: gamepico entry — boot the panel, then loop the menu and
 * whichever game it picks. The UART narrates state changes so the
 * HIL scripts (and the emulator tests) can follow along blind. */
#include "g.h"

int
gmain(void)
{
  uputs("GAMEPICO: boot\n");
  lcd_init();
  uputs("GAMEPICO: lcd up\n");
  fx_init();
  uputs("GAMEPICO: fx up\n");
  for (;;) {
    int g = menu_run();
    if (g == 0)
      dino_run();
    else if (g == 1)
      lanwalk_run();
    else if (g == 2)
      yacht_run();
    else
      seq_run();
  }
  return 0; /* unreachable; the entry contract wants an int */
}
