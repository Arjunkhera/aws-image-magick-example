#!/bin/bash

# Exit on error
set -e

# Build the Docker image
echo "Building Docker image..."
docker build -t imagemagick-test .

# Run the container
echo "Running container to convert HEIC images..."
docker run --rm -v $(pwd)/output:/app/output imagemagick-test

echo "Conversion complete. Check the 'output' directory for converted JPEGs." 