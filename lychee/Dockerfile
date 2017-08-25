FROM alpine:edge

ARG LYCHEE_VERSION=3.1.6

ENV UID=991 GID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    imagemagick-dev \
    tar \
    libressl \
    ca-certificates \
    build-base \
    autoconf \
    pcre-dev \
    libtool" \
 && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    nginx \
    php7.1-mbstring@testing \
    php7.1-fpm@testing \
    php7.1-exif@testing \
    php7.1-gd@testing \
    php7.1-json@testing \
    php7.1-mysqli@testing \
    php7.1-zip@testing \
    php7.1-session@testing \
    php7.1-pear@testing \
    php7.1-dev@testing \
    s6 \
    su-exec \
    imagemagick \
 && pecl install imagick \
 && echo "extension=imagick.so" > /etc/php7.1/conf.d/imagick.ini \
 && sed -i -e "s/max_execution_time = 30/max_execution_time = 200/g" \
    -e "s/post_max_size = 8M/post_max_size = 100M/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" \
    -e "s/memory_limit = 256M/memory_limit = 512M/g" \
    /etc/php7.1/php.ini \
 && mkdir /lychee && cd /lychee \
 && wget -qO- https://github.com/electerious/Lychee/archive/v${LYCHEE_VERSION}.tar.gz | tar xz --strip 1 \
 && apk del ${BUILD_DEPS} php7.1-pear php7.1-dev \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7.1/php-fpm.conf
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /lychee/uploads /lychee/data

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
