## Aerospike Server Dockerfile

This repository contains the Dockerfile for building a Docker image for running [Aerospike](http://aerospike.com). 

## Dependencies

- [debian:11](https://registry.hub.docker.com/_/debian/)

## Installation

1. Install [Docker](https://www.docker.io/).

2. Download from public [Docker Registry](https://index.docker.io/):

		docker pull aerospike/aerospike-tools

	_Alternatively, you can build an image from Dockerfile:_
   
		docker build -t="aerospike/aerospike-tools" github.com/aerospike/aerospike-tools.docker
