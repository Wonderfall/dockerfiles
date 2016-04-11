FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV UID=991 GID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    php-fpm \
    php-exif \
    php-gd \
    php-json \
    php-mysqli \
    php-zip \
    tar \
    supervisor \
    ca-certificates \
    tini@commuedge \
 && sed -i -e "s/max_execution_time = 30/max_execution_time = 200/g" \
    -e "s/post_max_size = 8M/post_max_size = 100M/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" \
    -e "s/memory_limit = 256M/memory_limit = 512M/g" \
    /etc/php/php.ini \
 && mkdir /lychee && cd /lychee \
 && wget -qO- https://github.com/electerious/Lychee/archive/master.tar.gz | tar xz --strip 1 \
 && apk del \
    tar \
    ca-certificates \
 && rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /lychee/uploads /lychee/data
EXPOSE 80
CMD ["tini","--","run.sh"]
