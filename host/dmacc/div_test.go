package dmacc_test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// Division and remainder by a constant divisor, checked against host
// arithmetic. The committed IR goldens (testdata/*.c) divide by values
// the compiler cannot see, so none of them reaches emitDivConst's
// power-of-two identities, let alone with a negative dividend or
// INT_MIN — hence this generated module instead: it sweeps every
// lowered divisor over the dividends that break naive shifts.

// divDividends: zero, both signs of small and large, every boundary the
// sign-bias identities care about.
var divDividends = []uint32{
	0, 1, 2, 3, 7, 9, 10, 11, 99, 100, 101, 255, 256, 999, 65535, 65536,
	123456789, 0x7FFFFFFF, 0x80000000, 0x80000001, 0xFFFFFFFF, 0xFFFFFFF6,
	0xFFFFFFFE, 1000000000, 0x40000000, 0xC0000000,
}

// divisors per width, in the operation's own signedness. The unsigned
// lists carry a couple of divisors emitDivConst declines (3, 7) so the
// runtime path stays covered from the same module.
var (
	divUnsigned32 = []int64{1, 2, 4, 16, 256, 65536, 0x40000000, 0x80000000, 10, 100, 3, 7}
	divSigned32   = []int64{1, -1, 2, -2, 8, -8, 1024, 0x40000000, -1073741824, -2147483648, 10, -10, 100, 7}
	divUnsigned16 = []int64{1, 2, 8, 128, 0x4000, 0x8000, 10, 100, 3}
	divSigned16   = []int64{1, -1, 2, -4, 64, 0x4000, -0x4000, -0x8000, 10, 7}
	divUnsigned8  = []int64{1, 2, 4, 64, 0x80, 10, 3}
	divSigned8    = []int64{1, -1, 2, -2, 64, -64, -0x80, 10, 7}
)

type divCase struct {
	op    string // udiv, urem, sdiv, srem
	bits  int    // 8, 16 or 32
	div   int64
	valIx int
}

// divExpect computes the case's result the way C does, as the i32 the
// generated module stores (sign-extended for the signed ops, zero
// extended for the unsigned ones).
func divExpect(c divCase, x uint32) uint32 {
	mask := uint32(1)<<uint(c.bits) - 1
	if c.bits == 32 {
		mask = 0xFFFFFFFF
	}
	a, d := x&mask, uint32(c.div)&mask
	if c.op == "udiv" || c.op == "urem" {
		if c.op == "udiv" {
			return a / d
		}
		return a % d
	}
	sx := func(v uint32) int32 {
		if c.bits == 32 {
			return int32(v)
		}
		return int32(v<<uint(32-c.bits)) >> uint(32-c.bits)
	}
	sa, sd := sx(a), sx(d)
	if c.op == "sdiv" {
		return uint32(sx(uint32(sa / sd)))
	}
	return uint32(sx(uint32(sa % sd)))
}

// divCaseList builds the sweep, skipping the one combination that is
// undefined in C: INT_MIN / -1 overflows the result type.
func divCaseList() []divCase {
	var cs []divCase
	add := func(op string, bits int, divs []int64, nval int) {
		for _, d := range divs {
			for i := 0; i < nval; i++ {
				lim := uint32(1)<<uint(bits-1) - 1
				if d == -1 && divDividends[i]&(uint32(1)<<uint(bits)-1) == lim+1 {
					continue
				}
				cs = append(cs, divCase{op: op, bits: bits, div: d, valIx: i})
			}
		}
	}
	n := len(divDividends)
	add("udiv", 32, divUnsigned32, n)
	add("urem", 32, divUnsigned32, n)
	add("sdiv", 32, divSigned32, n)
	add("srem", 32, divSigned32, n)
	add("udiv", 16, divUnsigned16, 12)
	add("urem", 16, divUnsigned16, 12)
	add("sdiv", 16, divSigned16, 12)
	add("srem", 16, divSigned16, 12)
	add("udiv", 8, divUnsigned8, 10)
	add("urem", 8, divUnsigned8, 10)
	add("sdiv", 8, divSigned8, 10)
	add("srem", 8, divSigned8, 10)
	return cs
}

// divModuleIR renders the sweep as an LLVM module: the dividends come
// out of a global array (so nothing folds), each case divides and
// widens back to i32, and the results land in @out for the test to read
// straight out of emulator memory.
func divModuleIR(cs []divCase) string {
	var b strings.Builder
	b.WriteString("target datalayout = \"e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64\"\n")
	b.WriteString("target triple = \"thumbv6m-unknown-none-eabi\"\n\n")
	fmt.Fprintf(&b, "@vals = dso_local global [%d x i32] [", len(divDividends))
	for i, v := range divDividends {
		if i > 0 {
			b.WriteString(", ")
		}
		fmt.Fprintf(&b, "i32 %d", int32(v))
	}
	b.WriteString("]\n")
	fmt.Fprintf(&b, "@out = dso_local global [%d x i32] zeroinitializer\n\n", len(cs))
	b.WriteString("define dso_local i32 @main() local_unnamed_addr {\n")
	for i := range divDividends {
		fmt.Fprintf(&b, "  %%p%d = getelementptr inbounds [%d x i32], ptr @vals, i32 0, i32 %d\n",
			i, len(divDividends), i)
		fmt.Fprintf(&b, "  %%v%d = load i32, ptr %%p%d, align 4\n", i, i)
	}
	for i, c := range cs {
		ty := fmt.Sprintf("i%d", c.bits)
		src := fmt.Sprintf("%%v%d", c.valIx)
		if c.bits < 32 {
			fmt.Fprintf(&b, "  %%t%d = trunc i32 %s to %s\n", i, src, ty)
			src = fmt.Sprintf("%%t%d", i)
		}
		fmt.Fprintf(&b, "  %%r%d = %s %s %s, %d\n", i, c.op, ty, src, int64(int32(uint32(c.div))))
		out := fmt.Sprintf("%%r%d", i)
		if c.bits < 32 {
			ext := "sext"
			if c.op == "udiv" || c.op == "urem" {
				ext = "zext"
			}
			fmt.Fprintf(&b, "  %%w%d = %s %s %%r%d to i32\n", i, ext, ty, i)
			out = fmt.Sprintf("%%w%d", i)
		}
		fmt.Fprintf(&b, "  %%o%d = getelementptr inbounds [%d x i32], ptr @out, i32 0, i32 %d\n",
			i, len(cs), i)
		fmt.Fprintf(&b, "  store i32 %s, ptr %%o%d, align 4\n", out, i)
	}
	b.WriteString("  ret i32 0\n}\n")
	return b.String()
}

// divChunk keeps each generated module inside SRAM: a signed
// power-of-two site is ~40 records, and the classic encoding spends 16
// bytes on each of them.
const divChunk = 150

func TestDivConst(t *testing.T) {
	t.Parallel()
	all := divCaseList()
	for start := 0; start < len(all); start += divChunk {
		end := start + divChunk
		if end > len(all) {
			end = len(all)
		}
		cs := all[start:end]
		mod, err := llir.Parse(divModuleIR(cs))
		if err != nil {
			t.Fatalf("parse: %v", err)
		}
		dasm, err := dmacc.Compile(mod, dmacc.Options{})
		if err != nil {
			t.Fatalf("compile: %v", err)
		}
		for _, v := range emu.Variants {
			for _, compact := range []bool{false, true} {
				name := fmt.Sprintf("%s/%d", v.Name, start)
				if compact {
					name = fmt.Sprintf("%s-compact/%d", v.Name, start)
				}
				t.Run(name, func(t *testing.T) {
					res, err := dmaasm.Assemble(dasm, dmaasm.Options{
						Variant: v, Compact: compact, DataBase: 0x20020000})
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
					rr, err := m.Run(emu.RunConfig{MaxCycles: 200_000_000})
					if err != nil {
						t.Fatal(err)
					}
					if rr.Reason != emu.StopIdle {
						t.Fatalf("did not halt: %+v", rr)
					}
					out, err := res.Symbol("g_out")
					if err != nil {
						t.Fatal(err)
					}
					bad := 0
					for i, c := range cs {
						x := divDividends[c.valIx]
						want := divExpect(c, x)
						if got := m.Peek32(out + uint32(4*i)); got != want {
							bad++
							if bad <= 8 {
								t.Errorf("%s i%d %#x / %d = %#x, host says %#x",
									c.op, c.bits, x, c.div, got, want)
							}
						}
					}
					if bad > 8 {
						t.Errorf("%d cases wrong in total", bad)
					}
				})
			}
		}
	}
}
