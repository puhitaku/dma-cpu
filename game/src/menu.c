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

static const char *names[5] = {"Dinosaur", "LANWalk", "Yacht",
                              "Sequencer", "CPU Sleep"};

#define NGAMES 5

static void
draw_item(int i, int selected)
{
  int y = 74 + i * 25;
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
  gfx_text2(56, 24, "DMA PICO", C_TITLE, C_BG);
  gfx_fill(56, 44, 128, 2, C_TITLE);
  gfx_text(8, 60, "Enjoy purely DMA-coded games", C_ITEM, C_BG);
  int sel = 0;
  for (int i = 0; i < NGAMES; i++)
    draw_item(i, i == sel);
  gfx_text(12, 208, "up/down: pick   press: play", C_FOOT, C_BG);
  gfx_present();
  led(LED_DIM(0x0040FF), LED_DIM(0x0040FF)); /* dim blue browse */
  uputs("menu up\n");

  uint beats = 0, t0 = now_us();
  for (;;) {
    frame_sync(33000);
    in_poll();
    int prev = sel;
    if (in_edge & BTN_UP)
      sel = sel == 0 ? NGAMES - 1 : sel - 1;
    if (in_edge & BTN_DOWN)
      sel = sel == NGAMES - 1 ? 0 : sel + 1;
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
      led(LED_BRIGHT(0x00FF40), LED_BRIGHT(0x00FF40));
      uputs("start: ");
      uputs(names[sel]);
      uputs("\n");
      /* launch fanfare: a rapid C5-E5-G5 arpeggio, timed by the
       * hardware clock so every game gets the identical jingle (a
       * frame-counted tone died at whatever pace the next game's
       * first frames happened to run). */
      snd_play(523, 55, 255);
      delay_us(55000);
      snd_play(659, 55, 255);
      delay_us(55000);
      snd_play(784, 55, 255);
      delay_us(90000);
      snd_off();
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
