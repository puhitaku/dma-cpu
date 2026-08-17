package dmacc_test

import (
	"bufio"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/img"
	"github.com/puhitaku/dma-cpu/llir"
)

// TestXIPRecursion: frame-stack recursion under XIPText — the push/pop
// header stubs (Fha/Fhb) and __rt_memcpy are RAM-resident while the
// recursive body executes from flash.
func TestXIPRecursion(t *testing.T) {
	src, err := os.ReadFile("testdata/recurse.ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	for _, v := range emu.Variants {
		for _, compact := range []bool{false, true} {
			res, err := dmaasm.Assemble(dasm, dmaasm.Options{
				Variant: v, Compact: compact,
				TextBase: 0x10080000, DataBase: 0x20010000, RAMTextBase: 0x20030000,
			})
			if err != nil {
				t.Fatal(err)
			}
			cfg := img.DefaultMachine()
			if compact {
				cfg = img.CompactMachine()
			}
			m := emu.NewMachine(v)
			m.Flash = make([]byte, 1<<20)
			if err := res.Image.LoadAndStart(m, nil, cfg); err != nil {
				t.Fatal(err)
			}
			rr, err := m.Run(emu.RunConfig{MaxCycles: 50_000_000})
			if err != nil {
				t.Fatal(err)
			}
			if rr.Reason != emu.StopIdle {
				t.Fatalf("%s compact=%v: did not halt: %v", v.Name, compact, rr.Reason)
			}
			ec, _ := res.Symbol("exitcode")
			if got := m.Peek32(ec); got != 89 {
				t.Errorf("%s compact=%v: tree(10) = %d, want 89", v.Name, compact, got)
			}
		}
	}
}

// TestXIPDifferential is TestDifferential with Options.XIPText: the main
// text links into the flash XIP window (immutable), every self-modified
// record lands in the RAM-resident .ramtext segment, and each golden must
// still produce clang's answer.
func TestXIPDifferential(t *testing.T) {
	exp, err := os.ReadFile("testdata/expected.txt")
	if err != nil {
		t.Fatal(err)
	}
	sc := bufio.NewScanner(strings.NewReader(string(exp)))
	for sc.Scan() {
		fields := strings.Fields(sc.Text())
		if len(fields) != 2 {
			continue
		}
		name := fields[0]
		want64, err := strconv.ParseInt(fields[1], 10, 64)
		if err != nil {
			t.Fatalf("%s: bad expected value %q", name, fields[1])
		}
		want := uint32(int32(want64))
		t.Run(name, func(t *testing.T) {
			src, err := os.ReadFile("testdata/" + name + ".ll")
			if err != nil {
				t.Fatal(err)
			}
			mod, err := llir.Parse(string(src))
			if err != nil {
				t.Fatalf("parse: %v", err)
			}
			dasm, err := dmacc.Compile(mod, dmacc.Options{XIPText: true})
			if err != nil {
				t.Fatalf("compile: %v", err)
			}
			for _, v := range emu.Variants {
				for _, compact := range []bool{false, true} {
					vname := v.Name
					if compact {
						vname += "-compact"
					}
					t.Run(vname, func(t *testing.T) {
						res, err := dmaasm.Assemble(dasm, dmaasm.Options{
							Variant:     v,
							Compact:     compact,
							TextBase:    0x10080000,
							DataBase:    0x20010000,
							RAMTextBase: 0x20030000,
						})
						if err != nil {
							t.Fatalf("assemble: %v", err)
						}
						cfg := img.DefaultMachine()
						if compact {
							cfg = img.CompactMachine()
						}
						m := emu.NewMachine(v)
						m.Flash = make([]byte, 1<<20)
						if err := res.Image.LoadAndStart(m, nil, cfg); err != nil {
							t.Fatal(err)
						}
						rr, err := m.Run(emu.RunConfig{MaxCycles: 80_000_000})
						if err != nil {
							t.Fatal(err)
						}
						if rr.Reason != emu.StopIdle {
							t.Fatalf("did not halt: %+v", rr)
						}
						ec, err := res.Symbol("exitcode")
						if err != nil {
							t.Fatal(err)
						}
						if got := m.Peek32(ec); got != want {
							t.Errorf("exitcode = %d (%#x), host says %d", int32(got), got, int32(want))
						}
					})
				}
			}
		})
	}
}
