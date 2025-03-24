FROM amazonlinux:2

# Install the system prerequisites needed to build and install packages
RUN yum install -y \
    gcc gcc-c++ cpp cpio make automake autoconf perl \
    chkconfig clang clang-libs dos2unix zlib zlib-devel zip unzip tar \
    libxml2 bzip2 bzip2-libs xz xz-libs pkgconfig libtool openssl-devel curl gzip

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

ADD build /root/build

# Example: build libde265 first
RUN /root/build/build_libde265.sh

# Now that CMake >= 3.16.3 is installed, this should work
RUN /root/build/build_libheif.sh

# And so on...
RUN /root/build/build_imagemagick.sh
