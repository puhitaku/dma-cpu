package emu_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/emu"
)

const (
	progBase    = 0x20000000
	varBase     = 0x20010000
	scratchAddr = 0x2003FF00
)

// forEachVariant runs a golden test on every supported SKU: the machine
// idioms must work identically even though the encodings differ.
func forEachVariant(t *testing.T, fn func(t *testing.T, v *emu.Variant)) {
	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) { fn(t, v) })
	}
}

// tprog is a tiny in-test assembler for hand-built block programs. Vars
// are bump-allocated SRAM words; blocks are emitted sequentially from
// progBase. Forward references are resolved by allocating a word first and
// patching it with set() once the target address is known.
type tprog struct {
	t       *testing.T
	m       *emu.Machine
	v       *emu.Variant
	cfg     emu.FetchExecConfig
	pc      uint32
	varAddr uint32
	bucket  uint32 // discard target for sniffed pass-through moves
	done    uint32 // completion flag, watched by run()
}

func newProg(t *testing.T, v *emu.Variant) *tprog {
	t.Helper()
	p := &tprog{
		t:       t,
		m:       emu.NewMachine(v),
		v:       v,
		cfg:     emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Entry: progBase, Scratch: scratchAddr},
		pc:      progBase,
		varAddr: varBase,
	}
	p.bucket = p.word(0)
	p.done = p.word(0)
	return p
}

func (p *tprog) word(v uint32) uint32 {
	a := p.varAddr
	p.varAddr += 4
	p.m.Poke32(a, v)
	return a
}

func (p *tprog) set(addr, v uint32) { p.m.Poke32(addr, v) }

func (p *tprog) here() uint32 { return p.pc }

func (p *tprog) emit(read, write, count, ctrl uint32) uint32 {
	addr := p.pc
	p.pc = p.m.WriteBlocks(p.pc, []emu.Block{emu.BuildBlock(read, write, count, ctrl)})
	return addr
}

// move emits a single 32-bit copy from src to dst, with optional extra CTRL
// bits OR-ed onto the standard exec control word.
func (p *tprog) move(src, dst uint32, extra ...uint32) uint32 {
	ctrl := p.cfg.ExecCtrl(p.v)
	for _, e := range extra {
		ctrl |= e
	}
	return p.emit(src, dst, 1, ctrl)
}

// jump emits an unconditional jump: the target address is interned as a
// literal and copied into the fetch channel's READ_ADDR (the PC).
func (p *tprog) jump(target uint32) uint32 {
	return p.move(p.word(target), emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr))
}

// epilogue emits "set done flag, then halt on an all-zero block".
func (p *tprog) epilogue() {
	p.move(p.word(1), p.done)
	p.emit(0, 0, 0, 0) // null trigger: HALT
}

// sniffSum points the sniffer at the exec channel in SUM (accumulate) mode.
func (p *tprog) sniffSum() {
	p.m.Poke32(p.v.SniffCtrlAddr(),
		emu.SniffCtrlEN|emu.SniffCtrlDmach(p.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
	p.m.Poke32(p.v.SniffDataAddr(), 0)
}

func (p *tprog) start() {
	p.t.Helper()
	if err := emu.SetupFetchExec(p.m, p.cfg); err != nil {
		p.t.Fatal(err)
	}
}

// run starts the machine and expects it to reach the epilogue.
func (p *tprog) run() {
	p.t.Helper()
	p.start()
	res, err := p.m.Run(emu.RunConfig{MaxCycles: 100_000, WatchWrites: []uint32{p.done}})
	if err != nil {
		p.t.Fatal(err)
	}
	if res.Reason != emu.StopWatch {
		p.t.Fatalf("machine did not reach epilogue: %+v", res)
	}
}

func (p *tprog) expect(addr, want uint32, what string) {
	p.t.Helper()
	if got := p.m.Peek32(addr); got != want {
		p.t.Errorf("%s = %#x, want %#x", what, got, want)
	}
}

// --- Raw channel behaviour (no fetch/execute machine) ---

func TestPlainCopy(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m := emu.NewMachine(v)
		src, dst := uint32(0x20001000), uint32(0x20002000)
		for i := uint32(0); i < 8; i++ {
			m.Poke32(src+4*i, 0xA0A0_0000+i)
		}
		m.Poke32(emu.ChanRegAddr(0, emu.OffReadAddr), src)
		m.Poke32(emu.ChanRegAddr(0, emu.OffWriteAddr), dst)
		m.Poke32(emu.ChanRegAddr(0, emu.OffTransCount), 8)
		m.Poke32(emu.ChanRegAddr(0, emu.OffCtrlTrig),
			emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|v.CtrlIncrWrite|
				v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(0))

		res, err := m.Run(emu.RunConfig{})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopIdle {
			t.Fatalf("expected idle, got %+v", res)
		}
		for i := uint32(0); i < 8; i++ {
			if got := m.Peek32(dst + 4*i); got != 0xA0A0_0000+i {
				t.Errorf("word %d = %#x", i, got)
			}
		}
		if m.INTR()&1 == 0 {
			t.Error("completion IRQ not raised")
		}
	})
}

func TestAtomicAliases(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m := emu.NewMachine(v)
		m.Poke32(v.SniffDataAddr(), 0xF0F0_1234)
		m.Poke32(v.SniffDataSetAddr(), 0x0000_000F)
		if got := m.Peek32(v.SniffDataAddr()); got != 0xF0F0_123F {
			t.Errorf("after SET: %#x", got)
		}
		m.Poke32(v.SniffDataClrAddr(), 0xF000_0000)
		if got := m.Peek32(v.SniffDataAddr()); got != 0x00F0_123F {
			t.Errorf("after CLR: %#x", got)
		}
		m.Poke32(v.SniffDataXORAddr(), 0xFFFF_FFFF)
		if got := m.Peek32(v.SniffDataAddr()); got != 0xFF0F_EDC0 {
			t.Errorf("after XOR: %#x", got)
		}
	})
}

// --- Fetch/execute machine: ALU idioms (prompts/overview.md §2) ---

func TestAdd(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		a, b, r := p.word(0x1111), p.word(0x2222), p.word(0)
		sniff := v.SniffDataAddr()

		p.move(a, sniff)                   // load accumulator
		p.move(b, p.bucket, v.CtrlSniffEn) // pass through sniffer: adds
		p.move(sniff, r)                   // store
		p.epilogue()

		p.run()
		p.expect(r, 0x3333, "a+b")
	})
}

func TestLogicOps(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		const A, B = 0x0F0F_3355, 0x00FF_0FF0
		va, vb := p.word(A), p.word(B)
		notA := p.word(^uint32(A))
		rOr, rAnd, rXor := p.word(0), p.word(0), p.word(0)
		sniff := v.SniffDataAddr()

		p.move(vb, sniff)
		p.move(va, v.SniffDataSetAddr()) // B | A
		p.move(sniff, rOr)

		p.move(vb, sniff)
		p.move(notA, v.SniffDataClrAddr()) // B &^ ^A == B & A
		p.move(sniff, rAnd)

		p.move(vb, sniff)
		p.move(va, v.SniffDataXORAddr()) // B ^ A
		p.move(sniff, rXor)
		p.epilogue()

		p.run()
		p.expect(rOr, A|B, "or")
		p.expect(rAnd, A&B, "and")
		p.expect(rXor, A^B, "xor")
	})
}

func TestSubtract(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		const A, B = 1000, 250
		va, vb, r := p.word(A), p.word(B), p.word(0)
		allOnes, one := p.word(0xFFFF_FFFF), p.word(1)
		sniff := v.SniffDataAddr()

		p.move(vb, sniff)
		p.move(allOnes, v.SniffDataXORAddr()) // ~B
		p.move(one, p.bucket, v.CtrlSniffEn)  // ~B + 1 == -B
		p.move(va, p.bucket, v.CtrlSniffEn)   // A - B
		p.move(sniff, r)
		p.epilogue()

		p.run()
		p.expect(r, A-B, "a-b")
	})
}

func TestMultiplyByConstant(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		vv, r := p.word(321), p.word(0)
		zero := p.word(0)
		sniff := v.SniffDataAddr()

		p.move(zero, sniff)
		// Pass v through the sniffer 4 times without incrementing: 4*v.
		p.emit(vv, p.bucket, 4, p.cfg.ExecCtrl(v)|v.CtrlSniffEn)
		p.move(sniff, r)
		p.epilogue()

		p.run()
		p.expect(r, 4*321, "4*v")
	})
}

func TestShiftLeft(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		vv, r := p.word(0x0123_4567), p.word(0)
		sniff := v.SniffDataAddr()

		p.move(vv, sniff)
		p.move(vv, p.bucket, v.CtrlSniffEn) // v+v == v<<1
		p.move(sniff, r)
		p.epilogue()

		p.run()
		p.expect(r, 0x0123_4567<<1, "v<<1")
	})
}

// --- Control flow ---

func TestUnconditionalJump(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		r := p.word(0)
		poison, good := p.word(0xDEAD), p.word(0xC0DE)

		target := p.word(0) // patched below
		p.move(target, emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr))
		p.move(poison, r) // must be skipped
		p.set(target, p.here())
		p.move(good, r)
		p.epilogue()

		p.run()
		p.expect(r, 0xC0DE, "result")
	})
}

// TestConditionalJump implements the jump-on-negative idiom: BSWAP moves
// the sign bit into bit 7, CLR isolates bit 4 (0 or 16 == one block), the
// sniffer adds the trampoline base, and the result is pushed into the PC.
// Both data outcomes jump; the two trampoline slots dispatch onward.
func TestConditionalJump(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		for name, tc := range map[string]struct {
			input uint32
			want  uint32
		}{
			"positive": {input: 5, want: 0x505},
			"zero":     {input: 0, want: 0x505},
			"negative": {input: ^uint32(5) + 1 /* -5 */, want: 0x909},
		} {
			t.Run(name, func(t *testing.T) {
				p := newProg(t, v)
				p.sniffSum()
				vv := p.word(tc.input)
				r := p.word(0)
				mask := p.word(0xFFFF_FFEF)
				trampBase := p.word(0) // patched: address of trampoline slot 0
				posMark, negMark := p.word(0x505), p.word(0x909)
				sniff := v.SniffDataAddr()
				pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

				p.move(vv, sniff, v.CtrlBswap)   // sign bit -> bit 7 (bits 4-6 too)
				p.move(mask, v.SniffDataClrAddr()) // isolate bit 4: 0 or 16
				p.move(trampBase, p.bucket, v.CtrlSniffEn)
				p.move(sniff, pc) // jump to slot 0 or slot 1

				posBody, negBody := p.word(0), p.word(0) // patched below
				p.set(trampBase, p.here())
				p.move(posBody, pc) // trampoline slot 0: non-negative
				p.move(negBody, pc) // trampoline slot 1: negative

				p.set(posBody, p.here())
				p.move(posMark, r)
				p.epilogue()

				p.set(negBody, p.here())
				p.move(negMark, r)
				p.epilogue()

				p.run()
				p.expect(r, tc.want, "branch marker")
			})
		}
	})
}

// --- Peripherals ---

func TestGPIO(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		pinHi, pinLo := p.word(v.GPIOOutCtrl(true)), p.word(v.GPIOOutCtrl(false))
		gpio2Ctrl := v.GPIOCtrlAddr(2)

		p.move(pinHi, gpio2Ctrl)
		p.move(pinLo, gpio2Ctrl)
		p.move(pinHi, gpio2Ctrl)
		p.move(pinLo, gpio2Ctrl)
		p.epilogue()

		p.run()
		want := []bool{true, false, true, false}
		if len(p.m.GPIOEvents) != len(want) {
			t.Fatalf("got %d GPIO events, want %d: %+v", len(p.m.GPIOEvents), len(want), p.m.GPIOEvents)
		}
		for i, ev := range p.m.GPIOEvents {
			if ev.Pin != 2 || ev.High != want[i] {
				t.Errorf("event %d: %+v", i, ev)
			}
			if i > 0 && ev.Cycle <= p.m.GPIOEvents[i-1].Cycle {
				t.Errorf("event %d not after event %d", i, i-1)
			}
		}
	})
}

func TestHalt(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		r := p.word(0)
		p.move(p.word(7), r)
		p.emit(0, 0, 0, 0) // halt without touching the done flag

		p.start()
		res, err := p.m.Run(emu.RunConfig{})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopIdle {
			t.Fatalf("expected idle halt, got %+v", res)
		}
		p.expect(r, 7, "result")
	})
}

// TestPacedLoop runs a counter loop throttled by pacing timer 3 and checks
// the iteration rate is timer-bound, not machine-bound.
func TestPacedLoop(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		counter, one := p.word(0), p.word(1)
		entry := p.word(progBase)
		sniff := v.SniffDataAddr()
		pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

		p.move(counter, sniff)
		p.move(one, p.bucket, v.CtrlSniffEn)
		p.move(sniff, counter)
		// Loop back, but gated on timer 3: X=1, Y=64 -> one pass per 64
		// cycles. TREQ is a field, so the ctrl word is built from scratch.
		p.emit(entry, pc, 1,
			emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqTimer3)|v.CtrlChainTo(p.cfg.Fix)|v.CtrlIRQQuiet)

		p.m.Poke32(v.TimerAddr(3), 1<<16|64)
		p.start()
		res, err := p.m.Run(emu.RunConfig{MaxCycles: 6400})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopMaxCycles {
			t.Fatalf("expected max-cycles, got %+v", res)
		}
		got := p.m.Peek32(counter)
		if got < 90 || got > 101 {
			t.Errorf("paced loop ran %d iterations in 6400 cycles, want ~100", got)
		}
	})
}

// --- Approach B (prompts/overview.md §3.2): hardware vector patching ---

// TestInterruptDispatch builds the dispatcher/injector mechanism end to
// end: a main loop with a safepoint that jumps indirectly through
// dispatch_target, an injector channel armed on an external DREQ, and an
// ISR that acknowledges, re-arms, and returns. The injector carries
// HIGH_PRIORITY so it wins arbitration over the 3-channel machine.
func TestInterruptDispatch(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		p := newProg(t, v)
		p.sniffSum()
		const injCh = 3
		counter, one := p.word(0), p.word(1)
		isrFlag := p.word(0)
		dispatch := p.word(0)   // patched: normally &resume_thunk
		irqResume := p.word(0)  // safepoint stores its resume address here
		isrEntry := p.word(0)   // patched: the injector's source operand
		thunkConst := p.word(0) // patched: ISR epilogue restores dispatch from this
		loopConst := p.word(progBase)
		rearm := p.word(1)
		sniff := v.SniffDataAddr()
		pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

		// Main loop: counter++ then a safepoint.
		p.move(counter, sniff)
		p.move(one, p.bucket, v.CtrlSniffEn)
		p.move(sniff, counter)
		p.move(loopConst, irqResume) // resume address == loop start
		p.move(dispatch, pc)         // indirect jump through dispatch_target

		thunk := p.here()
		p.move(irqResume, pc) // resume_thunk: fall back into the program
		p.set(dispatch, thunk)
		p.set(thunkConst, thunk)

		p.set(isrEntry, p.here())
		p.move(one, isrFlag)                                            // the ISR's observable work
		p.move(thunkConst, dispatch)                                    // EOI: restore the dispatcher
		p.move(rearm, emu.ChanRegAddr(injCh, emu.OffAl1TransCountTrig)) // re-arm injector
		p.move(irqResume, pc)                                           // return from interrupt

		// Injector: one 32-bit transfer isrEntry -> dispatch, paced by an
		// external DREQ, high priority so it cannot be starved.
		injCtrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
			v.CtrlTreq(v.DreqPIO0RX0) | v.CtrlChainTo(injCh) | v.CtrlIRQQuiet
		p.m.Poke32(emu.ChanRegAddr(injCh, emu.OffAl1ReadAddr), isrEntry)
		p.m.Poke32(emu.ChanRegAddr(injCh, emu.OffAl1WriteAddr), dispatch)
		p.m.Poke32(emu.ChanRegAddr(injCh, emu.OffTransCount), 1)
		p.m.Poke32(emu.ChanRegAddr(injCh, emu.OffCtrlTrig), injCtrl)

		p.start()

		// Phase 1: no interrupt pending; the loop must spin undisturbed.
		if _, err := p.m.Run(emu.RunConfig{MaxCycles: 3000}); err != nil {
			t.Fatal(err)
		}
		if got := p.m.Peek32(isrFlag); got != 0 {
			t.Fatalf("ISR ran without an interrupt (flag=%#x)", got)
		}
		c1 := p.m.Peek32(counter)
		if c1 == 0 {
			t.Fatal("main loop did not run")
		}

		// Phase 2: fire the interrupt; the ISR must run at the next safepoint.
		p.m.PulseDREQ(v.DreqPIO0RX0)
		res, err := p.m.Run(emu.RunConfig{MaxCycles: 3000, WatchWrites: []uint32{isrFlag}})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopWatch {
			t.Fatalf("ISR did not run: %+v", res)
		}

		// Phase 3: the main loop must have resumed after the ISR.
		if _, err := p.m.Run(emu.RunConfig{MaxCycles: 3000}); err != nil {
			t.Fatal(err)
		}
		c2 := p.m.Peek32(counter)
		if c2 <= c1 {
			t.Fatalf("main loop did not resume after ISR: counter %d -> %d", c1, c2)
		}

		// Phase 4: the injector was re-armed; a second interrupt must deliver.
		p.m.Poke32(isrFlag, 0)
		p.m.PulseDREQ(v.DreqPIO0RX0)
		res, err = p.m.Run(emu.RunConfig{MaxCycles: 3000, WatchWrites: []uint32{isrFlag}})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopWatch {
			t.Fatalf("second interrupt not delivered: %+v", res)
		}
	})
}

// TestCRCDeterminism pins the sniffer CRC behaviour: identical runs must
// produce identical accumulators (exact hardware bit order is calibrated
// against real silicon in the Phase 0 HIL tests).
func TestCRCDeterminism(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		run := func() uint32 {
			p := newProg(t, v)
			p.m.Poke32(v.SniffCtrlAddr(),
				emu.SniffCtrlEN|emu.SniffCtrlDmach(p.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcCRC32))
			p.m.Poke32(v.SniffDataAddr(), 0xFFFF_FFFF)
			data := p.word(0x1234_5678)
			p.emit(data, p.bucket, 3, p.cfg.ExecCtrl(v)|v.CtrlSniffEn)
			p.epilogue()
			p.run()
			return p.m.Peek32(v.SniffDataAddr())
		}
		a, b := run(), run()
		if a != b {
			t.Fatalf("CRC not deterministic: %#x vs %#x", a, b)
		}
		if a == 0xFFFF_FFFF {
			t.Fatal("CRC accumulator did not advance")
		}
	})
}

// --- RP2350-only features ---

// TestChannels12to15 verifies the extra RP2350 channels work and are
// rejected/unmapped on RP2040.
func TestChannels12to15(t *testing.T) {
	m := emu.NewMachine(emu.RP2350)
	v := emu.RP2350
	src, dst := uint32(0x20001000), uint32(0x20002000)
	m.Poke32(src, 0xCAFE)
	m.Poke32(emu.ChanRegAddr(15, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(15, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(15, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(15, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(15))
	if res, err := m.Run(emu.RunConfig{}); err != nil || res.Reason != emu.StopIdle {
		t.Fatalf("run: %+v, %v", res, err)
	}
	if got := m.Peek32(dst); got != 0xCAFE {
		t.Errorf("channel 15 copy = %#x", got)
	}

	// On RP2040 the same registers are unmapped: writes are ignored.
	m40 := emu.NewMachine(emu.RP2040)
	m40.Poke32(emu.ChanRegAddr(15, emu.OffReadAddr), src)
	if got := m40.Peek32(emu.ChanRegAddr(15, emu.OffReadAddr)); got != 0 {
		t.Errorf("rp2040 channel 15 should be unmapped, read %#x", got)
	}
}

// TestTriggerSelf exercises the RP2350 TRANS_COUNT TRIGGER_SELF mode: the
// channel re-triggers itself after each sequence, paced by a timer.
func TestTriggerSelf(t *testing.T) {
	v := emu.RP2350
	m := emu.NewMachine(v)
	src, dst := uint32(0x20001000), uint32(0x20002000)
	m.Poke32(src, 1)
	// One transfer per sequence, mode TRIGGER_SELF, paced by timer 0 so
	// each retrigger waits for the next tick.
	m.Poke32(v.TimerAddr(0), 1<<16|16)
	m.Poke32(emu.ChanRegAddr(6, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(6, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(6, emu.OffTransCount), 0x1<<28|1)
	m.Poke32(emu.ChanRegAddr(6, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqTimer0)|v.CtrlChainTo(6)|v.CtrlIRQQuiet)

	res, err := m.Run(emu.RunConfig{MaxCycles: 160})
	if err != nil {
		t.Fatal(err)
	}
	if res.Reason != emu.StopMaxCycles {
		t.Fatalf("expected still-running, got %+v", res)
	}
	// ~10 sequences in 160 cycles at one per 16 — the channel must still
	// be re-triggering itself, and the IRQ stayed quiet.
	if m.INTR() != 0 {
		t.Errorf("INTR = %#x, want 0 (IRQ_QUIET)", m.INTR())
	}
}

// TestEndless exercises the RP2350 ENDLESS mode: transfers continue until
// CHAN_ABORT with no completion.
func TestEndless(t *testing.T) {
	v := emu.RP2350
	m := emu.NewMachine(v)
	src, dst := uint32(0x20001000), uint32(0x20002000)
	m.Poke32(src, 7)
	m.Poke32(emu.ChanRegAddr(4, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(4, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(4, emu.OffTransCount), 0xF<<28)
	m.Poke32(emu.ChanRegAddr(4, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(4))

	res, err := m.Run(emu.RunConfig{MaxCycles: 100})
	if err != nil {
		t.Fatal(err)
	}
	if res.Reason != emu.StopMaxCycles {
		t.Fatalf("endless channel stopped: %+v", res)
	}
	if m.INTR() != 0 {
		t.Errorf("endless mode must not raise IRQs, INTR = %#x", m.INTR())
	}
	// Abort ends it; the machine then idles.
	m.Poke32(emu.DMABase+0x464, 1<<4) // CHAN_ABORT
	res, err = m.Run(emu.RunConfig{MaxCycles: 100})
	if err != nil {
		t.Fatal(err)
	}
	if res.Reason != emu.StopIdle {
		t.Fatalf("expected idle after abort, got %+v", res)
	}
}

// TestVariantEncodings pins the SKU-specific encodings against datasheet
// values so a refactor cannot silently swap layouts.
func TestVariantEncodings(t *testing.T) {
	v40, v50 := emu.RP2040, emu.RP2350
	if got := v40.CtrlChainTo(2) | v40.CtrlTreq(0x3F) | v40.CtrlIRQQuiet; got != 0x2<<11|0x3F<<15|1<<21 {
		t.Errorf("rp2040 ctrl encoding: %#x", got)
	}
	if got := v50.CtrlChainTo(2) | v50.CtrlTreq(0x3F) | v50.CtrlIRQQuiet; got != 0x2<<13|0x3F<<17|1<<23 {
		t.Errorf("rp2350 ctrl encoding: %#x", got)
	}
	if a := v40.SniffDataAddr(); a != 0x50000438 {
		t.Errorf("rp2040 SNIFF_DATA = %#x", a)
	}
	if a := v50.SniffDataAddr(); a != 0x50000458 {
		t.Errorf("rp2350 SNIFF_DATA = %#x", a)
	}
	if hi := v40.GPIOOutCtrl(true); hi != 0x3300 {
		t.Errorf("rp2040 GPIO high ctrl = %#x, want 0x3300", hi)
	}
	if hi := v50.GPIOOutCtrl(true); hi != 0xF000 {
		t.Errorf("rp2350 GPIO high ctrl = %#x, want 0xf000", hi)
	}
	if a := v50.GPIOCtrlAddr(2); a != 0x40028014 {
		t.Errorf("rp2350 GPIO2_CTRL = %#x", a)
	}
}

// --- Silicon-calibrated behaviours (verified on RP2350 hardware; see
// prompts/004-hw-calibration.md) ---

// A null CTRL_TRIG write zeroes CTRL but still raises the quiet-mode
// null-trigger IRQ based on the pre-write CTRL.
func TestNullCtrlTrigQuietIRQ(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m := emu.NewMachine(v)
		const ch = 8
		quiet := emu.CtrlEN | emu.CtrlSize32 | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(ch) | v.CtrlIRQQuiet
		m.Poke32(emu.ChanRegAddr(ch, emu.OffAl1Ctrl), quiet)
		m.Poke32(emu.ChanRegAddr(ch, emu.OffCtrlTrig), 0) // null trigger
		if m.INTR()&(1<<ch) == 0 {
			t.Error("null CTRL_TRIG on quiet channel must raise IRQ")
		}

		// Non-quiet channel: no IRQ on null trigger.
		m2 := emu.NewMachine(v)
		m2.Poke32(emu.ChanRegAddr(ch, emu.OffAl1Ctrl), quiet&^v.CtrlIRQQuiet)
		m2.Poke32(emu.ChanRegAddr(ch, emu.OffCtrlTrig), 0)
		if m2.INTR()&(1<<ch) != 0 {
			t.Error("null trigger on non-quiet channel must not raise IRQ")
		}
	})
}

// A zero-length sequence completes immediately: completion IRQ (unless
// quiet) and the chain fires.
func TestZeroCountCompletes(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m := emu.NewMachine(v)
		src, dst := uint32(0x20001000), uint32(0x20002000)
		m.Poke32(src, 0x77)
		// Channel 9: copies one word when triggered (armed via chain).
		m.Poke32(emu.ChanRegAddr(9, emu.OffReadAddr), src)
		m.Poke32(emu.ChanRegAddr(9, emu.OffWriteAddr), dst)
		m.Poke32(emu.ChanRegAddr(9, emu.OffTransCount), 1)
		m.Poke32(emu.ChanRegAddr(9, emu.OffAl1Ctrl),
			emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(9)|v.CtrlIRQQuiet)
		// Channel 8: zero-length, loud, chains to 9.
		m.Poke32(emu.ChanRegAddr(8, emu.OffTransCount), 0)
		m.Poke32(emu.ChanRegAddr(8, emu.OffCtrlTrig),
			emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(9))
		if m.INTR()&(1<<8) == 0 {
			t.Error("zero-count completion must raise IRQ on loud channel")
		}
		res, err := m.Run(emu.RunConfig{MaxCycles: 100})
		if err != nil || res.Reason != emu.StopIdle {
			t.Fatalf("run: %+v %v", res, err)
		}
		if got := m.Peek32(dst); got != 0x77 {
			t.Errorf("zero-count chain did not fire: dst=%#x", got)
		}
	})
}

// Banked DREQ credit does not survive into a new trigger: a channel
// triggered after idling next to a running pacing timer still paces from
// the next tick.
func TestCreditClearedOnTrigger(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		m := emu.NewMachine(v)
		src, dst := uint32(0x20001000), uint32(0x20002000)
		m.Poke32(src, 1)
		m.Poke32(v.TimerAddr(0), 1<<16|50) // one pulse per 50 cycles
		m.Poke32(emu.ChanRegAddr(8, emu.OffReadAddr), src)
		m.Poke32(emu.ChanRegAddr(8, emu.OffWriteAddr), dst)
		m.Poke32(emu.ChanRegAddr(8, emu.OffAl1Ctrl),
			emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqTimer0)|v.CtrlChainTo(8)|v.CtrlIRQQuiet)
		// Idle for 10 pulses' worth of cycles, then trigger 4 transfers.
		if _, err := m.Run(emu.RunConfig{MaxCycles: 500}); err != nil {
			t.Fatal(err)
		}
		m.Poke32(emu.ChanRegAddr(8, emu.OffAl1TransCountTrig), 4)
		res, err := m.Run(emu.RunConfig{MaxCycles: 5000})
		if err != nil {
			t.Fatal(err)
		}
		if res.Reason != emu.StopIdle {
			t.Fatalf("expected completion, got %+v", res)
		}
		// Paced: 4 transfers need ~4 timer periods (~200 cycles), not ~0.
		if res.Cycles < 150 {
			t.Errorf("completed in %d cycles — credits were banked across the trigger", res.Cycles)
		}
	})
}
