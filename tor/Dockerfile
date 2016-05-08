FROM alpine:3.3

ARG ARM_VERSION=1.4.5.0
ARG TOR_VERSION=0.2.7.6
ARG TOR_USER_ID=45553
ARG GPG_Mathewson="B35B F85B F194 89D0 4E28  C33C 2119 4EBB 1657 33EA"

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
 && FINGERPRINT="$(LANG=C gpg --verify tor-${TOR_VERSION}.tar.gz.asc tor-${TOR_VERSION}.tar.gz 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_Mathewson}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
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
