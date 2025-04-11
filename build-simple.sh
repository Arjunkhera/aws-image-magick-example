#!/bin/bash

# Exit on error
set -e

# Step 1: Create an Installation Folder
mkdir -p imagemagick
cd imagemagick

# Step 2: Run an Amazon Linux 2 Docker Container with volume mount
docker run \
  --rm -it \
  --platform linux/amd64 \
  -v $(pwd):/root/result \
  amazonlinux:2 \
  /bin/bash -c '
    # Step 3: Install OS Packages
    yum update -y
    yum install -y git gcc gcc-c++ cpp cpio make cmake3 automake autoconf chkconfig clang clang-libs dos2unix zlib zlib-devel zip unzip tar perl libxml2 bzip2 bzip2-libs xz xz-libs pkgconfig libtool

    # Step 4: Install ImageMagick Dependencies (minimal set for HEIC support)
    # Install libde265 (HEIC support 1 of 2)
    cd /root
    curl https://github.com/strukturag/libde265/releases/download/v1.0.8/libde265-1.0.8.tar.gz -L -o tmp-libde265
    tar xf tmp-libde265
    cd libde265*

    sh autogen.sh

    PKG_CONFIG_PATH=/root/build/cache/lib/pkgconfig \
      ./configure \
        CPPFLAGS=-I/root/build/cache/include \
        LDFLAGS=-L/root/build/cache/lib \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --prefix=/root/build/cache

    make
    make install

    # Install libheif (HEIC support 2 of 2)
    cd /root
    curl https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz -L -o tmp-libheif.tar.gz
    tar xf tmp-libheif.tar.gz
    cd libheif*

    sh autogen.sh

    PKG_CONFIG_PATH=/root/build/cache/lib/pkgconfig \
      ./configure \
        CPPFLAGS=-I/root/build/cache/include \
        LDFLAGS=-L/root/build/cache/lib \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --prefix=/root/build/cache

    make
    make install

    # Step 5: Build ImageMagick
    cd /root
    curl https://github.com/ImageMagick/ImageMagick/archive/7.0.8-45.tar.gz -L -o tmp-imagemagick.tar.gz
    tar xf tmp-imagemagick.tar.gz
    cd ImageMagick*

    PKG_CONFIG_PATH=/root/build/cache/lib/pkgconfig \
      ./configure \
        CPPFLAGS=-I/root/build/cache/include \
        LDFLAGS="-L/root/build/cache/lib -lstdc++" \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --prefix=/root/result \
        --enable-delegate-build \
        --disable-installed \
        --without-modules \
        --disable-docs \
        --without-magick-plus-plus \
        --without-perl \
        --without-x \
        --disable-openmp

    make clean
    make all
    make install
    
    echo "ImageMagick installation complete!"
    exit
  '

# Return to original directory
cd ..

echo "Done! The ImageMagick binaries are now in the 'imagemagick' directory."
echo "Try running: ./imagemagick/bin/magick -version"
echo
echo "To test HEIC conversion, you can use:"
echo "./imagemagick/bin/magick convert image.HEIC output.jpg" 