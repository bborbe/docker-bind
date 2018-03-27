REGISTRY ?= docker.io
IMAGE ?= bborbe/bind
ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

clean:
	docker rmi $(REGISTRY)/$(IMAGE):$(VERSION)

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t $(REGISTRY)/$(IMAGE):$(VERSION) .

run:
	docker run \
	-p 53:53/tcp \
	-p 53:53/udp \
	-v example:/etc/bind \
	-v example:/var/lib/bind \
	$(REGISTRY)/$(IMAGE):$(VERSION)

upload:
	docker push $(REGISTRY)/$(IMAGE):$(VERSION)
