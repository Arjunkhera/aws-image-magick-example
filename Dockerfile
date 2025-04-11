FROM --platform=linux/amd64 amazonlinux:2

# Copy pre-compiled ImageMagick binaries directly to root
COPY imagemagick /imagemagick

# Create working directory
WORKDIR /app

# Copy the HEIC image from host
COPY images/ /app/images

# Create output directory
RUN mkdir -p /app/images/output

# Add ImageMagick to PATH
ENV PATH="/imagemagick/bin:${PATH}"
