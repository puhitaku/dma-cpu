# DMA-CPU build/test entry points (see prompts/overview.md, Phase 0).

.PHONY: all build test vet clean test-hw

all: build

build:
	go build -o dmaemu ./cmd/dmaemu

test: vet
	go test ./...

vet:
	go vet ./...

clean:
	rm -f dmaemu

# Hardware-in-the-loop tests (Phase 0 step 1): flash via picotool/OpenOCD
# and diff UART/GPIO captures against emulator golden outputs. Not yet
# implemented — requires a connected Pico.
test-hw:
	@echo "test-hw: not implemented yet (requires hardware runner)"; exit 1
