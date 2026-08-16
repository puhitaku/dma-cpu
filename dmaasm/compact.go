package dmaasm

// Compact (Tier C) encoding: each classic 16-byte block becomes one or
// more 8-byte records executed on a channel bank (emu/compact.go,
// prompts/010-compact-isa.md). This file holds the bank classifier and
// the per-block planner — the state machine that decides which switch /
// count-set records surround each block. Pass 1 runs the planner to
// size instructions; pass 2 runs it again to emit, and the two are
// cross-checked per instruction (a mismatch is an assembly error).
//
// Invariants (the mode-domain rules):
//   - every instruction starts and ends in canonical state: plain bank,
//     all counts 1 (so labels and control-flow joins agree);
//   - switch records out of the size8 family go via plain (their byte
//     transfer can only retarget within channels 0..3);
//   - switch records out of bswap use a pre-swapped window literal;
//   - a plain-bank read of SNIFF_DATA while on the sniff bank runs in
//     place (delivered data is exact; self-accumulation hits state the
//     macros treat as dead after a read) — and if it targets %pc it is
//     staged through `at` so the jump leaves canonical state;
//   - macros never leave the sniff bank while the accumulator is live
//     except through such a read (the jeq/jlt/jltu compact variants in
//     emit.go are restructured to honor this).

import (
	"fmt"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

// cscrName is the hidden data word holding the current window address
// (the fix channel's source; switch records rewrite it).
const cscrName = "__cscr"

// cshape abstracts one classic block for planning.
type cshape struct {
	bank     int    // emu.CompactPlain..CompactSize16
	count    uint32 // TRANS_COUNT (0 = classic NOP, treated as 1)
	srcSniff bool   // source is SNIFF_DATA
	dstPc    bool   // destination is the fetch READ_ADDR (%pc)
	dyn      bool   // count is patched at runtime (dyncount flag)
	halt     bool   // all-zero HALT record
	// cntAfter: the record itself rewrites its bank's count reload (the
	// in-bank count-restore idiom for sniff count runs; its transfer
	// repeats `count` times, which callers compensate in the seed).
	cntAfter uint32
}

// classifyCtrl maps a classic block CTRL word onto a bank channel.
func (a *asm) classifyCtrl(ctrl uint32) (int, error) {
	sizeField := emu.CtrlSize16 | emu.CtrlSize32 // the 2-bit DATA_SIZE field
	base := a.cfg.ExecCtrl(a.v) &^ sizeField
	size := ctrl & sizeField
	extras := ctrl &^ base &^ sizeField
	sniff := extras&a.v.CtrlSniffEn != 0
	bswap := extras&a.v.CtrlBswap != 0
	incrR := extras&emu.CtrlIncrRead != 0
	incrW := extras&a.v.CtrlIncrWrite != 0
	rest := extras &^ (a.v.CtrlSniffEn | a.v.CtrlBswap | emu.CtrlIncrRead | a.v.CtrlIncrWrite)
	if rest != 0 || base&^ctrl != 0 {
		return 0, fmt.Errorf("compact: block CTRL %#x is not expressible as a bank", ctrl)
	}
	switch {
	case sniff && !bswap && !incrR && !incrW && size == emu.CtrlSize32:
		return emu.CompactSniff, nil
	case bswap && !sniff && !incrR && !incrW && size == emu.CtrlSize32:
		return emu.CompactBswap, nil
	case !sniff && !bswap && size == emu.CtrlSize8:
		switch {
		case !incrR && !incrW:
			return emu.CompactSize8, nil
		case !incrR && incrW:
			return emu.CompactSize8W, nil
		case incrR && incrW:
			return emu.CompactSize8RW, nil
		}
	case !sniff && !bswap && !incrR && !incrW && size == emu.CtrlSize16:
		return emu.CompactSize16, nil
	case !sniff && !bswap && !incrR && !incrW && size == emu.CtrlSize32:
		return emu.CompactPlain, nil
	}
	return 0, fmt.Errorf("compact: unsupported CTRL combination %#x", ctrl)
}

// --- Planner ---

type primKind int

const (
	pRec       primKind = iota // the block's own record
	pSwitch                    // window-selector rewrite (from -> to)
	pCount                     // count-set record for a bank channel
	pStageRead                 // SNIFF_DATA -> at, on the sniff bank
	pStagePush                 // at -> %pc, on the plain bank
	pHalt                      // all-zero record
)

type prim struct {
	kind     primKind
	from, to int    // pSwitch
	bank     int    // pCount
	k        uint32 // pCount
}

type cstate struct {
	bank  int
	cnt   [emu.CompactNumBanks]uint32
	dirty [emu.CompactNumBanks]bool
}

func newCstate() *cstate {
	st := &cstate{bank: emu.CompactPlain}
	for i := range st.cnt {
		st.cnt[i] = 1
	}
	return st
}

// switchTo plans a switch record into bank b.
func (st *cstate) switchTo(b int, ps []prim) []prim {
	if st.bank == b {
		return ps
	}
	ps = append(ps, prim{kind: pSwitch, from: st.bank, to: b})
	st.bank = b
	return ps
}

// plan returns the record sequence for one block.
func (st *cstate) plan(s cshape) []prim {
	var ps []prim
	if s.halt {
		return append(ps, prim{kind: pHalt})
	}
	k := s.count
	if k == 0 {
		k = 1 // classic zero-count NOP: a harmless single transfer
	}
	// Deferred sniff-read (see file comment) — only while the sniff
	// channel's count is a known 1 (the read record repeats otherwise).
	if s.srcSniff && st.bank == emu.CompactSniff && s.bank == emu.CompactPlain && k == 1 && !s.dyn &&
		st.cnt[emu.CompactSniff] == 1 && !st.dirty[emu.CompactSniff] {
		if s.dstPc {
			ps = append(ps, prim{kind: pStageRead})
			ps = st.switchTo(emu.CompactPlain, ps)
			return append(ps, prim{kind: pStagePush})
		}
		return append(ps, prim{kind: pRec})
	}
	if !s.dyn && s.cntAfter == 0 && (st.cnt[s.bank] != k || st.dirty[s.bank]) {
		ps = st.switchTo(emu.CompactPlain, ps)
		ps = append(ps, prim{kind: pCount, bank: s.bank, k: k})
		st.cnt[s.bank], st.dirty[s.bank] = k, false
	}
	ps = st.switchTo(s.bank, ps)
	ps = append(ps, prim{kind: pRec})
	switch {
	case s.dyn:
		st.dirty[s.bank] = true
	case s.cntAfter != 0:
		st.cnt[s.bank], st.dirty[s.bank] = s.cntAfter, false
	}
	// Auto-return banks chain through cleanup back to the plain window.
	if emu.CompactAutoReturn(s.bank) {
		st.bank = emu.CompactPlain
	}
	return ps
}

// planSync restores canonical state at an instruction boundary.
func (st *cstate) planSync() []prim {
	var ps []prim
	needCount := false
	for b := range st.cnt {
		if st.cnt[b] != 1 || st.dirty[b] {
			needCount = true
		}
	}
	if needCount {
		ps = st.switchTo(emu.CompactPlain, ps)
		for b := range st.cnt {
			if st.cnt[b] != 1 || st.dirty[b] {
				ps = append(ps, prim{kind: pCount, bank: b, k: 1})
				st.cnt[b], st.dirty[b] = 1, false
			}
		}
	}
	ps = st.switchTo(emu.CompactPlain, ps)
	return ps
}

// planPayloadDelta returns the byte offset from an instruction's start
// to its first payload record (skipping planner-inserted switch and
// count-set records) — the record that block-field addressing
// (.read/.write) must target.
func planPayloadDelta(shapes []cshape) uint32 {
	st := newCstate()
	n := 0
	for _, s := range shapes {
		for _, p := range st.plan(s) {
			if p.kind == pRec || p.kind == pHalt || p.kind == pStageRead {
				return uint32(n) * 8
			}
			n++
		}
	}
	return 0
}

// planCount sizes a whole instruction (shapes + trailing sync) in records.
func planCount(shapes []cshape) uint32 {
	st := newCstate()
	n := 0
	for _, s := range shapes {
		n += len(st.plan(s))
	}
	n += len(st.planSync())
	return uint32(n)
}

// --- Pass-1 literal interning for planner-generated records ---

// internPlanLits interns every literal the emitter will need for the
// given shapes: window literals (plain and pre-swapped variants) and
// count values.
func (a *asm) internPlanLits(shapes []cshape) {
	st := newCstate()
	var prims []prim
	for _, s := range shapes {
		prims = append(prims, st.plan(s)...)
	}
	prims = append(prims, st.planSync()...)
	for _, p := range prims {
		switch p.kind {
		case pSwitch:
			a.internLit(operand{kind: opLit, num: a.switchLitVal(p.from, p.to), isNum: true})
		case pCount:
			a.internLit(operand{kind: opLit, num: p.k, isNum: true})
		}
	}
}

// switchLitVal is the pool word a switch record reads: the target
// window address, pre-transformed for the current bank's data path.
func (a *asm) switchLitVal(from, to int) uint32 {
	w := emu.CompactWindow(to)
	if from == emu.CompactBswap {
		return bswap32(w)
	}
	// size8/size16 transfers read the literal's low byte/half, which are
	// the low bits of the full window address — the same literal works.
	return w
}

func bswap32(x uint32) uint32 {
	return x<<24 | x>>24 | x<<8&0x00FF0000 | x>>8&0x0000FF00
}

// --- Pass-2 record emitter ---

type cemit struct {
	a    *asm
	text *img.Seg
	st   *cstate
	n    uint32 // records emitted for the current instruction
	scrP img.Ptr
	atP  img.Ptr
}

func (c *cemit) emitPrims(ps []prim, src, dst img.Ptr) {
	for _, p := range ps {
		switch p.kind {
		case pRec:
			c.text.RecordP(src, dst)
		case pHalt:
			c.text.RecordP(img.Abs(0), img.Abs(0))
		case pSwitch:
			c.text.RecordP(c.a.litNumPtr(c.a.switchLitVal(p.from, p.to)), c.scrP)
		case pCount:
			c.text.RecordP(c.a.litNumPtr(p.k),
				img.Abs(emu.ChanRegAddr(p.bank, emu.OffAl2TransCount)))
		case pStageRead:
			c.text.RecordP(img.Abs(c.a.v.SniffDataAddr()), c.atP)
		case pStagePush:
			c.text.RecordP(c.atP, img.Abs(emu.ChanRegAddr(emu.CompactFetch, emu.OffReadAddr)))
		}
		c.n++
	}
}

// block converts one classic block; the shape is derived from the same
// (src, dst, count, ctrl) the classic emitter uses.
func (c *cemit) block(src, dst img.Ptr, count, ctrl uint32, dyn bool, cntAfter uint32) error {
	bank, err := c.a.classifyCtrl(ctrl)
	if err != nil {
		return err
	}
	s := cshape{
		bank:     bank,
		count:    count,
		srcSniff: src == img.Abs(c.a.v.SniffDataAddr()),
		dstPc:    dst == img.Abs(emu.ChanRegAddr(emu.CompactFetch, emu.OffReadAddr)),
		dyn:      dyn,
		cntAfter: cntAfter,
	}
	c.emitPrims(c.st.plan(s), src, dst)
	return nil
}

func (c *cemit) halt() {
	c.emitPrims([]prim{{kind: pHalt}}, img.Ptr{}, img.Ptr{})
}

// endInstr emits the canonical-state sync and validates the size against
// pass 1's prediction.
func (c *cemit) endInstr(line int, predicted uint32) error {
	c.emitPrims(c.st.planSync(), img.Ptr{}, img.Ptr{})
	if c.n != predicted {
		return fmt.Errorf("line %d: internal: compact sizing mismatch (layout %d records, emitted %d)",
			line, predicted, c.n)
	}
	c.n = 0
	return nil
}
