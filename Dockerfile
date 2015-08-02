#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

ENV AEROSPIKE_VERSION 3.5.15
ENV AEROSPIKE_SHA256 d6a9055b269959f257d7c51ef43c2e0960fb5518098714b871e77d9659ccb905

# Work from /aerospike
WORKDIR /aerospike

# Add Aerospike package and run script
ADD http://aerospike.com/download/server/${AEROSPIKE_VERSION}/artifact/debian7 /aerospike/aerospike-tools.tgz

ENV PATH /aerospike:$PATH

# Install Aerospike
RUN \
  apt-get update -y \
  && tar xzf aerospike-tools.tgz --strip-components=1 \
  && echo "$AEROSPIKE_SHA256 *aerospike-tools.tgz" | sha256sum -c - \
  && apt-get install python python-argparse -y \
  && aerospike-tools-deps/install.sh \
  && dpkg -i aerospike-tools-*.debian7.x86_64.deb \
  && rm -rf asinstall aerospike-tools.tgz aerospike-tools-deps *.deb /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
