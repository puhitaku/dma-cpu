package emu

// Compact-machine channel map (Tier C, prompts/010-compact-isa.md).
// An instruction is an 8-byte record (READ_ADDR, WRITE_ADDR) fetched
// into the alias-2 tail of one exec channel per transfer mode; CTRL and
// TRANS_COUNT are preset and persist. Plain and the size8 family sit on
// channels 0..3, whose windows share the upper three bytes, so a
// byte-wide switch-out (a size8 transfer of the plain-window literal's
// low byte) lands correctly. Cleanup's auto-return (below) retired that
// idiom — every switch record now runs on plain or sniff, both 32-bit —
// leaving the placement as convention.
//
// The machine is the contiguous block ch0..8. Fetch carries an 8-byte
// write ring (every window is 8-byte aligned: +0x28 within a 0x40
// stride), so its write pointer snaps back to the current window after
// each record — there is no fix channel. Banks chain straight back to
// fetch; the current-window state IS fetch's WRITE_ADDR register, which
// mode-switch records rewrite through the AL3 (non-trigger) alias.
// Channels 9 and up are the board-owned pool; 9 is the injector slot by
// ABI convention (boards may repurpose it, as the game does for audio).
const (
	CompactPlain   = 0 // 32-bit moves, alias ops, jumps
	CompactSize8   = 1 // byte moves
	CompactSize8W  = 2 // byte moves, INCR_WRITE (memset)
	CompactSize8RW = 3 // byte moves, INCR_READ|INCR_WRITE (memcpy)
	CompactSniff   = 4 // 32-bit moves observed by the sniffer
	CompactBswap   = 5 // 32-bit byte-swapped moves
	CompactSize16  = 6 // halfword moves
	CompactFetch   = 7
	// Cleanup restores fetch's write pointer to the plain window and
	// re-triggers fetch in the same single transfer (the write lands on
	// fetch's AL2_WRITE_ADDR_TRIG). The bswap/size banks chain through
	// it, so their records auto-return to plain — no switch-out record
	// ever executes on them (which would repeat at their count and, on
	// INCR banks, walk over memory).
	CompactCleanup = 8
	// CompactInjector is the ABI-convention interrupt slot in the
	// board-owned pool (parity with classic ch3) — not machine-frozen.
	CompactInjector = 9

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
// Banks chain straight back to fetch (whose write ring holds the
// window); auto-return banks chain through cleanup instead.
func CompactBankCtrl(v *Variant, ch int) uint32 {
	chain := CompactFetch
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

// CompactCleanupCtrl: cleanup's one transfer targets fetch's
// AL2_WRITE_ADDR_TRIG, so the restore is itself the re-trigger — its
// own chain stays disabled (self).
func CompactCleanupCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(CompactCleanup) | v.CtrlIRQQuiet
}

// CompactFetchCtrl: both pointers increment; the 8-byte write ring
// (RING_SEL=1, RING_SIZE=3) snaps the write pointer back to the current
// bank window after each record. Chain-to-self keeps fetch's own chain
// disabled — the banks' chains re-trigger it.
func CompactFetchCtrl(v *Variant) uint32 {
	return CtrlEN | CtrlSize32 | CtrlIncrRead | v.CtrlIncrWrite |
		v.CtrlRingSel | v.CtrlRingSize(3) |
		v.CtrlTreq(TreqPermanent) | v.CtrlChainTo(CompactFetch) | v.CtrlIRQQuiet
}
