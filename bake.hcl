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


#------------------------------------- jfrog -----------------------------------

# For jfrog builds load first and then push with jf docker push


group "push_jfrog" {
	targets=["aerospike_tools_jfrog"]
}

target "aerospike_tools_jfrog" {
	 tags=["artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools:11.0.2", "artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools:latest"]
	 platforms=["linux/amd64", "linux/arm64"]
	 context="."
}

group "test_jfrog" {
	targets=["aerospike_tools_amd64_jfrog", "aerospike_tools_arm64_jfrog"]
}

target "aerospike_tools_amd64_jfrog" {
	 tags=["artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools-amd64:11.0.2", "artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools-amd64:latest"]
	 platforms=["linux/amd64"]
	 context="."
}

target "aerospike_tools_arm64_jfrog" {
	 tags=["artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools-arm64:11.0.2", "artifact.aerospike.io/core-containers-dev-local/jfrog-test-aerospike-tools-arm64:latest"]
	 platforms=["linux/arm64"]
	 context="."
}


#------------------------------------- test -----------------------------------

group "test" {
	targets=["aerospike_tools_amd64", "aerospike_tools_arm64"]
}

target "aerospike_tools_amd64" {
	 tags=["aerospike/aerospike-tools-amd64:11.0.2", "aerospike/aerospike-tools-amd64:latest"]
	 platforms=["linux/amd64"]
	 context="."
}

target "aerospike_tools_arm64" {
	 tags=["aerospike/aerospike-tools-arm64:11.0.2", "aerospike/aerospike-tools-arm64:latest"]
	 platforms=["linux/arm64"]
	 context="."
}

#------------------------------------ push -----------------------------------

group "push" {
	targets=["aerospike_tools"]
}

target "aerospike_tools" {
	 tags=["aerospike/aerospike-tools:11.0.2", "aerospike/aerospike-tools:11.0.2_1", "aerospike/aerospike-tools:latest"]
	 platforms=["linux/amd64,linux/arm64"]
	 context="."
}
