#!/usr/bin/env bash
set -e

cd /root
curl https://github.com/mm2/Little-CMS/releases/download/lcms2.17/lcms2-2.17.tar.gz -L -o tmp-lcms2.tar.gz
tar xf tmp-lcms2.tar.gz
cd lcms2*

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