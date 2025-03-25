#!/bin/bash

# Create directories for binaries and libraries
mkdir -p output/bin
mkdir -p output/lib64
mkdir -p output/lib

# Create a container and extract binaries and libraries
CONTAINER_ID=$(docker create aws-imagemagick-libheif)

# Extract ImageMagick binaries
docker cp $CONTAINER_ID:/usr/local/bin/convert output/bin/
docker cp $CONTAINER_ID:/usr/local/bin/magick output/bin/
docker cp $CONTAINER_ID:/usr/local/bin/heif-info output/bin/

# Extract libheif libraries (both locations for completeness)
docker cp $CONTAINER_ID:/usr/lib64/libheif.so output/lib64/
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1 output/lib64/
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1.19.7 output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so.1 output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so.1.19.7 output/lib64/

# Extract libaom libraries
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so.3 output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so.3.7.1 output/lib64/

# Extract libde265 libraries
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0.1.8 output/lib/

# Extract libx265 libraries
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so.199 output/lib/

# Extract ImageMagick libraries
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10.0.1 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10.0.1 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5.0.0 output/lib/

# Extract GCC 11.3.0 runtime libraries
docker cp $CONTAINER_ID:/usr/local/gcc-11.3.0/lib64/libstdc++.so.6 output/lib64/ || true
docker cp $CONTAINER_ID:/usr/local/gcc-11.3.0/lib64/libstdc++.so.6.0.29 output/lib64/ || true
docker cp $CONTAINER_ID:/usr/local/gcc-11.3.0/lib64/libgcc_s.so.1 output/lib64/ || true

# Extract other dependencies that might be needed
docker cp $CONTAINER_ID:/usr/lib64/libjpeg.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libpng.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libtiff.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libgomp.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libz.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/liblzma.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libm.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libpthread.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libjbig.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libwebp.so output/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libzstd.so output/lib64/ || true

# Copy any other essential libraries and configurations
docker cp $CONTAINER_ID:/usr/local/lib64/pkgconfig output/lib64/
docker cp $CONTAINER_ID:/usr/local/lib/pkgconfig output/lib/

# Create simple loader script
cat > output/bin/run-convert.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:${SCRIPT_DIR}/../lib64:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/magick" convert "$@"
EOF

cat > output/bin/run-heif-info.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:${SCRIPT_DIR}/../lib64:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/heif-info" "$@"
EOF

chmod +x output/bin/run-convert.sh output/bin/run-heif-info.sh
chmod +x output/bin/magick output/bin/heif-info

# Remove container
docker rm $CONTAINER_ID

echo "Binaries and libraries have been extracted to the 'output' directory"
echo "Use the scripts in output/bin/run-convert.sh and output/bin/run-heif-info.sh to run the tools" 