FROM alpine:edge

ARG ARM_VERSION=1.4.5.0
ENV TERM=xterm

VOLUME /tor /torconfig

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add tor@testing python openssl ca-certificates \
 && wget -q https://www.atagar.com/arm/resources/static/arm-${ARM_VERSION}.tar.bz2 -P /tmp \
 && tar xjf /tmp/arm-${ARM_VERSION}.tar.bz2 -C /tmp && cd /tmp/arm && ./install \
 && rm -rf /var/cache/apk/* /tmp/* \
 && chown -R tor /etc/tor /tor /torconfig

EXPOSE 9001 9030
USER tor
ENTRYPOINT [ "tor" ]
