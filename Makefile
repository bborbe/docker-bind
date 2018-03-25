REGISTRY ?= docker.io
IMAGE ?= bborbe/bind
ifeq ($(VERSION),)
	VERSION := $(shell git fetch --tags; git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

clean:
	docker rmi $(REGISTRY)/bborbe/bind:$(VERSION)

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t $(REGISTRY)/bborbe/bind:$(VERSION) .

run:
	docker run \
	-p 53:53/tcp \
	-p 53:53/udp \
	-v example:/etc/bind \
	-v example:/var/lib/bind \
	$(REGISTRY)/bborbe/bind:$(VERSION)

upload:
	docker push $(REGISTRY)/bborbe/bind:$(VERSION)
