package dmacc

import "fmt"

// The runtime library: hand-written dmaasm routines for the operations
// the machine has no short block sequence for. ABI v0: arguments in
// r0/r1/r2, result in r0. All routines are leaves except the udiv/urem/
// sdiv/srem wrappers, which save lr and call __rt_udivmod.
//
// Division has two engines. __rt_udivmod is restoring long division,
// MSB-first: 31 rounds, ~6,900 emulator cycles for any divisor.
// __rt_udivmod10 is the shift-add reciprocal for the one divisor that
// dominates every program that prints a number — ~410 cycles, no loop.
// The compiler reaches it directly when it can see the constant 10
// (func.go, emitDivConst), and __rt_udivmod jumps to it when the
// divisor arrives in a register: printf-style digit loops take the
// base as a parameter, so the constant is nowhere in sight at compile
// time. Divisors that are powers of two never call anything — they are
// byte-lane shifts and masks at the site.
//
// Multiplies extract bits by repeated doubling and sign tests. The
// machine has no right shift: __rt_lshr borrows the DMA sniffer's
// OUT_REV bit reversal for counts under 16 (reverse, left-shift,
// reverse back); larger counts, and __rt_ashr always, consume bits from
// the top. The shift routines serve counts the compiler cannot see: a
// constant count is lowered inline instead, as a copy between the byte
// lanes of the little-endian value words (func.go, laneShrConst and
// emitShl). memcpy/memset patch a single INCR block — a DMA engine's
// native talent. They take a byte
// count from an arbitrary address, so they burst size8: one transfer per
// byte, whatever the length (a zero count is the silicon-verified NOP,
// so n=0 needs no guard). Calls whose length is a compile-time constant
// never come here — those lower to an inline record with a static
// wcount, one transfer per WORD in the classic encoding (func.go).

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
		data: "rt_macc: .word 0\nrt_mcnt: .word 0\nrt_mtmp: .word 0\nrt_mbyte: .word 0\n",
		text: `; r0 * r1, MSB-first over the multiplier. Leading zero BYTES of r1
; retire eight bits at a time up front: the accumulator is still zero
; there, so the doublings those passes would do are no-ops, and one
; byte-lane shift plus a counter step stands in for eight full ~6-macro
; passes. The count guard doubles as the r1 == 0 exit — four rounds
; drive it negative and the routine returns the zero accumulator.
; Counters step by adding a negative literal: add is three blocks
; where sub is five. rt_mbyte holds only the top byte of r1, written
; size8 over a word that starts at zero and is never written wider, so
; its upper three lanes stay zero without a clearing record.
__rt_mul:
    move zero, rt_macc
    move $31, rt_mcnt
rt_mul_bskip:
    move r1+3, rt_mbyte, size8
    add rt_mbyte, $0xFFFFFFFF, rt_mtmp
    jneg rt_mtmp, rt_mul_bs_go, rt_mul_loop
rt_mul_bs_go:
    add rt_mcnt, $0xFFFFFFF8, rt_mcnt
    jneg rt_mcnt, rt_mul_done, rt_mul_bs_shl
rt_mul_bs_shl:
    move $0, rt_mtmp
    move r1, rt_mtmp+1, size8, count=3, incrr, incrw
    move rt_mtmp, r1
    jump rt_mul_bskip
rt_mul_loop:
    shl rt_macc, rt_macc
    jsign r1, rt_mul_add, rt_mul_skip
rt_mul_add:
    add rt_macc, r0, rt_macc
rt_mul_skip:
    shl r1, r1
    add rt_mcnt, $0xFFFFFFFF, rt_mcnt
    jneg rt_mcnt, rt_mul_done, rt_mul_loop
rt_mul_done:
    move rt_macc, r0
    ret
`,
	},
	{
		name: "udivmod",
		deps: []string{"udivmod10"},
		data: "rt_dcnt: .word 0\n",
		text: `; quotient -> rt_dquo, remainder -> rt_drem. Divisor 10 hands over to
; the reciprocal routine, which fills the same two cells and returns to
; THIS routine's caller (it is a leaf, so lr still points there): a
; printf digit loop takes its base as a parameter, so the compiler
; never sees the constant, and the test costs 16 records against the
; ~6,900 cycles the long division would spend. Divisors with the sign
; bit set would overflow the shifted remainder, but their quotient is
; 0 or 1, so they get a direct compare instead.
__rt_udivmod:
    jeq r1, $10, __rt_udivmod10, rt_udm_wide
rt_udm_wide:
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
    add rt_dcnt, $0xFFFFFFFF, rt_dcnt
    jneg rt_dcnt, rt_udm_done, rt_udm_loop
rt_udm_done:
    ret
`,
	},
	{
		name: "udivmod10",
		data: "rt_drem: .word 0\nrt_dquo: .word 0\n" +
			"rt_dta: .word 0\nrt_dtb: .word 0\n",
		text: `; x / 10 and x % 10 by the shift-add reciprocal, exact for every
; uint32 and with no loop. Quotient -> rt_dquo and r0, remainder ->
; rt_drem and r1: the cell pair is __rt_udivmod's contract (so that
; routine can jump straight here), and the r0/r1 copies are what a
; compiled site reads, through the vector page in a guest image.
;
; The reciprocal is 51/64 * 257/256 * 65537/65536 / 8 =
; 858993459/2^33, which falls 2.3e-11 short of 1/10, so the quotient
; never exceeds x/10 and the fixup only ever has to add. The textbook
; chain opens with (x>>1) + (x>>2) and reaches 51/64 by a third step,
; x 17/16; folding all three into the one constant 204/256 costs a
; multiply and saves two sub-byte shifts, which are the expensive kind.
; 204*x would overflow, so the low byte multiplies separately and comes
; back through its own lane shift: 204x >> 8 == 204*(x >> 8) +
; (204*(x & 255) >> 8), exactly, and 204*(x >> 8) < 2^32.
;
; A sweep of all 2^32 dividends puts the pre-fixup remainder of THIS
; form in [0, 13], so the single compare at the end finishes it.
;
; Every shift has a constant count, so each is the byte-lane sequence
; the compiler emits for one (func.go, laneShrConst): a whole-byte
; count is a lane copy, and the sub-byte >>3 splits the word at the
; byte boundary — (q >> 8) << 5 for everything above the low byte,
; OR'd with byte 1 of q << 5 — the two halves agreeing on the bits they
; both carry. Left shifts ride mulc, which doubles the sniffer's
; accumulator once per bit of its constant.
__rt_udivmod10:
    move $0, rt_dta
    move r0+1, rt_dta, size8, count=3, incrr, incrw  ; a = x >> 8
    andn r0, $0xFFFFFF00, rt_dtb                     ; b = x & 255
    mulc rt_dta, 204, rt_dquo
    mulc rt_dtb, 204, rt_dtb
    move $0, rt_dta
    move rt_dtb+1, rt_dta, size8   ; 204b >> 8, one byte wide
    add rt_dquo, rt_dta, rt_dquo   ; q = 204x >> 8  (x 51/64)
    move $0, rt_dta
    move rt_dquo+1, rt_dta, size8, count=3, incrr, incrw
    add rt_dquo, rt_dta, rt_dquo   ; q += q >> 8    (x 257/256)
    move $0, rt_dta
    move rt_dquo+2, rt_dta, size16
    add rt_dquo, rt_dta, rt_dquo   ; q += q >> 16   (x 65537/65536)
    move $0, rt_dta
    move rt_dquo+1, rt_dta, size8, count=3, incrr, incrw
    mulc rt_dta, 32, rt_dta
    mulc rt_dquo, 32, rt_dtb
    move $0, rt_dquo
    move rt_dtb+1, rt_dquo, size8
    or rt_dquo, rt_dta, rt_dquo    ; q >>= 3
    mulc rt_dquo, 10, rt_drem
    sub r0, rt_drem, rt_drem       ; r = x - 10q, in [0, 13]
    add rt_drem, $0xFFFFFFF6, rt_dta
    jsign rt_dta, rt_udm10_out, rt_udm10_fix
rt_udm10_fix:
    move rt_dta, rt_drem           ; r -= 10
    add rt_dquo, $1, rt_dquo
rt_udm10_out:
    move rt_dquo, r0
    move rt_drem, r1
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
		text: `; r0 << r1, for counts only known at run time.
__rt_shl:
    andn r1, $0xFFFFFFE0, r1
rt_shl_loop:
    add r1, $0xFFFFFFFF, r1
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
		data: "rt_lres: .word 0\nrt_lcnt: .word 0\nrt_lrev: .word 0\nrt_lnorm: .word 0\n",
		text: `; r0 >> r1, for counts only known at run time. Shifts below 16 go
; through the sniffer's OUT_REV bit reversal: x >> n == rev(rev(x) << n),
; so reverse, do n cheap left doublings, reverse back — ~21 + 4n
; instructions instead of ~7*(32-n). Larger shifts keep the MSB-first
; rebuild loop, whose cost falls as n rises. OUT_REV lives in
; SNIFF_CTRL (bit 10) and transforms SNIFF_DATA reads only (writes
; store raw). Both CTRL flavors are computed BEFORE engaging: while
; OUT_REV is on, any accumulator read is reversed, so the restore must
; be a plain store of a precomputed word, never a read-modify-write.
; %sniff is caller-saved per the ABI, so clobbering the accumulator is
; free.
__rt_lshr:
    andn r1, $0xFFFFFFE0, r1
    jlt r1, $16, rt_lshr_rev, rt_lshr_slow
rt_lshr_rev:
    or %sniffctrl, $0x400, rt_lrev
    andn rt_lrev, $0x400, rt_lnorm
    move rt_lrev, %sniffctrl
    move r0, %sniff
    move %sniff, rt_lres
    move rt_lnorm, %sniffctrl
rt_lshr_dbl:
    add r1, $0xFFFFFFFF, r1
    jneg r1, rt_lshr_out, rt_lshr_go2
rt_lshr_go2:
    shl rt_lres, rt_lres
    jump rt_lshr_dbl
rt_lshr_out:
    move rt_lrev, %sniffctrl
    move rt_lres, %sniff
    move %sniff, r0
    move rt_lnorm, %sniffctrl
    ret
rt_lshr_slow:
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
    add rt_lcnt, $0xFFFFFFFF, rt_lcnt
    jump rt_lshr_loop
rt_lshr_done:
    move rt_lres, r0
    ret
`,
	},
	{
		name: "ashr",
		data: "rt_ares: .word 0\nrt_acnt: .word 0\n",
		text: `; like lshr's slow path, but the result starts as the sign fill.
; Reached only by a run-time count: a constant one folds into the
; logical shift as (y ^ s) - s.
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
    add rt_acnt, $0xFFFFFFFF, rt_acnt
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
	if g.opts.RuntimeExtern != nil {
		return nil // guest image: the host carries the bodies
	}
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
