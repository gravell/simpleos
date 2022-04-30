/**
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */


#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/uart.h"
#include "hardware/structs/ioqspi.h"

#define UART_ID uart0
#define BAUD_RATE 115200

// We are using pins 0 and 1, but see the GPIO function select table in the
// datasheet for information on which other pins can be used.
#define UART_TX_PIN 0
#define UART_RX_PIN 1

void runtime_init(void);

bool get_bootsel_button(void)
{
    const uint CS_PIN_INDEX = 1;

    // Must disable interrupts, as interrupt handlers may be in flash, and we
    // are about to temporarily disable flash access!
    /*
    uint32_t flags = save_and_disable_interrupts();
    */

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

    /*
    restore_interrupts(flags);
    */

    return button_state;
}

int main()
{
    // bool isLoop = true;
    // while (isLoop)
    // {
        // Wait for asm !
    // }

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

    // Use some the various UART functions to send out data
    // In a default system, printf will also output via the default UART

    // Send longer string for debug
    uart_puts(UART_ID, "Hello to SimpleOS!\r\n");

    // Send out a character without any conversions
    uart_putc_raw(UART_ID, 'A');

    // Send out a character but do CR/LF conversions
    uart_putc(UART_ID, 'B');

    // Send out a string, with CR/LF conversions
    uart_puts(UART_ID, "\r\n");
    uart_puts(UART_ID, "Hello, UART!\r\n");
    uart_puts(UART_ID, "Pawel wita!\r\n");
    uart_puts(UART_ID, "---\r\n");

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

        uart_puts(UART_ID, "Pawel wita!\r\n");

        if (gpio_get(7))
        {
            uart_puts(UART_ID, "Pawel wita jedynke\r\n");
        }
        else
        {
            uart_puts(UART_ID, "Pawel wita zero\r\n");
        }
        if (bootsel_pressed)
        {
            uart_puts(UART_ID, "Pawel wita tez bootsel :)\r\n");
        }

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


    while(1)
    {
        ;
    }
}

/// \end::hello_uart[]
