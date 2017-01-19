FROM alpine:edge

ARG LYCHEE_VERSION=3.1.5
ARG IMAGICK_EXT_VERSION=3.4.2

ENV UID=991 GID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    imagemagick-dev \
    tar \
    libressl \
    ca-certificates \
    build-base \
    autoconf \
    libtool" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    php7-mbstring@commuedge \
    php7-fpm@commuedge \
    php7-exif@commuedge \
    php7-gd@commuedge \
    php7-json@commuedge \
    php7-mysqli@commuedge \
    php7-zip@commuedge \
    php7-session@commuedge \
    php7-pear@commuedge \
    php7-dev@commuedge \
    s6 \
    su-exec \
    imagemagick \
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
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /lychee/uploads /lychee/data

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
