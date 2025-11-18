BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_REGISTRY ?= docker.io
IMAGE ?= bborbe/bind
ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

.PHONY: build
build:
	DOCKER_BUILDKIT=1 \
	docker build \
	--no-cache \
	--rm=true \
	--platform=linux/amd64 \
	--build-arg BUILD_GIT_VERSION=$$(git describe --tags --always --dirty) \
	--build-arg BUILD_GIT_COMMIT=$$(git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$$(date -u +%Y-%m-%dT%H:%M:%SZ) \
	-t $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION) \
	-f Dockerfile .

.PHONY: upload
upload:
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)

.PHONY: clean
clean:
	docker rmi $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION) || true

.PHONY: run
run:
	docker run \
	-p 53:53/tcp \
	-p 53:53/udp \
	--mount type=bind,source=`pwd`/example,target=/etc/bind \
	--mount type=bind,source=`pwd`/example,target=/var/lib/bind \
	$(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)
