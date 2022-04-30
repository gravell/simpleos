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

# Paths should be moved to single, separate config file so all scripts can use it as one entry point for config.
# Path required for script to work
PICO_SDK_PATH=../pico-sdk
# ARM_TOOLCHAIN_PATH=/home/pawel/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin

# Do we need these steps as separate ones?
# Generate boot stage 2 from pico-sdk repo
arm-none-eabi-gcc -E $PICO_SDK_PATH/src/rp2_common/boot_stage2/boot2_w25q080.S -I$PICO_SDK_PATH/src/rp2_common/boot_stage2 -I$PICO_SDK_PATH/src/rp2_common/pico_platform/include -I$PICO_SDK_PATH/src/boards/include/boards -I$PICO_SDK_PATH/src/rp2040/hardware_regs/include -I$PICO_SDK_PATH/src/rp2_common/boot_stage2/asminclude -o boot2_raw.S
arm-none-eabi-as boot2_raw.S -o boot2_raw.o
arm-none-eabi-ld boot2_raw.o -T $PICO_SDK_PATH/src/rp2_common/boot_stage2/boot_stage2.ld -o boot2_raw.elf
arm-none-eabi-objcopy boot2_raw.elf -O binary boot2_raw.bin

$PICO_SDK_PATH/src/rp2_common/boot_stage2/pad_checksum -s 0xffffffff boot2_raw.bin boot2.S

arm-none-eabi-as boot2.S -o boot2.o
arm-none-eabi-as copier.S -o copier.o

# arm-none-eabi-as copier.S -o copier.o
# arm-none-eabi-ld copier.o -T linker-bootloader.ld -o copier.elf
# arm-none-eabi-objcopy copier.elf -O binary copier.bin

# $PICO_SDK_PATH/src/rp2_common/boot_stage2/pad_checksum -s 0xffffffff copier.bin copier_signed.S
# arm-none-eabi-as copier_signed.S -o copier_signed.o

# startup.S is for start of real code and prepare before main, copier should be only copying routine


arm-none-eabi-ld boot2.o copier.o -T linker-bootloader.ld -Map=main.map -o bootloader.elf
# arm-none-eabi-ld copier_signed.o -T copier_signed.ld -Map=main.map -o bootloader.elf
arm-none-eabi-objdump -D bootloader.elf > bootloader.list
arm-none-eabi-objcopy bootloader.elf -O binary bootloader.bin
