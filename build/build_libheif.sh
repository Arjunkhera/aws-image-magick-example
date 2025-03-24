#!/usr/bin/env bash
set -e

cd /root

# Download and extract libheif
curl -L https://github.com/strukturag/libheif/releases/download/v1.19.7/libheif-1.19.7.tar.gz -o tmp-libheif.tar.gz
tar xf tmp-libheif.tar.gz
cd libheif-1.19.7

# Create a separate build directory
mkdir build
cd build

# Make sure pkg-config can find libraries in /root/build/cache/lib/pkgconfig
export PKG_CONFIG_PATH="/root/build/cache/lib/pkgconfig:$PKG_CONFIG_PATH"

# Configure with the release preset and set installation path
cmake --preset=release -D CMAKE_INSTALL_PREFIX=/root/build/cache ..

# Build and install
make
make install
