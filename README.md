# ImageMagick with libheif Support

This project provides Docker images and extractable binaries for ImageMagick 7.1.1-31 compiled with libheif support for processing HEIC/HEIF images on Linux systems.

## Available Builds

Three different builds are provided to support various use cases and environments:

### 1. Amazon Linux 2 with libheif 1.16.2
- Uses the standard GCC from Amazon Linux 2
- Most stable configuration for compatibility with older systems
- No C++20 features required
- Best for backward compatibility with older systems

### 2. CentOS 7 with libheif 1.19.2
- Uses devtoolset-11 for C++20 support
- Compatible with Amazon Linux 2 and other RHEL 7-based systems
- More advanced features from newer libheif
- Good middle ground for compatibility and features

### 3. Amazon Linux 2023 with libheif 1.19.2
- Uses the native GCC in AL2023 with C++20 support
- Most modern platform with best performance
- Latest libheif features
- Best for newer deployments on AL2023

## Features

All builds include:
- ImageMagick 7.1.1-31 with HEIC/HEIF support
- libde265, x265, and libaom for HEVC and AV1 support
- Various dependencies including libwebp, zstd, etc.

## Docker Usage

### Building the Docker Images

```bash
# For Amazon Linux 2 with libheif 1.16.2
docker build -t al2-libheif1.16.2 -f Dockerfile.al2-libheif1.16.2 .

# For CentOS 7 with libheif 1.19.2
docker build -t centos7-libheif1.19.2 -f Dockerfile.centos7-libheif1.19.2 .

# For Amazon Linux 2023 with libheif 1.19.2
docker build -t al2023-libheif1.19.2 -f Dockerfile.al2023-libheif1.19.2 .
```

### Running ImageMagick with Docker

```bash
# Check ImageMagick version
docker run --rm al2-libheif1.16.2 convert -version

# Process a HEIC image
docker run --rm -v $(pwd):/app al2023-libheif1.19.2 convert input.heic output.jpg

# View HEIF image info
docker run --rm -v $(pwd):/app centos7-libheif1.19.2 heif-info input.heic
```

## Extracting Binaries for Linux Systems

To extract the binaries and libraries for use on another Linux system, use the corresponding extraction script:

```bash
# For Amazon Linux 2 with libheif 1.16.2
./extract-al2-libheif1.16.2.sh

# For CentOS 7 with libheif 1.19.2
./extract-centos7-libheif1.19.2.sh 

# For Amazon Linux 2023 with libheif 1.19.2
./extract-al2023-libheif1.19.2.sh
```

### Using the Extracted Binaries

On your target Linux system:

1. Extract the tarball:
```bash
# Example for AL2 with libheif 1.16.2
tar -xzvf imagemagick-al2-libheif1.16.2.tar.gz
```

2. Run the ImageMagick conversion tool:
```bash
./output-al2-libheif1.16.2/bin/run-convert.sh input.heic output.jpg
```

3. View HEIF image info:
```bash
./output-al2-libheif1.16.2/bin/run-heif-info.sh input.heic
```

## Compatibility Notes

- The Amazon Linux 2 build with libheif 1.16.2 should have the widest compatibility with older Linux systems.
- The CentOS 7 build with libheif 1.19.2 offers newer features while maintaining compatibility with RHEL 7-based systems, including Amazon Linux 2.
- The Amazon Linux 2023 build with libheif 1.19.2 is optimized for newer systems but may have compatibility issues with older glibc versions.

When in doubt, test each version to see which one works best with your target environment.

## Working on ARM-based Macs and x86 Systems

All Dockerfiles can be used on both ARM-based Macs and x86 systems since Docker will build for the appropriate architecture. The resulting binaries, however, will only work on Linux systems with the same architecture as the build system.

- If building on an ARM Mac, the binaries will work on ARM-based Linux systems
- If building on an x86 system, the binaries will work on x86-based Linux systems

To create x86 binaries on an ARM Mac, you can use Docker's multi-platform build feature:

```bash
docker buildx build --platform linux/amd64 -t al2-libheif1.16.2-amd64 -f Dockerfile.al2-libheif1.16.2 .
```

## Dependencies

The Docker images include these key components:
- libwebp 1.3.2
- zstd 1.5.5
- libde265 (latest from git)
- x265 3.5
- libaom 3.7.1
- libheif (1.16.2 or 1.19.2 depending on the build)
- ImageMagick 7.1.1-31
