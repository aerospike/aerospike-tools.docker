#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#
FROM debian:bookworm-slim as build

ARG TARGETARCH

RUN \
  apt-get update -y \
  && apt-get install -y \
  wget

ARG TOOLS_VERSION=11.0.0
ARG TOOLS_ARTIFACT_URL_BASE="https://artifacts.aerospike.com/aerospike-tools/${TOOLS_VERSION}/aerospike-tools_${TOOLS_VERSION}_debian12"

RUN \
  if [ "${TARGETARCH}" = "arm64" ]; then \
    export PKG_TARGETARCH="aarch64"; \
  elif [ "${TARGETARCH}" = "amd64" ]; then \
    export PKG_TARGETARCH="x86_64"; \
  else \
    exit 1; \
  fi; \
  wget "${TOOLS_ARTIFACT_URL_BASE}_${PKG_TARGETARCH}.tgz" -O aerospike-tools.tgz \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && TOOLS_SHA256=$(wget "${TOOLS_ARTIFACT_URL_BASE}_${PKG_TARGETARCH}.tgz.sha256" \
  && cat *aerospike-tools*.sha256 | cut -d' ' -f1) \
  && echo "$TOOLS_SHA256 *aerospike-tools.tgz" | sha256sum -c -

FROM debian:bookworm-slim as install

# Work from /aerospike
WORKDIR /aerospike
ENV PATH /aerospike:$PATH

# Install Aerospike tools

COPY --from=build aerospike/aerospike-tools*.deb /aerospike/aerospike/

RUN apt update && apt install -y libreadline8 python3 && ls /aerospike && dpkg -i /aerospike/aerospike/aerospike-tools*.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
