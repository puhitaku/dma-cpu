package emu

// QSPI flash model (Phase 10, prompts/022): enough of the RP2350 QMI
// direct mode plus a serial-NOR command set for the kernel's flash
// driver to be developed and tested off-silicon. XIP reads are served
// from Flash regardless of direct-mode state (the real part stalls;
// the kernel never reads XIP while in direct mode, so the divergence
// is unobservable by correct drivers). Commands: WREN, RDSR, READ,
// 4K sector erase, 256B page program (with NOR and-semantics), and
// anything else answers 0xFF (the exit-XIP dance is a no-op here).
const (
	XIPBase = 0x10000000
	QMIBase = 0x400D0000

	qmiDirectCSR = 0x00
	qmiDirectTX  = 0x04
	qmiDirectRX  = 0x08

	qmiCSREn         = 1 << 0
	qmiCSRAssertCS0n = 1 << 2
	qmiCSRTxEmpty    = 1 << 11
	qmiCSRRxEmpty    = 1 << 16

	qmiTXNoPush = 1 << 20
)

type flashState struct {
	csr uint32
	rx  []byte

	inCmd bool
	cmd   byte
	nbyte int  // bytes seen after the command byte
	addr  uint32
	wel   bool
	page  []byte // PP data collected until CS deassert
}

func (m *Machine) flashRead(addr uint32) (uint32, bool) {
	// TIMER0 raw-low: a monotonic microsecond counter on silicon. The
	// model returns a scaled cycle count so the kernel's timer-based
	// flash delays terminate quickly off-silicon (256 "us" per cycle).
	if addr == 0x400B0028 {
		return uint32(m.Cycle << 16), true
	}
	switch addr {
	case QMIBase + qmiDirectCSR:
		v := m.fl.csr | qmiCSRTxEmpty
		if len(m.fl.rx) == 0 {
			v |= qmiCSRRxEmpty
		}
		return v, true
	case QMIBase + qmiDirectRX:
		if len(m.fl.rx) == 0 {
			return 0, true
		}
		b := m.fl.rx[0]
		m.fl.rx = m.fl.rx[1:]
		return uint32(b), true
	}
	return 0, false
}

func (m *Machine) flashWrite(addr, val uint32) bool {
	switch addr {
	case QMIBase + qmiDirectCSR:
		was := m.fl.csr
		m.fl.csr = val & (qmiCSREn | qmiCSRAssertCS0n)
		// CS deassert (or leaving direct mode) ends the transaction.
		if (was&qmiCSRAssertCS0n != 0) && (m.fl.csr&qmiCSRAssertCS0n == 0) {
			m.flashEndCmd()
		}
		return true
	case QMIBase + qmiDirectTX:
		if m.fl.csr&qmiCSREn == 0 || m.fl.csr&qmiCSRAssertCS0n == 0 {
			return true // clocking without CS: ignored
		}
		resp := m.flashClock(byte(val))
		if val&qmiTXNoPush == 0 {
			m.fl.rx = append(m.fl.rx, resp)
		}
		return true
	}
	return false
}

// flashClock feeds one byte through the NOR state machine and returns
// the byte shifted out during that transfer.
func (m *Machine) flashClock(b byte) byte {
	fl := &m.fl
	if !fl.inCmd {
		fl.inCmd = true
		fl.cmd = b
		fl.nbyte = 0
		fl.addr = 0
		fl.page = fl.page[:0]
		if fl.cmd == 0x06 { // WREN takes effect immediately
			fl.wel = true
		}
		return 0xFF
	}
	fl.nbyte++
	switch fl.cmd {
	case 0x05: // RDSR: WIP always clear (the model is instant), WEL bit 1
		if fl.wel {
			return 0x02
		}
		return 0x00
	case 0x03, 0x20, 0x02: // READ / sector erase / page program: 3 addr bytes
		if fl.nbyte <= 3 {
			fl.addr = fl.addr<<8 | uint32(b)
			return 0xFF
		}
		switch fl.cmd {
		case 0x03:
			if int(fl.addr) < len(m.Flash) {
				out := m.Flash[fl.addr]
				fl.addr++
				return out
			}
			return 0xFF
		case 0x02:
			fl.page = append(fl.page, b)
		}
	}
	return 0xFF
}

// flashEndCmd applies erase/program when CS deasserts.
func (m *Machine) flashEndCmd() {
	fl := &m.fl
	if fl.inCmd && fl.nbyte >= 3 && m.Flash != nil {
		switch fl.cmd {
		case 0x20:
			if fl.wel {
				base := fl.addr &^ 0xFFF
				for i := uint32(0); i < 0x1000 && base+i < uint32(len(m.Flash)); i++ {
					m.Flash[base+i] = 0xFF
				}
				fl.wel = false
			}
		case 0x02:
			if fl.wel {
				base := fl.addr &^ 0xFF // page-aligned wrap, like real NOR
				for i, b := range fl.page {
					a := base + (fl.addr+uint32(i))%0x100
					if a < uint32(len(m.Flash)) {
						m.Flash[a] &= b // program only clears bits
					}
				}
				fl.wel = false
			}
		}
	}
	fl.inCmd = false
	fl.page = fl.page[:0]
	fl.rx = fl.rx[:0]
}
