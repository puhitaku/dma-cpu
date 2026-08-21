package dmacc

import "fmt"

// The runtime library: hand-written dmaasm routines for the operations
// the machine has no short block sequence for. ABI v0: arguments in
// r0/r1/r2, result in r0. All routines are leaves except the sdiv/srem
// wrappers, which save lr and call __rt_udivmod.
//
// Division uses restoring long division MSB-first; shifts and multiplies
// extract bits by repeated doubling and sign tests (the machine has no
// right shift, so bits are consumed from the top). memcpy/memset patch a
// single INCR block — a DMA engine's native talent — so their cost is
// one transfer per byte regardless of length (a zero count is the
// silicon-verified NOP, so n=0 needs no guard).

type rtRoutine struct {
	name    string
	deps    []string
	data    string
	text    string
	selfmod bool // patches its own records: must be RAM-resident under XIPText
}

var rtRoutines = []rtRoutine{
	{
		name: "mul",
		data: "rt_macc: .word 0\nrt_mcnt: .word 0\n",
		text: `__rt_mul:
    move zero, rt_macc
    move $31, rt_mcnt
rt_mul_loop:
    shl rt_macc, rt_macc
    jsign r1, rt_mul_add, rt_mul_skip
rt_mul_add:
    add rt_macc, r0, rt_macc
rt_mul_skip:
    shl r1, r1
    sub rt_mcnt, $1, rt_mcnt
    jneg rt_mcnt, rt_mul_done, rt_mul_loop
rt_mul_done:
    move rt_macc, r0
    ret
`,
	},
	{
		name: "udivmod",
		data: "rt_drem: .word 0\nrt_dquo: .word 0\nrt_dcnt: .word 0\n",
		text: `; quotient -> rt_dquo, remainder -> rt_drem. Divisors with the
; sign bit set would overflow the shifted remainder, but their quotient
; is 0 or 1, so they get a direct compare instead.
__rt_udivmod:
    jsign r1, rt_udm_big, rt_udm_norm
rt_udm_big:
    jltu r0, r1, rt_udm_blo, rt_udm_bhs
rt_udm_blo:
    move zero, rt_dquo
    move r0, rt_drem
    ret
rt_udm_bhs:
    move $1, rt_dquo
    sub r0, r1, rt_drem
    ret
rt_udm_norm:
    move zero, rt_drem
    move zero, rt_dquo
    move $31, rt_dcnt
rt_udm_loop:
    shl rt_drem, rt_drem
    jsign r0, rt_udm_b1, rt_udm_b0
rt_udm_b1:
    add rt_drem, $1, rt_drem
rt_udm_b0:
    shl rt_dquo, rt_dquo
    jltu rt_drem, r1, rt_udm_skip, rt_udm_sub
rt_udm_sub:
    sub rt_drem, r1, rt_drem
    add rt_dquo, $1, rt_dquo
rt_udm_skip:
    shl r0, r0
    sub rt_dcnt, $1, rt_dcnt
    jneg rt_dcnt, rt_udm_done, rt_udm_loop
rt_udm_done:
    ret
`,
	},
	{
		name: "udiv",
		deps: []string{"udivmod"},
		data: "rt_udlr: .word 0\n",
		text: `__rt_udiv:
    move lr, rt_udlr
    call __rt_udivmod
    move rt_dquo, r0
    move rt_udlr, lr
    ret
`,
	},
	{
		name: "urem",
		deps: []string{"udivmod"},
		data: "rt_urlr: .word 0\n",
		text: `__rt_urem:
    move lr, rt_urlr
    call __rt_udivmod
    move rt_drem, r0
    move rt_urlr, lr
    ret
`,
	},
	{
		name: "sdiv",
		deps: []string{"udivmod"},
		data: "rt_sdlr: .word 0\nrt_sdsign: .word 0\n",
		text: `__rt_sdiv:
    move lr, rt_sdlr
    move zero, rt_sdsign
    jsign r0, rt_sdiv_na, rt_sdiv_pa
rt_sdiv_na:
    sub zero, r0, r0
    xor rt_sdsign, $1, rt_sdsign
rt_sdiv_pa:
    jsign r1, rt_sdiv_nb, rt_sdiv_pb
rt_sdiv_nb:
    sub zero, r1, r1
    xor rt_sdsign, $1, rt_sdsign
rt_sdiv_pb:
    call __rt_udivmod
    move rt_dquo, r0
    jbool rt_sdsign, rt_sdiv_done, rt_sdiv_neg
rt_sdiv_neg:
    sub zero, r0, r0
rt_sdiv_done:
    move rt_sdlr, lr
    ret
`,
	},
	{
		name: "srem",
		deps: []string{"udivmod"},
		data: "rt_srlr: .word 0\nrt_srsign: .word 0\n",
		text: `; C remainder takes the dividend's sign.
__rt_srem:
    move lr, rt_srlr
    move zero, rt_srsign
    jsign r0, rt_srem_na, rt_srem_pa
rt_srem_na:
    sub zero, r0, r0
    move $1, rt_srsign
rt_srem_pa:
    jsign r1, rt_srem_nb, rt_srem_pb
rt_srem_nb:
    sub zero, r1, r1
rt_srem_pb:
    call __rt_udivmod
    move rt_drem, r0
    jbool rt_srsign, rt_srem_done, rt_srem_neg
rt_srem_neg:
    sub zero, r0, r0
rt_srem_done:
    move rt_srlr, lr
    ret
`,
	},
	{
		name: "shl",
		text: `__rt_shl:
    andn r1, $0xFFFFFFE0, r1
rt_shl_loop:
    sub r1, $1, r1
    jneg r1, rt_shl_done, rt_shl_go
rt_shl_go:
    shl r0, r0
    jump rt_shl_loop
rt_shl_done:
    ret
`,
	},
	{
		name: "lshr",
		data: "rt_lres: .word 0\nrt_lcnt: .word 0\n",
		text: `; r0 >> r1 by consuming the top 32-n bits of r0 MSB-first.
__rt_lshr:
    andn r1, $0xFFFFFFE0, r1
    move zero, rt_lres
    move $31, rt_lcnt
    sub rt_lcnt, r1, rt_lcnt
rt_lshr_loop:
    jneg rt_lcnt, rt_lshr_done, rt_lshr_go
rt_lshr_go:
    shl rt_lres, rt_lres
    jsign r0, rt_lshr_1, rt_lshr_0
rt_lshr_1:
    add rt_lres, $1, rt_lres
rt_lshr_0:
    shl r0, r0
    sub rt_lcnt, $1, rt_lcnt
    jump rt_lshr_loop
rt_lshr_done:
    move rt_lres, r0
    ret
`,
	},
	{
		name: "ashr",
		data: "rt_ares: .word 0\nrt_acnt: .word 0\n",
		text: `; like lshr, but the result starts as the sign fill.
__rt_ashr:
    andn r1, $0xFFFFFFE0, r1
    move $31, rt_acnt
    sub rt_acnt, r1, rt_acnt
    jsign r0, rt_ashr_n, rt_ashr_p
rt_ashr_n:
    move $0xFFFFFFFF, rt_ares
    jump rt_ashr_loop
rt_ashr_p:
    move zero, rt_ares
rt_ashr_loop:
    jneg rt_acnt, rt_ashr_done, rt_ashr_go
rt_ashr_go:
    shl rt_ares, rt_ares
    jsign r0, rt_ashr_1, rt_ashr_0
rt_ashr_1:
    add rt_ares, $1, rt_ares
rt_ashr_0:
    shl r0, r0
    sub rt_acnt, $1, rt_acnt
    jump rt_ashr_loop
rt_ashr_done:
    move rt_ares, r0
    ret
`,
	},
	{
		name:    "memcpy",
		selfmod: true,
		text: `; r0 = dst, r1 = src, r2 = byte count: one patched INCR block.
; Compact records have no count field: the count goes straight into the
; bank channel's reload register instead (dyncount).
__rt_memcpy:
    move r0, rt_mcp_blk.write
    move r1, rt_mcp_blk.read
.ifcompact
    move r2, %cnt8rw
rt_mcp_blk:
    move @0, @0, size8, incrr, incrw, dyncount
.else
    move r2, rt_mcp_blk.count
rt_mcp_blk:
    move @0, @0, size8, incrr, incrw
.endif
    ret
`,
	},
	{
		name:    "memset",
		selfmod: true,
		text: `; r0 = dst, r1 = byte value (in a word), r2 = count. The read
; address stays on r1's low byte; only dst increments.
__rt_memset:
    move r0, rt_mst_blk.write
.ifcompact
    move r2, %cnt8w
rt_mst_blk:
    move r1, @0, size8, incrw, dyncount
.else
    move r2, rt_mst_blk.count
rt_mst_blk:
    move r1, @0, size8, incrw
.endif
    ret
`,
	},
}

// emitRuntime appends the needed routines (dependency-closed) to the
// program in a fixed order.
func (g *gen) emitRuntime() error {
	need := map[string]bool{}
	var mark func(n string)
	byName := map[string]rtRoutine{}
	for _, r := range rtRoutines {
		byName[r.name] = r
	}
	mark = func(n string) {
		if need[n] {
			return
		}
		need[n] = true
		for _, d := range byName[n].deps {
			mark(d)
		}
	}
	for n := range g.rt {
		if _, ok := byName[n]; !ok {
			return fmt.Errorf("dmacc: unknown runtime routine %q", n)
		}
		mark(n)
	}
	any := false
	for _, r := range rtRoutines {
		if need[r.name] && r.data != "" {
			if !any {
				fmt.Fprintf(&g.out, "\n; --- runtime ---\n.data\n")
				any = true
			}
			g.out.WriteString(r.data)
		}
	}
	first := true
	for _, r := range rtRoutines {
		if !need[r.name] {
			continue
		}
		if g.opts.Stats != nil {
			g.opts.Stats.Runtime = append(g.opts.Stats.Runtime, r.name)
		}
		if g.opts.XIPText {
			// All of the runtime lives in .ramtext: the self-patching
			// modules must, and the rest is shared with RAM-resident
			// flash-session code (RAMTextFuncs) that may call it while
			// XIP is down.
			g.ram.WriteString(r.text)
			continue
		}
		if first {
			if !any {
				fmt.Fprintf(&g.out, "\n; --- runtime ---\n")
			}
			fmt.Fprintf(&g.out, ".text\n")
			first = false
		}
		g.out.WriteString(r.text)
	}
	return nil
}
