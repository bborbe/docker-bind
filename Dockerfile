FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Docker Bind"
LABEL org.opencontainers.image.description="DNS server based on ISC Bind, packaged as a Docker image"
LABEL org.opencontainers.image.vendor="Benjamin Borbe"
LABEL org.opencontainers.image.licenses="BSD-2-Clause"
LABEL org.opencontainers.image.source="https://github.com/bborbe/docker-bind"
LABEL org.opencontainers.image.url="https://github.com/bborbe/docker-bind"
LABEL org.opencontainers.image.documentation="https://github.com/bborbe/docker-bind/blob/master/README.md"
LABEL org.opencontainers.image.authors="Benjamin Borbe"

ARG DOCKER_REGISTRY
ARG BRANCH
ARG BUILD_GIT_VERSION
ARG BUILD_GIT_COMMIT
ARG BUILD_DATE

ENV DOCKER_REGISTRY=${DOCKER_REGISTRY}
ENV BRANCH=${BRANCH}
ENV BUILD_GIT_VERSION=${BUILD_GIT_VERSION}
ENV BUILD_GIT_COMMIT=${BUILD_GIT_COMMIT}
ENV BUILD_DATE=${BUILD_DATE}

ENV HOME /root
ENV LANG en_US.UTF-8

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
	locales \
	apt-transport-https \
	ca-certificates \
	bind9 \
    dns-root-data \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean
RUN locale-gen en_US.UTF-8

RUN set -x \
	&& mkdir -p /var/run/named \
	&& chown -R bind:bind /var/run/named

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named","-u","bind","-g","-f"]
