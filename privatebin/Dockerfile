FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV GID=991 UID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="tar openssl ca-certificates" \
 && apk -U add \
    $BUILD_DEPS \
    nginx \
    supervisor \
    tini@commuedge \
    php7-fpm@testing \
    php7-gd@testing \
    php7-mcrypt@testing \
    php7-json@testing \
    php7-zlib@testing \
 && mkdir zerobin && cd zerobin \
 && wget -qO- https://github.com/PrivateBin/PrivateBin/archive/master.tar.gz | tar xz --strip 1 \
 && mv cfg/conf.ini.sample cfg/conf.ini \
 && apk del $BUILD_DEPS \
 && rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /zerobin/data

EXPOSE 80

CMD ["/sbin/tini","--","run.sh"]
