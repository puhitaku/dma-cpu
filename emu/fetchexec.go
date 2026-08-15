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
}

// ExecCtrl returns the standard CTRL word for program blocks executed on
// the Exec channel: run immediately, 32-bit, no increments, chain to Fix,
// no IRQ. OR in CtrlSize16/8, CtrlIncr*, CtrlSniffEn, CtrlBswap, or a
// CtrlTreq() as needed.
func (c FetchExecConfig) ExecCtrl() uint32 {
	return CtrlEN | CtrlSize32 | CtrlTreq(TreqPermanent) | CtrlChainTo(c.Fix) | CtrlIRQQuiet
}

// SetupFetchExec configures the three channels and starts the machine at
// cfg.Entry. The program must already be in memory.
func SetupFetchExec(m *Machine, cfg FetchExecConfig) error {
	if cfg.Fetch == cfg.Exec || cfg.Exec == cfg.Fix || cfg.Fetch == cfg.Fix {
		return fmt.Errorf("channels must be distinct: %+v", cfg)
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
		CtrlEN|CtrlSize32|CtrlTreq(TreqPermanent)|CtrlChainTo(cfg.Fix)|CtrlIRQQuiet)

	// Fetch: four 32-bit transfers per block, incrementing both pointers.
	fetchCtrl := CtrlEN | CtrlSize32 | CtrlIncrRead | CtrlIncrWrite |
		CtrlTreq(TreqPermanent) | CtrlChainTo(cfg.Fetch) | CtrlIRQQuiet
	m.Poke32(ChanRegAddr(cfg.Fetch, OffReadAddr), cfg.Entry)
	m.Poke32(ChanRegAddr(cfg.Fetch, OffWriteAddr), execRegs)
	m.Poke32(ChanRegAddr(cfg.Fetch, OffTransCount), 4)

	// Exec needs no pre-configuration: every register is loaded per block.

	// Writing CTRL_TRIG with EN set starts the first fetch.
	m.Poke32(ChanRegAddr(cfg.Fetch, OffCtrlTrig), fetchCtrl)
	return nil
}
