package dmacc_test

import (
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
)

// Throwaway: sizes of the Enter-path functions in the kernel XIP text.
func TestFuncSizes(t *testing.T) {
	bd := boards.Feather
	_, kernC := bootXshBoard(t, nil, bd)
	type sym struct {
		name string
		addr uint32
	}
	var fs []sym
	for n, a := range kernC.Symbols {
		if a >= bd.KernTextXIP && a < bd.KernTextXIP+300000 && strings.HasPrefix(n, "f_") {
			fs = append(fs, sym{n, a})
		}
		if strings.Contains(n, "swtch") || strings.Contains(n, "kenter") {
			fmt.Printf("SYM %s %08x\n", n, a)
		}
	}
	sort.Slice(fs, func(i, j int) bool { return fs[i].addr < fs[j].addr })
	want := map[string]bool{}
	for _, n := range []string{"dma_ksyscall", "kfbcon_putc", "cursor_xor",
		"cell_addr", "cons_poll", "kconswrite", "kconsread", "filewrite",
		"fileread", "kfs_read", "kfs_write", "badbuf"} {
		want["f_"+n] = true
	}
	want["cwc"] = true
	var tot uint32
	for i, f := range fs {
		if !want[f.name] {
			continue
		}
		end := bd.KernTextXIP + 300000
		if i+1 < len(fs) {
			end = fs[i+1].addr
		}
		fmt.Printf("SIZE %-16s %6d\n", f.name, end-f.addr)
		tot += end - f.addr
	}
	fmt.Printf("SIZE total %d\n", tot)
}
