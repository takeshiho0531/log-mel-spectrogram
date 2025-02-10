#!/bin/bash

SOURCE_DIR_SIM="./sim"
SOURCE_DIR_RTL="./rtl"

DEST_DIR_SIM_IMPORTS="./vivado/vivado.srcs/sim_1/imports/sim"
DEST_DIR_RTL="./vivado/vivado.srcs/sources_1/imports/rtl"

cp "$SOURCE_DIR_SIM/input.txt"          "$DEST_DIR_SIM_IMPORTS/"
cp "$SOURCE_DIR_SIM/tb_logmel.v"        "$DEST_DIR_SIM_IMPORTS/"

cp -r "$SOURCE_DIR_RTL"/* "$DEST_DIR_RTL/"

echo "All specified files and directories have been restored to their original locations."
