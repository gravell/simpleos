#!/bin/bash

# Global paths
source ${BASH_SOURCE%/*}/paths.sh

# General output directory
if [[ ! -d $OUTPUT_PATH ]]
then
    mkdir $OUTPUT_PATH
fi

# Object files
if [[ ! -d $OUTPUT_OBJ_PATH ]]
then
    mkdir $OUTPUT_OBJ_PATH
fi

# Intermediary files
if [[ ! -d $OUTPUT_GENERATED_PATH ]]
then
    mkdir $OUTPUT_GENERATED_PATH
fi

# Compile output
if [[ ! -d $OUTPUT_BIN_PATH ]]
then
    mkdir $OUTPUT_BIN_PATH
fi
