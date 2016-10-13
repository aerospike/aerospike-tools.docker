#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

ENV AEROSPIKE_VERSION 3.10.0
ENV AEROSPIKE_SHA256 44a9e736429eeb0f06867efb914898591e016004fa98ed9011d230d9c66ebdee 

# Work from /aerospike
WORKDIR /aerospike


ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  apt-get update -y \
  && apt-get install -y python wget logrotate ca-certificates python-dev python-setuptools  \
  && wget "https://www.aerospike.com/artifacts/aerospike-tools/${AEROSPIKE_VERSION}/aerospike-tools-${AEROSPIKE_VERSION}-debian7.tgz" -O aerospike-tools.tgz \
  && echo "$AEROSPIKE_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && apt-get purge -y --auto-remove wget ca-certificates \
  && easy_install pip \
  && pip install py-bcrypt


RUN ls /aerospike/aerospike && dpkg -i /aerospike/aerospike/aerospike-tools-*.debian7.x86_64.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
