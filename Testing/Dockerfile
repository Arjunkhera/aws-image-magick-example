FROM amazonlinux:2

# Enable developer toolset repo for newer GCC
RUN amazon-linux-extras enable topics-2

# Install the system prerequisites needed to build and install packages
# Make sure gzip is properly installed before other operations
RUN yum install -y gzip tar && \
    yum install -y \
    gcc gcc-c++ cpp cpio make automake autoconf perl \
    chkconfig clang clang-libs dos2unix zlib zlib-devel zip unzip \
    libxml2 bzip2 bzip2-libs xz xz-libs pkgconfig libtool openssl-devel curl \
    # Install GCC 10 for C++20 support
    && yum install -y gcc10 gcc10-c++

# Create build directory structure
RUN mkdir -p /root/build/cache/lib/pkgconfig /root/build/cache/include /root/result

# Remove any older cmake to avoid conflicts
RUN yum remove -y cmake || true

# Build and install a recent version of CMake (example: 3.22.0)
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz -o /tmp/cmake.tar.gz \
    && cd /tmp \
    && tar xzf cmake.tar.gz \
    && cd cmake-3.22.0 \
    && ./bootstrap --prefix=/usr/local \
    && make -j"$(nproc)" \
    && make install

# Confirm that "cmake" is the new version
RUN cmake --version

# Add build scripts
ADD build /root/build

# Example: build libde265 first
RUN /root/build/build_libde265.sh

# Build all the dependencies before libheif
# RUN /root/build/build_libbz2.sh
# RUN /root/build/build_libjpeg.sh
# RUN /root/build/build_libpng.sh
# RUN /root/build/build_libtiff.sh
# RUN /root/build/build_libwebp.sh
# RUN /root/build/build_libopenjp2.sh
# RUN /root/build/build_lcms.sh

# Now that CMake >= 3.16.3 is installed, build libheif with GCC 10
RUN /root/build/build_libheif.sh

# And ImageMagick after all dependencies are built
RUN /root/build/build_imagemagick.sh