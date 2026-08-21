package emu

// Compact-machine channel map (Tier C, prompts/010-compact-isa.md).
// An instruction is an 8-byte record (READ_ADDR, WRITE_ADDR) fetched
// into the alias-2 tail of one exec channel per transfer mode; CTRL and
// TRANS_COUNT are preset and persist. The size8-family banks and plain
// must live on channels 0..3: their window addresses share the upper
// three bytes, which is what makes a byte-wide switch-out (a size8
// transfer of the plain-window literal's low byte) land correctly.
const (
	CompactPlain    = 0 // 32-bit moves, alias ops, jumps
	CompactSize8    = 1 // byte moves
	CompactSize8W   = 2 // byte moves, INCR_WRITE (memset)
	CompactSize8RW  = 3 // byte moves, INCR_READ|INCR_WRITE (memcpy)
	CompactSniff    = 4 // 32-bit moves observed by the sniffer
	CompactBswap    = 5 // 32-bit byte-swapped moves
	CompactSize16   = 6 // halfword moves
	CompactFetch    = 7
	CompactFix      = 8
	CompactInjector = 9 // approach-B injector (parity with classic ch3)
	// Cleanup restores the window selector to the plain bank and chains
	// to fix. The bswap/size banks chain through it, so their records
	// auto-return to plain — no switch-out record ever executes on them
	// (which would repeat at their count and, on INCR banks, walk over
	// memory).
	CompactCleanup = 10

	CompactNumBanks = 7
)

// CompactAutoReturn reports whether records on this bank chain through
// the cleanup channel back to the plain bank.
func CompactAutoReturn(ch int) bool {
	switch ch {
	case CompactSize8, CompactSize8W, CompactSize8RW, CompactBswap, CompactSize16:
		return true
	}
	return false
}

// CompactWindow returns the record landing zone of a bank channel: the
// alias-2 tail (READ_ADDR, WRITE_ADDR_TRIG).
func CompactWindow(ch int) uint32 { return ChanRegAddr(ch, OffAl2ReadAddr) }

// CompactBankCtrl returns the static CTRL word of a bank channel.
// Auto-return banks chain through cleanup instead of straight to fix.
func CompactBankCtrl(v *Variant, ch int) uint32 {
	chain := CompactFix
	if CompactAutoReturn(ch) {
		chain = CompactCleanup
	}
	base := CtrlEN | v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(chain) | v.CtrlIRQQuiet
	switch ch {
	case CompactPlain:
		return base | CtrlSize32
	case CompactSize8:
		return base | CtrlSize8
	case CompactSize8W:
		return base | CtrlSize8 | v.CtrlIncrWrite
	case CompactSize8RW:
		return base | CtrlSize8 | CtrlIncrRead | v.CtrlIncrWrite
	case CompactSniff:
		return base | CtrlSize32 | v.CtrlSniffEn
	case CompactBswap:
		return base | CtrlSize32 | v.CtrlBswap
	case CompactSize16:
		return base | CtrlSize16
	}
	return 0
}

// CompactFixCtrl / CompactFetchCtrl: the machinery channels.
func CompactFixCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(CompactFix) | v.CtrlIRQQuiet
}

func CompactCleanupCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(CompactFix) | v.CtrlIRQQuiet
}

func CompactFetchCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | CtrlIncrRead | v.CtrlIncrWrite |
		v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(CompactFetch) | v.CtrlIRQQuiet
}
