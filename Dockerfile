FROM ubuntu:14.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ENV HOME /root
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN apt-get update; \
apt-get install bind9 -yq; \
apt-get clean
RUN cd /etc; rm -rf bind; ln -s ../var/lib/bind bind
RUN mkdir -p /var/log/named
RUN chown bind:bind /var/log/named
VOLUME ["/var/lib/bind"]
EXPOSE 53/udp 53/tcp
USER bind
CMD ["/usr/sbin/named","-f"]