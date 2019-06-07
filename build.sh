#!/bin/sh

set -e

if [ -z "$ANDROID_BUILD_TOP" ]; then
	echo "Error: Run \'lunch\' first" >&2
	exit 1
fi

export CLANG_DIR=$ANDROID_BUILD_TOP/prebuilts/clang/host/linux-x86/clang-r353983c
export GCC_DIR=$ANDROID_BUILD_TOP/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9
export PATH=$GCC_DIR/bin:$PATH
export PATH=$CLANG_DIR/bin:$PATH
export CROSS_COMPILE=arm-linux-androideabi-

make clean
make CC=clang LD=clang++
