#!/bin/bash

# Clean up previous build outputs
rm -rf output-centos7-libheif1.19.2
rm -f imagemagick-centos7-libheif1.19.2.tar.gz

echo "Building Docker image..."
docker build -t centos7-libheif1.19.2 -f Dockerfile.centos7-libheif1.19.2 .

# Create output directories
mkdir -p output-centos7-libheif1.19.2/bin
mkdir -p output-centos7-libheif1.19.2/lib
mkdir -p output-centos7-libheif1.19.2/lib64

# Create a container from the image
CONTAINER_ID=$(docker create centos7-libheif1.19.2)

# Extract the binaries and libraries
echo "Extracting binaries and libraries..."

# Extract ImageMagick binaries
docker cp $CONTAINER_ID:/usr/local/bin/convert output-centos7-libheif1.19.2/bin/
docker cp $CONTAINER_ID:/usr/local/bin/magick output-centos7-libheif1.19.2/bin/
docker cp $CONTAINER_ID:/usr/local/bin/heif-info output-centos7-libheif1.19.2/bin/

# Extract libheif libraries (both locations for completeness)
docker cp $CONTAINER_ID:/usr/lib64/libheif.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1 output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libheif.so.1.19.2 output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so.1 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib64/libheif.so.1.19.2 output-centos7-libheif1.19.2/lib/

# Extract libaom libraries
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so.3 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib64/libaom.so.3.7.1 output-centos7-libheif1.19.2/lib/

# Extract libde265 libraries 
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libde265.so.0.1.4 output-centos7-libheif1.19.2/lib/ || true

# Extract libx265 libraries
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libx265.so.199 output-centos7-libheif1.19.2/lib/

# Extract ImageMagick libraries
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickCore-7.Q16HDRI.so.10.0.1 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagickWand-7.Q16HDRI.so.10.0.1 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5 output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/libMagick++-7.Q16HDRI.so.5.0.0 output-centos7-libheif1.19.2/lib/

# Extract devtoolset-11 runtime libraries
docker cp $CONTAINER_ID:/opt/rh/devtoolset-11/root/usr/lib64/libstdc++.so.6 output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/opt/rh/devtoolset-11/root/usr/lib64/libstdc++.so.6.0.29 output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/opt/rh/devtoolset-11/root/usr/lib64/libgcc_s.so.1 output-centos7-libheif1.19.2/lib/ || true

# Extract other dependencies that might be needed
docker cp $CONTAINER_ID:/usr/lib64/libjpeg.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libpng.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libtiff.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libgomp.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libz.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/liblzma.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libm.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libpthread.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/lib64/libjbig.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/local/lib/libwebp.so output-centos7-libheif1.19.2/lib/ || true
docker cp $CONTAINER_ID:/usr/local/lib/libzstd.so output-centos7-libheif1.19.2/lib/ || true

# Copy any other essential libraries and configurations
docker cp $CONTAINER_ID:/usr/local/lib64/pkgconfig output-centos7-libheif1.19.2/lib/
docker cp $CONTAINER_ID:/usr/local/lib/pkgconfig output-centos7-libheif1.19.2/lib/

# Create simple loader script
cat > output-centos7-libheif1.19.2/bin/run-convert.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/magick" convert "$@"
EOF

cat > output-centos7-libheif1.19.2/bin/run-heif-info.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="${SCRIPT_DIR}/../lib:$LD_LIBRARY_PATH"
"${SCRIPT_DIR}/heif-info" "$@"
EOF

chmod +x output-centos7-libheif1.19.2/bin/run-convert.sh output-centos7-libheif1.19.2/bin/run-heif-info.sh
chmod +x output-centos7-libheif1.19.2/bin/magick output-centos7-libheif1.19.2/bin/heif-info 2>/dev/null || true

# Remove container
docker rm $CONTAINER_ID

# Create a tarball for distribution
tar -czf imagemagick-centos7-libheif1.19.2.tar.gz output-centos7-libheif1.19.2/

echo "Binaries and libraries have been extracted to the 'output-centos7-libheif1.19.2' directory"
echo "A tarball has been created as 'imagemagick-centos7-libheif1.19.2.tar.gz'"
echo "Use the scripts in output-centos7-libheif1.19.2/bin/run-convert.sh and output-centos7-libheif1.19.2/bin/run-heif-info.sh to run the tools" 