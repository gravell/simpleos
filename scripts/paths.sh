#!/bin/bash

# Variable paths that project uses
PICO_SDK_PATH=../pico-sdk
ARM_TOOLCHAIN_PATH=/home/pawel/Downloads/gcc-arm-none-eabi-10.3-2021.10
ARM_LIB_PATH=$ARM_TOOLCHAIN_PATH/lib/gcc/arm-none-eabi/10.3.1/thumb/v6-m/nofp

# Constant paths provided for convenience
OUTPUT_PATH=out
OUTPUT_OBJ_PATH=$OUTPUT_PATH/obj
OUTPUT_GENERATED_PATH=$OUTPUT_PATH/generated
OUTPUT_BIN_PATH=$OUTPUT_PATH/bin

# Toolchain utilities
GCC=$ARM_TOOLCHAIN_PATH/bin/arm-none-eabi-gcc
AS=$ARM_TOOLCHAIN_PATH/bin/arm-none-eabi-as
LD=$ARM_TOOLCHAIN_PATH/bin/arm-none-eabi-ld
OBJCOPY=$ARM_TOOLCHAIN_PATH/bin/arm-none-eabi-objcopy
