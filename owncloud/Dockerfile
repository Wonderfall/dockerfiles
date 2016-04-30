FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG VERSION=9.0.1
ARG APCU=5.1.3
ARG APCUBC=1.0.3

ENV GID=991 UID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    build-base \
    autoconf \
    gnupg \
    tar" \
 && apk -U add \
    $BUILD_DEPS \
    nginx \
    supervisor \
    openssl \
    ca-certificates \
    libwebp \
    tini@commuedge \
    php7@testing \
    php7-fpm@testing \
    php7-intl@testing \
    php7-curl@testing \
    php7-gd@testing \
    php7-mcrypt@testing \
    php7-opcache@testing \
    php7-json@testing \
    php7-session@testing \
    php7-pdo@testing \
    php7-dom@testing \
    php7-ctype@testing \
    php7-iconv@testing \
    php7-pdo_mysql@testing \
    php7-zlib@testing \
    php7-zip@testing \
    php7-xmlreader@testing \
    php7-posix@testing \
    php7-openssl@testing \
    php7-dev@testing \
    php7-pear@testing \
 && mkdir /owncloud && cd /tmp \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.sha256 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.asc \
 && wget -q https://pecl.php.net/get/apcu-$APCU.tgz \
 && wget -q https://pecl.php.net/get/apcu_bc-$APCUBC.tgz \
 && wget -q https://owncloud.org/owncloud.asc \
 && sha256sum -c owncloud-$VERSION.tar.bz2.sha256 \
 && gpg --import owncloud.asc \
 && gpg --verify owncloud-$VERSION.tar.bz2.asc \
 && tar xjf /tmp/owncloud-$VERSION.tar.bz2 --strip 1 -C /owncloud \
 && tar xzf apcu-$APCU.tgz && tar xzf apcu_bc-$APCUBC.tgz \
 && cd apcu-$APCU && phpize7 && ./configure --with-php-config=/usr/bin/php-config7 && make && make install \
 && cd ../apcu_bc-$APCUBC && phpize7 && ./configure --with-php-config=/usr/bin/php-config7 && make && make install \
 && sed -i "s/;env\[PATH\]/env\[PATH\]/g" /etc/php7/php-fpm.d/www.conf \
 && apk del $BUILD_DEPS php7-dev php7-pear \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7/conf.d/00_apcu.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY run.sh /usr/local/bin/run.sh
COPY cron /etc/periodic/15min/owncloud

RUN chmod +x /usr/local/bin/run.sh /etc/periodic/15min/owncloud

VOLUME /data /config /apps2
EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      owncloud="ownCloud v$VERSION" \
      apcu="apcu v$APCU" \
      apcu_bc="apcu_bc v$APCUBC"

CMD ["tini","--","run.sh"]
