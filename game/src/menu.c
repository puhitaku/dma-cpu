/* menu.c: the console's front door. Up/down picks a game, press
 * starts it. Idles with a once-a-second UART heartbeat so the HIL
 * capture scripts keep their "beat N" synchronization point. */
#include "g.h"

#define C_BG RGB(12, 16, 40)
#define C_TITLE RGB(255, 210, 60)
#define C_ITEM RGB(180, 190, 210)
#define C_SEL RGB(255, 255, 255)
#define C_SELBG RGB(40, 70, 140)
#define C_FOOT RGB(90, 100, 130)

static const char *names[3] = {"Dinosaur", "LANWalk", "Yacht"};

static void
draw_item(int i, int selected)
{
  int y = 96 + i * 28;
  gfx_fill(32, y - 4, 176, 24, selected ? C_SELBG : C_BG);
  if (selected)
    gfx_text(44, y, ">", C_TITLE, C_SELBG);
  gfx_text2(60, y - 4, names[i], selected ? C_SEL : C_ITEM,
            selected ? C_SELBG : C_BG);
}

int
menu_run(void)
{
  gfx_clear(C_BG);
  gfx_text2(56, 24, "GAMEPICO", C_TITLE, C_BG);
  gfx_fill(56, 44, 128, 2, C_TITLE);
  gfx_text(28, 60, "a DMA-CPU game console", C_ITEM, C_BG);
  int sel = 0;
  for (int i = 0; i < 3; i++)
    draw_item(i, i == sel);
  gfx_text(48, 200, "up/down: pick", C_FOOT, C_BG);
  gfx_text(48, 212, "press:   play", C_FOOT, C_BG);
  gfx_present();
  led(0x000418, 0x000418); /* both dim blue while browsing */
  uputs("menu up\n");

  uint beats = 0, t0 = now_us();
  for (;;) {
    frame_sync(33000);
    in_poll();
    int prev = sel;
    if (in_edge & BTN_UP)
      sel = sel == 0 ? 2 : sel - 1;
    if (in_edge & BTN_DOWN)
      sel = sel == 2 ? 0 : sel + 1;
    if (sel != prev) {
      draw_item(prev, 0);
      draw_item(sel, 1);
      gfx_present();
      snd_play(700, 40, 2);
      uputs("menu: ");
      uputs(names[sel]);
      uputs("\n");
    }
    if (in_edge & BTN_A) {
      snd_play(1000, 60, 4);
      led(0x00FF40, 0x00FF40);
      uputs("start: ");
      uputs(names[sel]);
      uputs("\n");
      return sel;
    }
    if (now_us() - t0 >= 1000000) {
      t0 += 1000000;
      beats++;
      uputs("beat ");
      uputn(beats);
      uputs("\n");
    }
  }
}
