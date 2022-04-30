#!/bin/bash

# ~/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-as startup.S -o startup.o
# ~/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gcc -Wall -Werror -O0 -c main.c -o main.o
# ~/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-ld startup.o main.o -T linker.ld -Map=main.map -o main.elf
# ~/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-objdump -D main.elf > main.list
# ~/Downloads/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-objcopy main.elf -O binary main.bin

./build-bootloader.sh
./build-core0.sh

cat bootloader.bin core0.bin > full_image.bin
