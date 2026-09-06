BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_REGISTRY ?= docker.io
IMAGE ?= bborbe/bind
ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

.PHONY: check-version-tag
check-version-tag:
	@if [ -n "$(ALLOW_UNTAGGED_BUILD)" ]; then \
		echo "ALLOW_UNTAGGED_BUILD set — skipping version/tag check"; \
	else \
		head_tag=$$(git describe --tags --exact-match HEAD 2>/dev/null); \
		if [ "$$head_tag" != "$(VERSION)" ]; then \
			echo "ERROR: refusing to build $(VERSION) from this tree." >&2; \
			echo "  HEAD is at tag: $${head_tag:-<untagged>}" >&2; \
			echo "  building as:    $(VERSION)" >&2; \
			echo "  An image stamped vX.Y.Z must be built from the vX.Y.Z tag." >&2; \
			echo "  Fix: git checkout $(VERSION)   (or set ALLOW_UNTAGGED_BUILD=1 for a scratch build)" >&2; \
			exit 1; \
		fi; \
	fi

.PHONY: build
build: check-version-tag
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
