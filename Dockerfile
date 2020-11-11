#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM openjdk:11-jre-slim 

ENV AEROSPIKE_VERSION 4.0.2
ENV AEROSPIKE_SHA256 a89962fccff37f0e458a173e8c3789174aba9f5ac2b174b43bd9409974efb764

# Work from /aerospike
WORKDIR /aerospike

ENV PATH /aerospike:$PATH

# Install Aerospike

RUN \
  apt-get update -y \
  && apt-get install -y python wget logrotate ca-certificates python-dev python-setuptools python-argparse python-bcrypt openssl python-openssl  \
  && wget "https://www.aerospike.com/artifacts/aerospike-tools/${AEROSPIKE_VERSION}/aerospike-tools-${AEROSPIKE_VERSION}-debian10.tgz" -O aerospike-tools.tgz \
  && echo "$AEROSPIKE_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && mkdir aerospike \
  && tar xzf aerospike-tools.tgz --strip-components=1 -C aerospike \
  && apt-get purge -y --auto-remove wget ca-certificates 


RUN ls /aerospike/aerospike && dpkg -i /aerospike/aerospike/aerospike-tools-*.debian10.x86_64.deb \
  && rm -rf aerospike-tools.tgz aerospike /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
