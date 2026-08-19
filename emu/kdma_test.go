package emu

import "testing"

// TestKDMACopyChannel drives channel 11 exactly as the kernel's
// kdmacpy does: READ_ADDR, WRITE_ADDR, TRANS_COUNT, CTRL_TRIG, then
// polls TRANS_COUNT to zero.
func TestKDMACopyChannel(t *testing.T) {
	v := RP2350
	m := NewMachine(v)
	src, dst := uint32(0x20001000), uint32(0x20002000)
	for i := uint32(0); i < 16; i++ {
		m.Poke32(src+4*i, 0xA0B00000+i)
	}
	base := DMABase + 11*ChanStride
	m.Poke32(base+0x0, src)
	m.Poke32(base+0x4, dst)
	m.Poke32(base+0x8, 16)
	m.Poke32(base+0xC, v.KDMACopyCtrl())
	rr, err := m.Run(RunConfig{MaxCycles: 1000})
	if err != nil {
		t.Fatalf("run: %v", err)
	}
	t.Logf("stop %v after %d cycles; remaining=%d", rr.Reason, rr.Cycles, m.Peek32(base+0x8))
	for i := uint32(0); i < 16; i++ {
		if got := m.Peek32(dst + 4*i); got != 0xA0B00000+i {
			t.Fatalf("word %d: %#x", i, got)
		}
	}
	if m.Peek32(dst+64) != 0 {
		t.Fatalf("copied past the end")
	}
}
