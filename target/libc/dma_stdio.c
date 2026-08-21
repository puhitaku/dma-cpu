/* DMA-machine stdout: a picolibc FILE whose put function writes UART0's
 * data register directly from the machine (dmacc maps __dma_uart_* to
 * the SKU's UART0 MMIO). The TXFF poll paces output on real hardware;
 * in the emulator FR reads 0, so it falls straight through. */
#include <stdio.h>
#include <dma/mmio.h>

static int dma_uart_putc(char c, FILE *file) {
    (void)file;
    /* CRLF translation, like the host-side stdio does for the ARM:
     * terminals need the carriage return. Console comparisons in the
     * test suites strip '\r' before diffing against host output. */
    if (c == '\n') {
        while (__dma_uart_fr & DMA_UART_FR_TXFF)
            ;
        __dma_uart_dr = '\r';
    }
    while (__dma_uart_fr & DMA_UART_FR_TXFF)
        ;
    __dma_uart_dr = (unsigned char)c;
    return (unsigned char)c;
}

static FILE __stdio = FDEV_SETUP_STREAM(dma_uart_putc, NULL, NULL, _FDEV_SETUP_WRITE);

FILE *const stdout = &__stdio;
FILE *const stderr = &__stdio;
