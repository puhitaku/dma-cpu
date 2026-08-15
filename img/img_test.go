package img_test

import (
	"reflect"
	"testing"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

func forEachVariant(t *testing.T, fn func(t *testing.T, v *emu.Variant)) {
	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) { fn(t, v) })
	}
}

// buildAddProgram creates a relocatable image computing r = a + b, then
// setting a done flag and halting. Layout mirrors the emulator golden
// tests, but every cross-segment address carries a relocation. Images are
// SKU-specific (ctrl words and sniffer addresses), so the builder takes
// the target Variant. Returns the image and the data-segment offsets of
// (r, done).
func buildAddProgram(t *testing.T, v *emu.Variant, a, b uint32) (*img.Image, uint32, uint32) {
	t.Helper()
	bld := img.NewBuilder()
	text := bld.Seg(0x20000000)
	data := bld.Seg(0x20010000)

	va := data.Word(a)
	vb := data.Word(b)
	r := data.Word(0)
	bucket := data.Word(0)
	done := data.Word(0)
	one := data.Word(1)

	cfg := img.DefaultMachine()
	ctrl := cfg.ExecCtrl(v)
	sniff := img.Abs(v.SniffDataAddr())

	text.BlockP(img.In(data, va), sniff, 1, ctrl)
	text.BlockP(img.In(data, vb), img.In(data, bucket), 1, ctrl|v.CtrlSniffEn)
	text.BlockP(sniff, img.In(data, r), 1, ctrl)
	text.BlockP(img.In(data, one), img.In(data, done), 1, ctrl)
	text.Halt()

	bld.Entry(text, 0)
	// Sniffer init: accumulate on the exec channel.
	bld.AddWrite(v.SniffCtrlAddr(),
		emu.SniffCtrlEN|emu.SniffCtrlDmach(cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
	bld.AddWrite(v.SniffDataAddr(), 0)

	im, err := bld.Image()
	if err != nil {
		t.Fatal(err)
	}
	return im, r, done
}

func TestEncodeDecodeRoundTrip(t *testing.T) {
	im, _, _ := buildAddProgram(t, emu.RP2040, 1, 2)
	raw, err := im.Encode()
	if err != nil {
		t.Fatal(err)
	}
	got, err := img.Decode(raw)
	if err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(im, got) {
		t.Fatalf("round trip mismatch:\n in: %+v\nout: %+v", im, got)
	}
}

func TestDecodeErrors(t *testing.T) {
	im, _, _ := buildAddProgram(t, emu.RP2040, 1, 2)
	raw, err := im.Encode()
	if err != nil {
		t.Fatal(err)
	}
	cases := map[string][]byte{
		"empty":     {},
		"bad magic": append([]byte("NOPE"), raw[4:]...),
		"truncated": raw[:len(raw)-3],
		"trailing":  append(append([]byte{}, raw...), 0, 0, 0, 0),
	}
	for name, data := range cases {
		if _, err := img.Decode(data); err == nil {
			t.Errorf("%s: expected error", name)
		}
	}
}

// runImage loads the image with the given placement, starts it, and runs
// until the watch address is written.
func runImage(t *testing.T, v *emu.Variant, im *img.Image, pl img.Placement, watch uint32) *emu.Machine {
	t.Helper()
	m := emu.NewMachine(v)
	if err := im.LoadAndStart(m, pl, img.DefaultMachine()); err != nil {
		t.Fatal(err)
	}
	res, err := m.Run(emu.RunConfig{MaxCycles: 100_000, WatchWrites: []uint32{watch}})
	if err != nil {
		t.Fatal(err)
	}
	if res.Reason != emu.StopWatch {
		t.Fatalf("program did not finish: %+v", res)
	}
	return m
}

func TestTier1Load(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		im, r, done := buildAddProgram(t, v, 0x1111, 0x2222)
		m := runImage(t, v, im, nil, 0x20010000+done)
		if got := m.Peek32(0x20010000 + r); got != 0x3333 {
			t.Errorf("r = %#x, want 0x3333", got)
		}
	})
}

// TestTier2Relocation is the Phase 1 acceptance test: the same image must
// behave identically wherever its segments are placed. The "high SRAM"
// placement targets RP2350-only address space.
func TestTier2Relocation(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		placements := map[string]img.Placement{
			"move both":      {0: 0x20004000, 1: 0x20024000},
			"move text only": {0: 0x20008C10},
			"move data only": {1: 0x2001F000},
		}
		if v == emu.RP2350 {
			// Exercise the extra 256 KiB that only RP2350 has.
			placements["high sram"] = img.Placement{0: 0x20060000, 1: 0x20070000}
		}
		for name, pl := range placements {
			t.Run(name, func(t *testing.T) {
				im, r, done := buildAddProgram(t, v, 40000, 2345)
				dataBase := uint32(0x20010000)
				if p, ok := pl[1]; ok {
					dataBase = p
				}
				m := runImage(t, v, im, pl, dataBase+done)
				if got := m.Peek32(dataBase + r); got != 42345 {
					t.Errorf("r = %d, want 42345", got)
				}
			})
		}
	})
}

// TestTier2Jump verifies that a jump-target literal (a data word pointing
// into text) is rebased when the text segment moves: the poison block after
// the jump must be skipped at any placement.
func TestTier2Jump(t *testing.T) {
	forEachVariant(t, func(t *testing.T, v *emu.Variant) {
		bld := img.NewBuilder()
		text := bld.Seg(0x20000000)
		data := bld.Seg(0x20010000)

		r := data.Word(0)
		poison := data.Word(0xDEAD)
		good := data.Word(0xC0DE)
		done := data.Word(0)
		one := data.Word(1)

		cfg := img.DefaultMachine()
		ctrl := cfg.ExecCtrl(v)
		pc := img.Abs(emu.ChanRegAddr(cfg.Fetch, emu.OffReadAddr))

		// Jump over the poison block. The target literal is a forward
		// reference: allocate, then patch once the target offset is known.
		target := data.Word(0)
		data.RelocAt(target, text)
		text.BlockP(img.In(data, target), pc, 1, ctrl)
		text.BlockP(img.In(data, poison), img.In(data, r), 1, ctrl)
		landing := text.BlockP(img.In(data, good), img.In(data, r), 1, ctrl)
		data.SetWord(target, text.LinkAddrOf(landing))
		text.BlockP(img.In(data, one), img.In(data, done), 1, ctrl)
		text.Halt()
		bld.Entry(text, 0)

		im, err := bld.Image()
		if err != nil {
			t.Fatal(err)
		}
		pl := img.Placement{0: 0x20030000, 1: 0x20038000}
		m := runImage(t, v, im, pl, 0x20038000+done)
		if got := m.Peek32(0x20038000 + r); got != 0xC0DE {
			t.Errorf("r = %#x, want 0xc0de (poison executed?)", got)
		}
	})
}

// TestWriteRef verifies rebasing of init-write values: an injector-style
// channel armed by the loader must point at the placed data segment.
func TestWriteRef(t *testing.T) {
	v := emu.RP2040
	bld := img.NewBuilder()
	text := bld.Seg(0x20000000)
	data := bld.Seg(0x20010000)
	vec := data.Word(0x12345678)
	done := data.Word(0)
	one := data.Word(1)

	cfg := img.DefaultMachine()
	text.BlockP(img.In(data, one), img.In(data, done), 1, cfg.ExecCtrl(v))
	text.Halt()
	bld.Entry(text, 0)
	// Point channel 3's read address at vec, wherever data lands.
	bld.AddWriteRef(emu.ChanRegAddr(3, emu.OffAl1ReadAddr), data, vec)

	im, err := bld.Image()
	if err != nil {
		t.Fatal(err)
	}
	const dataBase = 0x20020000
	m := runImage(t, v, im, img.Placement{1: dataBase}, dataBase+done)
	if got := m.Peek32(emu.ChanRegAddr(3, emu.OffAl1ReadAddr)); got != dataBase+vec {
		t.Errorf("ch3 READ_ADDR = %#x, want %#x", got, dataBase+vec)
	}
}

func TestOverlapRejected(t *testing.T) {
	im, _, _ := buildAddProgram(t, emu.RP2040, 1, 2)
	m := emu.NewMachine(emu.RP2040)
	// Place data on top of text.
	if _, err := im.Load(m, img.Placement{1: 0x20000000}); err == nil {
		t.Fatal("expected overlap error")
	}
}

// TestSRAMBounds: a placement valid on RP2350 must fail on RP2040's
// smaller SRAM.
func TestSRAMBounds(t *testing.T) {
	im, _, _ := buildAddProgram(t, emu.RP2040, 1, 2)
	m := emu.NewMachine(emu.RP2040)
	if _, err := im.Load(m, img.Placement{1: 0x20060000}); err == nil {
		t.Fatal("expected out-of-SRAM error on rp2040")
	}
	m50 := emu.NewMachine(emu.RP2350)
	if _, err := im.Load(m50, img.Placement{1: 0x20060000}); err != nil {
		t.Fatalf("same placement must fit rp2350: %v", err)
	}
}

func TestUnalignedEntryRejected(t *testing.T) {
	bld := img.NewBuilder()
	text := bld.Seg(0x20000000)
	text.Halt()
	bld.Entry(text, 0)
	im, err := bld.Image()
	if err != nil {
		t.Fatal(err)
	}
	m := emu.NewMachine(emu.RP2040)
	// 16-byte alignment of the entry block must hold after placement too.
	if err := im.LoadAndStart(m, img.Placement{0: 0x20000008}, img.DefaultMachine()); err == nil {
		t.Fatal("expected alignment error")
	}
}
