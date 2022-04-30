#!/bin/bash

rm *.o *.bin *.elf *.list *.map
# These are files generated on base of PICO-SDK build output + crc32 calculation.
# These are not full members of this repo and thus can be removed.
rm boot2.S boot2_raw.S
