# This file contains the targets for the test images.
#
# Build all test/push images:
#      docker buildx bake -f bake.hcl [test | push] --progressive plain [--load | --push]
#
# Build all test images:
#      docker buildx bake -f bake.hcl test --progressive plain --load
#
# Build all push images:
#      docker buildx bake -f bake.hcl push --progressive plain --push

#------------------------------------- test -----------------------------------

group "test" {
	targets=["aerospike_tools_amd64", "aerospike_tools_arm64"]
}

target "aerospike_tools_amd64" {
	 tags=["aerospike/aerospike-tools-amd64:8.5.1", "aerospike/aerospike-tools-amd64:latest"]
	 platforms=["linux/amd64"]
	 context="."
}

target "aerospike_tools_arm64" {
	 tags=["aerospike/aerospike-tools-arm64:8.5.1", "aerospike/aerospike-tools-arm64:latest"]
	 platforms=["linux/arm64"]
	 context="."
}

#------------------------------------ push -----------------------------------

group "push" {
	targets=["aerospike_tools"]
}

target "aerospike_tools" {
	 tags=["aerospike/aerospike-tools:8.5.1", "aerospike/aerospike-tools:8.5.1_5"]
	 platforms=["linux/amd64,linux/arm64"]
	 context="."
}
