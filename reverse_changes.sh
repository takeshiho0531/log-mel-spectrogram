#!/bin/bash

# 実行するディレクトリをプロジェクトルート (log-mel-spectrogram) と仮定
# 相対パスを設定
SOURCE_DIR_SIM="./sim"
SOURCE_DIR_RTL="./rtl"

DEST_DIR_SIM_IMPORTS="./vivado/vivado.srcs/sim_1/imports/sim"
DEST_DIR_RTL="./vivado/vivado.srcs/sources_1/imports/rtl"

# 個別ファイルをコピー (sim -> vivado 側に戻す)
cp "$SOURCE_DIR_SIM/input.txt"          "$DEST_DIR_SIM_IMPORTS/"
cp "$SOURCE_DIR_SIM/tb_logmel.v"        "$DEST_DIR_SIM_IMPORTS/"

# ディレクトリ (rtl) を再帰的にコピー (元の vivado 側に戻す)
cp -r "$SOURCE_DIR_RTL"/* "$DEST_DIR_RTL/"

echo "All specified files and directories have been restored to their original locations."
