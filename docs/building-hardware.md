# Building the hardware

Two consoles run this project's firmware. This guide gives the wiring for
each. Pin numbers are **GPIO numbers** (the `GPn` label on a Pico), taken
directly from the firmware source, so they are authoritative; the power
rails and passive values are the usual choices for these modules — check
each part's datasheet in [`references/datasheets/`](../references/datasheets)
for the specifics.

All grounds are common. "Active-low" inputs sit behind the RP2's internal
pull-ups (enabled in firmware) — wire the switch between the pin and GND.

---

## Game console (RP2040)

- **MCU:** original Raspberry Pi Pico (RP2040).
- **Display:** ST7789 240×240 LCD, write-only 8-pin module (no MISO, no
  TE) on SPI0, `references/datasheets/ST7789V.pdf` and
  `references/datasheets/M154-240240-RGB.pdf`.
- **Audio:** MAX98357A I2S mono amp (`references/datasheets/max98357.pdf`).
- **Light:** two WS2811 RGB LEDs, chained.
- **Input:** two 5-way joysticks (4 directions + press).

### Full GPIO map

| GPIO | Peripheral | Signal                     |
| ---- | ---------- | -------------------------- |
| GP2  | Joystick A | left                       |
| GP3  | Joystick A | up                         |
| GP4  | Joystick A | down                       |
| GP5  | Joystick A | right                      |
| GP6  | Joystick A | press (center push)        |
| GP7  | Joystick B | left                       |
| GP8  | Joystick B | up                         |
| GP9  | Joystick B | down                       |
| GP10 | Joystick B | right                      |
| GP11 | Joystick B | press                      |
| GP12 | WS2811     | data in (first LED)        |
| GP13 | MAX98357A  | BCLK (bit clock)           |
| GP14 | MAX98357A  | LRCLK (word select)        |
| GP15 | MAX98357A  | DIN (serial data)          |
| GP16 | ST7789     | DC (data/command)          |
| GP17 | ST7789     | CS (chip select)           |
| GP18 | ST7789     | SCK (SPI clock)            |
| GP19 | ST7789     | SDA (SPI MOSI)             |
| GP20 | ST7789     | RES (reset)                |
| GP21 | ST7789     | BLK (backlight enable)     |

### Joysticks

Each stick reports five contacts in this bit order — up, down, left,
right, press. They are **active-low** (internal pull-ups on); a press on
**either** stick's center counts as the action button.

- Joystick A: up = GP3, down = GP4, left = GP2, right = GP5, press = GP6.
- Joystick B: up = GP8, down = GP9, left = GP7, right = GP10, press = GP11.

Wire each contact between its GPIO and GND; connect the stick's common to
GND. (The roles are deliberately not in GPIO order — follow the table.)

### Display (ST7789, SPI0)

A single device holds CS low permanently, and the panel is driven in
**SPI mode 3**. Power the module from **3.3 V** (the Pico's `3V3` pin).

| ST7789 pin | Pico          |
| ---------- | ------------- |
| VCC        | 3V3           |
| GND        | GND           |
| SCK / SCL  | GP18          |
| SDA / MOSI | GP19          |
| DC         | GP16          |
| CS         | GP17          |
| RES        | GP20          |
| BLK        | GP21          |

### Audio (MAX98357A, I2S)

| MAX98357A | Pico / notes                                             |
| --------- | -------------------------------------------------------- |
| BCLK      | GP13                                                     |
| LRC       | GP14                                                     |
| DIN       | GP15                                                     |
| VIN       | 3.3–5 V                                                  |
| GND       | GND                                                      |
| SD (mode) | strap high → output = (L+R)/2 (mono)                     |
| GAIN      | strap per the datasheet for your speaker                 |
| +/−       | 4–8 Ω speaker                                            |

Note: the amp's LRCLK only accepts 8/16/32/44.1/48/88.2/96 kHz — **not
22.05 kHz**. The firmware clamps its sample rate accordingly.

### LEDs (WS2811)

Two WS2811 pixels chained; data enters the first pixel on **GP12**, and
its DOUT feeds the second. Wire order is **GRB**. Power the pixels from
**5 V** (`VBUS`) and share GND with the Pico. RP2 GPIO is 3.3 V logic; for
5 V pixels over anything but a short lead, add a level shifter on the data
line or run the pixels closer to 3.7 V.

---

## Presentation console (Adafruit Feather RP2350)

- **MCU:** Adafruit Feather RP2350 with PSRAM (RP2350A, 8 MiB flash, 8 MiB
  QSPI PSRAM on QMI CS1 = GPIO8). See
  `references/datasheets/adafruit-feather-rp2350.pdf`.
- **Display:** HDMI/DVI over the board's **HSTX 22-pin connector**.
- **Slides:** delivered over **USB**; no display-side storage is
  required. Nothing on this board is served by the ARM after boot — it
  is held in reset once the machine starts (`target/firmware`).

### HDMI (HSTX)

The Feather exposes HSTX on **GPIO12–19** through its 22-pin FPC
connector. Plug an Adafruit DVI/HDMI adapter into that connector and run
an HDMI cable to the display — there is no discrete wiring to do. The DMA
machine scans the SRAM framebuffer out through the HSTX FIFO at 640×480;
`clk_hstx` rides the USB PLL so video timing is independent of the
300 MHz machine overclock.

No user action is needed for the overclock or PSRAM: the firmware raises
`VREG`, divides `clk_peri` back into spec, and re-runs the PSRAM CS1 setup
itself (the RP2350 "silicon laws" are handled in firmware).

### SD card (optional, SPI0)

The presentation build streams slides over USB, so an SD card is optional
— it is used by the filesystem and flash-calibration experiments. When
fitted, the reader is on SPI0:

| SD (SPI) | Feather GPIO |
| -------- | ------------ |
| SCK      | GP22         |
| MOSI     | GP23         |
| MISO     | GP20         |
| CS       | GP10         |

Add ~10 kΩ pull-ups to 3.3 V on CS (and on MISO / the unused DAT lines)
as the SD SPI convention requires; power the card at 3.3 V.

### Power

Power the Feather over USB-C, or a LiPo on the JST connector (the board
charges it). The HDMI adapter and SD card run from the board's 3.3 V rail.

---

For turning these boards into running firmware, see
[building-firmware.md](building-firmware.md).
