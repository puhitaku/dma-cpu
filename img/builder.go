package img

import "encoding/binary"

// Builder constructs an Image programmatically. It is the low-level
// producer API that the Phase 2 assembler will target; tests use it
// directly. Offsets returned by the emit methods are segment-relative;
// combined with relocations they stand in for symbols.
type Builder struct {
	img Image
}

func NewBuilder() *Builder { return &Builder{} }

// Seg adds a segment linked at linkAddr and returns its handle.
func (b *Builder) Seg(linkAddr uint32) *Seg {
	b.img.Segments = append(b.img.Segments, Segment{LinkAddr: linkAddr})
	return &Seg{b: b, idx: uint32(len(b.img.Segments) - 1)}
}

// AddWrite appends an absolute MMIO init write.
func (b *Builder) AddWrite(addr, value uint32) {
	b.img.Writes = append(b.img.Writes, Write{Addr: addr, Value: value, Ref: RefAbs})
}

// AddWriteRef appends an init write whose value is an address inside ref
// (given as the segment-relative offset), rebased at load time.
func (b *Builder) AddWriteRef(addr uint32, ref *Seg, off uint32) {
	b.img.Writes = append(b.img.Writes, Write{Addr: addr, Value: ref.linkAddr() + off, Ref: ref.idx})
}

// Entry sets the entry point to the given offset within seg.
func (b *Builder) Entry(seg *Seg, off uint32) {
	b.img.EntrySeg = seg.idx
	b.img.EntryOff = off
}

// Image finalizes and returns the image (still owned by the builder).
func (b *Builder) Image() (*Image, error) {
	if err := b.img.validate(); err != nil {
		return nil, err
	}
	return &b.img, nil
}

// Seg is a segment under construction.
type Seg struct {
	b   *Builder
	idx uint32
}

func (s *Seg) linkAddr() uint32 { return s.b.img.Segments[s.idx].LinkAddr }
func (s *Seg) data() *[]byte    { return &s.b.img.Segments[s.idx].Data }

// Len returns the current segment length (== the offset of the next emit).
func (s *Seg) Len() uint32 { return uint32(len(*s.data())) }

// LinkAddrOf converts a segment-relative offset to its link-time address.
// The value is only meaningful in a word that carries a matching reloc (or
// under Tier-1 placement).
func (s *Seg) LinkAddrOf(off uint32) uint32 { return s.linkAddr() + off }

// Word appends a literal word and returns its offset.
func (s *Seg) Word(v uint32) uint32 {
	off := s.Len()
	*s.data() = binary.LittleEndian.AppendUint32(*s.data(), v)
	return off
}

// WordRef appends a word holding the address of ref:refOff, with a reloc so
// it is rebased when ref moves. Used for jump-target literals and pointers.
func (s *Seg) WordRef(ref *Seg, refOff uint32) uint32 {
	off := s.Word(ref.LinkAddrOf(refOff))
	s.RelocAt(off, ref)
	return off
}

// SetWord patches a previously emitted word (for forward references).
func (s *Seg) SetWord(off, v uint32) {
	binary.LittleEndian.PutUint32((*s.data())[off:off+4], v)
}

// RelocAt marks the word at off as an address into ref.
func (s *Seg) RelocAt(off uint32, ref *Seg) {
	s.b.img.Relocs = append(s.b.img.Relocs, Reloc{Seg: s.idx, Off: off, Ref: ref.idx})
}

// Block appends a control block whose READ_ADDR/WRITE_ADDR are absolute
// (MMIO or otherwise placement-independent) and returns its offset.
func (s *Seg) Block(read, write, count, ctrl uint32) uint32 {
	off := s.Word(read)
	s.Word(write)
	s.Word(count)
	s.Word(ctrl)
	return off
}

// Ptr names an address operand for BlockP: either absolute or a
// segment-relative reference that must be rebased with the segment.
type Ptr struct {
	seg *Seg // nil = absolute
	off uint32
	abs uint32
}

func Abs(addr uint32) Ptr          { return Ptr{abs: addr} }
func In(s *Seg, off uint32) Ptr    { return Ptr{seg: s, off: off} }

// BlockP appends a control block with relocatable operands and returns its
// offset.
func (s *Seg) BlockP(read, write Ptr, count, ctrl uint32) uint32 {
	off := s.Len()
	emitPtr := func(p Ptr) {
		if p.seg == nil {
			s.Word(p.abs)
		} else {
			s.WordRef(p.seg, p.off)
		}
	}
	emitPtr(read)
	emitPtr(write)
	s.Word(count)
	s.Word(ctrl)
	return off
}

// Halt appends the all-zero null-trigger block.
func (s *Seg) Halt() uint32 { return s.Block(0, 0, 0, 0) }

// RecordP appends a compact 8-byte record (READ_ADDR, WRITE_ADDR) with
// relocatable operands and returns its offset (Tier C, prompts/010).
func (s *Seg) RecordP(read, write Ptr) uint32 {
	off := s.Len()
	for _, p := range [2]Ptr{read, write} {
		if p.seg == nil {
			s.Word(p.abs)
		} else {
			s.WordRef(p.seg, p.off)
		}
	}
	return off
}
