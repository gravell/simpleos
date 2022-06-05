#!/bin/bash

# bootloader:
# - boot2
#   start:   0x00000000
#   end:     0x000000ff
#   purpose: piece of FW which ROM bootloader jumps to
#            configures flash to be used in XIP mode
#            jumps to copier (XIP)
# - copier
#   start:   0x00000100
#   end:     0x000001ff
#   purpose: boot2 jumps to copier after configuring flash
#            copies bootapp from flash to SRAM
#            jumps to bootapp
# - bootapp
#   start:   0x00000200
#   end:     0x00003fff
#   purpose: piece of FW loaded from flash to RAM by copier
#            supports UART debugging and FATFS
#            loads core0 and core1 os apps
#            performs bootloader updates (FATFS -> flash)

# Global paths
source ${BASH_SOURCE%/*}/paths.sh

# Local paths
SIMPLEOS_BOOTLOADER_SRC_PATH=src/bootloader

PICO_SDK_BOOT2_SRC=(
    $PICO_SDK_PATH/src/rp2_common/boot_stage2/boot2_w25q080.S
)

PICO_SDK_BOOT2_INC=(
    $PICO_SDK_PATH/src/rp2_common/boot_stage2
    $PICO_SDK_PATH/src/rp2_common/pico_platform/include
    $PICO_SDK_PATH/src/boards/include/boards
    $PICO_SDK_PATH/src/rp2040/hardware_regs/include
    $PICO_SDK_PATH/src/rp2_common/boot_stage2/asminclude
)

PICO_SDK_BOOT2_SIGNER_PATH=$PICO_SDK_PATH/src/rp2_common/boot_stage2

PICO_SDK_BOOT2_LINKER_SCRIPT=$PICO_SDK_PATH/src/rp2_common/boot_stage2/boot_stage2.ld
PICO_SDK_BOOT2_OUTPUT_FILENAME=boot2
PICO_SDK_BOOT2_SIGNED_OUTPUT_FILENAME=boot2_signed

# Stage #1 - generate *.S containing signed boot2 from pico-sdk repo
# - compile boot2
# - sign boot2 and save in form of binary blob (converted to *.S) that is included in bootloader
$GCC -E ${PICO_SDK_BOOT2_SRC[@]} ${PICO_SDK_BOOT2_INC[@]/#/-I} -o $OUTPUT_GENERATED_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.S
$AS $OUTPUT_GENERATED_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.S -o $OUTPUT_OBJ_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.o
$LD $OUTPUT_OBJ_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.o -T $PICO_SDK_BOOT2_LINKER_SCRIPT -o $OUTPUT_BIN_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.elf
$OBJCOPY $OUTPUT_BIN_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.elf -O binary $OUTPUT_BIN_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.bin

# Signing is simply padding boot2 binary to 256B and putting 32 bit CRC in last 4 bytes
$PICO_SDK_BOOT2_SIGNER_PATH/pad_checksum -s 0xffffffff $OUTPUT_BIN_PATH/$PICO_SDK_BOOT2_OUTPUT_FILENAME.bin $OUTPUT_GENERATED_PATH/$PICO_SDK_BOOT2_SIGNED_OUTPUT_FILENAME.S

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
    $PICO_SDK_PATH/src/rp2040/hardware_structs/include
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
    $PICO_SDK_PATH/src/rp2_common/hardware_divider/include
)

SIMPLEOS_BOOTLOADER_FLAGS=(
    BUILD_TYPE_BOOTAPP=1
)

SIMPLEOS_BOOTLOADER_SRC=(
    $OUTPUT_GENERATED_PATH/boot2_signed.S
    $SIMPLEOS_BOOTLOADER_SRC_PATH/copier.S
    $SIMPLEOS_BOOTLOADER_SRC_PATH/startup.S
    $SIMPLEOS_BOOTLOADER_SRC_PATH/main.c
    $SIMPLEOS_BOOTLOADER_SRC_PATH/stubs.c
    $SIMPLEOS_BOOTLOADER_SRC_PATH/runtime.c
)

SIMPLEOS_BOOTLOADER_OBJ=(
    $(basename -a ${SIMPLEOS_BOOTLOADER_SRC[@]} ${PICO_SDK_SRC[@]} | sed -E "s/\.(c|S)/\.o/")
)

SIMPLEOS_BOOTLOADER_LIB=(
    $ARM_LIB_PATH/libgcc.a
)

SIMPLEOS_BOOTLOADER_LINKER_SCRIPT=$SIMPLEOS_BOOTLOADER_SRC_PATH/linker-bootloader.ld
SIMPLEOS_BOOTLOADER_OUTPUT_FILENAME=bootloader

# Stage 2 - build bootloader
$GCC -mcpu=cortex-m0plus -c -g ${PICO_SDK_FLAGS[@]/#/-D} ${SIMPLEOS_BOOTLOADER_FLAGS[@]/#/-D} ${PICO_SDK_INC[@]/#/-I} ${PICO_SDK_SRC[@]} ${SIMPLEOS_BOOTLOADER_SRC[@]}
mv -f ${SIMPLEOS_BOOTLOADER_OBJ[@]} $OUTPUT_OBJ_PATH
$LD ${SIMPLEOS_BOOTLOADER_OBJ[@]/#/$OUTPUT_OBJ_PATH/} ${SIMPLEOS_BOOTLOADER_LIB[@]} -T $SIMPLEOS_BOOTLOADER_LINKER_SCRIPT -Map=$OUTPUT_BIN_PATH/$SIMPLEOS_BOOTLOADER_OUTPUT_FILENAME.map -o $OUTPUT_BIN_PATH/$SIMPLEOS_BOOTLOADER_OUTPUT_FILENAME.elf
$OBJCOPY $OUTPUT_BIN_PATH/$SIMPLEOS_BOOTLOADER_OUTPUT_FILENAME.elf -O binary $OUTPUT_BIN_PATH/$SIMPLEOS_BOOTLOADER_OUTPUT_FILENAME.bin

