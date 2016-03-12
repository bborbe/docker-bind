default: build

build:
	docker build --rm=true -t bborbe/bind .

run:
	docker run -h example.com -p 53:53 -v /tmp:/bind  bborbe/bind:latest

bash:
	docker run -i -t bborbe/bind:latest /bin/bash

upload:
	docker push bborbe/bind