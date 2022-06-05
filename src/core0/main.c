#include "pico/stdlib.h"
#include "hardware/uart.h"
#include "hardware/structs/ioqspi.h"

#include "runtime.h"

#define UART_ID uart0

bool get_bootsel_button(void)
{
    const uint CS_PIN_INDEX = 1;

    // Set chip select to Hi-Z
    hw_write_masked(&ioqspi_hw->io[CS_PIN_INDEX].ctrl,
                    GPIO_OVERRIDE_LOW << IO_QSPI_GPIO_QSPI_SS_CTRL_OEOVER_LSB,
                    IO_QSPI_GPIO_QSPI_SS_CTRL_OEOVER_BITS);

    // Note we can't call into any sleep functions in flash right now
    for (volatile int i = 0; i < 1000; ++i);

    // The HI GPIO registers in SIO can observe and control the 6 QSPI pins.
    // Note the button pulls the pin *low* when pressed.
    bool button_state = !(sio_hw->gpio_hi_in & (1u << CS_PIN_INDEX));

    // Need to restore the state of chip select, else we are going to have a
    // bad time when we return to code in flash!
    hw_write_masked(&ioqspi_hw->io[CS_PIN_INDEX].ctrl,
                    GPIO_OVERRIDE_NORMAL << IO_QSPI_GPIO_QSPI_SS_CTRL_OEOVER_LSB,
                    IO_QSPI_GPIO_QSPI_SS_CTRL_OEOVER_BITS);

    return button_state;
}

void heartbeat(void)
{
    // Light the built-in diode with heartbeat pattern
    const uint LED_PIN = PICO_DEFAULT_LED_PIN;

    gpio_put(LED_PIN, 1);
    for (uint32_t x = 0 ; x < 1000000; x++)
    {
        ;
    }
    gpio_put(LED_PIN, 0);
    for (uint32_t x = 0 ; x < 1000000; x++)
    {
        ;
    }
    gpio_put(LED_PIN, 1);
    for (uint32_t x = 0 ; x < 1000000; x++)
    {
        ;
    }
    gpio_put(LED_PIN, 0);
    for (uint32_t x = 0 ; x < 6000000; x++)
    {
        ;
    }
}

int main(void)
{
#if BUILD_TYPE_CORE0
    uart_puts(UART_ID, "Hello to SimpleOS!\r\n");

    // Send out a character without any conversions
    // uart_putc_raw(UART_ID, 'A');

    // Send out a character but do CR/LF conversions
    // uart_putc(UART_ID, 'B');

    // Send out a string, with CR/LF conversions
    // uart_puts(UART_ID, "\r\n");
    // uart_puts(UART_ID, "Hello, UART!\r\n");
    // uart_puts(UART_ID, "Pawel wita!\r\n");
    // uart_puts(UART_ID, "---\r\n");

    gpio_init(7);
    gpio_set_dir(7, GPIO_IN);
    gpio_pull_up(7);

    const uint LED_PIN = PICO_DEFAULT_LED_PIN;
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);

    while (1)
    {
        uint32_t sum = 0;
        bool bootsel_pressed = false;
        for (int i = 0; i < 9; ++i)
        {
            for (uint32_t x = 0 ; x < 100000; x++)
            {
                ;
            }

            if(get_bootsel_button())
            {
                sum++;
            }
        }

        if (sum >= 5)
        {
            bootsel_pressed = true;
        }

        /*
        uart_puts(UART_ID, "Pawel wita!\r\n");

        if (gpio_get(7))
        {
            uart_puts(UART_ID, "Pawel wita jedynke\r\n");
        }
        else
        {
            uart_puts(UART_ID, "Pawel wita zero\r\n");
        }
        */
        if (bootsel_pressed)
        {
            uart_puts(UART_ID, "Bootsel pressed\r\n");
        }

        heartbeat();
    }
#endif // BUILD_TYPE_CORE0
    while(1)
    {
        ;
    }
}
