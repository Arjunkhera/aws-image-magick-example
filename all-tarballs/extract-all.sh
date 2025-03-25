#!/bin/bash

# Extract all working tarballs
echo "Extracting imagemagick-libheif-centos7.tar.gz..."
tar -xzf imagemagick-libheif-centos7.tar.gz

echo "Extracting imagemagick-libheif-ubuntu.tar.gz..."
tar -xzf imagemagick-libheif-ubuntu.tar.gz

echo "Extracting libheif-imagemagick-bin.tar.gz..."
tar -xzf libheif-imagemagick-bin.tar.gz

echo "All tarballs extracted!"
echo "You can find the binaries in the output-* directories."
