#!/bin/bash

# Clean up previous build outputs
rm -rf output-al2023-libheif1.19.2
rm -f imagemagick-al2023-libheif1.19.2.tar.gz

echo "Building Docker image..."
docker build -t al2023-libheif1.19.2 -f Dockerfile.al2023-libheif1.19.2 .

# Create output directories
mkdir -p output-al2023-libheif1.19.2/bin
mkdir -p output-al2023-libheif1.19.2/lib
mkdir -p output-al2023-libheif1.19.2/lib64

# Create a container from the image
CONTAINER_ID=$(docker create al2023-libheif1.19.2)

# Extract the binaries and libraries
echo "Extracting binaries and libraries..."

# Extract ImageMagick binaries
docker cp $CONTAINER_ID:/usr/local/bin/convert output-al2023-libheif1.19.2/bin/
docker cp $CONTAINER_ID:/usr/local/bin/magick output-al2023-libheif1.19.2/bin/
docker cp $CONTAINER_ID:/usr/local/bin/heif-info output-al2023-libheif1.19.2/bin/

# Extract libheif libraries (both locations for completeness)
docker cp $CONTAINER_ID:/usr/lib64/libheif.so output-al2023-libheif1.19.2/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1 output-al2023-libheif1.19.2/lib64/ || true
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1.19.2 output-al2023-libheif1.19.2/lib64/ || true
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so.1 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libheif.so.1.19.2 output-al2023-libheif1.19.2/lib/

# Extract libaom libraries
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so.3 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libaom.so.3.7.1 output-al2023-libheif1.19.2/lib/

# Extract libde265 libraries 
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0.1.4 output-al2023-libheif1.19.2/lib/ || true

# Extract libx265 libraries
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so.199 output-al2023-libheif1.19.2/lib/

# Extract ImageMagick libraries
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10.0.1 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10.0.1 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5 output-al2023-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5.0.0 output-al2023-libheif1.19.2/lib/

# Extract system libraries (AL2023 uses different paths than AL2)
docker cp $CONTAINER_ID:/usr/lib64/libstdc++.so.6 output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libgcc_s.so.1 output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libjpeg.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libpng.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libtiff.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libgomp.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libz.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/liblzma.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/local/lib/libwebp.so output-al2023-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/local/lib/libzstd.so output-al2023-libheif1.19.2/lib/ || true

# Copy any other essential libraries and configurations
docker cp $CONTAINER_ID:/usr/local/lib/pkgconfig output-al2023-libheif1.19.2/lib/

# Create simple loader script
cat > output-al2023-libheif1.19.2/bin/run-convert.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/magick" convert "$@"
EOF

cat > output-al2023-libheif1.19.2/bin/run-heif-info.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/heif-info" "$@"
EOF

chmod +x output-al2023-libheif1.19.2/bin/run-convert.sh output-al2023-libheif1.19.2/bin/run-heif-info.sh
chmod +x output-al2023-libheif1.19.2/bin/magick output-al2023-libheif1.19.2/bin/heif-info 2>/dev/null || true

# Remove container
docker rm $CONTAINER_ID

# Create a tarball for distribution
tar -czf imagemagick-al2023-libheif1.19.2.tar.gz output-al2023-libheif1.19.2/

echo "Binaries and libraries have been extracted to the 'output-al2023-libheif1.19.2' directory"
echo "A tarball has been created as 'imagemagick-al2023-libheif1.19.2.tar.gz'"
echo "Use the scripts in output-al2023-libheif1.19.2/bin/run-convert.sh and output-al2023-libheif1.19.2/bin/run-heif-info.sh to run the tools" 