VERSION ?= latest
REGISTRY ?= docker.io

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
	bborbe/bind:$(VERSION)

shell:
	docker run -i -t $(REGISTRY)/bborbe/bind:$(VERSION) /bin/bash

upload:
	docker push $(REGISTRY)/bborbe/bind:$(VERSION)
