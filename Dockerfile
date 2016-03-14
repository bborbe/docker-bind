FROM ubuntu:14.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ENV HOME /root
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends bind9 \
    && apt-get clean

RUN set -x \
	&& mkdir -p /var/run/named \
	&& chown -R bind:bind /var/run/named

EXPOSE 53/udp 53/tcp

CMD ["/usr/sbin/named","-u","bind","-g","-f"]