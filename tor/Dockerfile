FROM alpine:edge

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add tor@testing \
 && rm -f /var/cache/apk/*

EXPOSE 9001

VOLUME /tor
VOLUME /torconfig

RUN chown -R tor /etc/tor /tor /torconfig

USER tor

ENTRYPOINT [ "tor" ]
