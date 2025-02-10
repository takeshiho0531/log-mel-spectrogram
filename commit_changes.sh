#!/bin/bash

# 実行するディレクトリをプロジェクトルート (log-mel-spectrogram) と仮定する
# 相対パスを設定
SOURCE_DIR_XSIM="./vivado/vivado.sim/sim_1/behav/xsim"
SOURCE_DIR_SIM_IMPORTS="./vivado/vivado.srcs/sim_1/imports/sim"
SOURCE_DIR_RTL="./vivado/vivado.srcs/sources_1/imports/rtl"

DEST_DIR_SIM="./sim"
DEST_DIR_RTL="./rtl"

# 個別ファイルをコピー
cp "$SOURCE_DIR_XSIM/simulate.log"       "$DEST_DIR_SIM/"
cp "$SOURCE_DIR_XSIM/output.txt"         "$DEST_DIR_SIM/"
cp "$SOURCE_DIR_SIM_IMPORTS/input.txt"   "$DEST_DIR_SIM/"
cp "$SOURCE_DIR_SIM_IMPORTS/tb_logmel.v" "$DEST_DIR_SIM/"

# ディレクトリ (rtl) を再帰的にコピー
# 既に $DEST_DIR_RTL が存在する場合は、その中に入っていきます。
cp -r "$SOURCE_DIR_RTL"/* "$DEST_DIR_RTL/"

echo "All specified files and directories have been copied successfully."
