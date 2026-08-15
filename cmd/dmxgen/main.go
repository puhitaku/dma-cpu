// Command dmxgen generates the HIL (hardware-in-the-loop) test images and
// the C header the target firmware embeds (target/firmware/generated/).
//
// Every image is built for one SKU, executed in the emulator, and the
// emulator's results become the expected values baked into the header —
// the firmware then reports expected-vs-observed per check, so any
// emulator/silicon divergence surfaces as a FAIL on the UART log.
//
// Usage:
//
//	go run ./cmd/dmxgen -sku rp2350 -o target/firmware/generated/images.h
//	go run ./cmd/dmxgen -sku rp2350 -dmxdir out/   # also dump .dmx files
package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

// layout is the SRAM region reserved for the DMA machine on the HIL
// firmware. It must not collide with the firmware's own .data/.bss (low
// SRAM) or stacks (top of SRAM); the firmware asserts this at boot.
type layout struct {
	text, data, scratch uint32
}

var layouts = map[string]layout{
	"rp2350": {text: 0x20040000, data: 0x20050000, scratch: 0x2005FF00},
	"rp2040": {text: 0x20010000, data: 0x20018000, scratch: 0x2001FF00},
}

const calCh = 8 // channel used by the C-side calibration experiments

// check kinds, mirrored by the firmware.
const (
	checkMem  = 0 // read 32-bit word at Addr, compare to Want
	checkGPIO = 1 // read pin Addr level, compare to Want (0/1)
)

type check struct {
	Kind int
	Addr uint32 // address (mem) or pin number (gpio)
	Want uint32 // design intent; verified against the emulator run
	Name string
}

type test struct {
	Name  string
	Image *img.Image
	Done  uint32 // absolute done-flag address; 0 = perf test (no done)
	// Perf tests: counter address and blocks executed per counter tick.
	PerfCounter  uint32
	BlocksPerIt  uint32
	Checks       []check
	EmuCycles    uint64 // filled by the emulator verification run
}

// gp assembles one machine program into text/data segments.
type gp struct {
	v          *emu.Variant
	cfg        emu.FetchExecConfig
	bld        *img.Builder
	text, data *img.Seg
	lay        layout
	bucket     uint32
	done       uint32
}

func newGP(v *emu.Variant, lay layout) *gp {
	bld := img.NewBuilder()
	g := &gp{
		v:    v,
		cfg:  emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Scratch: lay.scratch},
		bld:  bld,
		text: bld.Seg(lay.text),
		data: bld.Seg(lay.data),
		lay:  lay,
	}
	g.bucket = g.data.Word(0)
	g.done = g.data.Word(0)
	return g
}

func (g *gp) dp(off uint32) img.Ptr  { return img.In(g.data, off) }
func (g *gp) dataAddr(off uint32) uint32 { return g.lay.data + off }
func (g *gp) pc() img.Ptr            { return img.Abs(emu.ChanRegAddr(g.cfg.Fetch, emu.OffReadAddr)) }
func (g *gp) sniff() img.Ptr         { return img.Abs(g.v.SniffDataAddr()) }

func (g *gp) move(src, dst img.Ptr, extra ...uint32) uint32 {
	ctrl := g.cfg.ExecCtrl(g.v)
	for _, e := range extra {
		ctrl |= e
	}
	return g.text.BlockP(src, dst, 1, ctrl)
}

// textRefWord allocates a data word that will hold the address of a text
// offset (with reloc); patch later with setTextRef.
func (g *gp) textRefWord() uint32 {
	off := g.data.Word(0)
	g.data.RelocAt(off, g.text)
	return off
}

func (g *gp) setTextRef(dataOff, textOff uint32) {
	g.data.SetWord(dataOff, g.text.LinkAddrOf(textOff))
}

func (g *gp) sniffSumInit() {
	g.bld.AddWrite(g.v.SniffCtrlAddr(),
		emu.SniffCtrlEN|emu.SniffCtrlDmach(g.cfg.Exec)|emu.SniffCtrlCalc(emu.SniffCalcSum))
	g.bld.AddWrite(g.v.SniffDataAddr(), 0)
}

// epilogue: set done flag, halt.
func (g *gp) epilogue() {
	one := g.data.Word(1)
	g.move(g.dp(one), g.dp(g.done))
	g.text.Halt()
}

func (g *gp) finish(name string, checks []check) (*test, error) {
	im, err := g.bld.Image()
	if err != nil {
		return nil, fmt.Errorf("%s: %w", name, err)
	}
	checks = append(checks, check{checkMem, g.dataAddr(g.done), 1, "done"})
	return &test{Name: name, Image: im, Done: g.dataAddr(g.done), Checks: checks}, nil
}

// --- The test programs ---

func progAdd(v *emu.Variant, lay layout) (*test, error) {
	g := newGP(v, lay)
	g.sniffSumInit()
	a, b, r := g.data.Word(0x1111), g.data.Word(0x2222), g.data.Word(0)
	g.move(g.dp(a), g.sniff())
	g.move(g.dp(b), g.dp(g.bucket), v.CtrlSniffEn)
	g.move(g.sniff(), g.dp(r))
	g.epilogue()
	return g.finish("add", []check{{checkMem, g.dataAddr(r), 0x3333, "a+b"}})
}

func progLogic(v *emu.Variant, lay layout) (*test, error) {
	g := newGP(v, lay)
	const A, B = 0x0F0F_3355, 0x00FF_0FF0
	va, vb, notA := g.data.Word(A), g.data.Word(B), g.data.Word(^uint32(A))
	rOr, rAnd, rXor := g.data.Word(0), g.data.Word(0), g.data.Word(0)
	g.move(g.dp(vb), g.sniff())
	g.move(g.dp(va), img.Abs(v.SniffDataSetAddr()))
	g.move(g.sniff(), g.dp(rOr))
	g.move(g.dp(vb), g.sniff())
	g.move(g.dp(notA), img.Abs(v.SniffDataClrAddr()))
	g.move(g.sniff(), g.dp(rAnd))
	g.move(g.dp(vb), g.sniff())
	g.move(g.dp(va), img.Abs(v.SniffDataXORAddr()))
	g.move(g.sniff(), g.dp(rXor))
	g.epilogue()
	return g.finish("logic", []check{
		{checkMem, g.dataAddr(rOr), A | B, "or"},
		{checkMem, g.dataAddr(rAnd), A & B, "and"},
		{checkMem, g.dataAddr(rXor), A ^ B, "xor"},
	})
}

func progCondJump(name string, input, want uint32) func(*emu.Variant, layout) (*test, error) {
	return func(v *emu.Variant, lay layout) (*test, error) {
		g := newGP(v, lay)
		g.sniffSumInit()
		vin, r := g.data.Word(input), g.data.Word(0)
		mask := g.data.Word(0xFFFF_FFEF)
		posMark, negMark := g.data.Word(0x505), g.data.Word(0x909)
		trampBase := g.textRefWord()
		posBody, negBody := g.textRefWord(), g.textRefWord()

		g.move(g.dp(vin), g.sniff(), v.CtrlBswap)
		g.move(g.dp(mask), img.Abs(v.SniffDataClrAddr()))
		g.move(g.dp(trampBase), g.dp(g.bucket), v.CtrlSniffEn)
		g.move(g.sniff(), g.pc())

		g.setTextRef(trampBase, g.text.Len())
		g.move(g.dp(posBody), g.pc()) // trampoline slot 0: non-negative
		g.move(g.dp(negBody), g.pc()) // trampoline slot 1: negative

		one := g.data.Word(1)
		g.setTextRef(posBody, g.text.Len())
		g.move(g.dp(posMark), g.dp(r))
		g.move(g.dp(one), g.dp(g.done))
		g.text.Halt()

		g.setTextRef(negBody, g.text.Len())
		g.move(g.dp(negMark), g.dp(r))
		g.move(g.dp(one), g.dp(g.done))
		g.text.Halt()

		im, err := g.bld.Image()
		if err != nil {
			return nil, fmt.Errorf("%s: %w", name, err)
		}
		return &test{Name: name, Image: im, Done: g.dataAddr(g.done), Checks: []check{
			{checkMem, g.dataAddr(r), want, "branch marker"},
			{checkMem, g.dataAddr(g.done), 1, "done"},
		}}, nil
	}
}

func progGPIO(v *emu.Variant, lay layout) (*test, error) {
	g := newGP(v, lay)
	const pin = 2
	hi, lo := g.data.Word(v.GPIOOutCtrl(true)), g.data.Word(v.GPIOOutCtrl(false))
	ctrl := img.Abs(v.GPIOCtrlAddr(pin))
	g.move(g.dp(hi), ctrl)
	g.move(g.dp(lo), ctrl)
	g.move(g.dp(hi), ctrl) // final state: driven high
	g.epilogue()
	return g.finish("gpio", []check{{checkGPIO, pin, 1, "gpio2 level"}})
}

// progPerf: an endless counter loop; the firmware runs it for a fixed
// time, aborts, and reports blocks/second. 4 blocks per iteration.
func progPerf(v *emu.Variant, lay layout) (*test, error) {
	g := newGP(v, lay)
	g.sniffSumInit()
	counter := g.data.Word(0)
	one := g.data.Word(1)
	loop := g.textRefWord()
	g.setTextRef(loop, 0)
	g.move(g.dp(counter), g.sniff())
	g.move(g.dp(one), g.dp(g.bucket), v.CtrlSniffEn)
	g.move(g.sniff(), g.dp(counter))
	g.move(g.dp(loop), g.pc())
	im, err := g.bld.Image()
	if err != nil {
		return nil, fmt.Errorf("perf: %w", err)
	}
	return &test{Name: "perf", Image: im, PerfCounter: g.dataAddr(counter), BlocksPerIt: 4}, nil
}

// --- Emulator verification: run each image; intended values must match ---

func verify(v *emu.Variant, lay layout, t *test) error {
	m := emu.NewMachine(v)
	cfg := emu.FetchExecConfig{Fetch: 0, Exec: 1, Fix: 2, Scratch: lay.scratch}
	if err := t.Image.LoadAndStart(m, nil, cfg); err != nil {
		return fmt.Errorf("%s: %w", t.Name, err)
	}
	if t.Done == 0 { // perf: just prove it keeps running
		res, err := m.Run(emu.RunConfig{MaxCycles: 10_000})
		if err != nil {
			return fmt.Errorf("%s: %w", t.Name, err)
		}
		if res.Reason != emu.StopMaxCycles {
			return fmt.Errorf("%s: stopped unexpectedly: %+v", t.Name, res)
		}
		if m.Peek32(t.PerfCounter) == 0 {
			return fmt.Errorf("%s: counter did not advance", t.Name)
		}
		return nil
	}
	res, err := m.Run(emu.RunConfig{MaxCycles: 1_000_000, WatchWrites: []uint32{t.Done}})
	if err != nil {
		return fmt.Errorf("%s: %w", t.Name, err)
	}
	if res.Reason != emu.StopWatch {
		return fmt.Errorf("%s: did not reach done: %+v", t.Name, res)
	}
	t.EmuCycles = res.Cycles
	for _, c := range t.Checks {
		switch c.Kind {
		case checkMem:
			if got := m.Peek32(c.Addr); got != c.Want {
				return fmt.Errorf("%s/%s: emulator got %#x, intent %#x", t.Name, c.Name, got, c.Want)
			}
		case checkGPIO:
			evs := m.GPIOEvents
			if len(evs) == 0 {
				return fmt.Errorf("%s/%s: no GPIO events in emulator", t.Name, c.Name)
			}
			level := uint32(0)
			if evs[len(evs)-1].High {
				level = 1
			}
			if level != c.Want {
				return fmt.Errorf("%s/%s: emulator final level %d, intent %d", t.Name, c.Name, level, c.Want)
			}
		}
	}
	return nil
}

// calExpect computes the emulator's sniffer result for the C-side CRC/SUM
// calibration experiments: seed, then pass one 32-bit word through a
// sniffed copy on calCh.
func calExpect(v *emu.Variant, sniffCtrl, seed, word uint32) uint32 {
	m := emu.NewMachine(v)
	src, dst := uint32(0x20001000), uint32(0x20001100)
	m.Poke32(src, word)
	m.Poke32(v.SniffCtrlAddr(), sniffCtrl)
	m.Poke32(v.SniffDataAddr(), seed)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffReadAddr), src)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffWriteAddr), dst)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(calCh, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(calCh)|v.CtrlIRQQuiet|v.CtrlSniffEn)
	if res, err := m.Run(emu.RunConfig{MaxCycles: 1000}); err != nil || res.Reason != emu.StopIdle {
		panic(fmt.Sprintf("calExpect: %+v %v", res, err))
	}
	return m.Peek32(v.SniffDataAddr())
}

// --- C header emission ---

func emitHeader(v *emu.Variant, lay layout, tests []*test) string {
	var b strings.Builder
	p := func(format string, args ...any) { fmt.Fprintf(&b, format+"\n", args...) }

	p("/* Generated by cmd/dmxgen — DO NOT EDIT. Regenerate with:")
	p(" *   go run ./cmd/dmxgen -sku %s -o target/firmware/generated/images.h", v.Name)
	p(" * Expected values are the emulator's results: a FAIL on hardware")
	p(" * means silicon and emulator disagree — that is the finding. */")
	p("#ifndef DMX_HIL_IMAGES_H")
	p("#define DMX_HIL_IMAGES_H")
	p("")
	p("#include <stddef.h>")
	p("#include <stdint.h>")
	p("")
	p("#define HIL_SKU \"%s\"", v.Name)
	p("#define HIL_SCRATCH 0x%08Xu", lay.scratch)
	p("#define HIL_MACHINE_RAM_START 0x%08Xu", lay.text)
	p("#define HIL_MACHINE_RAM_END 0x%08Xu", lay.scratch+4)
	p("")
	p("/* Calibration experiment constants (channel %d). */", calCh)
	p("#define HIL_CAL_CH %d", calCh)
	p("#define HIL_CAL_CH_BASE 0x%08Xu", emu.ChanRegAddr(calCh, 0))
	p("#define HIL_INTR_ADDR 0x%08Xu", v.IntrAddr())
	p("#define HIL_CHAN_ABORT_ADDR 0x%08Xu", v.ChanAbortAddr())
	p("#define HIL_TIMER0_ADDR 0x%08Xu", v.TimerAddr(0))
	p("#define HIL_SNIFF_CTRL_ADDR 0x%08Xu", v.SniffCtrlAddr())
	p("#define HIL_SNIFF_DATA_ADDR 0x%08Xu", v.SniffDataAddr())
	p("#define HIL_NCHANNELS %d", v.NChannels)
	p("#define HIL_CTRL_BUSY_MASK 0x%08Xu", v.CtrlBusy)
	base := emu.CtrlEN | emu.CtrlSize32 | v.CtrlTreq(emu.TreqPermanent) | v.CtrlChainTo(calCh) | v.CtrlIRQQuiet
	p("#define HIL_CAL_CTRL_BASIC 0x%08Xu", base)
	p("#define HIL_CAL_CTRL_BASIC_NOEN 0x%08Xu", base&^emu.CtrlEN)
	p("#define HIL_CAL_CTRL_BASIC_LOUD 0x%08Xu", base&^v.CtrlIRQQuiet)
	p("#define HIL_CAL_CTRL_TIMER0 0x%08Xu",
		emu.CtrlEN|emu.CtrlSize32|v.CtrlTreq(emu.TreqTimer0)|v.CtrlChainTo(calCh)|v.CtrlIRQQuiet)
	p("#define HIL_CAL_CTRL_SNIFF 0x%08Xu", base|v.CtrlSniffEn)
	crcCtrl := emu.SniffCtrlEN | emu.SniffCtrlDmach(calCh) | emu.SniffCtrlCalc(emu.SniffCalcCRC32)
	sumCtrl := emu.SniffCtrlEN | emu.SniffCtrlDmach(calCh) | emu.SniffCtrlCalc(emu.SniffCalcSum)
	p("#define HIL_CAL_SNIFF_CRC32 0x%08Xu", crcCtrl)
	p("#define HIL_CAL_SNIFF_SUM 0x%08Xu", sumCtrl)
	p("#define HIL_CAL_EXPECT_CRC32 0x%08Xu /* emulator; calibrating */", calExpect(v, crcCtrl, 0xFFFFFFFF, 0x12345678))
	p("#define HIL_CAL_EXPECT_SUM 0x%08Xu", calExpect(v, sumCtrl, 0x1000, 0x234))
	p("")
	p("typedef struct { int kind; uint32_t addr; uint32_t want; const char *what; } hil_check;")
	p("typedef struct {")
	p("    const char *name;")
	p("    const uint8_t *dmx; size_t dmx_len;")
	p("    uint32_t done_addr;               /* 0: perf test */")
	p("    uint32_t perf_counter_addr, blocks_per_iter;")
	p("    int n_checks; hil_check checks[8];")
	p("} hil_test;")
	p("")
	for _, t := range tests {
		raw, err := t.Image.Encode()
		if err != nil {
			panic(err)
		}
		p("static const uint8_t hil_%s_dmx[] = {", t.Name)
		for i := 0; i < len(raw); i += 16 {
			end := min(i+16, len(raw))
			var line []string
			for _, by := range raw[i:end] {
				line = append(line, fmt.Sprintf("0x%02x", by))
			}
			p("    %s,", strings.Join(line, ", "))
		}
		p("};")
	}
	p("")
	p("static const hil_test hil_tests[] = {")
	for _, t := range tests {
		p("    {\"%s\", hil_%s_dmx, sizeof hil_%s_dmx, 0x%08Xu, 0x%08Xu, %d, %d, {",
			t.Name, t.Name, t.Name, t.Done, t.PerfCounter, t.BlocksPerIt, len(t.Checks))
		for _, c := range t.Checks {
			p("        {%d, 0x%08Xu, 0x%08Xu, \"%s\"},", c.Kind, c.Addr, c.Want, c.Name)
		}
		p("    }},")
	}
	p("};")
	p("#define HIL_N_TESTS %d", len(tests))
	p("")
	p("#endif /* DMX_HIL_IMAGES_H */")
	return b.String()
}

func run() error {
	sku := flag.String("sku", "rp2350", "target SKU (rp2040 or rp2350)")
	out := flag.String("o", "target/firmware/generated/images.h", "output C header path")
	dmxDir := flag.String("dmxdir", "", "also write raw .dmx files into this directory")
	flag.Parse()

	v, err := emu.VariantByName(*sku)
	if err != nil {
		return err
	}
	lay, ok := layouts[v.Name]
	if !ok {
		return fmt.Errorf("no HIL layout for %s", v.Name)
	}

	builders := []func(*emu.Variant, layout) (*test, error){
		progAdd,
		progLogic,
		progCondJump("condjump_pos", 5, 0x505),
		progCondJump("condjump_neg", ^uint32(5)+1, 0x909),
		progGPIO,
		progPerf,
	}
	var tests []*test
	for _, build := range builders {
		t, err := build(v, lay)
		if err != nil {
			return err
		}
		if err := verify(v, lay, t); err != nil {
			return fmt.Errorf("emulator verification failed: %w", err)
		}
		tests = append(tests, t)
	}

	if *dmxDir != "" {
		if err := os.MkdirAll(*dmxDir, 0o755); err != nil {
			return err
		}
		for _, t := range tests {
			raw, err := t.Image.Encode()
			if err != nil {
				return err
			}
			path := filepath.Join(*dmxDir, t.Name+".dmx")
			if err := os.WriteFile(path, raw, 0o644); err != nil {
				return err
			}
		}
	}
	if err := os.MkdirAll(filepath.Dir(*out), 0o755); err != nil {
		return err
	}
	if err := os.WriteFile(*out, []byte(emitHeader(v, lay, tests)), 0o644); err != nil {
		return err
	}
	for _, t := range tests {
		fmt.Printf("%-14s %5d bytes  emu cycles: %d\n", t.Name, mustLen(t), t.EmuCycles)
	}
	fmt.Printf("wrote %s (sku %s)\n", *out, v.Name)
	return nil
}

func mustLen(t *test) int {
	raw, err := t.Image.Encode()
	if err != nil {
		panic(err)
	}
	return len(raw)
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmxgen:", err)
		os.Exit(1)
	}
}
