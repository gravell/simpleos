#!/bin/bash

# Path to pi-pico sdk used to manage ahrdware level features
PICO_SDK_PATH=../pico-sdk
# ARM_TOOLCHAIN_PATH=/home/pawel/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin
# ARM_LIB_PATH=/home/pawel/Downloads/gcc-arm-none-eabi-10.3-2021.10/lib/gcc/arm-none-eabi/10.3.1/arm/v5te/softfp/







PICO_SDK_SRC=(
    ../pico-examples/uart/hello_uart/hello_uart.c
    ../pico-sdk/src/rp2_common/hardware_uart/uart.c
    ../pico-sdk/src/host/hardware_uart/uart.c
)




PICO_SDK_INC=(
    $PICO_SDK_PATH/src/rp2_common/pico_platform/include
    $PICO_SDK_PATH/src/common/pico_stdlib/include
    $PICO_SDK_PATH/src/rp2040/hardware_regs/include
    $PICO_SDK_PATH/src/rp2040/hardware_structs/include/
    $PICO_SDK_PATH/build/generated/pico_base
    $PICO_SDK_PATH/src/common/pico_base/include
    $PICO_SDK_PATH/src/common/pico_time/include
    $PICO_SDK_PATH/src/rp2_common/hardware_base/include
    $PICO_SDK_PATH/src/rp2_common/hardware_resets/include
    $PICO_SDK_PATH/src/rp2_common/hardware_clocks/include
    $PICO_SDK_PATH/src/common/pico_sync/include
    $PICO_SDK_PATH/src/rp2_common/pico_stdio/include
    $PICO_SDK_PATH/src/rp2_common/hardware_pll/include
    $PICO_SDK_PATH/src/rp2_common/hardware_irq/include
    $PICO_SDK_PATH/src/rp2_common/hardware_timer/include
    $PICO_SDK_PATH/src/rp2_common/hardware_uart/include
    $PICO_SDK_PATH/src/rp2_common/hardware_gpio/include
    $PICO_SDK_PATH/src/rp2_common/hardware_sync/include
    $PICO_SDK_PATH/src/rp2_common/hardware_watchdog/include
    $PICO_SDK_PATH/src/rp2_common/hardware_xosc/include
    $PICO_SDK_PATH/src/rp2_common/hardware_claim/include
    # $PICO_SDK_PATH/src/rp2_common/pico_printf/include
    $PICO_SDK_PATH/src/rp2_common/pico_stdio_uart/include
    $PICO_SDK_PATH/src/rp2_common/hardware_divider/include/
)






arm-none-eabi-gcc -mcpu=cortex-m0plus -c -g -DLIB_PICO_STDIO_UART=1 -DPICO_UART_ENABLE_CRLF_SUPPORT=1 -DPICO_TIME_DEFAULT_ALARM_POOL_DISABLED=1 -DPICO_NO_RAM_VECTOR_TABLE=1 -DPICO_DISABLE_SHARED_IRQ_HANDLERS=1 ${PICO_SDK_INC[@]/#/-I} startup-core0.S ../pico-sdk/src/rp2_common/hardware_claim/claim.c ../pico-sdk/src/rp2_common/hardware_timer/timer.c ../pico-sdk/src/rp2_common/hardware_xosc/xosc.c ../pico-sdk/src/rp2_common/pico_platform/platform.c ../pico-sdk/src/rp2_common/hardware_watchdog/watchdog.c ../pico-sdk/src/rp2_common/hardware_pll/pll.c ../pico-sdk/src/rp2_common/hardware_irq/irq.c ../pico-sdk/src/rp2_common/hardware_clocks/clocks.c ../pico-sdk/src/rp2_common/hardware_gpio/gpio.c ../pico-sdk/src/rp2_common/hardware_uart/uart.c main.c stubs.c runtime.c
arm-none-eabi-ld startup-core0.o claim.o timer.o xosc.o platform.o watchdog.o pll.o irq.o clocks.o gpio.o uart.o main.o stubs.o runtime.o /usr/lib/gcc/arm-none-eabi/10.3.1/thumb/v6-m/nofp/libgcc.a -T linker-core0.ld -Map=core0.map -o core0.elf
arm-none-eabi-objcopy core0.elf -O binary core0.bin
