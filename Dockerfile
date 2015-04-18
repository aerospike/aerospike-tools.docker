#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

ENV AEROSPIKE_VERSION 3.5.14
ENV AEROSPIKE_SHA256 df810e67d363291f6f40c046564bbc7ab775fcdb45ebfb878368361705063015

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
  && dpkg -i aerospike-tools-* \
  && rm -rf aerospike-tools.tgz /var/lib/apt/lists/*

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
