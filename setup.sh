#!/bin/bash

#DIRs
RDIR=$(pwd)
BUILD_DIR=$RDIR/build
BUILD_TOOL_DIR=$RDIR/prebuilts/build-tools
DOWNLOADS_DIR=$RDIR/downloads
KERNEL_DIR=$RDIR/kernel
KERNEL_BUILD_TOOL_DIR=$RDIR/prebuilts/kernel-build-tools
CLANG_DIR=$RDIR/prebuilts/clang/host/linux-x86/clang-r383902
GCC_DIR=$RDIR/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9
GLIBC_DIR=$GCC_DIR/../host/x86_64-linux-glibc2.17-4.8

#DOWNLOAD LINKS
BUILD_LINK=https://android.googlesource.com/kernel/build/+archive/refs/heads/master.tar.gz
BUILD_TOOL_LINK=https://android.googlesource.com/kernel/prebuilts/build-tools/+archive/refs/heads/master.tar.gz
KERNEL_BUILD_TOOL_LINK=https://android.googlesource.com/kernel/prebuilts/build-tools/+archive/refs/heads/master.tar.gz
CLANG_LINK=https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android-msm-coral-4.14-android12L/clang-r383902.tar.gz
GCC_LINK=https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/0a0604336d4d1067aa1aaef8d3779b31fcee841d.tar.gz
GLIBC_LINK=https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/+archive/refs/heads/master.tar.gz

#DOWNLOADED FILES
BUILD_ARCHIVE=$DOWNLOADS_DIR/build.tar.gz
BUILD_TOOL_ARCHIVE=$DOWNLOADS_DIR/build-tools.tar.gz
KERNEL_BUILD_TOOL_ARCHIVE=$DOWNLOADS_DIR/kernel-build-tools.tar.gz
CLANG_ARCHIVE=$DOWNLOADS_DIR/clang-r383902.tar.gz
GCC_ARCHIVE=$DOWNLOADS_DIR/gcc4.9.tar.gz
GLIBC_ARCHIVE=$DOWNLOADS_DIR/x86_64-linux-glibc2.17-4.8.tar.gz

# BUILD SETUP
SETUP_BUILD() {
    echo "Creating folders..."
        mkdir -p $DOWNLOADS_DIR &&
        mkdir -p $BUILD_DIR &&
        mkdir -p $BUILD_TOOL_DIR &&
        mkdir -p $KERNEL_DIR &&
        mkdir -p $KERNEL_BUILD_TOOL_DIR &&
        mkdir -p $CLANG_DIR &&
        mkdir -p $GCC_DIR &&
        mkdir -p $GLIBC_DIR

}
# DOWNLOADING FILES
SETUP_DOWNLOAD() {
    echo "Downloading files..."
    if [ -f $BUILD_ARCHIVE ]; then
        echo "You have already downloaded build files..."
    else
        wget $BUILD_LINK -O $BUILD_ARCHIVE
    fi

    if [ -f $BUILD_TOOL_ARCHIVE ]; then
        echo "You have already downloaded build tool..."
    else
        wget $BUILD_TOOL_LINK -O $BUILD_TOOL_ARCHIVE
    fi
    if [ -f $KERNEL_BUILD_TOOL_ARCHIVE ]; then
        echo "You have already downloaded kernel build tool..."
    else
        wget $KERNEL_BUILD_TOOL_LINK -O $KERNEL_BUILD_TOOL_ARCHIVE
    fi
    if [ -f $CLANG_ARCHIVE ]; then
        echo "You have already downloaded clang..."
    else
        wget $CLANG_LINK -O $CLANG_ARCHIVE
    fi
    if [ -f $GCC_ARCHIVE ]; then
        echo "You have already downloaded gcc..."
    else
        wget $GCC_LINK -O $GCC_ARCHIVE
    fi
    if [ -f $GLIBC_ARCHIVE ]; then
        echo "You have already downloaded gcc libs..."
    else
        wget $GLIBC_LINK -O $GLIBC_ARCHIVE
    fi
}

# EXTRACTING DOWNLOADED FILES
EXTRACT_DOWNLOAD() {
    echo "Extracting downloaded files..."
    if [ -f $BUILD_ARCHIVE ]; then
        echo "EXTRACTING $BUILD_ARCHIVE ..."
        tar -zxf $BUILD_ARCHIVE -C $BUILD_DIR
    else
        echo "$BUILD_ARCHIVE not found..."
    fi

    if [ -f $BUILD_TOOL_ARCHIVE ]; then
        echo "EXTRACTING $BUILD_TOOL_ARCHIVE ..."
        tar -zxf $BUILD_TOOL_ARCHIVE -C $BUILD_TOOL_DIR
    else
        echo "$BUILD_TOOL_ARCHIVE not found..."
    fi
    if [ -f $KERNEL_BUILD_TOOL_ARCHIVE ]; then
        echo "EXTRACTING $KERNEL_BUILD_TOOL_ARCHIVE ..."
        tar -zxf $KERNEL_BUILD_TOOL_ARCHIVE -C $KERNEL_BUILD_TOOL_DIR
    else
        echo "$KERNEL_BUILD_TOOL_ARCHIVE not found..."
    fi
    if [ -f $CLANG_ARCHIVE ]; then
        echo "EXTRACTING $CLANG_ARCHIVE ..."
        tar -zxf $CLANG_ARCHIVE -C $CLANG_DIR
    else
        echo "$CLANG_ARCHIVE not found..."
    fi
    if [ -f $GCC_ARCHIVE ]; then
        echo "EXTRACTING $GCC_ARCHIVE ..."
        tar -zxf $GCC_ARCHIVE -C $GCC_DIR
    else
        echo "$GCC_ARCHIVE not found..."
    fi
    if [ -f $GLIBC_ARCHIVE ]; then
        echo "EXTRACTING $GLIBC_ARCHIVE ..."
        tar -zxf $GLIBC_ARCHIVE -C $GLIBC_DIR
    else
        echo "$GLIBC_ARCHIVE not found..."
    fi
}

# FIXING SYMLINKS
FIX_SYMLINK(){
    cd $BUILD_DIR/build-tools
    rm -rf ./sysroot
    ln -sf ../../prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/sysroot ./sysroot 
    cd ./path/linux-x86
    mv ./bison ../
    rm -rf ./*
    mv ../bison ./
    cp --symbolic-link ../../../../prebuilts/kernel-build-tools/linux-x86/bin/* .
    echo "Done"
    cd $RDIR
}

# Executing...
SETUP_BUILD &&
SETUP_DOWNLOAD &&
EXTRACT_DOWNLOAD &&
FIX_SYMLINK &&
echo "Finished Enjoy kernel building"