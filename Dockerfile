#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM debian:7

# Work from /tmp
WORKDIR /aerospike

# Add Aerospike package and run script
ADD http://aerospike.com/download/server/3.5.8/artifact/debian7 /aerospike/aerospike-tools.tgz

ENV PATH /aerospike:$PATH

# Install Aerospike
RUN \
  apt-get update -y \
  && tar xzf aerospike-tools.tgz \
  && apt-get install python python-argparse -y \
  && cd aerospike-server-community-* \
  && dpkg -i aerospike-tools-* 

# Addition of wrapper script
ADD wrapper.sh /aerospike/wrapper

# Wrapper script entrypoint
ENTRYPOINT ["wrapper"]
