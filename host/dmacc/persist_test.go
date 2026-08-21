package dmacc_test

import (
	"bytes"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/emu"
)

// TestXv6Persist: the full persistence loop. Boot 1 stages the golden
// disk, creates a file, and runs `sync` (the kernel burns the RAM
// disk into the flash slot over QMI direct mode). Boot 2 shares the
// same flash, stages from the now-valid slot, and reads the file
// back. A third boot checks the generation advances.
func TestXv6Persist(t *testing.T) {
	t.Parallel()
	flash := make([]byte, 0x400000) // the full 4 MiB flash map
	for i := range flash {
		flash[i] = 0xFF
	}

	run := func(feed string, budget uint64) string {
		m, _ := bootXshFlash(t, flash)
		m.FeedConsole(feed)
		// Chunked run, servicing the ARM-executor mailbox in between
		// (the kernel spins on the ack while a request is pending),
		// stopping once the script has quiesced at a prompt — the
		// fixed budget alone burned 10-50x the needed cycles.
		var used uint64
		quiet, last := 0, len(m.ConsoleOut)
		for used < budget && quiet < 3 {
			rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000})
			if err != nil {
				t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
			}
			used += rr.Cycles
			for serviceFlashMailbox(m, flash) {
			}
			if len(m.ConsoleIn) == 0 && len(m.ConsoleOut) == last &&
				bytes.HasSuffix(m.ConsoleOut, []byte("$ ")) {
				quiet++
			} else {
				quiet = 0
			}
			last = len(m.ConsoleOut)
		}
		return strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	}

	out := run("echo persistent booom > keep\rsync\rls\r", 900_000_000)
	t.Logf("boot1:\n%s", out)
	if !strings.Contains(out, "keep") {
		t.Fatalf("boot 1 did not create the file:\n%s", out)
	}

	out = run("cat keep\r", 400_000_000)
	t.Logf("boot2:\n%s", out)
	if !strings.Contains(out, "persistent booom") {
		t.Errorf("the file did not survive the reboot:\n%s", out)
	}

	out = run("echo second > keep2\rsync\rcat keep\rcat keep2\r", 900_000_000)
	t.Logf("boot3:\n%s", out)
	for _, want := range []string{"persistent booom", "second"} {
		if !strings.Contains(out, want) {
			t.Errorf("missing %q after generation 2:\n%s", want, out)
		}
	}
}
