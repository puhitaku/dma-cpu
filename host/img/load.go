package img

import (
	"encoding/binary"
	"fmt"
	"sort"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// Placement maps a segment index to its load address. Segments not present
// load at their link address (Tier 1). Load addresses must be word-aligned;
// the entry segment must land 16-byte aligned.
type Placement map[int]uint32

// ABI v0 draft defaults (to be frozen in Phase 2): the machine occupies
// channels 0–2 and one reserved SRAM word near the top of memory.
func DefaultMachine() emu.FetchExecConfig {
	return emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Scratch: 0x2003FF00}
}

// CompactMachine is the Tier-C 8-byte-record machine (emu/compact.go):
// fixed channel map, bank/fix configuration carried by the image's init
// writes, fetch-only loader setup.
func CompactMachine() emu.FetchExecConfig {
	return emu.FetchExecConfig{Compact: true}
}

// Load places the image into the machine's memory, applies relocations and
// init writes, and returns the resolved entry address. It does not start
// the machine — callers that want the standard fetch/execute arrangement
// use LoadAndStart.
func (im *Image) Load(m *emu.Machine, pl Placement) (entry uint32, err error) {
	place := make([]uint32, len(im.Segments))
	delta := make([]uint32, len(im.Segments))
	for i, s := range im.Segments {
		place[i] = s.LinkAddr
		if p, ok := pl[i]; ok {
			place[i] = p
		}
		if place[i]%4 != 0 {
			return 0, fmt.Errorf("dmx: segment %d placed at unaligned %#x", i, place[i])
		}
		delta[i] = place[i] - s.LinkAddr // wraps; addition rebase is exact
	}
	if err := checkOverlap(im.Segments, place); err != nil {
		return 0, err
	}

	// Relocate into scratch copies so the Image stays reusable.
	bufs := make([][]byte, len(im.Segments))
	for i, s := range im.Segments {
		bufs[i] = append([]byte(nil), s.Data...)
	}
	for _, r := range im.Relocs {
		b := bufs[r.Seg][r.Off : r.Off+4]
		binary.LittleEndian.PutUint32(b, binary.LittleEndian.Uint32(b)+delta[r.Ref])
	}
	for i, b := range bufs {
		if err := m.LoadBytes(place[i], b); err != nil {
			return 0, fmt.Errorf("dmx: segment %d: %w", i, err)
		}
	}
	for i, w := range im.Writes {
		v := w.Value
		if w.Ref != RefAbs {
			v += delta[w.Ref]
		}
		if err := m.Write(w.Addr, v, 4); err != nil {
			return 0, fmt.Errorf("dmx: init write %d: %w", i, err)
		}
	}
	return place[im.EntrySeg] + im.EntryOff, nil
}

// LoadAndStart loads the image and starts it on the standard 3-channel
// fetch/execute machine. cfg.Entry is taken from the image.
func (im *Image) LoadAndStart(m *emu.Machine, pl Placement, cfg emu.FetchExecConfig) error {
	entry, err := im.Load(m, pl)
	if err != nil {
		return err
	}
	cfg.Entry = entry
	return emu.SetupFetchExec(m, cfg)
}

func checkOverlap(segs []Segment, place []uint32) error {
	type extent struct {
		idx        int
		start, end uint32
	}
	var es []extent
	for i, s := range segs {
		if len(s.Data) == 0 {
			continue
		}
		es = append(es, extent{i, place[i], place[i] + uint32(len(s.Data))})
	}
	sort.Slice(es, func(a, b int) bool { return es[a].start < es[b].start })
	for i := 1; i < len(es); i++ {
		if es[i].start < es[i-1].end {
			return fmt.Errorf("dmx: segments %d and %d overlap at %#x",
				es[i-1].idx, es[i].idx, es[i].start)
		}
	}
	return nil
}
