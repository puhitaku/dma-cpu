package emu

import (
	"encoding/binary"
	"fmt"
	"io"
)

// GPIOEvent records an output-level change decoded from a write to an
// IO_BANK0 GPIOx_CTRL register (OUTOVER = 0x2 drives low, 0x3 drives
// high; field positions are SKU-specific — see Variant.GPIOOutCtrl).
type GPIOEvent struct {
	Cycle uint64
	Pin   int
	High  bool
}

// Machine is the emulated system: SRAM, the DMA block, a generic MMIO
// backing store for everything else in the peripheral space, and the
// deterministic scheduler. One Step() is one bus-transfer slot ("cycle");
// real transfers take a few system clocks each, so cycle counts are
// proportional to, not equal to, hardware time.
type Machine struct {
	v    *Variant
	sram []byte
	dma  dma

	// mmio backs peripheral registers the emulator has no model for, so DMA
	// programs can use arbitrary SFRs as scratch (a documented idiom).
	// Keyed by the alias-normalized address.
	mmio map[uint32]uint32

	Cycle      uint64
	GPIOEvents []GPIOEvent

	// ConsoleOut collects bytes written to UART0's data register — the
	// DMA machine's stdout (see libc/, Phase 4.5).
	ConsoleOut []byte
	// ConsoleIn feeds UART0 reads — the machine's stdin (Phase 5b): a
	// DR read pops the next byte, and FR's RXFE bit reflects emptiness.
	ConsoleIn []byte
	// TXPace, when nonzero, models the transmit FIFO draining at one
	// byte per TXPace cycles: after a DR write, FR reads TXFF (bit 5)
	// until the pace elapses. Real 115200-baud silicon spends ~87 us
	// per byte — long kernel writes behave very differently from the
	// always-ready default (see prompts/017).
	TXPace  uint64
	lastTX  uint64

	// Flash, when non-nil, is the QSPI flash content, served read-only
	// through the XIP window (flash.go explains why writes are the ARM
	// executor's job).
	Flash []byte

	// TraceW, when non-nil, receives one line per DMA transfer.
	TraceW io.Writer

	watch    map[uint32]bool
	watchHit *uint32
}

// Run termination reasons.
type StopReason string

const (
	StopIdle      StopReason = "idle"       // no channel busy — the machine halted
	StopStalled   StopReason = "stalled"    // busy channels exist but none can ever run without external DREQs
	StopWatch     StopReason = "watch"      // a watched address was written
	StopMaxCycles StopReason = "max-cycles" // cycle budget exhausted
)

type RunResult struct {
	Reason    StopReason
	Cycles    uint64 // cycles consumed by this Run call
	WatchAddr uint32 // valid when Reason == StopWatch
}

// NewMachine creates a machine emulating the given SKU (emu.RP2040 or
// emu.RP2350).
func NewMachine(v *Variant) *Machine {
	m := &Machine{
		v:    v,
		sram: make([]byte, v.SRAMSize),
		mmio: make(map[uint32]uint32),
	}
	m.dma.v = v
	return m
}

// Variant returns the SKU this machine emulates.
func (m *Machine) Variant() *Variant { return m.v }

// --- Bus ---

func (m *Machine) inSRAM(addr uint32, size int) bool {
	return addr >= SRAMBase && addr+uint32(size) <= SRAMBase+uint32(len(m.sram))
}

// aliasOp splits a peripheral-space address into its normalized register
// address and atomic-alias operation (0 = plain, 1 = XOR, 2 = SET, 3 = CLR).
func aliasOp(addr uint32) (norm uint32, op uint32) {
	op = (addr >> 12) & 3
	return addr &^ (3 << 12), op
}

func applyAlias(cur, val, op uint32) uint32 {
	switch op {
	case 1:
		return cur ^ val
	case 2:
		return cur | val
	case 3:
		return cur &^ val
	default:
		return val
	}
}

// Read performs a bus read of size bytes (1, 2, or 4).
func (m *Machine) Read(addr uint32, size int) (uint32, error) {
	if addr%uint32(size) != 0 {
		return 0, fmt.Errorf("unaligned %d-byte read at %#08x", size, addr)
	}
	switch {
	case m.inSRAM(addr, size):
		off := addr - SRAMBase
		switch size {
		case 1:
			return uint32(m.sram[off]), nil
		case 2:
			return uint32(binary.LittleEndian.Uint16(m.sram[off:])), nil
		default:
			return binary.LittleEndian.Uint32(m.sram[off:]), nil
		}
	case addr >= DMABase && addr < DMABase+0x4000:
		norm, _ := aliasOp(addr - DMABase)
		return m.dma.regRead(norm), nil
	case m.Flash != nil && addr >= XIPBase && addr+uint32(size) <= XIPBase+uint32(len(m.Flash)):
		off := addr - XIPBase
		switch size {
		case 1:
			return uint32(m.Flash[off]), nil
		case 2:
			return uint32(binary.LittleEndian.Uint16(m.Flash[off:])), nil
		default:
			return binary.LittleEndian.Uint32(m.Flash[off:]), nil
		}
	case addr >= 0x40000000 && addr < 0x60000000:
		norm, _ := aliasOp(addr)
		switch norm {
		case m.v.UARTDRAddr():
			if len(m.ConsoleIn) == 0 {
				return 0, nil
			}
			b := m.ConsoleIn[0]
			m.ConsoleIn = m.ConsoleIn[1:]
			return uint32(b), nil
		case m.v.UARTFRAddr():
			// RXFE tracks the input queue; TXFF models TXPace.
			var fr uint32
			if len(m.ConsoleIn) == 0 {
				fr |= 1 << 4
			}
			if m.TXPace != 0 && m.Cycle-m.lastTX < m.TXPace {
				fr |= 1 << 5
			}
			return fr, nil
		}
		return m.mmio[norm], nil
	}
	return 0, fmt.Errorf("bus fault: read at %#08x", addr)
}

// FeedConsole appends input bytes for the machine's UART to consume.
func (m *Machine) FeedConsole(s string) { m.ConsoleIn = append(m.ConsoleIn, s...) }

// Write performs a bus write of size bytes, applying atomic-alias semantics
// in the peripheral space. MMIO writes are performed at register (32-bit)
// granularity regardless of size, matching APB behaviour.
func (m *Machine) Write(addr uint32, val uint32, size int) error {
	if addr%uint32(size) != 0 {
		return fmt.Errorf("unaligned %d-byte write at %#08x", size, addr)
	}
	if m.watch != nil && m.watch[addr] {
		a := addr
		m.watchHit = &a
	}
	switch {
	case m.inSRAM(addr, size):
		off := addr - SRAMBase
		switch size {
		case 1:
			m.sram[off] = byte(val)
		case 2:
			binary.LittleEndian.PutUint16(m.sram[off:], uint16(val))
		default:
			binary.LittleEndian.PutUint32(m.sram[off:], val)
		}
		return nil
	case addr >= DMABase && addr < DMABase+0x4000:
		norm, op := aliasOp(addr - DMABase)
		final := applyAlias(m.dma.regRead(norm), val, op)
		m.dma.regWrite(norm, final, val != 0)
		return nil
	case addr >= 0x40000000 && addr < 0x60000000:
		norm, op := aliasOp(addr)
		final := applyAlias(m.mmio[norm], val, op)
		m.mmio[norm] = final
		m.decodeGPIO(norm, final)
		if norm == m.v.UARTDRAddr() {
			m.ConsoleOut = append(m.ConsoleOut, byte(final))
			m.lastTX = m.Cycle
		}
		return nil
	}
	return fmt.Errorf("bus fault: write at %#08x", addr)
}

func (m *Machine) decodeGPIO(normAddr, val uint32) {
	base := m.v.IOBank0Base
	if normAddr < base+4 || normAddr >= base+uint32(m.v.GPIOPins)*8 {
		return
	}
	off := normAddr - base
	if off%8 != 4 { // GPIOx_CTRL registers sit at 8*pin + 4
		return
	}
	switch (val >> m.v.gpioOutoverLSB) & 3 { // OUTOVER field
	case 2:
		m.GPIOEvents = append(m.GPIOEvents, GPIOEvent{m.Cycle, int(off / 8), false})
	case 3:
		m.GPIOEvents = append(m.GPIOEvents, GPIOEvent{m.Cycle, int(off / 8), true})
	}
}

// --- Host (loader/test) accessors: not bus transactions, no side effects
// beyond the raw store, but MMIO writes go through the bus path so register
// semantics (e.g. triggers) apply. ---

func (m *Machine) Poke32(addr, val uint32) {
	if err := m.Write(addr, val, 4); err != nil {
		panic(err)
	}
}

func (m *Machine) Peek32(addr uint32) uint32 {
	v, err := m.Read(addr, 4)
	if err != nil {
		panic(err)
	}
	return v
}

// LoadBytes copies a raw image into memory at addr (SRAM only).
func (m *Machine) LoadBytes(addr uint32, data []byte) error {
	if !m.inSRAM(addr, len(data)) {
		return fmt.Errorf("image [%#08x, +%#x) outside SRAM", addr, len(data))
	}
	copy(m.sram[addr-SRAMBase:], data)
	return nil
}

// WriteBlocks places control blocks contiguously at addr and returns the
// address just past the last block.
func (m *Machine) WriteBlocks(addr uint32, blocks []Block) uint32 {
	for _, b := range blocks {
		for i, w := range b {
			m.Poke32(addr+uint32(4*i), w)
		}
		addr += 16
	}
	return addr
}

// PulseDREQ injects one external DREQ pulse (e.g. a PIO RX-FIFO push).
func (m *Machine) PulseDREQ(dreq uint32) { m.dma.pulseDreq(dreq) }

// INTR returns the raw DMA interrupt status register.
func (m *Machine) INTR() uint32 { return m.dma.intr }

// --- Scheduler ---

// step executes one cycle: tick pacing timers, then let the
// highest-priority runnable channel issue one transfer. Returns whether any
// transfer was issued.
func (m *Machine) step() (bool, error) {
	m.Cycle++
	m.dma.tickTimers()

	chIdx := -1
	for pass := 0; pass < 2 && chIdx < 0; pass++ {
		for i := 0; i < m.v.NChannels; i++ {
			c := &m.dma.ch[i]
			hp := c.ctrl&CtrlHighPriority != 0
			if (pass == 0) == hp && m.dma.runnable(i) {
				chIdx = i
				break
			}
		}
	}
	if chIdx < 0 {
		return false, nil
	}
	return true, m.transfer(chIdx)
}

// transfer issues one datum move for the given channel and handles
// completion, chaining, and the sniffer.
func (m *Machine) transfer(chIdx int) error {
	c := &m.dma.ch[chIdx]
	if m.v.ctrlTreqSel(c.ctrl) != TreqPermanent && c.credit > 0 {
		c.credit--
	}
	size := 1 << ctrlDataSize(c.ctrl)
	if size == 8 { // DATA_SIZE == 0x3 is reserved
		return fmt.Errorf("ch%d: reserved DATA_SIZE in CTRL %#08x", chIdx, c.ctrl)
	}

	datum, err := m.Read(c.readAddr, size)
	if err != nil {
		return fmt.Errorf("ch%d: %w", chIdx, err)
	}
	if c.ctrl&m.v.CtrlBswap != 0 {
		datum = bswap(datum, size)
	}
	writeAddr := c.writeAddr
	if err := m.Write(writeAddr, datum, size); err != nil {
		return fmt.Errorf("ch%d: %w", chIdx, err)
	}
	if c.ctrl&m.v.CtrlSniffEn != 0 {
		m.dma.sniff(chIdx, datum, size)
	}
	if m.TraceW != nil {
		fmt.Fprintf(m.TraceW, "%8d ch%-2d %#08x -> %#08x  %#0*x\n",
			m.Cycle, chIdx, c.readAddr, writeAddr, 2*size+2, datum)
	}

	if c.ctrl&CtrlIncrRead != 0 {
		c.readAddr = m.v.incrRing(c.readAddr, uint32(size), c.ctrl, false)
	}
	if c.ctrl&m.v.CtrlIncrWrite != 0 {
		c.writeAddr = m.v.incrRing(c.writeAddr, uint32(size), c.ctrl, true)
	}

	// NOTE: the transfer above may have re-written this channel's own
	// registers (self-modification is legal on this machine); re-fetch the
	// channel pointer state via c, which aliases the live struct.
	if c.mode == transModeEndless {
		return nil // ENDLESS (RP2350): never decrements, never completes
	}
	if c.remaining > 0 {
		c.remaining--
	}
	if c.remaining == 0 && c.busy {
		m.dma.complete(chIdx)
	}
	return nil
}

// incrRing advances an address by size (reverse-decrement on SKUs that
// have INCR_*_REV) with optional ring wrapping (RING_SIZE bits, applied to
// read or write side per RING_SEL).
func (v *Variant) incrRing(addr, size, ctrl uint32, isWrite bool) uint32 {
	rev := v.CtrlIncrReadRev
	if isWrite {
		rev = v.CtrlIncrWriteRev
	}
	next := addr + size
	if rev != 0 && ctrl&rev != 0 {
		next = addr - size
	}
	ring := v.ctrlRingSize(ctrl)
	if ring == 0 {
		return next
	}
	ringApplies := (ctrl&v.CtrlRingSel != 0) == isWrite
	if !ringApplies {
		return next
	}
	mask := uint32(1)<<ring - 1
	return (addr &^ mask) | (next & mask)
}

// RunConfig bounds a Run call.
type RunConfig struct {
	MaxCycles   uint64   // 0 means the default of 10M
	WatchWrites []uint32 // stop when any of these addresses is written
}

// Run executes until the machine halts (idle), stalls waiting on external
// DREQs, hits a watched write, or exhausts the cycle budget.
func (m *Machine) Run(cfg RunConfig) (RunResult, error) {
	maxCycles := cfg.MaxCycles
	if maxCycles == 0 {
		maxCycles = 10_000_000
	}
	m.watch = make(map[uint32]bool, len(cfg.WatchWrites))
	for _, a := range cfg.WatchWrites {
		m.watch[a] = true
	}
	m.watchHit = nil
	defer func() { m.watch = nil }()

	start := m.Cycle
	for m.Cycle-start < maxCycles {
		issued, err := m.step()
		if err != nil {
			return RunResult{Cycles: m.Cycle - start}, err
		}
		if m.watchHit != nil {
			return RunResult{Reason: StopWatch, Cycles: m.Cycle - start, WatchAddr: *m.watchHit}, nil
		}
		if issued {
			continue
		}
		// Nothing ran this cycle. Decide between halt, stall, and merely
		// waiting for a pacing timer to accrue credit.
		anyBusy, anyTimerWait := false, false
		for i := 0; i < m.v.NChannels; i++ {
			if m.dma.ch[i].busy && m.dma.ch[i].ctrl&CtrlEN != 0 {
				anyBusy = true
				if m.dma.waitsOnLiveTimer(i) {
					anyTimerWait = true
				}
			}
		}
		if !anyBusy {
			return RunResult{Reason: StopIdle, Cycles: m.Cycle - start}, nil
		}
		if !anyTimerWait {
			return RunResult{Reason: StopStalled, Cycles: m.Cycle - start}, nil
		}
		// Timer-paced wait: keep ticking.
	}
	return RunResult{Reason: StopMaxCycles, Cycles: m.Cycle - start}, nil
}
