The DMA controller in the RP2040/RP2350 microcontroller of the Raspberry Pi Pico is known to be Turing-complete (see the docs/ece4760.pdf). Leveraging this capability, I plan to explore some experimental projects:

- Enhance LLVM to support DMA programming and make Clang compatible with RP2040 DMA
- Implement a DMA program loader and test it both in emulator and on actual hardware
- If we successfully address issues like interrupt handling, consider porting xv6 to run natively on DMA

To implement this, I want to create a development and testing loop using the Coding Agent. However, before proceeding, there are several considerations I'd like to examine:

- What implementation approaches are feasible for interrupting and modifying the program counter of DMA programs through GPIO interrupt and timer interrupt
- Since DMA programs typically place normally CPU-internal and non-addressable registers like zero register, flag register, and PC in SRAM, how can we resolve this during linking?

Please analyze these points while reviewing prompts/ece4760.pdf and propose a development plan in prompts/overview.md with the project goals I proposed first. Output in English.

