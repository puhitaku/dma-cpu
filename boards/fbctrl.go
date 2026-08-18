package boards

import "github.com/puhitaku/dma-cpu/emu"

// FbCtrls returns the CTRL words of the video scanout engine
// (prompts/036) for one SKU, in the order the kernel driver's loader
// globals expect: walker, kick, stream, vblank, tail, copier. kfb.c
// receives them pre-encoded because CTRL bit layouts are SKU-specific
// (emu.Variant is their single home). All scanout channels run at
// high priority: the display preempts the machine, never the reverse.
func FbCtrls(v *emu.Variant) (walk, kick, strm, vbl, tail, cpy uint32) {
	base := emu.CtrlEN | emu.CtrlHighPriority | emu.CtrlSize32
	// Walker: block ring -> executor alias0, 16 B write ring, free-running.
	walk = base | emu.CtrlIncrRead | v.CtrlIncrWrite | v.CtrlRingSel |
		v.CtrlRingSize(4) | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(FbChanWalk)
	// Executor, kick blocks: 3 words into the copier's alias3, then back
	// to the walker.
	kick = base | emu.CtrlIncrRead | v.CtrlIncrWrite |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(FbChanWalk)
	// Executor, line stream: line buffer -> HSTX FIFO, DREQ-paced.
	strm = base | emu.CtrlIncrRead | v.CtrlTreq(v.DreqHSTX) | v.CtrlChainTo(FbChanWalk)
	// Executor, vblank stream: an 8-word command line replayed through a
	// 32 B read ring.
	vbl = strm | v.CtrlRingSize(5)
	// Executor, tail: one word into the walker's READ_ADDR_TRIG to loop
	// the frame; no chain (the retriggered walker takes over).
	tail = base | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(FbChanExec)
	// Copier: PSRAM -> line buffer, as fast as the bus allows.
	cpy = base | emu.CtrlIncrRead | v.CtrlIncrWrite |
		v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(FbChanCopy)
	return
}
