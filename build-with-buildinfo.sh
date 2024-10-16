#!/bin/bash

# Enable strict mode for better error handling
set -euo pipefail

# Enable debug mode if DEBUG environment variable is set
if [[ "${DEBUG:-}" == "true" ]]; then
    set -x
fi

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <build-name> <build-number>"
    exit 1
fi

# Assign arguments to variables
BUILD_NAME="$1"
BUILD_NUMBER="$2"

# Step 1: Build and push Docker images using Docker buildx bake
docker buildx bake -f bake.hcl push_jfrog --no-cache --push --metadata-file=build-metadata

# Step 2: Extract the first image name and SHA digest
META_INFO=$(jq -r '.[] | {digest: .["containerimage.digest"], names: .["image.name"] | split(",")} | "\(.names[0])@\(.digest)"' build-metadata)

# Check if the SHA digest and image name were found
if [ -z "$META_INFO" ]; then
    echo "Failed to extract SHA digest and image name from build-metadata."
    exit 1
fi

# Prepare the meta file for jfrog
echo "$META_INFO" > meta-file

# Step 3: Use jf rt build-docker-create to create Docker build information
jf rt build-docker-create --build-name "$BUILD_NAME" --build-number "$BUILD_NUMBER" core-containers-dev-local --image-file ./meta-file

# Step 4: Publish the build information to JFrog Artifactory
jf rt build-publish "$BUILD_NAME" "$BUILD_NUMBER"


echo "Docker build information created and published successfully."
