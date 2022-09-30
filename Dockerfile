#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:bullseye-slim 

ENV AEROSPIKE_VERSION 7.2.1
ENV AEROSPIKE_SHA256 b0f3f3414150295d9190c1894bd800cf0342e1d60b2acf85bdb7f2d769df9cb0

# Work from /aerospike
WORKDIR /aerospike

ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  apt-get update -y \
  && apt-get install -y python3-pip python3 python3-distutils python3-apt wget logrotate ca-certificates python3-dev python3-setuptools openssl python3-openssl libcurl4-openssl-dev\
  && wget "https://www.aerospike.com/artifacts/aerospike-tools/${AEROSPIKE_VERSION}/aerospike-tools-${AEROSPIKE_VERSION}-debian11.tgz" -O aerospike-tools.tgz \
  && echo "$AEROSPIKE_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && apt-get purge -y --auto-remove wget  


RUN ls /aerospike/aerospike && dpkg -i /aerospike/aerospike/aerospike-tools-*.debian11.x86_64.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
