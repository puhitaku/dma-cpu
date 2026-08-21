package fsimg

// FAT32 volume builder (prompts/029): produces the vfat images the
// kernel's read-only FAT driver (xv6/dma/kfat.c) mounts, for tests
// and for baking demo volumes. Geometry is the simple end of the
// spec — 512-byte sectors, one sector per cluster, one FAT, 32
// reserved sectors — but the on-disk structures (BPB, FAT chains,
// 8.3 directory entries with VFAT long-name entries) are the real
// ones, so the driver exercised here reads PC-formatted volumes too.
// Note: small volumes get a FAT32 BPB even below the spec's official
// 65525-cluster threshold; the driver trusts the BPB (as this
// project's own volumes do) rather than re-deriving the FAT type.

import (
	"encoding/binary"
	"fmt"
	"strings"
)

const fatSectorSize = 512

type fatFile struct {
	path string // "NAME.TXT" or "DIR/NAME.TXT"
	data []byte
}

// FATBuilder accumulates files, then lays out the volume in Bytes.
type FATBuilder struct {
	totalSectors uint32
	files        []fatFile
	dirs         []string
}

// NewFAT32 creates a builder for a volume of totalSectors 512-byte
// sectors (so a 1 MiB volume is 2048).
func NewFAT32(totalSectors uint32) *FATBuilder {
	return &FATBuilder{totalSectors: totalSectors}
}

// AddDir creates a subdirectory in the root.
func (b *FATBuilder) AddDir(name string) {
	b.dirs = append(b.dirs, name)
}

// AddFile adds a file; path may be "NAME" or "DIR/NAME" for a
// directory previously created with AddDir.
func (b *FATBuilder) AddFile(path string, data []byte) {
	b.files = append(b.files, fatFile{path, data})
}

// shortName produces the 11-byte 8.3 directory-entry name and
// whether the original needs VFAT long-name entries.
func shortName(name string, seq int) ([11]byte, bool) {
	var out [11]byte
	for i := range out {
		out[i] = ' '
	}
	base, ext, _ := strings.Cut(name, ".")
	up := strings.ToUpper(base)
	upext := strings.ToUpper(ext)
	long := up != base || upext != ext || len(base) > 8 || len(ext) > 3 ||
		strings.Contains(ext, ".")
	if long {
		// LONGFI~N style stub.
		stub := strings.Map(func(r rune) rune {
			if r >= 'A' && r <= 'Z' || r >= '0' && r <= '9' {
				return r
			}
			return -1
		}, up)
		if len(stub) > 6 {
			stub = stub[:6]
		}
		stub = fmt.Sprintf("%s~%d", stub, seq)
		copy(out[:8], stub)
		if len(upext) > 3 {
			upext = upext[:3]
		}
		copy(out[8:], upext)
		return out, true
	}
	copy(out[:8], up)
	copy(out[8:], upext)
	return out, false
}

func lfnChecksum(short [11]byte) byte {
	var sum byte
	for _, c := range short {
		sum = ((sum & 1) << 7) + (sum >> 1) + c
	}
	return sum
}

// dirEntries encodes one file's directory entries: LFN entries (when
// needed) followed by the 8.3 entry.
func dirEntries(name string, short [11]byte, long bool, attr byte,
	cluster, size uint32) []byte {
	var out []byte
	if long {
		// 13 UCS-2 units per LFN entry, last entry first with bit 6 set.
		u := make([]uint16, 0, len(name)+1)
		for _, r := range name {
			u = append(u, uint16(r))
		}
		u = append(u, 0)
		for len(u)%13 != 0 {
			u = append(u, 0xFFFF)
		}
		n := len(u) / 13
		sum := lfnChecksum(short)
		for i := n - 1; i >= 0; i-- {
			e := make([]byte, 32)
			seq := byte(i + 1)
			if i == n-1 {
				seq |= 0x40
			}
			e[0] = seq
			e[11] = 0x0F // ATTR_LONG_NAME
			e[13] = sum
			part := u[i*13 : i*13+13]
			slots := []int{1, 3, 5, 7, 9, 14, 16, 18, 20, 22, 24, 28, 30}
			for j, off := range slots {
				binary.LittleEndian.PutUint16(e[off:], part[j])
			}
			out = append(out, e...)
		}
	}
	e := make([]byte, 32)
	copy(e[:11], short[:])
	e[11] = attr
	binary.LittleEndian.PutUint16(e[20:], uint16(cluster>>16))
	binary.LittleEndian.PutUint16(e[26:], uint16(cluster))
	binary.LittleEndian.PutUint32(e[28:], size)
	out = append(out, e...)
	return out
}

// Bytes lays out and returns the volume image.
func (b *FATBuilder) Bytes() []byte {
	const rsvd = 32
	// One FAT, 4 bytes per cluster entry, one sector per cluster:
	// fatSz sectors cover (totalSectors - rsvd - fatSz) clusters.
	fatSz := (b.totalSectors/128 + 2)
	dataStart := rsvd + fatSz
	nclusters := b.totalSectors - dataStart
	img := make([]byte, b.totalSectors*fatSectorSize)

	// --- BPB ---
	bpb := img[0:fatSectorSize]
	copy(bpb[0:], []byte{0xEB, 0x58, 0x90})
	copy(bpb[3:], "DMACPU  ")
	binary.LittleEndian.PutUint16(bpb[11:], fatSectorSize)
	bpb[13] = 1 // sectors per cluster
	binary.LittleEndian.PutUint16(bpb[14:], rsvd)
	bpb[16] = 1 // FATs
	bpb[21] = 0xF8
	binary.LittleEndian.PutUint32(bpb[32:], b.totalSectors)
	binary.LittleEndian.PutUint32(bpb[36:], fatSz)
	binary.LittleEndian.PutUint32(bpb[44:], 2) // root cluster
	binary.LittleEndian.PutUint16(bpb[48:], 1) // FSInfo
	bpb[66] = 0x29
	copy(bpb[71:], "DMA VFAT   ")
	copy(bpb[82:], "FAT32   ")
	bpb[510] = 0x55
	bpb[511] = 0xAA
	// FSInfo (minimal signatures, unknown free count).
	fsi := img[fatSectorSize : 2*fatSectorSize]
	binary.LittleEndian.PutUint32(fsi[0:], 0x41615252)
	binary.LittleEndian.PutUint32(fsi[484:], 0x61417272)
	binary.LittleEndian.PutUint32(fsi[488:], 0xFFFFFFFF)
	binary.LittleEndian.PutUint32(fsi[492:], 0xFFFFFFFF)
	fsi[510] = 0x55
	fsi[511] = 0xAA

	fat := img[rsvd*fatSectorSize : dataStart*fatSectorSize]
	setFAT := func(cl, v uint32) {
		binary.LittleEndian.PutUint32(fat[cl*4:], v)
	}
	setFAT(0, 0x0FFFFFF8)
	setFAT(1, 0x0FFFFFFF)
	next := uint32(3) // 2 is the root
	cluster := func(cl uint32) []byte {
		off := (dataStart + (cl - 2)) * fatSectorSize
		return img[off : off+fatSectorSize]
	}
	// Allocate a cluster chain holding data; returns the first cluster.
	alloc := func(data []byte) uint32 {
		if len(data) == 0 {
			return 0
		}
		first := next
		for off := 0; off < len(data); off += fatSectorSize {
			cl := next
			next++
			if next-2 > nclusters {
				panic("fatimg: volume full")
			}
			end := off + fatSectorSize
			if end > len(data) {
				end = len(data)
			}
			copy(cluster(cl), data[off:end])
			if end < len(data) {
				setFAT(cl, cl+1)
			} else {
				setFAT(cl, 0x0FFFFFFF)
			}
		}
		return first
	}

	// Build directories: root (cluster 2) plus subdirs.
	rootEnts := []byte{}
	subEnts := map[string][]byte{}
	subCl := map[string]uint32{}
	seq := 1
	// Reserve subdir clusters up front so parents can reference them.
	for _, d := range b.dirs {
		subCl[d] = next
		next++
		setFAT(subCl[d], 0x0FFFFFFF)
	}
	for _, f := range b.files {
		dir, name, has := strings.Cut(f.path, "/")
		if !has {
			name = f.path
		}
		cl := alloc(f.data)
		short, long := shortName(name, seq)
		seq++
		ents := dirEntries(name, short, long, 0x20, cl, uint32(len(f.data)))
		if has {
			subEnts[dir] = append(subEnts[dir], ents...)
		} else {
			rootEnts = append(rootEnts, ents...)
		}
	}
	for _, d := range b.dirs {
		short, long := shortName(d, seq)
		seq++
		rootEnts = append(rootEnts,
			dirEntries(d, short, long, 0x10, subCl[d], 0)...)
		// "." and ".." entries inside the subdir.
		var dot, dotdot [11]byte
		copy(dot[:], ".          ")
		copy(dotdot[:], "..         ")
		ents := dirEntries(".", dot, false, 0x10, subCl[d], 0)
		ents = append(ents, dirEntries("..", dotdot, false, 0x10, 0, 0)...)
		subEnts[d] = append(ents, subEnts[d]...)
		if len(subEnts[d]) > fatSectorSize {
			panic("fatimg: subdir too large for one cluster")
		}
		copy(cluster(subCl[d]), subEnts[d])
	}
	if len(rootEnts) > fatSectorSize {
		panic("fatimg: root dir too large for one cluster")
	}
	copy(cluster(2), rootEnts)
	setFAT(2, 0x0FFFFFFF)
	return img
}
