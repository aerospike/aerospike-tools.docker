#!/bin/bash

# If not on docker desktop run the falling once to install platform emulators 
# using the following command:

# docker run --privileged --rm tonistiigi/binfmt --install all


# Run the following to setup a new builder:

# docker buildx create --name mybuilder --driver docker-container && docker buildx use mybuilder


TOOLS_VERSION=$(cat Dockerfile | grep TOOLS_VERSION= | cut -d'=' -f 2)
DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64,linux/arm64 -t aerospike/aerospike-tools:latest -t aerospike/aerospike-tools:$TOOLS_VERSION --push .