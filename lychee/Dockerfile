FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG LYCHEE_VERSION=3.1.1
ARG IMAGICK_EXT_VERSION=3.4.2

ENV UID=991 GID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    imagemagick-dev \
    tar \
    openssl \
    ca-certificates \
    build-base \
    autoconf \
    libtool" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    libwebp \
    php7-mbstring@testing \
    php7-fpm@testing \
    php7-exif@testing \
    php7-gd@testing \
    php7-json@testing \
    php7-mysqli@testing \
    php7-zip@testing \
    php7-session@testing \
    php7-pear@testing \
    php7-dev@testing \
    supervisor \
    imagemagick \
    tini@commuedge \
 && sed -i -e "s/max_execution_time = 30/max_execution_time = 200/g" \
    -e "s/post_max_size = 8M/post_max_size = 100M/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" \
    -e "s/memory_limit = 256M/memory_limit = 512M/g" \
    /etc/php7/php.ini \
 && mkdir /lychee && cd /lychee \
 && wget -qO- https://github.com/electerious/Lychee/archive/v${LYCHEE_VERSION}.tar.gz | tar xz --strip 1 \
 && cd /tmp && wget -q https://pecl.php.net/get/imagick-${IMAGICK_EXT_VERSION}.tgz \
 && tar xzf imagick-${IMAGICK_EXT_VERSION}.tgz && cd imagick-${IMAGICK_EXT_VERSION} \
 && phpize7 && ./configure --with-php-config=/usr/bin/php-config7 && make && make install \
 && echo "extension=imagick.so" > /etc/php7/conf.d/00_imagick.ini \
 && apk del ${BUILD_DEPS} php7-pear php7-dev \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /lychee/uploads /lychee/data
EXPOSE 80
CMD ["/sbin/tini","--","run.sh"]
