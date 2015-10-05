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
