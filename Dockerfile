#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

ENV AEROSPIKE_VERSION 3.5.12
ENV AEROSPIKE_SHA256 ac82e7d021d0f3f3e1697f528fc76f79763d115458f4c84e8483b5081a15ee76 

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
