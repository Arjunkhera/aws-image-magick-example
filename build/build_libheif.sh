#!/usr/bin/env bash
set -e

cd /root

# Download and extract the latest libheif
curl -L https://github.com/strukturag/libheif/releases/download/v1.19.7/libheif-1.19.7.tar.gz -o tmp-libheif.tar.gz
tar xf tmp-libheif.tar.gz
cd libheif-1.19.7

# Create a separate build directory
mkdir -p build
cd build

# Make sure pkg-config can find libraries in /root/build/cache/lib/pkgconfig
export PKG_CONFIG_PATH="/root/build/cache/lib/pkgconfig:$PKG_CONFIG_PATH"

# Use GCC 10 for C++20 support
export CC=gcc10
export CXX=g++10

# Configure with CMake and set installation path
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/root/build/cache \
  -DBUILD_SHARED_LIBS=OFF \
  -DWITH_EXAMPLES=OFF \
  -DWITH_GDK_PIXBUF=OFF \
  -DCMAKE_C_FLAGS="-I/root/build/cache/include" \
  -DCMAKE_CXX_FLAGS="-I/root/build/cache/include -std=c++20" \
  -DCMAKE_EXE_LINKER_FLAGS="-L/root/build/cache/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-L/root/build/cache/lib" \
  -DCMAKE_STATIC_LINKER_FLAGS="-L/root/build/cache/lib" \
  ..

# Build and install
make -j"$(nproc)"
make install