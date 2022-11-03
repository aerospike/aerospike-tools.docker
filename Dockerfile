#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:bullseye-slim 

ARG TARGETARCH
ARG TOOLS_VERSION=7.3.1
ARG TOOLS_ARTIFACT_URL="https://www.aerospike.com/artifacts/aerospike-tools/${TOOLS_VERSION}/aerospike-tools_${TOOLS_VERSION}_debian11_${TARGETARCH}.tgz"
ARG TOOLS_SHA_URL="${TOOLS_ARTIFACT_URL}.sha256"

# Work from /aerospike
WORKDIR /aerospike

ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  apt-get update -y \
  && apt-get install -y python3-pip python3 python3-distutils python3-apt wget logrotate ca-certificates python3-dev python3-setuptools openssl python3-openssl libcurl4-openssl-dev\
  && wget ${TOOLS_ARTIFACT_URL} -O aerospike-tools.tgz \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && TOOLS_SHA256=$(wget ${TOOLS_SHA_URL} && cat *aerospike-tools*.sha256 | cut -d' ' -f1) \
  && echo "$TOOLS_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && apt-get purge -y --auto-remove wget  


RUN ls /aerospike/aerospike && dpkg -i /aerospike/aerospike/aerospike-tools-*.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
