// Package img defines the DMX executable image format for DMA-machine
// programs and its loader (see prompts/overview.md §4.4 and Phase 1, and
// doc/dmx.md for the binary layout).
//
// A DMX image is a list of segments (program blocks and data are both just
// bytes), a list of ABS32 relocations, a list of MMIO init writes, and an
// entry point. Tier 1 use loads every segment at its link address; Tier 2
// use places segments anywhere and the loader rebases every relocated word
// by the segment's placement delta — the DMA machine's entire answer to
// position independence, since blocks address everything absolutely.
package img

import (
	"encoding/binary"
	"fmt"
)

const (
	Magic uint32 = 0x31584D44 // "DMX1", little-endian

	// RefAbs marks a write value as absolute (not rebased by any segment).
	RefAbs uint32 = 0xFFFFFFFF
)

// Segment is a contiguous byte range linked at LinkAddr. Data length must
// be a multiple of 4 (the machine is word-oriented; the encoder enforces
// it).
type Segment struct {
	LinkAddr uint32
	Data     []byte
}

// Reloc rebases the 32-bit word at Seg:Off by the placement delta of
// segment Ref. Both program-text fields (block READ_ADDR/WRITE_ADDR words
// pointing at data) and data words (jump-target literals pointing at text)
// are covered by the same record.
type Reloc struct {
	Seg uint32 // segment containing the word to fix up
	Off uint32 // byte offset of the word within Seg
	Ref uint32 // segment whose placement delta is added
}

// Write is an MMIO (or memory) init write applied by the loader after
// segments are placed, in table order. Typical uses: sniffer configuration,
// pacing timers, arming an interrupt injector channel. If Ref != RefAbs,
// Value is rebased by segment Ref's placement delta first.
type Write struct {
	Addr  uint32
	Value uint32
	Ref   uint32
}

// Image is a decoded DMX executable.
type Image struct {
	Segments []Segment
	Relocs   []Reloc
	Writes   []Write
	EntrySeg uint32 // segment containing the first control block
	EntryOff uint32 // byte offset of the entry block within EntrySeg
}

// Encode serializes the image (see doc/dmx.md).
func (im *Image) Encode() ([]byte, error) {
	if err := im.validate(); err != nil {
		return nil, err
	}
	var out []byte
	w := func(vs ...uint32) {
		for _, v := range vs {
			out = binary.LittleEndian.AppendUint32(out, v)
		}
	}
	w(Magic, 0, uint32(len(im.Segments)), uint32(len(im.Relocs)), uint32(len(im.Writes)),
		im.EntrySeg, im.EntryOff)
	for _, s := range im.Segments {
		w(s.LinkAddr, uint32(len(s.Data)))
	}
	for _, r := range im.Relocs {
		w(r.Seg, r.Off, r.Ref)
	}
	for _, wr := range im.Writes {
		w(wr.Addr, wr.Value, wr.Ref)
	}
	for _, s := range im.Segments {
		out = append(out, s.Data...)
	}
	return out, nil
}

// Decode parses and validates a DMX image.
func Decode(raw []byte) (*Image, error) {
	r := reader{raw: raw}
	if r.u32() != Magic {
		return nil, fmt.Errorf("dmx: bad magic")
	}
	if flags := r.u32(); flags != 0 {
		return nil, fmt.Errorf("dmx: unsupported flags %#x", flags)
	}
	nSeg, nRel, nWr := r.u32(), r.u32(), r.u32()
	im := &Image{EntrySeg: r.u32(), EntryOff: r.u32()}
	// Arbitrary sanity bounds to reject garbage counts before allocating.
	if nSeg > 1024 || nRel > 1<<20 || nWr > 1<<16 {
		return nil, fmt.Errorf("dmx: implausible table sizes (%d/%d/%d)", nSeg, nRel, nWr)
	}
	sizes := make([]uint32, nSeg)
	for i := range sizes {
		im.Segments = append(im.Segments, Segment{LinkAddr: r.u32()})
		sizes[i] = r.u32()
	}
	for i := uint32(0); i < nRel; i++ {
		im.Relocs = append(im.Relocs, Reloc{Seg: r.u32(), Off: r.u32(), Ref: r.u32()})
	}
	for i := uint32(0); i < nWr; i++ {
		im.Writes = append(im.Writes, Write{Addr: r.u32(), Value: r.u32(), Ref: r.u32()})
	}
	for i := range im.Segments {
		im.Segments[i].Data = r.bytes(sizes[i])
	}
	if r.err != nil {
		return nil, fmt.Errorf("dmx: truncated image: %w", r.err)
	}
	if r.pos != len(raw) {
		return nil, fmt.Errorf("dmx: %d trailing bytes", len(raw)-r.pos)
	}
	if err := im.validate(); err != nil {
		return nil, err
	}
	return im, nil
}

func (im *Image) validate() error {
	nSeg := uint32(len(im.Segments))
	for i, s := range im.Segments {
		if len(s.Data)%4 != 0 {
			return fmt.Errorf("dmx: segment %d size %d not word-aligned", i, len(s.Data))
		}
		if s.LinkAddr%4 != 0 {
			return fmt.Errorf("dmx: segment %d link address %#x not word-aligned", i, s.LinkAddr)
		}
	}
	for i, r := range im.Relocs {
		if r.Seg >= nSeg || r.Ref >= nSeg {
			return fmt.Errorf("dmx: reloc %d references segment out of range", i)
		}
		if r.Off%4 != 0 || r.Off+4 > uint32(len(im.Segments[r.Seg].Data)) {
			return fmt.Errorf("dmx: reloc %d offset %#x invalid", i, r.Off)
		}
	}
	for i, w := range im.Writes {
		if w.Ref != RefAbs && w.Ref >= nSeg {
			return fmt.Errorf("dmx: write %d references segment out of range", i)
		}
		if w.Addr%4 != 0 {
			return fmt.Errorf("dmx: write %d address %#x not word-aligned", i, w.Addr)
		}
	}
	if im.EntrySeg >= nSeg {
		return fmt.Errorf("dmx: entry segment out of range")
	}
	if im.EntryOff%16 != 0 || im.EntryOff >= uint32(len(im.Segments[im.EntrySeg].Data)) {
		return fmt.Errorf("dmx: entry offset %#x invalid", im.EntryOff)
	}
	return nil
}

type reader struct {
	raw []byte
	pos int
	err error
}

func (r *reader) u32() uint32 {
	if r.err != nil {
		return 0
	}
	if r.pos+4 > len(r.raw) {
		r.err = fmt.Errorf("need 4 bytes at offset %d", r.pos)
		return 0
	}
	v := binary.LittleEndian.Uint32(r.raw[r.pos:])
	r.pos += 4
	return v
}

func (r *reader) bytes(n uint32) []byte {
	if r.err != nil {
		return nil
	}
	if r.pos+int(n) > len(r.raw) {
		r.err = fmt.Errorf("need %d bytes at offset %d", n, r.pos)
		return nil
	}
	b := make([]byte, n)
	copy(b, r.raw[r.pos:])
	r.pos += int(n)
	return b
}
