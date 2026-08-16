// Command dmacc compiles LLVM IR (.ll, the clang -O1 subset) into
// dmaasm source, and optionally assembles it into a DMX executable.
//
// The front half is stock clang:
//
//	clang --target=armv6m-none-eabi -O1 -fno-unroll-loops -fsigned-char \
//	      -ffreestanding -S -emit-llvm prog.c -o prog.ll
//
// Usage:
//
//	dmacc -o prog.dasm prog.ll                          # IR -> dasm
//	dmacc -sku rp2350 -dmx prog.dmx -o prog.dasm prog.ll  # ... and assemble
package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
)

func run() error {
	entry := flag.String("entry", "main", "entry function")
	noSafepoints := flag.Bool("nosafepoints", false, "omit safepoints at backward branches")
	out := flag.String("o", "", "output .dasm path (required)")
	dmx := flag.String("dmx", "", "also assemble to this .dmx path")
	sku := flag.String("sku", "rp2350", "target SKU for -dmx (rp2040 or rp2350)")
	textBase := flag.Uint64("text", 0x20000000, "text link address for -dmx")
	dataBase := flag.Uint64("data", 0x20010000, "data link address for -dmx")
	flag.Parse()

	if *out == "" || flag.NArg() != 1 {
		flag.Usage()
		return fmt.Errorf("need -o and exactly one input .ll file")
	}
	src, err := os.ReadFile(flag.Arg(0))
	if err != nil {
		return err
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		return fmt.Errorf("%s: %w", flag.Arg(0), err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{Entry: *entry, NoSafepoints: *noSafepoints})
	if err != nil {
		return fmt.Errorf("%s: %w", flag.Arg(0), err)
	}
	if err := os.WriteFile(*out, []byte(dasm), 0o644); err != nil {
		return err
	}
	fmt.Printf("%s: %d bytes of dasm\n", *out, len(dasm))
	if *dmx == "" {
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
	raw, err := res.Image.Encode()
	if err != nil {
		return err
	}
	if err := os.WriteFile(*dmx, raw, 0o644); err != nil {
		return err
	}
	fmt.Printf("%s: %d bytes (sku %s)\n", *dmx, len(raw), v.Name)
	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmacc:", err)
		os.Exit(1)
	}
}
