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

// TestDifferential compiles each committed IR golden (clang output for
// testdata/*.c, regenerated with `make llgen`) and runs it on both SKUs
// in the emulator; the exit code must match the host execution recorded
// in testdata/expected.txt.
func TestDifferential(t *testing.T) {
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
			dasm, err := dmacc.Compile(mod, dmacc.Options{})
			if err != nil {
				t.Fatalf("compile: %v", err)
			}
			for _, v := range emu.Variants {
				t.Run(v.Name, func(t *testing.T) {
					res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v})
					if err != nil {
						t.Fatalf("assemble: %v", err)
					}
					m := emu.NewMachine(v)
					if err := res.Image.LoadAndStart(m, nil, img.DefaultMachine()); err != nil {
						t.Fatal(err)
					}
					rr, err := m.Run(emu.RunConfig{MaxCycles: 50_000_000})
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
					t.Logf("cycles: %d", rr.Cycles)
				})
			}
		})
	}
}

// TestRecursionRejected: v0 static frames make recursion a compile-time
// error, not a silent miscompile.
func TestRecursionRejected(t *testing.T) {
	src, err := os.ReadFile("testdata/recurse.ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	if _, err := dmacc.Compile(mod, dmacc.Options{}); err == nil {
		t.Fatal("expected a recursion error")
	} else if !strings.Contains(err.Error(), "recursion") {
		t.Fatalf("wrong error: %v", err)
	}
}

// TestDeterminism: same IR in, same dasm out.
func TestDeterminism(t *testing.T) {
	src, err := os.ReadFile("testdata/memory.ll")
	if err != nil {
		t.Fatal(err)
	}
	gen := func() string {
		mod, err := llir.Parse(string(src))
		if err != nil {
			t.Fatal(err)
		}
		dasm, err := dmacc.Compile(mod, dmacc.Options{})
		if err != nil {
			t.Fatal(err)
		}
		return dasm
	}
	if gen() != gen() {
		t.Error("compilation is not deterministic")
	}
}

// TestNoSafepoints: the flag removes safepoints (and with them the need
// for a live dispatch word beyond crt0 init).
func TestNoSafepoints(t *testing.T) {
	src, err := os.ReadFile("testdata/collatz.ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	with, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	without, err := dmacc.Compile(mod, dmacc.Options{NoSafepoints: true})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(with, "safepoint") {
		t.Error("default output has no safepoints")
	}
	if strings.Contains(without, "safepoint") {
		t.Error("NoSafepoints output still has safepoints")
	}
}
