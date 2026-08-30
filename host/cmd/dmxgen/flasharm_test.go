package main

// The flash-executor bake, which is a three-state decision the kernel
// cannot recover from if it is wrong: a mailbox address on a board
// whose firmware runs no mailbox service makes kflash.c's arm_request
// spin forever on an ack. So both halves are pinned here — which value
// each shipped board gets, and that the sentinel still means the same
// thing on the C side.

import (
	"os"
	"regexp"
	"strconv"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
)

func TestFlashArmStates(t *testing.T) {
	for _, tc := range []struct {
		bd   *boards.Board
		want uint32
		why  string
	}{
		{boards.Pico2, 0, "the machine drives the QMI itself"},
		{boards.Pico, boards.Pico.Scratch + 0x10, "the parked ARM's mailbox"},
		{boards.Feather, kflashNoExec, "no executor at all: sync must answer -ENODEV"},
	} {
		if got := flashArm(tc.bd); got != tc.want {
			t.Errorf("%s: g_kflash_arm = %#x, want %#x (%s)",
				tc.bd.Name, got, tc.want, tc.why)
		}
	}
	// A sentinel that collided with a real mailbox address would be
	// indistinguishable from the state it exists to rule out.
	for _, bd := range boards.All {
		if bd.Scratch+0x10 == kflashNoExec {
			t.Errorf("%s: the mailbox address IS the sentinel", bd.Name)
		}
	}
}

// TestFlashNoExecSentinel keeps the Go constant and kflash.c's #define
// in step: they are two spellings of one wire value, and nothing else
// would catch them drifting apart until a board hung on silicon.
func TestFlashNoExecSentinel(t *testing.T) {
	src, err := os.ReadFile("../../../target/xv6/dma/kflash.c")
	if err != nil {
		t.Fatal(err)
	}
	m := regexp.MustCompile(`#define KFLASH_NOEXEC (\d+)u`).FindSubmatch(src)
	if m == nil {
		t.Fatal("kflash.c no longer defines KFLASH_NOEXEC as a decimal literal")
	}
	n, err := strconv.Atoi(string(m[1]))
	if err != nil {
		t.Fatal(err)
	}
	if uint32(n) != kflashNoExec {
		t.Errorf("kflash.c KFLASH_NOEXEC = %d, dmxgen bakes %d", n, kflashNoExec)
	}
}
