FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG VERSION=9.0.1
ENV GID=991 UID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    supervisor \
    gnupg \
    tar \
    openssl \
    ca-certificates \
    tini@commuedge \
    libwebp@edge \
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
 && mkdir /owncloud && cd /tmp \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.sha256 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.asc \
 && wget -q https://owncloud.org/owncloud.asc \
 && sha256sum -c owncloud-$VERSION.tar.bz2.sha256 \
 && gpg --import owncloud.asc \
 && gpg --verify owncloud-$VERSION.tar.bz2.asc \
 && tar xjf /tmp/owncloud-$VERSION.tar.bz2 --strip 1 -C /owncloud \
 && sed -i "s/;env\[PATH\]/env\[PATH\]/g" /etc/php7/php-fpm.d/www.conf \
 && apk del tar ca-certificates gnupg \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY run.sh /usr/local/bin/run.sh
COPY cron /etc/periodic/15min/owncloud

RUN chmod +x /usr/local/bin/run.sh /etc/periodic/15min/owncloud

VOLUME /data /config /apps2
EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      owncloud="ownCloud v$VERSION"

CMD ["tini","--","run.sh"]
