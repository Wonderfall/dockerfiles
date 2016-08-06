FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG NEXTCLOUD_VERSION=10.0beta

ENV GID=991 UID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="tar" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    supervisor \
    openssl \
    ca-certificates \
    libsmbclient \
    tini@commuedge \
    php7@testing \
    php7-fpm@testing \
    php7-intl@testing \
    php7-mbstring@testing \
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
    php7-pdo_pgsql@testing \
    php7-pgsql@testing \
    php7-pdo_sqlite@testing \
    php7-sqlite3@testing \
    php7-zlib@testing \
    php7-zip@testing \
    php7-xmlreader@testing \
    php7-posix@testing \
    php7-openssl@testing \
    php7-ldap@testing \
    php7-ftp@testing \
    php7-apcu@testing \
    php7-redis@testing \
 && mkdir /nextcloud && cd /tmp \
 && wget -q https://download.nextcloud.com/server/prereleases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 \
 && tar xjf nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 --strip 1 -C /nextcloud \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7/conf.d/apcu.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY run.sh /usr/local/bin/run.sh
COPY cron /etc/periodic/15min/nextcloud

RUN chmod +x /usr/local/bin/run.sh /etc/periodic/15min/nextcloud

VOLUME /data /config /apps2

EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud ${NEXTCLOUD_VERSION}"

CMD ["/sbin/tini","--","run.sh"]
