FROM alpine:edge

ENV UID=991 GID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add pgbouncer@testing tini su-exec \
 && rm -rf /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /config

CMD ["/sbin/tini","--","run.sh"]
