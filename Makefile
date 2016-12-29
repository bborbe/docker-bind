VERSION ?= 1.0.0

default: build

clean:
	docker rmi bborbe/bind:$(VERSION)

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t bborbe/bind:$(VERSION) .

run:
	docker run \
	-p 53:53/tcp \
	-p 53:53/udp \
	-v example:/etc/bind \
	-v example:/var/lib/bind \
	bborbe/bind:$(VERSION)

shell:
	docker run -i -t bborbe/bind:$(VERSION) /bin/bash

upload:
	docker push bborbe/bind:$(VERSION)
