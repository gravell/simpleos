#!/bin/bash

# Global paths
source ${BASH_SOURCE%/*}/scripts/paths.sh

source ${BASH_SOURCE%/*}/scripts/create-dirs.sh
source ${BASH_SOURCE%/*}/scripts/build-bootloader.sh
source ${BASH_SOURCE%/*}/scripts/build-core0.sh
# Waiting for core1 code to be prepared
# source ${BASH_SOURCE%/*}/scripts/build-core1.sh

# This is temporary solution to flash one binary
# Won't be needed once target (FS based) loading system is ready
cat $OUTPUT_BIN_PATH/bootloader.bin $OUTPUT_BIN_PATH/core0.bin > $OUTPUT_BIN_PATH/full_image.bin
