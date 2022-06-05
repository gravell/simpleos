#!/bin/bash

# Global paths
source ${BASH_SOURCE%/*}/paths.sh

# Local paths
SIMPLEOS_CORE0_SRC_PATH=src/core0

PICO_SDK_FLAGS=(
    LIB_PICO_STDIO_UART=1
    PICO_UART_ENABLE_CRLF_SUPPORT=1
    PICO_TIME_DEFAULT_ALARM_POOL_DISABLED=1
    PICO_NO_RAM_VECTOR_TABLE=1
    PICO_DISABLE_SHARED_IRQ_HANDLERS=1
)

PICO_SDK_SRC=(
    $PICO_SDK_PATH/src/rp2_common/hardware_claim/claim.c
    $PICO_SDK_PATH/src/rp2_common/hardware_timer/timer.c
    $PICO_SDK_PATH/src/rp2_common/hardware_xosc/xosc.c
    $PICO_SDK_PATH/src/rp2_common/pico_platform/platform.c
    $PICO_SDK_PATH/src/rp2_common/hardware_watchdog/watchdog.c
    $PICO_SDK_PATH/src/rp2_common/hardware_pll/pll.c
    $PICO_SDK_PATH/src/rp2_common/hardware_irq/irq.c
    $PICO_SDK_PATH/src/rp2_common/hardware_clocks/clocks.c
    $PICO_SDK_PATH/src/rp2_common/hardware_gpio/gpio.c
    $PICO_SDK_PATH/src/rp2_common/hardware_uart/uart.c
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

SIMPLEOS_CORE0_FLAGS=(
    BUILD_TYPE_CORE0=1
)

SIMPLEOS_CORE0_SRC=(
    $SIMPLEOS_CORE0_SRC_PATH/startup.S
    $SIMPLEOS_CORE0_SRC_PATH/main.c
    $SIMPLEOS_CORE0_SRC_PATH/stubs.c
    $SIMPLEOS_CORE0_SRC_PATH/runtime.c
)

SIMPLEOS_CORE0_OBJ=(
    $(basename -a ${SIMPLEOS_CORE0_SRC[@]} ${PICO_SDK_SRC[@]} | sed -E "s/\.(c|S)/\.o/")
)

SIMPLEOS_CORE0_LIB=(
    $ARM_LIB_PATH/libgcc.a
)

SIMPLEOS_CORE0_LINKER_SCRIPT=$SIMPLEOS_CORE0_SRC_PATH/linker-core0.ld
SIMPLEOS_CORE0_OUTPUT_FILENAME=core0

$GCC -mcpu=cortex-m0plus -c -g ${PICO_SDK_FLAGS[@]/#/-D} ${SIMPLEOS_CORE0_FLAGS[@]/#/-D} ${PICO_SDK_INC[@]/#/-I} ${PICO_SDK_SRC[@]} ${SIMPLEOS_CORE0_SRC[@]}
mv -f ${SIMPLEOS_CORE0_OBJ[@]} $OUTPUT_OBJ_PATH
$LD ${SIMPLEOS_CORE0_OBJ[@]/#/$OUTPUT_OBJ_PATH/} ${SIMPLEOS_CORE0_LIB[@]} -T $SIMPLEOS_CORE0_LINKER_SCRIPT -Map=$OUTPUT_BIN_PATH/$SIMPLEOS_CORE0_OUTPUT_FILENAME.map -o $OUTPUT_BIN_PATH/$SIMPLEOS_CORE0_OUTPUT_FILENAME.elf
$OBJCOPY $OUTPUT_BIN_PATH/$SIMPLEOS_CORE0_OUTPUT_FILENAME.elf -O binary $OUTPUT_BIN_PATH/$SIMPLEOS_CORE0_OUTPUT_FILENAME.bin
