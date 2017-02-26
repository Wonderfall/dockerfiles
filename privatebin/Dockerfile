FROM alpine:edge

ENV GID=991 UID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="tar libressl ca-certificates" \
 && apk -U upgrade && apk add \
    $BUILD_DEPS \
    nginx \
    s6 \
    su-exec \
    php7.1-fpm@testing \
    php7.1-gd@testing \
    php7.1-mcrypt@testing \
    php7.1-json@testing \
    php7.1-zlib@testing \
 && mkdir zerobin && cd zerobin \
 && wget -qO- https://github.com/PrivateBin/PrivateBin/archive/master.tar.gz | tar xz --strip 1 \
 && mv cfg/conf.ini.sample cfg/conf.ini \
 && apk del $BUILD_DEPS \
 && rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7.1/php-fpm.conf
COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /zerobin/data

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
