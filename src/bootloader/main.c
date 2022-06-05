#include "pico/stdlib.h"
#include "hardware/uart.h"

#include "runtime.h"

int main()
{
#if BUILD_TYPE_BOOTAPP
#define UART_ID uart0
#define BAUD_RATE 115200

#define UART_TX_PIN 0
#define UART_RX_PIN 1

    bool static runtime_init_done = false;
    if (!runtime_init_done)
    {
        runtime_init();
        runtime_init_done = true;
    }
    // Set up our UART with the required speed.
    uart_init(UART_ID, BAUD_RATE);

    // Set the TX and RX pins by using the function select on the GPIO
    // Set datasheet for more information on function select
    gpio_set_function(UART_TX_PIN, GPIO_FUNC_UART);
    gpio_set_function(UART_RX_PIN, GPIO_FUNC_UART);

    // Welcome message
    uart_puts(UART_ID, "SimpleOS bootloader start...\r\n");

    // Open window for entering bootloader console
    uart_puts(UART_ID, "Press magic key to enter bootloader console...\r\n");
    uint32_t tick = 0;
    while (tick < 10000000)
    {
        if(uart_is_readable(UART_ID))
        {
            char c = (char) uart_get_hw(UART_ID)->dr;
            uart_puts(UART_ID, "Bootlaoder console entered\r\n");
            uart_puts(UART_ID, "It is stub function for now, continue with regular bootlaoder flow...\r\n");
            break;
        }
        else
        {
            tick++;
        }
    }

    // Copy app form flash to SRAM.
    // Eventually it is going to be copied from FS to SRAM
    uart_puts(UART_ID, "Loading OS code to SRAM...\r\n");
    for (uint32_t i = 0 ; i < 16 * 1024 ; i += 4)
    {
        uint32_t *p_s = (uint32_t *)(0x10004000 + i);
        uint32_t *p_d = (uint32_t *)(0x20010000 + i);
        *p_d = *p_s;
    }

    uart_puts(UART_ID, "SimpleOS bootloader finished!\r\n");

    uart_puts(UART_ID, "Jumping to OS...\r\n");
    asm volatile("bx %0" : : "r" (0x20010001));
#endif // BUILD_TYPE_BOOTAPP
    while(1)
    {
        ;
    }
}
