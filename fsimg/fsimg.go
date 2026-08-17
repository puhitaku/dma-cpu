// Package fsimg builds xv6 filesystem images (a Go reimplementation of
// mkfs/mkfs.c, so tests and dmxgen need no host C tool) and serializes
// DMX-exec files — the executable format the kernel's exec() loads:
// a 13-word header ('DMAX', segment lengths, link bases, reloc count,
// and the symbol offsets the loader needs), then text, data, and the
// packed relocation words. Layout constants mirror kernel/fs.h.
package fsimg

import (
	"encoding/binary"
	"fmt"

	"github.com/puhitaku/dma-cpu/img"
)

const (
	BSIZE    = 1024
	FSMagic  = 0x10203040
	NDirect  = 12
	NIndir   = BSIZE / 4
	DirSiz   = 14
	RootIno  = 1
	TDir     = 1
	TFile    = 2
	TDevice  = 3
	dinodeSz = 64 // 4 shorts + uint size + 13 addrs
	ipb      = BSIZE / dinodeSz
	direntSz = 16
)

// Builder accumulates files and produces the image.
type Builder struct {
	size    uint32 // total blocks
	ninodes uint32
	nlog    uint32

	disk      []byte
	freeBlock uint32
	freeInode uint32
	inodes    []dinode

	inodestart, bmapstart uint32
}

type dinode struct {
	typ          int16
	major, minor int16
	nlink        int16
	size         uint32
	addrs        [NDirect + 1]uint32
}

// New sizes the image: total blocks, inode count, log blocks (the
// kernel never replays the log, but the superblock reserves it).
func New(blocks, ninodes uint32) *Builder {
	// nlog 0: the DMA kernel's log layer is a no-op (kbio.c) — the log
	// region would only waste blocks on an already-tight disk.
	b := &Builder{size: blocks, ninodes: ninodes, nlog: 0}
	ninodeblocks := ninodes/ipb + 1
	nbitmap := blocks/(BSIZE*8) + 1
	b.disk = make([]byte, blocks*BSIZE)
	b.inodestart = 2 + b.nlog
	b.bmapstart = b.inodestart + ninodeblocks
	b.freeBlock = b.bmapstart + nbitmap
	b.freeInode = 1
	b.inodes = make([]dinode, ninodes+1)

	// superblock (block 1)
	sb := b.disk[BSIZE:]
	put := func(off int, v uint32) { binary.LittleEndian.PutUint32(sb[off:], v) }
	put(0, FSMagic)
	put(4, blocks)
	put(8, blocks-b.freeBlock)
	put(12, ninodes)
	put(16, b.nlog)
	put(20, 2)
	put(24, b.inodestart)
	put(28, b.bmapstart)

	// root directory
	root := b.iallocDir()
	if root != RootIno {
		panic("root inode")
	}
	b.dirlink(RootIno, ".", RootIno)
	b.dirlink(RootIno, "..", RootIno)
	return b
}

func (b *Builder) iallocDir() uint32 {
	in := b.freeInode
	b.freeInode++
	b.inodes[in] = dinode{typ: TDir, nlink: 1}
	return in
}

func (b *Builder) balloc() uint32 {
	if b.freeBlock >= b.size {
		panic("fsimg: disk full")
	}
	n := b.freeBlock
	b.freeBlock++
	return n
}

// append adds bytes to inode in's data.
func (b *Builder) iappend(in uint32, data []byte) {
	ip := &b.inodes[in]
	for len(data) > 0 {
		fbn := ip.size / BSIZE
		var blk uint32
		switch {
		case fbn < NDirect:
			if ip.addrs[fbn] == 0 {
				ip.addrs[fbn] = b.balloc()
			}
			blk = ip.addrs[fbn]
		case fbn < NDirect+NIndir:
			if ip.addrs[NDirect] == 0 {
				ip.addrs[NDirect] = b.balloc()
			}
			ind := ip.addrs[NDirect]
			slot := (fbn - NDirect) * 4
			ptr := binary.LittleEndian.Uint32(b.disk[ind*BSIZE+slot:])
			if ptr == 0 {
				ptr = b.balloc()
				binary.LittleEndian.PutUint32(b.disk[ind*BSIZE+slot:], ptr)
			}
			blk = ptr
		default:
			panic("fsimg: file too large")
		}
		off := ip.size % BSIZE
		n := uint32(len(data))
		if n > BSIZE-off {
			n = BSIZE - off
		}
		copy(b.disk[blk*BSIZE+off:], data[:n])
		ip.size += n
		data = data[n:]
	}
}

func (b *Builder) dirlink(dir uint32, name string, inum uint32) {
	if len(name) > DirSiz {
		panic("fsimg: name too long: " + name)
	}
	ent := make([]byte, direntSz)
	binary.LittleEndian.PutUint16(ent, uint16(inum))
	copy(ent[2:], name)
	b.iappend(dir, ent)
}

// AddDevice creates a device inode in the root directory (upstream
// mkfs makes "console" this way).
func (b *Builder) AddDevice(name string, major, minor int16) {
	in := b.freeInode
	b.freeInode++
	b.inodes[in] = dinode{typ: TDevice, major: major, minor: minor, nlink: 1}
	b.dirlink(RootIno, name, in)
}

// AddFile creates name in the root directory with the given content.
func (b *Builder) AddFile(name string, content []byte) {
	in := b.freeInode
	b.freeInode++
	b.inodes[in] = dinode{typ: TFile, nlink: 1}
	b.iappend(in, content)
	b.dirlink(RootIno, name, in)
}

// AddLink adds a second root-directory name for the most recently
// added file — hard links for busybox-style multi-call binaries (the
// toolbox program dispatches on argv[0]).
func (b *Builder) AddLink(name string) {
	in := b.freeInode - 1
	b.inodes[in].nlink++
	b.dirlink(RootIno, name, in)
}

// Bytes finalizes inodes + the free bitmap and returns the image.
func (b *Builder) Bytes() []byte {
	for i := uint32(1); i < b.freeInode; i++ {
		ip := &b.inodes[i]
		off := (b.inodestart+i/ipb)*BSIZE + (i%ipb)*dinodeSz
		d := b.disk[off:]
		binary.LittleEndian.PutUint16(d[0:], uint16(ip.typ))
		binary.LittleEndian.PutUint16(d[2:], uint16(ip.major))
		binary.LittleEndian.PutUint16(d[4:], uint16(ip.minor))
		binary.LittleEndian.PutUint16(d[6:], uint16(ip.nlink))
		binary.LittleEndian.PutUint32(d[8:], ip.size)
		for j, a := range ip.addrs {
			binary.LittleEndian.PutUint32(d[12+4*j:], a)
		}
	}
	for blk := uint32(0); blk < b.freeBlock; blk++ {
		off := b.bmapstart*BSIZE + blk/8
		b.disk[off] |= 1 << (blk % 8)
	}
	return b.disk
}

// DMXExec serializes an assembled (reloc-intact) image as a DMX-exec
// file for the kernel's exec(). sym looks up assembler symbols.
func DMXExec(im *img.Image, sym func(string) (uint32, error)) ([]byte, error) {
	text, data := im.Segments[0], im.Segments[1]
	need := func(n string, base uint32) (uint32, error) {
		a, err := sym(n)
		if err != nil {
			return 0, fmt.Errorf("dmxexec: %w", err)
		}
		return a - base, nil
	}
	var offs [7]uint32
	var err error
	for i, n := range []string{"warmstart", "crtthunk", "dispatch", "irqresume", "lr",
		"g___dma_sysmail", "g___dma_syscall_entry"} {
		base := text.LinkAddr
		if i >= 2 {
			base = data.LinkAddr
		}
		if offs[i], err = need(n, base); err != nil {
			return nil, err
		}
	}
	pad := func(b []byte) []byte {
		for len(b)%4 != 0 {
			b = append(b, 0)
		}
		return b
	}
	t, d := pad(text.Data), pad(data.Data)
	hdr := []uint32{0x58414D44, uint32(len(t)), uint32(len(d)),
		text.LinkAddr, data.LinkAddr, uint32(len(im.Relocs)),
		offs[0], offs[1], offs[2], offs[3], offs[4], offs[5], offs[6]}
	out := make([]byte, 0, 52+len(t)+len(d)+4*len(im.Relocs))
	var w [4]byte
	for _, h := range hdr {
		binary.LittleEndian.PutUint32(w[:], h)
		out = append(out, w[:]...)
	}
	out = append(out, t...)
	out = append(out, d...)
	for _, r := range im.Relocs {
		v := r.Off & 0x3FFFFFFF
		if r.Seg == 1 {
			v |= 1 << 31
		}
		if r.Ref == 1 {
			v |= 1 << 30
		}
		binary.LittleEndian.PutUint32(w[:], v)
		out = append(out, w[:]...)
	}
	return out, nil
}
