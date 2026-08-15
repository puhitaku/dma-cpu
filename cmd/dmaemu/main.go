// Command dmaemu runs a DMA-machine program in the emulator, driven by a
// JSON config file. Example:
//
//	{
//	  "load":    [{"file": "prog.bin", "addr": "0x20000000"}],
//	  "poke32":  [{"addr": "0x20010000", "value": "0x2a"}],
//	  "machine": {"fetch": 0, "exec": 1, "fix": 2,
//	              "entry": "0x20000000", "scratch": "0x2003ff00"},
//	  "writes":  [{"addr": "0x50000434", "value": "0x1e3"}],
//	  "run":     {"maxCycles": 1000000, "watchWrites": ["0x2001fffc"]},
//	  "dump32":  [{"addr": "0x20010000", "count": 4}]
//	}
//
// "writes" are ordered raw register writes applied after "machine" setup
// (or standalone, for hand-configured channel arrangements). The result —
// stop reason, cycle count, dumps, and GPIO events — is printed as JSON.
//
// Alternatively, a DMX executable (see doc/dmx.md) replaces "machine":
//
//	{
//	  "image": {"file": "prog.dmx", "placement": {"1": "0x20020000"}},
//	  "run":   {"maxCycles": 1000000}
//	}
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strconv"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
)

// u32 accepts JSON numbers or strings in any Go literal base ("0x...").
type u32 uint32

func (u *u32) UnmarshalJSON(b []byte) error {
	var s string
	if err := json.Unmarshal(b, &s); err == nil {
		v, err := strconv.ParseUint(s, 0, 32)
		if err != nil {
			return err
		}
		*u = u32(v)
		return nil
	}
	var n uint64
	if err := json.Unmarshal(b, &n); err != nil {
		return err
	}
	*u = u32(n)
	return nil
}

type config struct {
	Load []struct {
		File string `json:"file"`
		Addr u32    `json:"addr"`
	} `json:"load"`
	Poke32 []struct {
		Addr  u32 `json:"addr"`
		Value u32 `json:"value"`
	} `json:"poke32"`
	Machine *struct {
		Fetch   int `json:"fetch"`
		Exec    int `json:"exec"`
		Fix     int `json:"fix"`
		Entry   u32 `json:"entry"`
		Scratch u32 `json:"scratch"`
	} `json:"machine"`
	Image *struct {
		File      string         `json:"file"`
		Placement map[string]u32 `json:"placement"`
	} `json:"image"`
	Writes []struct {
		Addr  u32 `json:"addr"`
		Value u32 `json:"value"`
	} `json:"writes"`
	Run struct {
		MaxCycles   uint64 `json:"maxCycles"`
		WatchWrites []u32  `json:"watchWrites"`
	} `json:"run"`
	Dump32 []struct {
		Addr  u32 `json:"addr"`
		Count int `json:"count"`
	} `json:"dump32"`
	Trace string `json:"trace"`
}

type output struct {
	Reason    string          `json:"reason"`
	Cycles    uint64          `json:"cycles"`
	WatchAddr string          `json:"watchAddr,omitempty"`
	Dumps     []outputDump    `json:"dumps,omitempty"`
	GPIO      []emu.GPIOEvent `json:"gpio,omitempty"`
}

type outputDump struct {
	Addr   string   `json:"addr"`
	Values []string `json:"values"`
}

func run() error {
	cfgPath := flag.String("c", "", "path to JSON config (required)")
	flag.Parse()
	if *cfgPath == "" {
		flag.Usage()
		return fmt.Errorf("missing -c")
	}
	raw, err := os.ReadFile(*cfgPath)
	if err != nil {
		return err
	}
	var cfg config
	if err := json.Unmarshal(raw, &cfg); err != nil {
		return fmt.Errorf("%s: %w", *cfgPath, err)
	}

	m := emu.NewMachine()
	if cfg.Trace != "" {
		f, err := os.Create(cfg.Trace)
		if err != nil {
			return err
		}
		defer f.Close()
		m.TraceW = f
	}

	// Relative paths in the config resolve against the config's directory.
	cfgDir := filepath.Dir(*cfgPath)
	for _, l := range cfg.Load {
		path := l.File
		if !filepath.IsAbs(path) {
			path = filepath.Join(cfgDir, path)
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		if err := m.LoadBytes(uint32(l.Addr), data); err != nil {
			return err
		}
	}
	for _, p := range cfg.Poke32 {
		m.Poke32(uint32(p.Addr), uint32(p.Value))
	}
	if cfg.Machine != nil && cfg.Image != nil {
		return fmt.Errorf(`"machine" and "image" are mutually exclusive`)
	}
	if mc := cfg.Machine; mc != nil {
		err := emu.SetupFetchExec(m, emu.FetchExecConfig{
			Fetch: mc.Fetch, Exec: mc.Exec, Fix: mc.Fix,
			Entry: uint32(mc.Entry), Scratch: uint32(mc.Scratch),
		})
		if err != nil {
			return err
		}
	}
	if ic := cfg.Image; ic != nil {
		path := ic.File
		if !filepath.IsAbs(path) {
			path = filepath.Join(cfgDir, path)
		}
		raw, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		im, err := img.Decode(raw)
		if err != nil {
			return err
		}
		pl := img.Placement{}
		for k, v := range ic.Placement {
			idx, err := strconv.Atoi(k)
			if err != nil {
				return fmt.Errorf("placement key %q: %w", k, err)
			}
			pl[idx] = uint32(v)
		}
		if err := im.LoadAndStart(m, pl, img.DefaultMachine()); err != nil {
			return err
		}
	}
	for _, w := range cfg.Writes {
		m.Poke32(uint32(w.Addr), uint32(w.Value))
	}

	rc := emu.RunConfig{MaxCycles: cfg.Run.MaxCycles}
	for _, w := range cfg.Run.WatchWrites {
		rc.WatchWrites = append(rc.WatchWrites, uint32(w))
	}
	res, err := m.Run(rc)
	if err != nil {
		return err
	}

	out := output{Reason: string(res.Reason), Cycles: res.Cycles, GPIO: m.GPIOEvents}
	if res.Reason == emu.StopWatch {
		out.WatchAddr = fmt.Sprintf("%#08x", res.WatchAddr)
	}
	for _, d := range cfg.Dump32 {
		dump := outputDump{Addr: fmt.Sprintf("%#08x", uint32(d.Addr))}
		for i := 0; i < d.Count; i++ {
			dump.Values = append(dump.Values, fmt.Sprintf("%#08x", m.Peek32(uint32(d.Addr)+uint32(4*i))))
		}
		out.Dumps = append(out.Dumps, dump)
	}
	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "  ")
	return enc.Encode(out)
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "dmaemu:", err)
		os.Exit(1)
	}
}
