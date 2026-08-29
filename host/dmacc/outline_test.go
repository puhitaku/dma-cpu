package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestOutlineInvariants checks the structural promises of
// host/dmacc/outline.go on real images: helper bodies hold only
// relocatable instructions, every helper entry and every resume label is
// defined exactly once, and no site jumps across the flash/SRAM split.
// (That the outlined code RUNS is the whole xv6 and game suite's job —
// every one of them executes it.)
func TestOutlineInvariants(t *testing.T) {
	t.Parallel()
	shMod, err := llir.Merge(
		parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
		parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 2, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	for _, img := range []struct{ name, dasm string }{
		{"xsh-kernel", compileKernelXsh(t, false)},
		{"sh-xip", shDasm},
	} {
		checkOutline(t, img.name, img.dasm)
	}
}

func checkOutline(t *testing.T, name, dasm string) {
	t.Helper()
	// Section of every label definition, and of every reference.
	sec, defs, helpers := "", map[string]string{}, 0
	inHelper := false
	var refs []struct{ sym, sec string }
	for _, raw := range strings.Split(dasm, "\n") {
		l := raw
		if i := strings.IndexByte(l, ';'); i >= 0 {
			l = l[:i]
		}
		l = strings.TrimSpace(l)
		switch {
		case l == "":
			continue
		case l == ".text", l == ".ramtext", l == ".data":
			sec = l
			if l == ".data" {
				sec = ".data"
			}
			inHelper = false
			continue
		case sec == ".data" && strings.Contains(l, ":"):
			// A data definition ("sym: .word 0") names its own storage.
			defs[strings.TrimSpace(l[:strings.IndexByte(l, ':')])] = sec
			continue
		case strings.HasSuffix(l, ":") && !strings.ContainsAny(l, " \t"):
			lbl := strings.TrimSuffix(l, ":")
			// Only the generated names: the runtime legitimately defines
			// the same label in both arms of an `.ifcompact`.
			if old, dup := defs[lbl]; dup && strings.HasPrefix(lbl, "__ol") {
				t.Errorf("%s: label %q defined twice (%s, %s)", name, lbl, old, sec)
			}
			defs[lbl] = sec
			inHelper = strings.HasPrefix(lbl, "__ol_") && lbl != "__ol_ret"
			if inHelper {
				helpers++
			}
			continue
		}
		mnem := l
		if i := strings.IndexByte(mnem, ' '); i >= 0 {
			mnem = mnem[:i]
		}
		if inHelper {
			// Whatever moved into a helper had to be relocatable.
			switch mnem {
			case "call", "safepoint":
				t.Errorf("%s: helper body holds a %s: %q", name, mnem, l)
			}
			for _, f := range []string{".read", ".write", ".count", ".ctrl"} {
				if strings.Contains(l, f) {
					t.Errorf("%s: helper body holds a block-field reference: %q", name, l)
				}
			}
		}
		for _, tok := range strings.FieldsFunc(l, func(r rune) bool {
			return !(r == '_' || r >= 'a' && r <= 'z' || r >= 'A' && r <= 'Z' || r >= '0' && r <= '9')
		}) {
			if strings.HasPrefix(tok, "__ol_") || strings.HasPrefix(tok, "__olr_") {
				refs = append(refs, struct{ sym, sec string }{tok, sec})
			}
		}
	}
	if helpers == 0 {
		t.Fatalf("%s: the outliner produced no helpers", name)
	}
	for _, r := range refs {
		d, ok := defs[r.sym]
		if !ok {
			t.Errorf("%s: %q is referenced but never defined", name, r.sym)
			continue
		}
		if r.sym == "__ol_ret" {
			if d != ".data" {
				t.Errorf("%s: the resume cell lives in %s, not .data", name, d)
			}
			continue
		}
		// A .ramtext site must not jump into flash text, and vice versa:
		// RAMTextFuncs code runs while the XIP window is down.
		if d != r.sec {
			t.Errorf("%s: %q is defined in %s but referenced from %s", name, r.sym, d, r.sec)
		}
	}
	t.Logf("%s: %d outlined helpers", name, helpers)
}
