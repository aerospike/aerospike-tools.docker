#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

ENV AEROSPIKE_VERSION 3.6.1
ENV AEROSPIKE_SHA256 28207fe6b79f42d2901657a4e05560198f452e2a1a91f018f9c564bf1f808e28

# Work from /aerospike
WORKDIR /aerospike


ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  apt-get update -y \
  && apt-get install -y python wget logrotate ca-certificates \
  && wget "https://www.aerospike.com/artifacts/aerospike-tools/${AEROSPIKE_VERSION}/aerospike-tools-${AEROSPIKE_VERSION}-debian7.tgz" -O aerospike-tools.tgz \
  && echo "$AEROSPIKE_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && apt-get purge -y --auto-remove wget ca-certificates
RUN dpkg -i /aerospike/aerospike-tools-3.6.1.debian7.x86_64.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*


# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
