#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:bullseye-20221114-slim 

ARG TARGETARCH
ARG TOOLS_VERSION=8.0.1
ARG TOOLS_ARTIFACT_URL_BASE="https://artifacts.aerospike.com/aerospike-tools/${TOOLS_VERSION}/aerospike-tools_${TOOLS_VERSION}_debian11"

# Work from /aerospike
WORKDIR /aerospike

ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  if [ "${TARGETARCH}" = "arm64" ]; then \
    export PKG_TARGETARCH="aarch64"; \
  elif [ "${TARGETARCH}" = "amd64" ]; then \
    export PKG_TARGETARCH="x86_64"; \
  else \
    exit 1; \
  fi; \
  apt-get update -y \
  && apt-get install -y python3-pip python3 python3-distutils python3-apt wget logrotate ca-certificates python3-dev python3-setuptools openssl python3-openssl libcurl4-openssl-dev\
  && wget "${TOOLS_ARTIFACT_URL_BASE}_${PKG_TARGETARCH}.tgz" -O aerospike-tools.tgz \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && TOOLS_SHA256=$(wget "${TOOLS_ARTIFACT_URL_BASE}_${PKG_TARGETARCH}.tgz.sha256" \
  && cat *aerospike-tools*.sha256 | cut -d' ' -f1) \
  && echo "$TOOLS_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && apt-get purge -y --auto-remove wget  


RUN ls /aerospike/aerospike && dpkg -i /aerospike/aerospike/aerospike-tools*.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
