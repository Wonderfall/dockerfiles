FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV GID=991 UID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS="tar openssl ca-certificates" \
 && apk -U add \
    $BUILD_DEPS \
    nginx \
    s6 \
    su-exec \
    tini@commuedge \
    php7-fpm@commuedge \
    php7-gd@commuedge \
    php7-mcrypt@commuedge \
    php7-json@commuedge \
    php7-zlib@commuedge \
 && mkdir zerobin && cd zerobin \
 && wget -qO- https://github.com/PrivateBin/PrivateBin/archive/master.tar.gz | tar xz --strip 1 \
 && mv cfg/conf.ini.sample cfg/conf.ini \
 && apk del $BUILD_DEPS \
 && rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/*

VOLUME /zerobin/data

EXPOSE 8888

CMD ["run.sh"]
