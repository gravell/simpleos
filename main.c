/**
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */


#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/uart.h"

/// \tag::hello_uart[]

#define UART_ID uart0
#define BAUD_RATE 115200

// We are using pins 0 and 1, but see the GPIO function select table in the
// datasheet for information on which other pins can be used.
#define UART_TX_PIN 0
#define UART_RX_PIN 1

void runtime_init(void);
int main() {
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
    uart_puts(UART_ID, "AAAAAABBBBBBCCCCCCCDDDDDDDDDDEEEFFFFFFFFGGGGGGGHHHHHHH");

    // Send out a character without any conversions
    uart_putc_raw(UART_ID, 'A');

    // Send out a character but do CR/LF conversions
    uart_putc(UART_ID, 'B');

    // Send out a string, with CR/LF conversions
    uart_puts(UART_ID, "\r\n");
    uart_puts(UART_ID, "Hello, UART!\r\n");
    uart_puts(UART_ID, "Pawel wita!\r\n");
    uart_puts(UART_ID, "---\r\n");


    while (1)
    {
// #define ROSC_MHZ_MAX 12
        // delay(100 * ROSC_MHZ_MAX / 3);
        uint32_t sum = 0;
        for (int i = 0; i < 9; ++i)
        {
            // delay(1 * ROSC_MHZ_MAX / 3);
            for (uint32_t x = 0 ; x < 1000000; x++)
            {}
            sum += (sio_hw->gpio_hi_in >> 1) & 1u;
        }

        if (sum >= 5)
            uart_puts(UART_ID, "Pawel wita!\r\n");
    }


    while(1)
    {}
}

/// \end::hello_uart[]
