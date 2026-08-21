// Command dmaasm assembles DMA-machine assembly (.dasm) into a DMX
// executable (doc/dmx.md) for one RP2 SKU.
//
// Usage:
//
//	dmaasm -sku rp2350 [-text 0x20040000] [-data 0x20050000] \
//	       [-syms out.json] -o out.dmx prog.dasm
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
)

func run() error {
	sku := flag.String("sku", "rp2350", "target SKU (rp2040 or rp2350)")
	textBase := flag.Uint64("text", 0x20000000, "text segment link address")
	dataBase := flag.Uint64("data", 0x20010000, "data segment link address")
	out := flag.String("o", "", "output .dmx path (required)")
	syms := flag.String("syms", "", "optional symbol table output (JSON)")
	flag.Parse()

	if *out == "" || flag.NArg() != 1 {
		flag.Usage()
		return fmt.Errorf("need -o and exactly one input file")
	}
	v, err := emu.VariantByName(*sku)
	if err != nil {
		return err
	}
	src, err := os.ReadFile(flag.Arg(0))
	if err != nil {
		return err
	}
	res, err := dmaasm.Assemble(string(src), dmaasm.Options{
		Variant:  v,
		TextBase: uint32(*textBase),
		DataBase: uint32(*dataBase),
	})
	if err != nil {
		return fmt.Errorf("%s: %w", flag.Arg(0), err)
	}
	raw, err := res.Image.Encode()
	if err != nil {
		return err
	}
	if err := os.WriteFile(*out, raw, 0o644); err != nil {
		return err
	}
	if *syms != "" {
		hexed := make(map[string]string, len(res.Symbols))
		for k, a := range res.Symbols {
			hexed[k] = fmt.Sprintf("%#08x", a)
		}
		data, err := json.MarshalIndent(hexed, "", "  ")
		if err != nil {
			return err
		}
		if err := os.WriteFile(*syms, append(data, '\n'), 0o644); err != nil {
			return err
		}
	}
	fmt.Printf("%s: %d bytes (sku %s)\n", *out, len(raw), v.Name)
	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmaasm:", err)
		os.Exit(1)
	}
}
