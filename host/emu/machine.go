package emu

import (
	"encoding/binary"
	"fmt"
	"io"
	"math/bits"
	"os"
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
// deterministic scheduler. One cycle is one bus-transfer slot; real
// transfers take a few system clocks each, so cycle counts are
// proportional to, not equal to, hardware time.
type Machine struct {
	v      *Variant
	sram   []byte
	loaded [][2]uint32 // LoadBytes ranges, for cross-image overlap checks
	dma    dma

	// mmio backs peripheral registers the emulator has no model for, so DMA
	// programs can use arbitrary SFRs as scratch (a documented idiom).
	// Keyed by the alias-normalized address.
	mmio map[uint32]uint32

	Cycle      uint64
	GPIOEvents []GPIOEvent
	gpioLevel  [64]byte // last level per pin: OUTOVER writes or SetPadIn

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
	TXPace uint64
	lastTX uint64

	// Flash, when non-nil, is the QSPI flash content: reads of the XIP
	// window (0x10000000+) are served from it, and the QMI direct-mode
	// model (flash.go) lets the machine erase/program it.
	Flash []byte
	fl    flashState

	// PSRAM, when non-nil, backs the QMI CS1 sub-window of the XIP
	// space (offset 0x01000000: 0x11000000 cached, 0x15000000 uncached
	// alias — RP2350 datasheet §4.4). Unlike flash it accepts plain
	// bus writes; like flash it is unreachable during a QMI
	// direct-mode session.
	PSRAM []byte

	// HSTXOut collects words written to the HSTX FIFO (RP2350 only) —
	// the video scanout stream, captured for tests.
	HSTXOut []uint32
	// HSTXPace: cycles per granted FIFO word (see step()); 0 = free-run.
	HSTXPace uint64
	hstxNext uint64

	// SPIOut collects frames written to SPI0's data register — the
	// LCD stream on the gamepico board. Size is the bus access width
	// (the ST7789 path mixes 8-bit command and 16-bit pixel frames);
	// Cycle lets tests interleave the stream with GPIOEvents (the
	// D/C pin) to tell commands from parameters.
	SPIOut []SPIWrite

	// XIP streamer model (RP2350): STREAM_ADDR/STREAM_CTR writes arm a
	// linear fetch; reads of the XIP_AUX drain port pop words from the
	// XIP backing (flash or PSRAM). The stream DREQ self-sustains: one
	// pulse per armed word up front (credit-capped), one more per
	// drained word while the counter is live.
	streamAddr uint32

	// Read-profiling window (Profile): per-word read counts over
	// [profLo, profHi) — literal-pool hotness for the flash-pool split.
	profLo, profHi uint32
	profCounts     []uint32

	// SPI-mode SD card (sdcard.go): set SDImage to attach a card
	// behind SPI0. spiRx is the RX FIFO the drain channel empties.
	SDImage   []byte
	SDReads   int // blocks served (CMD17 + CMD18 streaming; diagnostic)
	SDRuns    int // CMD18 commands served (diagnostic)
	spiRx     []byte
	sdc       sdCard
	streamCtr uint32

	// SPI0 SSPDMACR as last written: the PL022 raises its TX DREQ only
	// while TXDMAE (bit 1) is set — a paced channel starves without it
	// (found on silicon: the LCD flush hung at row 0).
	spiDmacr uint32

	// PIO0 TX stub (not a PIO emulator): words written to TXF0..3 are
	// captured per SM, and each SM's TX DREQ is granted at a rate
	// derived from its CLKDIV as if the SM consumed one FIFO word per
	// 64 PIO cycles — the cadence of the gamepico I2S program (32
	// bits x 2 cycles). Other PIO registers live in the generic mmio
	// map: config writes are remembered, FSTAT reads zero (TX never
	// full), and instructions are never executed.
	PIO0TX  [4][]uint32
	pioNext [4]uint64

	// TraceW, when non-nil, receives one line per DMA transfer.
	TraceW io.Writer

	watch    []uint32
	watchHit *uint32
	rrLast   uint // last granted channel (round-robin arbitration)

	// Burst-engine observability (words moved via the fast bulk loop).
	BurstCount uint64
	BurstWords uint64
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
	m.dma.nowp = &m.Cycle
	return m
}

// Variant returns the SKU this machine emulates.
func (m *Machine) Variant() *Variant { return m.v }

// --- Bus ---

// inPSRAM reports whether the access falls inside the QMI CS1 PSRAM
// sub-window, in either the cached (0x11000000) or the uncached-alias
// (0x15000000) view of the XIP space.
const psramWinOff = 0x01000000

func (m *Machine) inPSRAM(addr uint32, size int) bool {
	if m.PSRAM == nil || addr < XIPBase || addr >= XIPBase+0x08000000 {
		return false
	}
	off := (addr - XIPBase) & 0x03FFFFFF
	return off >= psramWinOff && off-psramWinOff+uint32(size) <= uint32(len(m.PSRAM)) &&
		off-psramWinOff <= off-psramWinOff+uint32(size)
}

func (m *Machine) inSRAM(addr uint32, size int) bool {
	// addr+size can wrap at the top of the address space (a stray
	// pointer like -4): compare in offset space, which cannot wrap
	// once addr >= SRAMBase holds.
	return addr >= SRAMBase && addr-SRAMBase+uint32(size) <= uint32(len(m.sram)) &&
		addr-SRAMBase <= addr-SRAMBase+uint32(size)
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
	if m.profCounts != nil && addr >= m.profLo && addr < m.profHi {
		m.profCounts[(addr-m.profLo)>>2]++
	}
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
	case m.Flash != nil && addr >= XIPBase &&
		addr-XIPBase+uint32(size) <= uint32(len(m.Flash)),
		m.Flash != nil && addr >= XIPBase+0x04000000 &&
			addr-(XIPBase+0x04000000)+uint32(size) <= uint32(len(m.Flash)):
		// The second range is the uncached alias (0x14000000); the
		// emulator has no cache, so both windows read the same bytes.
		if m.fl.csr&qmiCSREn != 0 {
			// QMI direct mode owns the bus: on silicon a memory-mapped
			// access stalls or faults here. Anything the machine fetches
			// or reads mid-session must be SRAM-resident (XIP text keeps
			// the whole kflash_sync closure in .ramtext) — fault loudly
			// instead of serving data the hardware would not.
			return 0, fmt.Errorf("XIP read at %#08x during a QMI direct-mode session", addr)
		}
		off := (addr - XIPBase) & 0x03FFFFFF
		switch size {
		case 1:
			return uint32(m.Flash[off]), nil
		case 2:
			return uint32(binary.LittleEndian.Uint16(m.Flash[off:])), nil
		default:
			return binary.LittleEndian.Uint32(m.Flash[off:]), nil
		}
	case m.inPSRAM(addr, size):
		if m.fl.csr&qmiCSREn != 0 {
			return 0, fmt.Errorf("PSRAM read at %#08x during a QMI direct-mode session", addr)
		}
		off := (addr-XIPBase)&0x03FFFFFF - psramWinOff
		switch size {
		case 1:
			return uint32(m.PSRAM[off]), nil
		case 2:
			return uint32(binary.LittleEndian.Uint16(m.PSRAM[off:])), nil
		default:
			return binary.LittleEndian.Uint32(m.PSRAM[off:]), nil
		}
	case m.v.XIPAuxBase != 0 && addr == m.v.XIPAuxBase:
		// The stream drain port. Underflow (reading with no stream
		// armed) returns zero, matching "undefined but harmless".
		if m.fl.csr&qmiCSREn != 0 {
			return 0, fmt.Errorf("XIP stream read during a QMI direct-mode session")
		}
		if m.streamCtr == 0 {
			return 0, nil
		}
		v, err := m.Read(m.streamAddr, 4)
		if err != nil {
			return 0, err
		}
		m.streamAddr += 4
		m.streamCtr--
		return v, nil
	case addr >= 0x40000000 && addr < 0x60000000:
		if v, ok := m.flashRead(addr); ok {
			return v, nil
		}
		norm, _ := aliasOp(addr)
		// IO_BANK0 GPIOx_STATUS: reflect the OUTOVER-driven level as
		// INFROMPAD (bit 17) and OUTTOPAD (bit 9), the loopback real
		// pads give when the input buffer is enabled — `gpio read`
		// self-verifies without wiring.
		if norm >= m.v.IOBank0Base && norm < m.v.IOBank0Base+uint32(m.v.GPIOPins)*8 &&
			(norm-m.v.IOBank0Base)%8 == 0 {
			lv := uint32(m.gpioLevel[(norm-m.v.IOBank0Base)/8])
			return lv<<17 | lv<<9, nil
		}
		if m.v.SPI0Base != 0 && norm == m.v.SPI0Base+0xC { /* SSPSR */
			sr := uint32(0x3) /* TFE|TNF: TX always drains */
			if len(m.spiRx) > 0 {
				sr |= 0x4 /* RNE */
			}
			return sr, nil
		}
		if m.v.SPI0Base != 0 && norm == m.v.SPI0Base+0x8 { /* SSPDR read */
			if len(m.spiRx) == 0 {
				return 0xFF, nil
			}
			b := m.spiRx[0]
			m.spiRx = m.spiRx[1:]
			return uint32(b), nil
		}
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
	for _, w := range m.watch {
		if w == addr {
			a := addr
			m.watchHit = &a
			break
		}
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
		if op == 0 {
			// Plain write: applyAlias would discard the current value,
			// so skip the regRead — this is the machine's instruction
			// path (control-block streaming) and regRead was hot.
			m.dma.regWrite(norm, val, val != 0)
			return nil
		}
		final := applyAlias(m.dma.regRead(norm), val, op)
		m.dma.regWrite(norm, final, val != 0)
		return nil
	case m.inPSRAM(addr, size):
		if m.fl.csr&qmiCSREn != 0 {
			return fmt.Errorf("PSRAM write at %#08x during a QMI direct-mode session", addr)
		}
		off := (addr-XIPBase)&0x03FFFFFF - psramWinOff
		switch size {
		case 1:
			m.PSRAM[off] = byte(val)
		case 2:
			binary.LittleEndian.PutUint16(m.PSRAM[off:], uint16(val))
		default:
			binary.LittleEndian.PutUint32(m.PSRAM[off:], val)
		}
		return nil
	case addr >= 0x40000000 && addr < 0x60000000:
		if m.flashWrite(addr, val) {
			return nil
		}
		if m.v.HSTXFifoBase != 0 && addr == m.v.HSTXFifoBase {
			// Cap the capture: a free-running scanout writes ~5M words
			// per emulated second, and long boots would hoard RAM. Two
			// full frames plus slack is all any test reads.
			if len(m.HSTXOut) < 1<<20 {
				m.HSTXOut = append(m.HSTXOut, val)
			}
			return nil
		}
		if m.v.SPI0Base != 0 && addr == m.v.SPI0Base+0x8 { /* SSPDR */
			m.SPIOut = append(m.SPIOut, SPIWrite{m.Cycle, val, uint8(size)})
			if m.SDImage != nil {
				m.spiRx = append(m.spiRx, m.sdStep(byte(val)))
			}
			return nil
		}
		if m.v.SPI0Base != 0 && addr == m.v.SPI0Base+0x24 { /* SSPDMACR */
			m.spiDmacr = val
			return nil
		}
		if m.v.SPI0Base != 0 && (addr == m.v.SPI0Base+0x0 ||
			addr == m.v.SPI0Base+0x4 || addr == m.v.SPI0Base+0x10) {
			return nil /* CR0/CR1/CPSR: clocking modeled as instant */
		}
		if m.v.PIO0Base != 0 && addr >= m.v.PIO0Base+0x10 &&
			addr < m.v.PIO0Base+0x20 { /* TXF0..TXF3 */
			// Narrow IO writes replicate across the 32-bit bus
			// (RP2040 datasheet 2.1.4) — the mono-PCM path leans on
			// a halfword arriving as S:S.
			switch size {
			case 1:
				val = (val & 0xFF) * 0x01010101
			case 2:
				val = (val & 0xFFFF) * 0x00010001
			}
			sm := (addr - m.v.PIO0Base - 0x10) / 4
			if len(m.PIO0TX[sm]) < 1<<21 {
				m.PIO0TX[sm] = append(m.PIO0TX[sm], val)
			}
			return nil
		}
		if m.v.XIPStreamAddr != 0 && addr == m.v.XIPStreamAddr {
			m.streamAddr = val &^ 3
			return nil
		}
		if m.v.XIPStreamAddr != 0 && addr == m.v.XIPStreamAddr+4 {
			m.streamCtr = val & 0x003FFFFF
			return nil
		}
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

// SetPadIn drives a GPIO pad's input level, as external wiring (a
// joystick, a pull-up) would: GPIOx_STATUS reads reflect it until an
// OUTOVER write overrides the pin. Pins default low, so tests that
// model pulled-up buttons must set them high before the machine runs.
func (m *Machine) SetPadIn(pin int, high bool) {
	if pin < 0 || pin >= len(m.gpioLevel) {
		return
	}
	if high {
		m.gpioLevel[pin] = 1
	} else {
		m.gpioLevel[pin] = 0
	}
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
		m.gpioLevel[off/8] = 0
		m.GPIOEvents = append(m.GPIOEvents, GPIOEvent{m.Cycle, int(off / 8), false})
	case 3:
		m.gpioLevel[off/8] = 1
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

// LoadBytes copies a raw image into memory at addr (SRAM only). Ranges
// loaded this way are remembered per machine, and a later load that
// overlaps one is an error: silent cross-image clobbering (a kernel data
// segment growing into a process image) has produced ticks-dead machines
// with no fault more than once.
func (m *Machine) LoadBytes(addr uint32, data []byte) error {
	inFlash := m.Flash != nil && addr >= XIPBase &&
		addr+uint32(len(data)) <= XIPBase+uint32(len(m.Flash))
	if !m.inSRAM(addr, len(data)) && !inFlash {
		return fmt.Errorf("image [%#08x, +%#x) outside SRAM", addr, len(data))
	}
	lo, hi := addr, addr+uint32(len(data))
	for _, r := range m.loaded {
		if lo < r[1] && r[0] < hi {
			return fmt.Errorf("image [%#08x, %#08x) overlaps previously loaded [%#08x, %#08x)",
				lo, hi, r[0], r[1])
		}
	}
	m.loaded = append(m.loaded, [2]uint32{lo, hi})
	if inFlash {
		// Staging a flash-resident segment: the emulator counterpart of
		// the firmware writing program text into QSPI flash before boot.
		copy(m.Flash[addr-XIPBase:], data)
	} else {
		copy(m.sram[addr-SRAMBase:], data)
	}
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

// SPIWrite is one captured SPI0 data-register write.
type SPIWrite struct {
	Cycle uint64
	Val   uint32
	Size  uint8 // bus access width in bytes (1 or 2 for the LCD path)
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
	if m.dma.timerActive != 0 && m.Cycle >= m.dma.timerNextMin {
		m.dma.fireDue(m.Cycle)
	}
	// The XIP stream DREQ is level-like: while the streamer holds data,
	// re-grant a credit to any drained listener (a trigger clears
	// banked credit on silicon, but the hardware request line simply
	// re-asserts — one-shot pulses would deadlock the copier).
	if m.v.DreqXIPStream != 0 && m.streamCtr > 0 {
		m.dma.levelDreq(m.v.DreqXIPStream)
	}
	// SPI0 TX drains continuously: a level request for any listener
	// (the LCD pixel stream) — but only while SSPDMACR.TXDMAE is set,
	// like the PL022. Masked so non-SPI workloads never scan.
	if m.dma.spiListen != 0 && m.spiDmacr&0x2 != 0 {
		m.dma.levelDreqMask(m.dma.spiListen)
	}
	// UART0 DREQs (console DMA): TX has FIFO room at the pace TXPace
	// models (0 = drain instantly, like the FR read path); RX holds a
	// byte while ConsoleIn is nonempty. Level-modeled like the SPI.
	if m.dma.uartTxListen != 0 && (m.TXPace == 0 || m.Cycle-m.lastTX >= m.TXPace) {
		m.dma.levelDreqMask(m.dma.uartTxListen)
	}
	if m.dma.uartRxListen != 0 && len(m.ConsoleIn) > 0 {
		m.dma.levelDreqMask(m.dma.uartRxListen)
	}
	if m.dma.spiRxListen != 0 && len(m.spiRx) > 0 {
		m.dma.levelDreqMask(m.dma.spiRxListen)
	}
	// HSTX drain pacing: one FIFO word per HSTXPace cycles (the wire
	// consumes 4 px/word at 25.2 MHz ≈ one word per 48 bus cycles at
	// 300 MHz). 0 = unpaced free-run (the frame test's fast path).
	// Without pacing an HP scanout would hog the emulated bus in a
	// way the DREQ-paced silicon never does.
	if m.dma.hstxListen != 0 && (m.HSTXPace == 0 || m.Cycle >= m.hstxNext) {
		m.dma.levelDreqMask(m.dma.hstxListen)
		m.hstxNext = m.Cycle + m.HSTXPace
	}
	// PIO0 TX pacing stub: one word per 64 PIO cycles at the SM's
	// CLKDIV (the gamepico I2S cadence), gated on the SM enable bit
	// in the CTRL word remembered by the mmio map.
	if m.dma.pioListen != 0 {
		ctrl := m.mmio[m.v.PIO0Base]
		for sm := 0; sm < 4; sm++ {
			lst := m.dma.pioTx[sm]
			if lst == 0 || ctrl&(1<<uint(sm)) == 0 || m.Cycle < m.pioNext[sm] {
				continue
			}
			m.dma.levelDreqMask(lst)
			div := m.mmio[m.v.PIO0Base+0xC8+uint32(sm)*0x18] >> 16
			if div == 0 {
				div = 1
			}
			m.pioNext[sm] = m.Cycle + uint64(div)*64
		}
	}
	// Channel selection over the cached ready set: high-priority
	// channels first, ROUND-ROBIN within a class — the hardware
	// arbiter rotates, and a strict lowest-index pick starves high
	// channels behind a busy machine (the LP scanout copier never ran
	// while the machine polled it, a livelock real silicon does not
	// have).
	r := m.dma.ready
	if r == 0 {
		return false, nil
	}
	pick := r & m.dma.hp
	if pick == 0 {
		pick = r
	}
	// Rotate: first ready channel strictly after the last grant, else
	// wrap to the lowest.
	after := pick &^ (uint32(1)<<(m.rrLast+1) - 1)
	var ch int
	if after != 0 {
		ch = bits.TrailingZeros32(after)
	} else {
		ch = bits.TrailingZeros32(pick)
	}
	m.rrLast = uint(ch)
	// Burst gate: the remaining-count compare alone rejects the
	// machine's instruction traffic (1-4 word control sequences), so
	// the full eligibility check runs only for genuine bulk moves.
	if !noFast && m.dma.ch[ch].remaining >= burstMin && r == uint32(1)<<ch {
		if k := m.burstLen(ch); k > 1 {
			return true, m.burst(ch, k)
		}
	}
	return true, m.transfer(ch)
}

// burstMin is the smallest sequence worth the burst setup cost; below
// it the per-word path is faster than resolving windows.
const burstMin = 16

// burstLen reports how many words of the channel's sequence may run
// as one uninterrupted burst, or 1 when the per-word path must be
// used. Eligibility: the channel is the sole ready channel (checked
// by the caller), unpaced (permanent TREQ, so no credit accounting),
// counting down normally, with no observers (sniffer, trace, watch)
// and no ring wrapping. Triggers only fire from completions, so
// nothing can preempt it — except the sources step() would have
// serviced during those cycles: pacing timers, the XIP stream DREQ
// (excluded outright), and the time-paced level grants, which cap the
// run so a waiting listener is never starved for a whole burst.
func (m *Machine) burstLen(chIdx int) uint64 {
	d := &m.dma
	c := &d.ch[chIdx]
	if c.treq != TreqPermanent || c.mode == transModeEndless ||
		c.sniffEn || c.ringMaskR != 0 || c.ringMaskW != 0 || c.sizeLog == 3 ||
		m.TraceW != nil || len(m.watch) != 0 || m.streamCtr != 0 {
		return 1
	}
	k := uint64(c.remaining)
	if d.timerActive != 0 {
		// The burst occupies cycles [Cycle, Cycle+k-1]; the next pulse
		// lands at timerNextMin, which fireDue guarantees is > Cycle.
		if gap := d.timerNextMin - m.Cycle; gap < k {
			k = gap
		}
	}
	if gap := m.pacedGrantGap(); gap < k {
		k = gap
	}
	if k > 1<<16 {
		k = 1 << 16
	}
	return k
}

// pacedGrantGap reports how many cycles may pass before step() owes a
// level grant to a channel that is armed and out of credit, for the
// sources whose grant is a function of TIME rather than of machine
// state: the UART TX pace, the HSTX drain pace, and the PIO TX
// cadences. A burst skips those cycles' step() calls, so without this
// cap a bulk copy would starve the console, the display or the audio
// ring for its whole length — silicon interleaves them instead. The
// state-driven grants (SPI TX/RX, UART RX, the XIP streamer) need no
// cap: nothing a plain memory burst does can assert them.
func (m *Machine) pacedGrantGap() uint64 {
	d := &m.dma
	gap := ^uint64(0)
	due := func(next uint64) {
		g := uint64(1) // already owed: take the per-word path
		if next > m.Cycle {
			g = next - m.Cycle
		}
		if g < gap {
			gap = g
		}
	}
	if m.TXPace != 0 && d.uartTxListen != 0 && d.starved(d.uartTxListen) {
		due(m.lastTX + m.TXPace)
	}
	if m.HSTXPace != 0 && d.hstxListen != 0 && d.starved(d.hstxListen) {
		due(m.hstxNext)
	}
	if d.pioListen != 0 {
		ctrl := m.mmio[m.v.PIO0Base]
		for sm := 0; sm < 4; sm++ {
			lst := d.pioTx[sm]
			if lst == 0 || ctrl&(1<<uint(sm)) == 0 || !d.starved(lst) {
				continue
			}
			due(m.pioNext[sm])
		}
	}
	return gap
}

// burst executes k words of the channel in one tight loop over the
// resolved memory windows — identical word order, addresses, and
// final cycle count to k single steps (m.Cycle advances by k-1: the
// caller's step already accounted the first word's cycle). Falls back
// to one plain transfer when a window is not plain memory.
func (m *Machine) burst(chIdx int, k uint64) error {
	c := &m.dma.ch[chIdx]
	sz := uint32(1) << c.sizeLog
	ra, wa := c.readAddr, c.writeAddr
	rw, ww := &c.rwin, &c.wwin
	if rw.hi == 0 || ra < rw.lo || ra >= rw.hi {
		*rw = m.resolveWin(ra, false)
	}
	if ww.hi == 0 || wa < ww.lo || wa >= ww.hi {
		*ww = m.resolveWin(wa, true)
	}
	if rw.buf == nil || ww.buf == nil || ra&(sz-1) != 0 || wa&(sz-1) != 0 ||
		ra < rw.lo || rw.hi-ra < sz || wa < ww.lo || ww.hi-wa < sz {
		return m.transfer(chIdx)
	}
	// Cap the burst to the room each window has along its stride.
	switch c.strideR {
	case sz:
		if r := uint64((rw.hi - ra) / sz); r < k {
			k = r
		}
	case 0:
	default: // reverse: -sz
		if r := uint64((ra-rw.lo)/sz) + 1; r < k {
			k = r
		}
	}
	switch c.strideW {
	case sz:
		if r := uint64((ww.hi - wa) / sz); r < k {
			k = r
		}
	case 0:
	default:
		if r := uint64((wa-ww.lo)/sz) + 1; r < k {
			k = r
		}
	}
	if k < 2 {
		return m.transfer(chIdx)
	}
	m.BurstCount++
	m.BurstWords += k
	rb, wb := rw.buf, ww.buf
	ro, wo := ra-rw.lo, wa-ww.lo
	if sz == 4 && !c.bswap && c.strideR == 4 && c.strideW == 4 {
		// The dominant shape: a forward word copy (memmove kernels,
		// framebuffer blits, disk I/O). Per-word forward order also
		// gives overlapping ranges their architectural result.
		for i := uint64(0); i < k; i++ {
			binary.LittleEndian.PutUint32(wb[wo:], binary.LittleEndian.Uint32(rb[ro:]))
			ro += 4
			wo += 4
		}
	} else {
		for i := uint64(0); i < k; i++ {
			var v uint32
			switch sz {
			case 1:
				v = uint32(rb[ro])
			case 2:
				v = uint32(binary.LittleEndian.Uint16(rb[ro:]))
			default:
				v = binary.LittleEndian.Uint32(rb[ro:])
			}
			if c.bswap {
				v = bswap(v, int(sz))
			}
			switch sz {
			case 1:
				wb[wo] = byte(v)
			case 2:
				binary.LittleEndian.PutUint16(wb[wo:], uint16(v))
			default:
				binary.LittleEndian.PutUint32(wb[wo:], v)
			}
			ro += c.strideR
			wo += c.strideW
		}
	}
	c.readAddr = ra + uint32(k)*c.strideR
	c.writeAddr = wa + uint32(k)*c.strideW
	m.Cycle += k - 1
	c.remaining -= uint32(k)
	if c.remaining == 0 && c.busy {
		m.dma.complete(chIdx)
	}
	return nil
}

// transfer issues one datum move for the given channel and handles
// completion, chaining, and the sniffer.
func (m *Machine) transfer(chIdx int) error {
	c := &m.dma.ch[chIdx]
	if c.treq != TreqPermanent && c.credit > 0 {
		c.credit--
		m.dma.updateReady(chIdx)
	}
	if c.sizeLog == 3 { // DATA_SIZE == 0x3 is reserved
		return fmt.Errorf("ch%d: reserved DATA_SIZE in CTRL %#08x", chIdx, c.ctrl)
	}
	size := 1 << c.sizeLog
	sz := uint32(size)

	// B3 fast path: while the address sits in a resolved plain-memory
	// window, skip the bus decode. Falls back per word on any miss;
	// the slow path is the reference semantics (and reports errors).
	var datum uint32
	fastR := false
	if !noFast {
		ra := c.readAddr
		w := &c.rwin
		if w.hi == 0 || ra < w.lo || ra >= w.hi {
			*w = m.resolveWin(ra, false)
		}
		if w.buf != nil && m.profCounts == nil && ra >= w.lo && w.hi-ra >= sz && ra&(sz-1) == 0 {
			off := ra - w.lo
			switch size {
			case 1:
				datum = uint32(w.buf[off])
			case 2:
				datum = uint32(binary.LittleEndian.Uint16(w.buf[off:]))
			default:
				datum = binary.LittleEndian.Uint32(w.buf[off:])
			}
			fastR = true
		}
	}
	if !fastR {
		var err error
		datum, err = m.Read(c.readAddr, size)
		if err != nil {
			return fmt.Errorf("ch%d: %w", chIdx, err)
		}
	}
	if c.bswap {
		datum = bswap(datum, size)
	}
	writeAddr := c.writeAddr
	wrote := false
	if !noFast && len(m.watch) == 0 {
		w := &c.wwin
		if w.hi == 0 || writeAddr < w.lo || writeAddr >= w.hi {
			*w = m.resolveWin(writeAddr, true)
		}
		if w.buf != nil && writeAddr >= w.lo && w.hi-writeAddr >= sz && writeAddr&(sz-1) == 0 {
			off := writeAddr - w.lo
			switch size {
			case 1:
				w.buf[off] = byte(datum)
			case 2:
				binary.LittleEndian.PutUint16(w.buf[off:], uint16(datum))
			default:
				binary.LittleEndian.PutUint32(w.buf[off:], datum)
			}
			wrote = true
		}
	}
	if !wrote {
		if err := m.Write(writeAddr, datum, size); err != nil {
			return fmt.Errorf("ch%d: %w", chIdx, err)
		}
	}
	if c.sniffEn {
		m.dma.sniff(chIdx, datum, size)
	}
	if m.TraceW != nil {
		fmt.Fprintf(m.TraceW, "%8d ch%-2d %#08x -> %#08x  %#0*x\n",
			m.Cycle, chIdx, c.readAddr, writeAddr, 2*size+2, datum)
	}

	if c.strideR != 0 {
		c.readAddr = advanceAddr(c.readAddr, c.strideR, c.ringMaskR)
	}
	if c.strideW != 0 {
		c.writeAddr = advanceAddr(c.writeAddr, c.strideW, c.ringMaskW)
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
	// RP2040: a channel writing its OWN TRANS_COUNT (any alias) while
	// running wedges after that beat — stuck busy, never completes,
	// immune to CHAN_ABORT; only a DMA block reset revives it (measured
	// on silicon, prompts/040). RP2350 latches the value as reload only.
	if m.v.SelfCountWedge && writeAddr-ChanRegAddr(chIdx, 0) < ChanStride {
		switch writeAddr - ChanRegAddr(chIdx, 0) {
		case OffTransCount, OffAl1TransCountTrig, OffAl2TransCount, OffAl3TransCount:
			c.wedged = true
			m.dma.updateReady(chIdx)
			return nil
		}
	}
	if c.remaining == 0 && c.busy {
		m.dma.complete(chIdx)
	}
	return nil
}

// resolveWin maps addr to a plain-memory window for direct channel
// access, or a negative window (nil buf) spanning a region that must
// stay on the slow bus path. A zero memWin means "unmapped; resolve
// again next time" (the slow path will fault with the real error).
func (m *Machine) resolveWin(addr uint32, forWrite bool) memWin {
	if addr >= SRAMBase && addr-SRAMBase < uint32(len(m.sram)) {
		return memWin{m.sram, SRAMBase, SRAMBase + uint32(len(m.sram))}
	}
	if addr >= 0x40000000 && addr < 0x60000000 {
		// DMA regs and MMIO: trigger/UART/GPIO semantics live here.
		return memWin{nil, 0x40000000, 0x60000000}
	}
	if m.fl.csr&qmiCSREn == 0 && addr >= XIPBase && addr < XIPBase+0x08000000 {
		block := addr &^ 0x03FFFFFF // cached / uncached alias base
		off := addr - block
		if m.PSRAM != nil && off >= psramWinOff && off-psramWinOff < uint32(len(m.PSRAM)) {
			lo := block + psramWinOff
			return memWin{m.PSRAM, lo, lo + uint32(len(m.PSRAM))}
		}
		if m.Flash != nil && !forWrite && off < uint32(len(m.Flash)) &&
			(block == XIPBase || block == XIPBase+0x04000000) {
			return memWin{m.Flash, block, block + uint32(len(m.Flash))}
		}
	}
	return memWin{}
}

// winsInvalidate drops every channel's cached memory windows (QMI
// direct-mode transitions change what the fast path may touch).
func (m *Machine) winsInvalidate() {
	for i := range m.dma.ch {
		m.dma.ch[i].rwin = memWin{}
		m.dma.ch[i].wwin = memWin{}
	}
}

// advanceAddr steps an address by the channel's pre-decoded stride
// (negative strides wrap in uint32, matching reverse-decrement), with
// optional ring wrapping when the mask is nonzero.
func advanceAddr(addr, stride, ringMask uint32) uint32 {
	next := addr + stride
	if ringMask == 0 {
		return next
	}
	return (addr &^ ringMask) | (next & ringMask)
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
	m.watch = append(m.watch[:0], cfg.WatchWrites...)
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
		// Timer-paced wait: nothing can happen until the next timer
		// pulse, so jump straight to the cycle before it (the next
		// step lands exactly on the fire cycle). Exact by
		// construction: no channel is runnable and only timer pulses
		// can change that. Clamped to the cycle budget.
		if !noFast && m.dma.timerNextMin > m.Cycle+1 {
			next := m.dma.timerNextMin - 1
			if lim := start + maxCycles; next > lim {
				next = lim
			}
			m.Cycle = next
		}
	}
	return RunResult{Reason: StopMaxCycles, Cycles: m.Cycle - start}, nil
}

// noFast, set via EMU_NO_FAST=1, disables the semantics-preserving
// fast paths (idle timer jumps, window caches, bursts) so a suspected
// divergence can be bisected against the plain per-cycle model.
var noFast = os.Getenv("EMU_NO_FAST") != ""

// Clone returns an independent deep copy of the machine: identical
// architectural state, no shared mutable memory. Host-side observers
// (trace writer, watchpoints) do not carry over. The intended use is
// boot-once-fork-many test harnesses: boot a golden machine to a
// known point, then run divergent scenarios on clones in parallel.
func (m *Machine) Clone() *Machine {
	n := &Machine{}
	*n = *m
	n.sram = append([]byte(nil), m.sram...)
	n.loaded = append([][2]uint32(nil), m.loaded...)
	n.mmio = make(map[uint32]uint32, len(m.mmio))
	for k, v := range m.mmio {
		n.mmio[k] = v
	}
	n.GPIOEvents = append([]GPIOEvent(nil), m.GPIOEvents...)
	// Clones start a fresh scanout capture: a booted parent has often
	// already spent the 1<<20-word cap, so an inherited buffer costs
	// 4 MB per clone and still records nothing of the clone's own run.
	n.HSTXOut = nil
	for i := range m.PIO0TX {
		n.PIO0TX[i] = append([]uint32(nil), m.PIO0TX[i]...)
	}
	n.ConsoleOut = append([]byte(nil), m.ConsoleOut...)
	n.ConsoleIn = append([]byte(nil), m.ConsoleIn...)
	if m.Flash != nil {
		n.Flash = append([]byte(nil), m.Flash...)
	}
	if m.PSRAM != nil {
		n.PSRAM = append([]byte(nil), m.PSRAM...)
	}
	n.fl.rx = append([]byte(nil), m.fl.rx...)
	n.fl.page = append([]byte(nil), m.fl.page...)
	if m.SDImage != nil {
		n.SDImage = append([]byte(nil), m.SDImage...)
	}
	n.spiRx = append([]byte(nil), m.spiRx...)
	n.sdc.cmd = append([]byte(nil), m.sdc.cmd...)
	n.sdc.resp = append([]byte(nil), m.sdc.resp...)
	n.TraceW = nil
	n.watch = nil
	n.watchHit = nil
	n.dma.nowp = &n.Cycle
	n.winsInvalidate() // cached windows point into the old machine
	return n
}

// LoadedRanges exposes the LoadBytes bookkeeping (test/diagnostic use).
func (m *Machine) LoadedRanges() [][2]uint32 { return m.loaded }

// Profile starts counting bus reads per word over [lo, hi) — the
// measurement side of the profile-guided literal-pool split. Counts
// are indexed by (addr-lo)/4; pass lo==hi to stop.
func (m *Machine) Profile(lo, hi uint32) {
	if hi <= lo {
		m.profCounts = nil
		return
	}
	m.profLo, m.profHi = lo, hi
	m.profCounts = make([]uint32, (hi-lo+3)/4)
}

// ProfileCounts returns the live count slice (nil when not profiling).
func (m *Machine) ProfileCounts() []uint32 { return m.profCounts }
