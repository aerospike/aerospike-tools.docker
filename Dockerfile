#
# Aerospike Tools Dockerfile
#
# http://github.com/aerospike/aerospike-tools.docker
#

FROM ubuntu:14.04

# Add Aerospike package and run script
ADD http://aerospike.com/download/server/3.3.26/artifact/ubuntu12 /tmp/aerospike.tgz
# Work from /tmp
WORKDIR /tmp

# Install Aerospike
RUN \
  apt-get update -y \
  && ls -al /tmp/ \
  && tar xzf aerospike.tgz \
  && apt-get install python python-argparse -y \
  && cd aerospike-server-community-* \
  && sudo dpkg -i aerospike-tools-* \
  && sudo rm -rf /tmp/*

# Expose Aerospike ports
#
#   3000 – service port, for client connections
#   3001 – fabric port, for cluster communication
#   3002 – mesh port, for cluster heartbeat
#   3003 – info port
#
EXPOSE 3000 3001 3002 3003 8081

# Create a bash shell container to run tools
ENTRYPOINT ["/bin/bash"]
