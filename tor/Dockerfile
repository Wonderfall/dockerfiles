FROM alpine:3.3

ARG ARM_VERSION=1.4.5.0
ARG TOR_VERSION=0.2.7.6
ARG TOR_USER_ID=45553

ENV TERM=xterm

VOLUME /usr/local/etc/tor /tordata

RUN BUILD_DEPS=" \
    libevent-dev \
    openssl-dev \
    build-base \
    gnupg \
    ca-certificates" \
 && apk -U add \
    ${BUILD_DEPS} \
    python \
    libevent \
    openssl \
 && cd /tmp \
 && wget -q https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz \
 && wget -q https://www.torproject.org/dist/tor-${TOR_VERSION}.tar.gz.asc \
 && gpg --keyserver keys.gnupg.net --recv-keys 0x165733EA \
 && gpg --verify tor-0.2.7.6.tar.gz.asc \
 && tar xzf tor-${TOR_VERSION}.tar.gz \
 && cd tor-${TOR_VERSION} \
 && ./configure --disable-asciidoc \
 && make && make install \
 && adduser -h /var/run/tor -D -s /sbin/nologin -u ${TOR_USER_ID} tor \
 && cd /tmp \
 && wget -q https://www.atagar.com/arm/resources/static/arm-${ARM_VERSION}.tar.bz2  \
 && tar xjf /tmp/arm-${ARM_VERSION}.tar.bz2 && cd arm && ./install \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 9001 9030
USER tor
ENTRYPOINT [ "tor" ]
