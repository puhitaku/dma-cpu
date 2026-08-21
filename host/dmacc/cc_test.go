package dmacc_test

import (
	"bufio"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestDifferential compiles each committed IR golden (clang output for
// testdata/*.c, regenerated with `make llgen`) and runs it on both SKUs
// in the emulator; the exit code must match the host execution recorded
// in testdata/expected.txt.
func TestDifferential(t *testing.T) {
	t.Parallel()
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
				for _, compact := range []bool{false, true} {
					name := v.Name
					if compact {
						name += "-compact"
					}
					t.Run(name, func(t *testing.T) {
						res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, Compact: compact})
						if err != nil {
							t.Fatalf("assemble: %v", err)
						}
						cfg := img.DefaultMachine()
						if compact {
							cfg = img.CompactMachine()
						}
						m := emu.NewMachine(v)
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
						t.Logf("cycles: %d", rr.Cycles)
					})
				}
			}
		})
	}
}

// loadLibc parses the committed picolibc IR goldens (libc/ll, built by
// `make libc`).
func loadLibc(t *testing.T) []*llir.Module {
	t.Helper()
	names, err := os.ReadDir("../../target/libc/ll")
	if err != nil {
		t.Fatalf("libc goldens missing (run `make libc`): %v", err)
	}
	var mods []*llir.Module
	for _, e := range names {
		if !strings.HasSuffix(e.Name(), ".ll") {
			continue
		}
		src, err := os.ReadFile("../../target/libc/ll/" + e.Name())
		if err != nil {
			t.Fatal(err)
		}
		m, err := llir.Parse(string(src))
		if err != nil {
			t.Fatalf("%s: %v", e.Name(), err)
		}
		mods = append(mods, m)
	}
	return mods
}

// TestLibcStdio links testdata/stdio.ll against the picolibc goldens and
// compares both the exit code and every console byte with the host libc
// execution (testdata/stdio.console, stdio.expected — `make llgen`).
func TestLibcStdio(t *testing.T) {
	t.Parallel()
	src, err := os.ReadFile("testdata/stdio.ll")
	if err != nil {
		t.Fatal(err)
	}
	prog, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Merge(append([]*llir.Module{prog}, loadLibc(t)...)...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatalf("compile: %v", err)
	}
	expRaw, err := os.ReadFile("testdata/stdio.expected")
	if err != nil {
		t.Fatal(err)
	}
	want64, err := strconv.ParseInt(strings.Fields(string(expRaw))[1], 10, 64)
	if err != nil {
		t.Fatal(err)
	}
	wantExit := uint32(int32(want64))
	wantConsole, err := os.ReadFile("testdata/stdio.console")
	if err != nil {
		t.Fatal(err)
	}
	for _, v := range emu.Variants {
		for _, compact := range []bool{false, true} {
			name := v.Name
			if compact {
				name += "-compact"
			}
			t.Run(name, func(t *testing.T) {
				res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, Compact: compact, DataBase: 0x20030000})
				if err != nil {
					t.Fatalf("assemble: %v", err)
				}
				cfg := img.DefaultMachine()
				if compact {
					cfg = img.CompactMachine()
				}
				m := emu.NewMachine(v)
				if err := res.Image.LoadAndStart(m, nil, cfg); err != nil {
					t.Fatal(err)
				}
				rr, err := m.Run(emu.RunConfig{MaxCycles: 100_000_000})
				if err != nil {
					t.Fatal(err)
				}
				if rr.Reason != emu.StopIdle {
					t.Fatalf("did not halt: %+v", rr)
				}
				ec, _ := res.Symbol("exitcode")
				if got := m.Peek32(ec); got != wantExit {
					t.Errorf("exitcode = %d, host says %d", int32(got), int32(wantExit))
				}
				got := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
				if got != string(wantConsole) {
					t.Errorf("console mismatch:\n--- dma ---\n%s\n--- host ---\n%s", got, wantConsole)
				}
				t.Logf("cycles: %d, console bytes: %d", rr.Cycles, len(m.ConsoleOut))
			})
		}
	}
}

// TestRecursion: bounded recursion via depth cloning (each level owns
// its own static frame; depth-K overflow lowers to HALT). tree(10)
// requires depth 10 of the default 12.
func TestRecursion(t *testing.T) {
	t.Parallel()
	src, err := os.ReadFile("testdata/recurse.ll")
	if err != nil {
		t.Fatal(err)
	}
	mod, err := llir.Parse(string(src))
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	for _, v := range emu.Variants {
		res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v})
		if err != nil {
			t.Fatal(err)
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
			t.Fatalf("%s: did not halt: %v", v.Name, rr.Reason)
		}
		ec, _ := res.Symbol("exitcode")
		if got := m.Peek32(ec); got != 89 {
			t.Errorf("%s: tree(10) = %d, want 89", v.Name, got)
		}
	}
}

// TestDeterminism: same IR in, same dasm out.
func TestDeterminism(t *testing.T) {
	t.Parallel()
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
	t.Parallel()
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
