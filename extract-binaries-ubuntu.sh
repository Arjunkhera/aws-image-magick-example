#!/bin/bash

# Create directories for binaries and libraries
mkdir -p output/bin
mkdir -p output/lib

# Build the Docker image if it doesn't exist
if ! docker images | grep -q ubuntu-imagemagick-libheif; then
  echo "Building Docker image..."
  docker build -t ubuntu-imagemagick-libheif -f Dockerfile.ubuntu .
fi

# Create a container and extract binaries and libraries
CONTAINER_ID=$(docker create ubuntu-imagemagick-libheif)

# Extract ImageMagick binaries
docker cp $CONTAINER_ID:/usr/local/bin/convert output/bin/
docker cp $CONTAINER_ID:/usr/local/bin/magick output/bin/
docker cp $CONTAINER_ID:/usr/local/bin/heif-info output/bin/

# Extract libheif libraries
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so.1 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so.1.18.0 output/lib/

# Extract libaom libraries
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so.3 output/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so.3.7.1 output/lib/

# Extract libde265 libraries 
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libde265.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libde265.so.0 output/lib/ || true

# Extract libx265 libraries
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libx265.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libx265.so.199 output/lib/ || true

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

# Extract key system libraries
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libstdc++.so.6 output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libgcc_s.so.1 output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libjpeg.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libpng.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libtiff.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libgomp.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libz.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/liblzma.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libwebp.so output/lib/ || true
docker cp $CONTAINER_ID:/usr/lib/aarch64-linux-gnu/libzstd.so output/lib/ || true

# Copy any other essential libraries and configurations
docker cp $CONTAINER_ID:/usr/local/lib/pkgconfig output/lib/

# Create simple loader script
cat > output/bin/run-convert.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/magick" convert "$@"
EOF

cat > output/bin/run-heif-info.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/heif-info" "$@"
EOF

chmod +x output/bin/run-convert.sh output/bin/run-heif-info.sh
chmod +x output/bin/magick output/bin/heif-info 2>/dev/null || true

# Remove container
docker rm $CONTAINER_ID

# Create a tarball for distribution
tar -czf imagemagick-libheif-ubuntu.tar.gz output/

echo "Binaries and libraries have been extracted to the 'output' directory"
echo "A tarball has been created as 'imagemagick-libheif-ubuntu.tar.gz'"
echo "Use the scripts in output/bin/run-convert.sh and output/bin/run-heif-info.sh to run the tools" 