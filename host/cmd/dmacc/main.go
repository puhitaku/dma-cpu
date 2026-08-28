// Command dmacc compiles LLVM IR (.ll, the clang -Oz subset) into
// dmaasm source, and optionally assembles it into a DMX executable.
//
// The front half is stock clang:
//
//	clang --target=armv6m-none-eabi -Oz -fno-unroll-loops -fsigned-char \
//	      -ffreestanding -S -emit-llvm prog.c -o prog.ll
//
// Usage:
//
//	dmacc -o prog.dasm prog.ll                          # IR -> dasm
//	dmacc -sku rp2350 -dmx prog.dmx -o prog.dasm prog.ll  # ... and assemble
//	dmacc -run -dump results:8 prog.ll                  # run in the emulator
//
// -run executes the program in the emulator and prints the exit code
// (main's return value). -dump name[:count] prints memory after the run
// by C symbol name; repeatable.
package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// dumpFlag collects repeatable -dump name[:count] requests.
type dumpFlag []string

func (d *dumpFlag) String() string     { return strings.Join(*d, ",") }
func (d *dumpFlag) Set(s string) error { *d = append(*d, s); return nil }

func run() error {
	entry := flag.String("entry", "main", "entry function")
	noSafepoints := flag.Bool("nosafepoints", false, "omit safepoints at backward branches")
	out := flag.String("o", "", "output .dasm path")
	dmx := flag.String("dmx", "", "also assemble to this .dmx path")
	sku := flag.String("sku", "rp2350", "target SKU (rp2040 or rp2350)")
	textBase := flag.Uint64("text", 0x20000000, "text link address")
	dataBase := flag.Uint64("data", 0x20030000, "data link address (192 KiB of text headroom fits either SKU)")
	doRun := flag.Bool("run", false, "run the program in the emulator")
	size := flag.Bool("size", false, "print a code-size report (blocks by IR construct and function)")
	maxCycles := flag.Uint64("maxcycles", 200_000_000, "emulator cycle budget for -run")
	var dumps dumpFlag
	flag.Var(&dumps, "dump", "after -run, print memory at C symbol `name[:count]` (repeatable)")
	flag.Parse()

	if flag.NArg() < 1 {
		flag.Usage()
		return fmt.Errorf("need at least one input .ll file")
	}
	if *out == "" && *dmx == "" && !*doRun {
		flag.Usage()
		return fmt.Errorf("nothing to do: need -o, -dmx, or -run")
	}
	var mods []*llir.Module
	for _, path := range flag.Args() {
		src, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		mod, err := llir.Parse(string(src))
		if err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		mods = append(mods, mod)
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		return err
	}
	copts := dmacc.Options{Entry: *entry, NoSafepoints: *noSafepoints}
	if *size {
		copts.Stats = &dmacc.Stats{}
	}
	dasm, err := dmacc.Compile(mod, copts)
	if err != nil {
		return err
	}
	if *size {
		fmt.Print(copts.Stats.Report())
	}
	if *out != "" {
		if err := os.WriteFile(*out, []byte(dasm), 0o644); err != nil {
			return err
		}
		fmt.Printf("%s: %d bytes of dasm\n", *out, len(dasm))
	}
	if *dmx == "" && !*doRun {
		return nil
	}
	v, err := emu.VariantByName(*sku)
	if err != nil {
		return err
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant:  v,
		TextBase: uint32(*textBase),
		DataBase: uint32(*dataBase),
	})
	if err != nil {
		return fmt.Errorf("assembling generated dasm: %w", err)
	}
	if *dmx != "" {
		raw, err := res.Image.Encode()
		if err != nil {
			return err
		}
		if err := os.WriteFile(*dmx, raw, 0o644); err != nil {
			return err
		}
		fmt.Printf("%s: %d bytes (sku %s)\n", *dmx, len(raw), v.Name)
	}
	if !*doRun {
		return nil
	}
	return runEmu(res, v, *maxCycles, dumps)
}

// runEmu executes the assembled program and prints the exit code plus
// any requested symbol dumps.
func runEmu(res *dmaasm.Result, v *emu.Variant, maxCycles uint64, dumps dumpFlag) error {
	m := emu.NewMachine(v)
	if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
		return err
	}
	rr, err := m.Run(emu.RunConfig{MaxCycles: maxCycles})
	if err != nil {
		return err
	}
	if rr.Reason != emu.StopIdle {
		return fmt.Errorf("program did not halt: stopped with %q after %d cycles (raise -maxcycles?)", rr.Reason, rr.Cycles)
	}
	if len(m.ConsoleOut) > 0 {
		os.Stdout.Write(m.ConsoleOut)
		if m.ConsoleOut[len(m.ConsoleOut)-1] != '\n' {
			fmt.Println()
		}
	}
	ec, err := res.Symbol("exitcode")
	if err != nil {
		return err
	}
	val := m.Peek32(ec)
	fmt.Printf("exit: %d (0x%x)  cycles: %d  sku: %s\n", int32(val), val, rr.Cycles, v.Name)
	for _, d := range dumps {
		name, count := d, 1
		if i := strings.LastIndexByte(d, ':'); i >= 0 {
			n, err := strconv.Atoi(d[i+1:])
			if err != nil || n < 1 {
				return fmt.Errorf("-dump %q: want name[:count]", d)
			}
			name, count = d[:i], n
		}
		// C globals are emitted as g_<name>; accept either spelling.
		addr, err := res.Symbol("g_" + name)
		if err != nil {
			if addr, err = res.Symbol(name); err != nil {
				return fmt.Errorf("-dump %q: no such symbol", name)
			}
		}
		var vals []string
		for i := 0; i < count; i++ {
			vals = append(vals, strconv.FormatInt(int64(int32(m.Peek32(addr+uint32(4*i)))), 10))
		}
		fmt.Printf("%s: %s\n", name, strings.Join(vals, " "))
	}
	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmacc:", err)
		os.Exit(1)
	}
}
