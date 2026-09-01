package emu

// The TIMER block's free-running microsecond counter, TIMERAWH:TIMERAWL
// (block offsets +0x24 and +0x28 — RP2040 datasheet §4.6.5, RP2350
// §12.8; note the HIGH word sits BELOW the low one, and +0x2C is
// DBGPAUSE, not part of the counter). On silicon this is a real 1 MHz
// counter fed from the watchdog tick and wholly independent of
// clk_sys. Here it is derived from Machine.Cycle through a TimerModel.

// TimerModel maps emulated cycles onto that counter:
//
//	microseconds = Cycle * Mul / Div
//
// The zero value selects TimerHonest, so a machine that says nothing
// gets the mapping its own scheduler tick implies.
type TimerModel struct{ Mul, Div uint64 }

// DefaultCyclesPerUS is the emulated machine's clock, in cycles per
// microsecond. It is not a free choice: every rig that runs a kernel
// arms the scheduler's DMA pacing timer at 15000 cycles for a 100 us
// quantum (host/boards, Board.TickCycles at the 150 MHz family
// default; host/cmd/dmxgen armKernelCh and host/dmacc kernwire_test
// poke exactly that word), so on the emulated machine a microsecond
// IS 150 cycles. A TIMERAWL that reported anything else would
// contradict the tick the same machine delivers — which is how
// wallclock in the xv6 port came to read zero for a 40 ms draw.
//
// Silicon disagrees with the number and that is fine: the feather
// overclocks clk_sys to 300 MHz and dmxgen arms 30000 cycles per
// tick there, while TIMERAWL keeps counting real microseconds off
// its own 1 MHz reference. The two only have to agree in the
// emulator, where one cycle counter stands in for both clocks.
const DefaultCyclesPerUS = 150

// TimerHonest is that mapping: one microsecond per DefaultCyclesPerUS
// emulated cycles.
var TimerHonest = TimerModel{Mul: 1, Div: DefaultCyclesPerUS}

// TimerFreeRun is the deliberately dishonest fast model — 256 "us" per
// emulated cycle — for machines that must outrun their own busy-waits.
// The gamepico program is the whole reason it exists: its panel bring-up
// spins out 280 ms of fixed ST7789 reset delays (target/game/src/lcd.c)
// and its frame loop paces on TIMERAWL (input.c), so an honest timer
// would spend 42M cycles on the panel reset alone and then pace every
// emulated frame at 60 Hz. Nothing in the game reads the counter for
// anything but delay, so the scale is free there; the rigs that want it
// say so (host/dmacc game_test.go, host/cmd/dmxgen buildGame).
var TimerFreeRun = TimerModel{Mul: 256, Div: 1}

// timeUS is the current value of the 64-bit microsecond counter.
func (m *Machine) timeUS() uint64 {
	t := m.Timer
	if t.Div == 0 { // the zero value, and any half-filled struct
		t = TimerHonest
	}
	return m.Cycle * t.Mul / t.Div
}

// timerRead serves TIMERAWL/TIMERAWH. The two halves are read
// separately by software, so a driver that wants a coherent 64-bit
// value has to do the high-low-high dance — see wall_now() in
// target/xv6/dma/kproc.c.
func (m *Machine) timerRead(addr uint32) (uint32, bool) {
	switch addr {
	case m.v.TimerRawL:
		return uint32(m.timeUS()), true
	case m.v.TimerRawH():
		return uint32(m.timeUS() >> 32), true
	}
	return 0, false
}
