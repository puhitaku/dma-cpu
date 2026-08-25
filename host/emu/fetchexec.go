package emu

import "fmt"

// FetchExecConfig describes the 3-channel fetch/execute machine this
// project builds on (see prompts/overview.md §2 for the architecture and
// its origin):
//
//   - Fetch copies the next 16-byte control block from SRAM into Exec's
//     alias-0 registers; the final word lands on CTRL_TRIG and starts Exec.
//     Fetch's READ_ADDR is the program counter.
//   - Exec performs the block's data move, then chains to Fix (every
//     program block must carry CtrlChainTo(Fix)).
//   - Fix copies the constant at Scratch (the address of Exec's registers)
//     into Fetch's AL2_WRITE_ADDR_TRIG, resetting Fetch's write pointer and
//     re-triggering it in one transfer.
//
// This setup procedure is the reference for the Phase 1 ARM-side loader.
type FetchExecConfig struct {
	Fetch, Exec, Fix int
	Entry            uint32 // address of the first control block (initial PC)
	Scratch          uint32 // SRAM word the machine may clobber (holds &Exec regs)

	// Compact selects the Tier-C 8-byte-record machine (emu/compact.go):
	// the contiguous ch0..8 map, no fix channel — fetch's write ring
	// holds the window. Fetch/Exec/Fix/Scratch are ignored; the bank and
	// cleanup configuration arrive as image init writes, so setup here
	// is fetch-only.
	Compact bool
}

// ExecCtrl returns the standard CTRL word for program blocks executed on
// the Exec channel of the given SKU: run immediately, 32-bit, no
// increments, chain to Fix, no IRQ. OR in CtrlSize16/8, CtrlIncrRead,
// v.CtrlSniffEn, v.CtrlBswap, or rebuild with v.CtrlTreq as needed —
// remember that CHAIN_TO and TREQ_SEL are fields, not flags.
func (c FetchExecConfig) ExecCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(c.Fix) | v.CtrlIRQQuiet
}

// SetupFetchExec configures the three channels and starts the machine at
// cfg.Entry. The program must already be in memory.
func SetupFetchExec(m *Machine, cfg FetchExecConfig) error {
	v := m.Variant()
	if cfg.Compact {
		if cfg.Entry%8 != 0 {
			return fmt.Errorf("compact entry %#08x is not 8-byte aligned", cfg.Entry)
		}
		// Banks and cleanup were configured by the image's init writes;
		// only fetch remains. Its 8-byte write ring holds the window,
		// so no other machinery channel needs arming.
		fetchRegs := ChanRegAddr(CompactFetch, 0)
		m.Poke32(fetchRegs+OffReadAddr, cfg.Entry)
		m.Poke32(fetchRegs+OffWriteAddr, CompactWindow(CompactPlain))
		m.Poke32(fetchRegs+OffTransCount, 2)
		m.Poke32(fetchRegs+OffCtrlTrig, CompactFetchCtrl(v))
		return nil
	}
	if cfg.Fetch == cfg.Exec || cfg.Exec == cfg.Fix || cfg.Fetch == cfg.Fix {
		return fmt.Errorf("channels must be distinct: %+v", cfg)
	}
	if max := v.NChannels; cfg.Fetch >= max || cfg.Exec >= max || cfg.Fix >= max {
		return fmt.Errorf("channel out of range for %s (%d channels): %+v", v.Name, max, cfg)
	}
	if cfg.Entry%16 != 0 {
		return fmt.Errorf("entry %#08x is not 16-byte aligned", cfg.Entry)
	}
	execRegs := ChanRegAddr(cfg.Exec, 0)

	// The Fix channel's source operand: the address of Exec's registers.
	m.Poke32(cfg.Scratch, execRegs)

	// Fix: one 32-bit transfer, Scratch -> Fetch.AL2_WRITE_ADDR_TRIG.
	// Configured via non-trigger aliases; it is armed by Exec's chain.
	m.Poke32(ChanRegAddr(cfg.Fix, OffAl1ReadAddr), cfg.Scratch)
	m.Poke32(ChanRegAddr(cfg.Fix, OffAl1WriteAddr), ChanRegAddr(cfg.Fetch, OffAl2WriteAddrTrig))
	m.Poke32(ChanRegAddr(cfg.Fix, OffAl2TransCount), 1)
	m.Poke32(ChanRegAddr(cfg.Fix, OffAl1Ctrl),
		CtrlEN|CtrlSize32|v.CtrlTreq(TreqPermanent)|v.CtrlChainTo(cfg.Fix)|v.CtrlIRQQuiet)

	// Fetch: four 32-bit transfers per block, incrementing both pointers.
	fetchCtrl := CtrlEN | CtrlSize32 | CtrlIncrRead | v.CtrlIncrWrite |
		v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(cfg.Fetch) | v.CtrlIRQQuiet
	m.Poke32(ChanRegAddr(cfg.Fetch, OffReadAddr), cfg.Entry)
	m.Poke32(ChanRegAddr(cfg.Fetch, OffWriteAddr), execRegs)
	m.Poke32(ChanRegAddr(cfg.Fetch, OffTransCount), 4)

	// Exec needs no pre-configuration: every register is loaded per block.

	// Writing CTRL_TRIG with EN set starts the first fetch.
	m.Poke32(ChanRegAddr(cfg.Fetch, OffCtrlTrig), fetchCtrl)
	return nil
}
