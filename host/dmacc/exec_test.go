package dmacc_test

import (
	"encoding/binary"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/prog"
)

// pokeBytes writes a byte blob into machine RAM word-wise (LE),
// returning the address one past the (padded) end.
func pokeBytes(m *emu.Machine, addr uint32, b []byte) uint32 {
	for len(b)%4 != 0 {
		b = append(b, 0)
	}
	for i := 0; i < len(b); i += 4 {
		m.Poke32(addr+uint32(i), binary.LittleEndian.Uint32(b[i:]))
	}
	return addr + uint32(len(b))
}

// registerImage stores an UNBAKED image (relocs intact) as a kernel
// registry row: blob bytes + packed reloc table into RAM at store,
// row fields into kimages[slot]. Returns the next free storage addr.
func registerImage(t *testing.T, m *emu.Machine, kernC *dmaasm.Result,
	slot int, name string, res *dmaasm.Result, store uint32) uint32 {
	t.Helper()
	im := res.Image
	text, data := im.Segments[0], im.Segments[1]
	tAddr := store
	store = pokeBytes(m, store, text.Data)
	dAddr := store
	store = pokeBytes(m, store, data.Data)
	rAddr := store
	for _, r := range im.Relocs {
		w := r.Off & 0x3FFFFFFF
		if r.Seg == 1 {
			w |= 1 << 31
		}
		if r.Ref == 1 {
			w |= 1 << 30
		}
		m.Poke32(store, w)
		store += 4
	}

	off := func(n string, base uint32) uint32 { return mustSym(t, res, n) - base }
	row := mustSym(t, kernC, "g_kimages") + uint32(slot)*84
	nb := make([]byte, 12)
	copy(nb, name)
	pokeBytes(m, row, nb)
	for i, v := range []uint32{
		tAddr, uint32(len(text.Data)),
		dAddr, uint32(len(data.Data)),
		text.LinkAddr, data.LinkAddr,
		rAddr, uint32(len(im.Relocs)),
		off("warmstart", text.LinkAddr), off("crtthunk", text.LinkAddr),
		off("dispatch", data.LinkAddr), off("irqresume", data.LinkAddr),
		off("lr", data.LinkAddr), off("g___dma_sysmail", data.LinkAddr),
		off("g___dma_syscall_entry", data.LinkAddr),
	} {
		m.Poke32(row+12+uint32(i)*4, v)
	}
	return store
}

// TestXv6Exec runs Phase 5e end to end: pid 2 vforks, the child execs
// the registered "hello" image — placed and relocated by the kernel's
// own loader — the parent's fork() return arrives by deposit at exec
// time, and wait() reaps the child's exit(7).
func TestXv6Exec(t *testing.T) {
	t.Parallel()
	spawnMod, err := llir.Merge(parseLL(t, "testdata/xv6spawn.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	spawnDasm, err := dmacc.Compile(spawnMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	helloMod, err := llir.Merge(parseLL(t, "testdata/xv6hello.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	helloDasm, err := dmacc.Compile(helloMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	const wantConsole = "parent: spawning\nhello from exec\nparent: reaped\n"

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
				Variant: v, TextBase: 0x20000000, DataBase: 0x20002000})
			if err != nil {
				t.Fatal(err)
			}
			kernC := buildKernelC(t, v, 0x20004000, 0x20038000)
			asm := func(text, data uint32) *dmaasm.Result {
				res, err := dmaasm.Assemble(spawnDasm, dmaasm.Options{
					Variant: v, TextBase: text, DataBase: data})
				if err != nil {
					t.Fatal(err)
				}
				return res
			}
			idle := asm(0x20020000, 0x20024000)
			parent := asm(0x20026000, 0x2002A000)
			// hello is linked at arbitrary bases: the kernel places it.
			hello, err := dmaasm.Assemble(helloDasm, dmaasm.Options{
				Variant: v, TextBase: 0x2003C000, DataBase: 0x2003C000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			var entries [2]uint32
			for i, r := range []*dmaasm.Result{idle, parent} {
				e, err := r.Image.Load(m, nil)
				if err != nil {
					t.Fatal(err)
				}
				entries[i] = e
			}
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			wireKernel(t, m, v, kern, kernC, []kproc{
				{idle, entries[0], 1, 0, true},
				{parent, entries[1], 2, 0, true},
			})
			// Registry ("flash"), allocator arena, pid counter, vector.
			end := registerImage(t, m, kernC, 0, "hello", hello, 0x2002C000)
			if end > 0x20034000 {
				t.Fatalf("blob storage overflow: %#x", end)
			}
			m.Poke32(mustSym(t, kernC, "g_arena"), 0x20034000)
			m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2003F000)
			m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
			m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))

			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entries[0], Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			done := false
			for i := 0; i < 100; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "parent: reaped") {
					done = true
					break
				}
			}
			if !done {
				t.Fatalf("spawn did not complete; console %q, states %d/%d/%d, ticks=%d",
					m.ConsoleOut,
					procField(m, kernC, 0, pfState),
					procField(m, kernC, 1, pfState),
					procField(m, kernC, 2, pfState),
					m.Peek32(mustSym(t, kernC, "g_ticks")))
			}
			if got := strings.ReplaceAll(string(m.ConsoleOut), "\r", ""); got != wantConsole {
				t.Errorf("console:\n got %q\nwant %q", got, wantConsole)
			}
			psym := func(n string) uint32 { return mustSym(t, parent, n) }
			if sp := m.Peek32(psym("g_spawn_pid")); sp != 3 {
				t.Errorf("fork returned pid %d, want 3", sp)
			}
			if rp := m.Peek32(psym("g_reap_pid")); rp != 3 {
				t.Errorf("wait() returned pid %d, want 3", rp)
			}
			if rs := int32(m.Peek32(psym("g_reap_status"))); rs != 7 {
				t.Errorf("wait() status %d, want 7", rs)
			}
			if st := procField(m, kernC, 2, pfState); st != stUnused {
				t.Errorf("child slot state %d, want UNUSED(%d)", st, stUnused)
			}
			// System stays alive: idle keeps counting, parent keeps
			// pausing (both survive many more ticks).
			id1 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			id2 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if id2 <= id1 {
				t.Errorf("idle stalled after the spawn: %d -> %d", id1, id2)
			}
			t.Logf("ticks=%d arena_used=%#x", m.Peek32(mustSym(t, kernC, "g_ticks")),
				m.Peek32(mustSym(t, kernC, "g_arena"))-0x20030000)
		})
	}
}
