## Aerospike Tools Dockerfile

This repository contains the Dockerfile for [Aerospike Tools](http://aerospike.com). 

### Dependencies

- [ubuntu:14.04](https://registry.hub.docker.com/_/ubuntu/)

### Installation

1. Install [Docker](https://www.docker.io/).

2. Build an image from Dockerfile:_
   
		docker build -t="aerospike/aerospike-tools" github.com/aerospike/aerospike-tools.docker

### Usage

The following will run `asd` with all the exposed ports forward to the host machine.

	docker run -ti --name aerospike-tools aerospike/aerospike-server
	




