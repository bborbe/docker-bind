default: build

clean:
	docker rmi bborbe/bind

build:
	docker build --no-cache --rm=true -t bborbe/bind .

run:
	docker run \
	-p 53:53/tcp \
	-p 53:53/udp \
	-v example:/etc/bind \
	-v example:/var/lib/bind \
	bborbe/bind:latest

shell:
	docker run -i -t bborbe/bind:latest /bin/bash

upload:
	docker push bborbe/bind
