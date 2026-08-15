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

// tprog is a tiny in-test assembler for hand-built block programs. Vars
// are bump-allocated SRAM words; blocks are emitted sequentially from
// progBase. Forward references are resolved by allocating a word first and
// patching it with set() once the target address is known.
type tprog struct {
	t       *testing.T
	m       *emu.Machine
	cfg     emu.FetchExecConfig
	pc      uint32
	varAddr uint32
	bucket  uint32 // discard target for sniffed pass-through moves
	done    uint32 // completion flag, watched by run()
}

func newProg(t *testing.T) *tprog {
	t.Helper()
	p := &tprog{
		t:       t,
		m:       emu.NewMachine(),
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
	ctrl := p.cfg.ExecCtrl()
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
	p.m.Poke32(emu.SniffCtrlAddr, emu.SniffCtrlEN|emu.SniffCtrlDmach(p.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
	p.m.Poke32(emu.SniffDataAddr, 0)
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
	m := emu.NewMachine()
	src, dst := uint32(0x20001000), uint32(0x20002000)
	for i := uint32(0); i < 8; i++ {
		m.Poke32(src+4*i, 0xA0A0_0000+i)
	}
	m.Poke32(emu.ChanRegAddr(0, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(0, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(0, emu.OffTransCount), 8)
	m.Poke32(emu.ChanRegAddr(0, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlIncrRead|emu.CtrlIncrWrite|emu.CtrlTreq(emu.TreqPermanent)|emu.CtrlChainTo(0))

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
}

func TestAtomicAliases(t *testing.T) {
	m := emu.NewMachine()
	m.Poke32(emu.SniffDataAddr, 0xF0F0_1234)
	m.Poke32(emu.SniffDataSetAddr, 0x0000_000F)
	if got := m.Peek32(emu.SniffDataAddr); got != 0xF0F0_123F {
		t.Errorf("after SET: %#x", got)
	}
	m.Poke32(emu.SniffDataClrAddr, 0xF000_0000)
	if got := m.Peek32(emu.SniffDataAddr); got != 0x00F0_123F {
		t.Errorf("after CLR: %#x", got)
	}
	m.Poke32(emu.SniffDataXORAddr, 0xFFFF_FFFF)
	if got := m.Peek32(emu.SniffDataAddr); got != 0xFF0F_EDC0 {
		t.Errorf("after XOR: %#x", got)
	}
}

// --- Fetch/execute machine: ALU idioms (prompts/overview.md §2) ---

func TestAdd(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	a, b, r := p.word(0x1111), p.word(0x2222), p.word(0)
	sniff := emu.SniffDataAddr

	p.move(a, sniff)                       // load accumulator
	p.move(b, p.bucket, emu.CtrlSniffEn)   // pass through sniffer: adds
	p.move(sniff, r)                       // store
	p.epilogue()

	p.run()
	p.expect(r, 0x3333, "a+b")
}

func TestLogicOps(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	const A, B = 0x0F0F_3355, 0x00FF_0FF0
	va, vb := p.word(A), p.word(B)
	notA := p.word(^uint32(A))
	rOr, rAnd, rXor := p.word(0), p.word(0), p.word(0)
	sniff := emu.SniffDataAddr

	p.move(vb, sniff)
	p.move(va, emu.SniffDataSetAddr) // B | A
	p.move(sniff, rOr)

	p.move(vb, sniff)
	p.move(notA, emu.SniffDataClrAddr) // B &^ ^A == B & A
	p.move(sniff, rAnd)

	p.move(vb, sniff)
	p.move(va, emu.SniffDataXORAddr) // B ^ A
	p.move(sniff, rXor)
	p.epilogue()

	p.run()
	p.expect(rOr, A|B, "or")
	p.expect(rAnd, A&B, "and")
	p.expect(rXor, A^B, "xor")
}

func TestSubtract(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	const A, B = 1000, 250
	va, vb, r := p.word(A), p.word(B), p.word(0)
	allOnes, one := p.word(0xFFFF_FFFF), p.word(1)
	sniff := emu.SniffDataAddr

	p.move(vb, sniff)
	p.move(allOnes, emu.SniffDataXORAddr)  // ~B
	p.move(one, p.bucket, emu.CtrlSniffEn) // ~B + 1 == -B
	p.move(va, p.bucket, emu.CtrlSniffEn)  // A - B
	p.move(sniff, r)
	p.epilogue()

	p.run()
	p.expect(r, A-B, "a-b")
}

func TestMultiplyByConstant(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	v, r := p.word(321), p.word(0)
	zero := p.word(0)
	sniff := emu.SniffDataAddr

	p.move(zero, sniff)
	// Pass v through the sniffer 4 times without incrementing: 4*v.
	p.emit(v, p.bucket, 4, p.cfg.ExecCtrl()|emu.CtrlSniffEn)
	p.move(sniff, r)
	p.epilogue()

	p.run()
	p.expect(r, 4*321, "4*v")
}

func TestShiftLeft(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	v, r := p.word(0x0123_4567), p.word(0)
	sniff := emu.SniffDataAddr

	p.move(v, sniff)
	p.move(v, p.bucket, emu.CtrlSniffEn) // v+v == v<<1
	p.move(sniff, r)
	p.epilogue()

	p.run()
	p.expect(r, 0x0123_4567<<1, "v<<1")
}

// --- Control flow ---

func TestUnconditionalJump(t *testing.T) {
	p := newProg(t)
	r := p.word(0)
	poison, good := p.word(0xDEAD), p.word(0xC0DE)

	target := p.word(0)      // patched below
	p.move(target, emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr))
	p.move(poison, r)        // must be skipped
	p.set(target, p.here())
	p.move(good, r)
	p.epilogue()

	p.run()
	p.expect(r, 0xC0DE, "result")
}

// TestConditionalJump implements the paper's jump-on-negative idiom: BSWAP
// moves the sign bit into bit 7, CLR isolates bit 4 (0 or 16 == one block),
// the sniffer adds the trampoline base, and the result is pushed into the
// PC. Both data outcomes jump; the two trampoline slots dispatch onward.
func TestConditionalJump(t *testing.T) {
	for name, tc := range map[string]struct {
		input uint32
		want  uint32
	}{
		"positive": {input: 5, want: 0x505},
		"zero":     {input: 0, want: 0x505},
		"negative": {input: ^uint32(5) + 1 /* -5 */, want: 0x909},
	} {
		t.Run(name, func(t *testing.T) {
			p := newProg(t)
			p.sniffSum()
			v := p.word(tc.input)
			r := p.word(0)
			mask := p.word(0xFFFF_FFEF)
			trampBase := p.word(0) // patched: address of trampoline slot 0
			posMark, negMark := p.word(0x505), p.word(0x909)
			sniff := emu.SniffDataAddr
			pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

			p.move(v, sniff, emu.CtrlBswap)       // sign bit -> bit 7 (bits 4-6 too)
			p.move(mask, emu.SniffDataClrAddr)    // isolate bit 4: 0 or 16
			p.move(trampBase, p.bucket, emu.CtrlSniffEn)
			p.move(sniff, pc)                     // jump to slot 0 or slot 1

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
}

// --- Peripherals ---

func TestGPIO(t *testing.T) {
	p := newProg(t)
	pinHi, pinLo := p.word(0x3300), p.word(0x3200)
	gpio2Ctrl := emu.IOBank0Base + 2*8 + 4

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
}

func TestHalt(t *testing.T) {
	p := newProg(t)
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
}

// TestPacedLoop runs a counter loop throttled by pacing timer 3 and checks
// the iteration rate is timer-bound, not machine-bound.
func TestPacedLoop(t *testing.T) {
	p := newProg(t)
	p.sniffSum()
	counter, one := p.word(0), p.word(1)
	entry := p.word(progBase)
	sniff := emu.SniffDataAddr
	pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

	p.move(counter, sniff)
	p.move(one, p.bucket, emu.CtrlSniffEn)
	p.move(sniff, counter)
	// Loop back, but gated on timer 3: X=1, Y=64 -> one pass per 64 cycles.
	// Note: TREQ is a field, not a flag — the ctrl word is built from
	// scratch because OR-ing over TREQ=permanent (all ones) cannot work.
	p.emit(entry, pc, 1,
		emu.CtrlEN|emu.CtrlSize32|emu.CtrlTreq(emu.TreqTimer3)|emu.CtrlChainTo(p.cfg.Fix)|emu.CtrlIRQQuiet)

	p.m.Poke32(emu.DMABase+emu.OffTimer0+12, 1<<16|64)
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
}

// --- Approach B (prompts/overview.md §3.2): hardware vector patching ---

// TestInterruptDispatch builds the dispatcher/injector mechanism end to
// end: a main loop with a safepoint that jumps indirectly through
// dispatch_target, an injector channel armed on an external DREQ, and an
// ISR that acknowledges, re-arms, and returns. The injector carries
// HIGH_PRIORITY so it wins arbitration over the 3-channel machine.
func TestInterruptDispatch(t *testing.T) {
	p := newProg(t)
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
	sniff := emu.SniffDataAddr
	pc := emu.ChanRegAddr(p.cfg.Fetch, emu.OffReadAddr)

	// Main loop: counter++ then a safepoint.
	p.move(counter, sniff)
	p.move(one, p.bucket, emu.CtrlSniffEn)
	p.move(sniff, counter)
	p.move(loopConst, irqResume) // resume address == loop start
	p.move(dispatch, pc)         // indirect jump through dispatch_target

	thunk := p.here()
	p.move(irqResume, pc) // resume_thunk: fall back into the program
	p.set(dispatch, thunk)
	p.set(thunkConst, thunk)

	p.set(isrEntry, p.here())
	p.move(one, isrFlag)          // the ISR's observable work
	p.move(thunkConst, dispatch)  // EOI: restore the dispatcher
	p.move(rearm, emu.ChanRegAddr(injCh, emu.OffAl1TransCountTrig)) // re-arm injector
	p.move(irqResume, pc)         // return from interrupt

	// Injector: one 32-bit transfer isrEntry -> dispatch, paced by an
	// external DREQ, high priority so it cannot be starved.
	injCtrl := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32 |
		emu.CtrlTreq(emu.DreqPIO0RX0) | emu.CtrlChainTo(injCh) | emu.CtrlIRQQuiet
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
	p.m.PulseDREQ(emu.DreqPIO0RX0)
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
	p.m.PulseDREQ(emu.DreqPIO0RX0)
	res, err = p.m.Run(emu.RunConfig{MaxCycles: 3000, WatchWrites: []uint32{isrFlag}})
	if err != nil {
		t.Fatal(err)
	}
	if res.Reason != emu.StopWatch {
		t.Fatalf("second interrupt not delivered: %+v", res)
	}
}

// TestCRCDeterminism pins the sniffer CRC behaviour: identical runs must
// produce identical accumulators (exact hardware bit order is calibrated
// against real silicon in the Phase 0 HIL tests).
func TestCRCDeterminism(t *testing.T) {
	run := func() uint32 {
		p := newProg(t)
		p.m.Poke32(emu.SniffCtrlAddr,
			emu.SniffCtrlEN|emu.SniffCtrlDmach(p.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcCRC32))
		p.m.Poke32(emu.SniffDataAddr, 0xFFFF_FFFF)
		data := p.word(0x1234_5678)
		p.emit(data, p.bucket, 3, p.cfg.ExecCtrl()|emu.CtrlSniffEn)
		p.epilogue()
		p.run()
		return p.m.Peek32(emu.SniffDataAddr)
	}
	a, b := run(), run()
	if a != b {
		t.Fatalf("CRC not deterministic: %#x vs %#x", a, b)
	}
	if a == 0xFFFF_FFFF {
		t.Fatal("CRC accumulator did not advance")
	}
}
