#include <stdio.h>
#include <stdarg.h>
#include "pico.h"

#include "hardware/regs/m0plus.h"
#include "hardware/regs/resets.h"
#include "hardware/structs/mpu.h"
#include "hardware/structs/scb.h"
#include "hardware/structs/padsbank0.h"

#include "hardware/clocks.h"
#include "hardware/irq.h"
#include "hardware/resets.h"

#include "pico/mutex.h"
#include "pico/time.h"

#if LIB_PICO_PRINTF_PICO
#include "pico/printf.h"
#else
#define weak_raw_printf printf
#define weak_raw_vprintf vprintf
#endif

#if PICO_ENTER_USB_BOOT_ON_EXIT
#include "pico/bootrom.h"
#endif

#include <stdint.h>

void __assert_func(const char *file, int line, const char *func, const char *failedexpr)
{
    while(1);
}

void /*__noreturn*/ panic_unsupported(void)
{
    while(1);
}

void /*__noreturn*/ panic(const char *fmt, ...)
{
    while(1);
}

int putchar(int character)
{
    while(1);
}

// IRQs - to be moved to separate file

// void reset_handler(void)
// {
// it calls main, let's not use it
    // while(1);
// }

// void _reset_handler(void)
// {
// it calls main, let's not use it
    // while(1);
// }

void isr_nmi(void)
{
    while(1);
}

void isr_hardfault(void)
{
    while(1);
}

// void isr_irq20(void)
// {
    // while(1);
// }

// void isr_irq21(void)
// {
    // while(1);
// }

void runtime_init(void)
{
    reset_block(~(
            RESETS_RESET_IO_QSPI_BITS |
            RESETS_RESET_PADS_QSPI_BITS |
            RESETS_RESET_PLL_USB_BITS |
            RESETS_RESET_USBCTRL_BITS |
            RESETS_RESET_SYSCFG_BITS |
            RESETS_RESET_PLL_SYS_BITS
    ));

    unreset_block_wait(RESETS_RESET_BITS & ~(
            RESETS_RESET_ADC_BITS |
            RESETS_RESET_RTC_BITS |
            RESETS_RESET_SPI0_BITS |
            RESETS_RESET_SPI1_BITS |
            RESETS_RESET_UART0_BITS |
            RESETS_RESET_UART1_BITS |
            RESETS_RESET_USBCTRL_BITS
    ));

    clocks_init();

    unreset_block_wait(RESETS_RESET_BITS);

#if !PICO_IE_26_29_UNCHANGED_ON_RESET
    // after resetting BANK0 we should disable IE on 26-29
    hw_clear_alias(padsbank0_hw)->io[26] = hw_clear_alias(padsbank0_hw)->io[27] =
            hw_clear_alias(padsbank0_hw)->io[28] = hw_clear_alias(padsbank0_hw)->io[29] = PADS_BANK0_GPIO0_IE_BITS;
#endif
    irq_init_priorities();
}
