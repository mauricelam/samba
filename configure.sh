#!/bin/bash
CWD=$(pwd)

mkdir -p bin/mybin
ln -s "$(which python2)" bin/mybin/python
export PATH="$PWD/bin/mybin:$PATH"

[[ -n $ANDROID_SDK ]] || { echo "ANDROID_SDK is not set"; exit 1; }
NDK=$ANDROID_SDK/ndk/23.1.7779620

HOST=linux-x86_64

ANDROID_VER=23

TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64

# Flags for 32-bit ARM
#ABI=arm-linux-androideabi
#PLATFORM_ARCH=arm
#TRIPLE=arm-linux-androideabi

# Flags for ARM v7 used with flags for 32-bit ARM to compile for ARMv7
#COMPILER_FLAG="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
#LINKER_FLAG="-march=armv7-a -Wl,--fix-cortex-a8"

# Flags for 64-bit ARM v8
ABI=aarch64-linux-android
PLATFORM_ARCH=arm64
TRIPLE=aarch64-linux-android

# Flags for x86
#ABI=x86
#PLATFORM_ARCH=x86
#TRIPLE=i686-linux-android

# Flags for x86_64
#ABI=x86_64
#PLATFORM_ARCH=x86_64
#TRIPLE=x86_64-linux-android

export CC="$CWD/cc_shim.py $TOOLCHAIN/bin/$TRIPLE$ANDROID_VER-clang"
export AR=$TOOLCHAIN/bin/$TRIPLE-ar
export RANLIB=$TOOLCHAIN/bin/$TRIPLE-ranlib

export CFLAGS="$COMPILER_FLAG -O2 -D_FORTIFY_SOURCE=2 -D__ANDROID_API__=$ANDROID_VER -D__USE_FILE_OFFSET64=1 -fstack-protector-all -fPIE -Wa,--noexecstack -Wformat -Wformat-security"
export LDFLAGS="$LINKER_FLAG -Wl,-z,relro,-z,now"

# Create standalone tool chain
# rm -rf $TOOLCHAIN
# echo "Creating standalone toolchain..."
# $NDK/build/tools/make_standalone_toolchain.py --arch $PLATFORM_ARCH --api $ANDROID_VER --install-dir $TOOLCHAIN --unified-headers

# Configure Samba build
echo "Configuring Samba..."
$CWD/configure --hostcc="$(which gcc)" --without-ads --without-ldap --without-acl-support --without-ad-dc --cross-compile --cross-answers=build_answers --prefix=$CWD/out
