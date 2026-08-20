/* gmain.c: gamepico entry — M1 scope: boot banner, LCD bring-up, a
 * test card, and a heartbeat loop that mirrors joystick state to the
 * UART (the console is the test surface until the LCD is wired). */
#include "g.h"

static const ushort bars[8] = {
    RGB(255, 255, 255), RGB(255, 255, 0), RGB(0, 255, 255),
    RGB(0, 255, 0),     RGB(255, 0, 255), RGB(255, 0, 0),
    RGB(0, 0, 255),     RGB(0, 0, 0),
};

static void
testcard(void)
{
  gfx_clear(RGB(0, 0, 0));
  for (int i = 0; i < 8; i++)
    gfx_fill(i * 30, 0, 30, 180, bars[i]);
  for (int x = 0; x < LCD_W; x++) { /* gray ramp strip */
    ushort g = RGB(x + 8, x + 8, x + 8);
    for (int y = 180; y < 210; y++)
      fb[y * LCD_W + x] = g;
  }
  gfx_damage(0, 180, LCD_W - 1, 209);
  gfx_fill(0, 210, LCD_W, 30, RGB(16, 16, 64));
  gfx_text(8, 220, "GAMEPICO test card", RGB(255, 255, 255), RGB(16, 16, 64));
  gfx_present();
}

static uint
joys(int base)
{
  uint m = 0;
  for (int i = 0; i < 5; i++)
    m |= (uint)gpio_in_pu(base + i) << i;
  return m; /* pulled up: 0x1F = all released */
}

int
gmain(void)
{
  uputs("GAMEPICO: boot\n");
  lcd_init();
  uputs("GAMEPICO: lcd up\n");
  testcard();
  uputs("GAMEPICO: test card shown\n");

  uint prevA = 0x1F, prevB = 0x1F, beats = 0;
  uint t0 = now_us();
  for (;;) {
    uint a = joys(PIN_JOYA_UP), b = joys(PIN_JOYB_UP);
    if (a != prevA || b != prevB) {
      uputs("joy a=");
      uputhex(a);
      uputs(" b=");
      uputhex(b);
      uputs("\n");
      prevA = a;
      prevB = b;
    }
    if (now_us() - t0 >= 1000000) {
      t0 += 1000000;
      beats++;
      uputs("beat ");
      uputn(beats);
      uputs("\n");
    }
  }
  return 0; /* unreachable; the entry contract wants an int */
}
