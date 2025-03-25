ImageMagick with libheif Tarballs
=================================

This directory contains the following tarballs:

1. Successful builds:
   - imagemagick-libheif-centos7.tar.gz: CentOS 7 build with libheif
   - imagemagick-libheif-ubuntu.tar.gz: Ubuntu build with libheif
   - libheif-imagemagick-bin.tar.gz: Another previously built version
   - imagemagick-al2-libheif1.16.2.tar.gz: Amazon Linux 2 build with libheif 1.16.2 (FIXED)

2. Empty tarballs (builds failed):
   - imagemagick-centos7-libheif1.19.2.tar.gz: CentOS 7 with libheif 1.19.2 (build failed)
   - imagemagick-al2023-libheif1.19.2.tar.gz: Amazon Linux 2023 with libheif 1.19.2 (build failed)

The build scripts encountered errors during Docker image creation for some builds. The errors were:
- CentOS 7 build: Could not resolve CentOS mirrors
- AL2023 build: epel-release package not found in Amazon Linux 2023

To use the successful builds, extract the tarball and use the included run scripts.
