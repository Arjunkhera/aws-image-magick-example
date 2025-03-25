#!/bin/bash

# First, run the extraction script if it hasn't been run
if [ ! -d "output" ]; then
  ./extract-binaries.sh
fi

# Create a tarball of the output directory
tar -czvf libheif-imagemagick-bin.tar.gz output

echo "Created libheif-imagemagick-bin.tar.gz for deployment on Linux systems"
echo "To use these binaries on a Linux system:"
echo "1. Extract the tarball: tar -xzvf libheif-imagemagick-bin.tar.gz"
echo "2. Run the conversion tool: ./output/bin/run-convert.sh [options]"
echo "3. Run the HEIF info tool: ./output/bin/run-heif-info.sh [options]" 