package emu_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// readPair reads TIMERAWH and TIMERAWL the way software must: two
// separate bus accesses, no atomicity between them.
func readRawH(t *testing.T, m *emu.Machine, v *emu.Variant) uint32 {
	t.Helper()
	x, err := m.Read(v.TimerRawH(), 4)
	if err != nil {
		t.Fatalf("TIMERAWH: %v", err)
	}
	return x
}

func readRawL(t *testing.T, m *emu.Machine, v *emu.Variant) uint32 {
	t.Helper()
	x, err := m.Read(v.TimerRawL, 4)
	if err != nil {
		t.Fatalf("TIMERAWL: %v", err)
	}
	return x
}

// TestTimerRawModel pins the cycles-to-microseconds mapping on both
// SKUs and both models. The honest numbers are the ones the scheduler
// tick implies: 15000 cycles is one 100 us quantum, so 15000 cycles
// must read as exactly 100 us.
func TestTimerRawModel(t *testing.T) {
	cases := []struct {
		name    string
		model   emu.TimerModel
		cycle   uint64
		wantLo  uint32
		wantHi  uint32
		comment string
	}{
		{name: "zero value is honest", cycle: 15000, wantLo: 100},
		{name: "honest/one tick", model: emu.TimerHonest, cycle: 15000, wantLo: 100},
		{name: "honest/zero", model: emu.TimerHonest, cycle: 0, wantLo: 0},
		{name: "honest/truncates", model: emu.TimerHonest, cycle: 149, wantLo: 0},
		{name: "honest/one us", model: emu.TimerHonest, cycle: 150, wantLo: 1},
		{name: "honest/one second", model: emu.TimerHonest, cycle: 150 * 1000000, wantLo: 1000000},
		// The 32-bit low word wraps at 2^32 us (71.6 minutes of
		// machine time, 6.4e11 cycles) and the high word takes over.
		{name: "honest/at the wrap", model: emu.TimerHonest,
			cycle: 150 * (1 << 32), wantLo: 0, wantHi: 1},
		{name: "honest/just under the wrap", model: emu.TimerHonest,
			cycle: 150*(1<<32) - 150, wantLo: 0xFFFFFFFF, wantHi: 0},
		{name: "honest/past the wrap", model: emu.TimerHonest,
			cycle: 150*(1<<32) + 150*7, wantLo: 7, wantHi: 1},
		// The gamepico model: 256 "us" per cycle, so a 120 ms panel
		// reset is waited out in under 500 cycles.
		{name: "freerun/one cycle", model: emu.TimerFreeRun, cycle: 1, wantLo: 256},
		{name: "freerun/panel reset", model: emu.TimerFreeRun, cycle: 469, wantLo: 120064},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			for _, v := range emu.Variants {
				m := emu.NewMachine(v)
				m.Timer = tc.model
				m.Cycle = tc.cycle
				if got := readRawL(t, m, v); got != tc.wantLo {
					t.Errorf("%s TIMERAWL at cycle %d = %d, want %d",
						v.Name, tc.cycle, got, tc.wantLo)
				}
				if got := readRawH(t, m, v); got != tc.wantHi {
					t.Errorf("%s TIMERAWH at cycle %d = %d, want %d",
						v.Name, tc.cycle, got, tc.wantHi)
				}
			}
		})
	}
}

// TestTimerRawHAddress: TIMERAWH is at +0x24, BELOW TIMERAWL at +0x28.
// +0x2C is DBGPAUSE — a driver that reached there for the high word
// would read a debug-control register and call it time.
func TestTimerRawHAddress(t *testing.T) {
	for _, v := range emu.Variants {
		if got, want := v.TimerRawH(), v.TimerRawL-4; got != want {
			t.Errorf("%s TIMERAWH = %#x, want %#x", v.Name, got, want)
		}
		if v.TimerRawL&0xFF != 0x28 {
			t.Errorf("%s TIMERAWL = %#x, want block offset 0x28", v.Name, v.TimerRawL)
		}
	}
}

// TestTimerRawCoherentRead exercises the high-low-high read the
// kernel's wall_now() performs (target/xv6/dma/kproc.c), with the low
// word wrapping in the middle of it. The naive pair — read high, read
// low, keep both — reports a value 2^32 us wrong right at the wrap;
// the retry catches it, and one retry is always enough.
func TestTimerRawCoherentRead(t *testing.T) {
	v := emu.RP2350
	// The cycle at which the microsecond counter's low word rolls
	// over, and one microsecond either side of it.
	const wrap = uint64(emu.DefaultCyclesPerUS) * (1 << 32)

	for _, tc := range []struct {
		name string
		// cycles is the machine cycle each successive bus read
		// observes, last value repeating: the emulator standing in
		// for time passing INSIDE a multi-word read.
		cycles         []uint64
		wantHi, wantLo uint32
		wantReads      int
	}{
		{
			name:   "no wrap",
			cycles: []uint64{wrap - 300},
			wantHi: 0, wantLo: 0xFFFFFFFE, wantReads: 3,
		},
		{
			// The dangerous interleaving: high reads 0, the counter
			// wraps, low reads 0. Pairing those reports 0 us — 71.6
			// minutes in the past.
			name:   "wrap between the high and low reads",
			cycles: []uint64{wrap - 150, wrap},
			wantHi: 1, wantLo: 0, wantReads: 5,
		},
		{
			// A wrap after the low read is wrong the other way
			// (high 1 over low 0xFFFFFFFF: 71.6 minutes ahead); the
			// closing high read is what notices.
			name:   "wrap between the low and closing high reads",
			cycles: []uint64{wrap - 150, wrap - 150, wrap},
			wantHi: 1, wantLo: 0, wantReads: 5,
		},
	} {
		t.Run(tc.name, func(t *testing.T) {
			m := emu.NewMachine(v)
			reads := 0
			at := func() {
				i := reads
				if i >= len(tc.cycles) {
					i = len(tc.cycles) - 1
				}
				m.Cycle = tc.cycles[i]
			}
			// wall_now(), transcribed: h = RAWH; for { l = RAWL;
			// h2 = RAWH; if h2 == h { done }; h = h2 }.
			at()
			h := readRawH(t, m, v)
			reads++
			var lo uint32
			for pass := 1; ; pass++ {
				at()
				lo = readRawL(t, m, v)
				reads++
				at()
				h2 := readRawH(t, m, v)
				reads++
				if h2 == h {
					break
				}
				h = h2
				if pass > 1 {
					t.Fatal("high-low-high did not settle on the second pass")
				}
			}
			if h != tc.wantHi || lo != tc.wantLo {
				t.Errorf("coherent read = (%d, %#x), want (%d, %#x)",
					h, lo, tc.wantHi, tc.wantLo)
			}
			if reads != tc.wantReads {
				t.Errorf("took %d bus reads, want %d", reads, tc.wantReads)
			}
			// And the naive pair, which is what the retry exists to
			// reject: on the wrapping cases it must disagree.
			if len(tc.cycles) > 1 {
				m.Cycle = tc.cycles[0]
				nh := readRawH(t, m, v)
				m.Cycle = tc.cycles[len(tc.cycles)-1]
				nl := readRawL(t, m, v)
				if uint64(nh)<<32|uint64(nl) == uint64(tc.wantHi)<<32|uint64(tc.wantLo) {
					t.Error("the naive high-then-low read agreed with the " +
						"coherent one; this case does not test anything")
				}
			}
		})
	}
}
