FROM ubuntu:18.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ARG VERSION

ENV HOME /root
ENV LANG en_US.UTF-8

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
	locales \
	apt-transport-https \
	ca-certificates \
	bind9 \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean
RUN locale-gen en_US.UTF-8

RUN set -x \
	&& mkdir -p /var/run/named \
	&& chown -R bind:bind /var/run/named

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named","-u","bind","-g","-f"]
