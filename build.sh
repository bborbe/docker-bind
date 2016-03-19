#!/bin/sh

set -e

docker build --rm=true -t bborbe/bind .
docker push bborbe/bind
docker rmi bborbe/bind
