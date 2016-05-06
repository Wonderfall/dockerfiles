FROM alpine:edge

VOLUME /tor
VOLUME /torconfig

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add tor@testing \
 && rm -f /var/cache/apk/* \
 && chown -R tor /etc/tor /tor /torconfig

EXPOSE 9001 9030
USER tor
ENTRYPOINT [ "tor" ]
