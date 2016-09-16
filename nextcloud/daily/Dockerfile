FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV UID=991 GID=991

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="tar" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    s6 \
    openssl \
    ca-certificates \
    libsmbclient \
    samba-client \
    su-exec \
    php7@commuedge \
    php7-fpm@commuedge \
    php7-intl@commuedge \
    php7-mbstring@commuedge \
    php7-curl@commuedge \
    php7-gd@commuedge \
    php7-mcrypt@commuedge \
    php7-opcache@commuedge \
    php7-json@commuedge \
    php7-session@commuedge \
    php7-pdo@commuedge \
    php7-dom@commuedge \
    php7-ctype@commuedge \
    php7-iconv@commuedge \
    php7-pdo_mysql@commuedge \
    php7-pdo_pgsql@commuedge \
    php7-pgsql@commuedge \
    php7-pdo_sqlite@commuedge \
    php7-sqlite3@commuedge \
    php7-zlib@commuedge \
    php7-zip@commuedge \
    php7-xmlreader@commuedge \
    php7-posix@commuedge \
    php7-openssl@commuedge \
    php7-ldap@commuedge \
    php7-ftp@commuedge \
    php7-apcu@testing \
    php7-redis@testing \
 && mkdir /nextcloud && cd /tmp \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2 \
 && tar xjf latest.tar.bz2 --strip 1 -C /nextcloud \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7/conf.d/apcu.ini
COPY run.sh /usr/local/bin/run.sh
COPY occ /usr/local/bin/occ
COPY cron /etc/periodic/15min/nextcloud
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/* /etc/periodic/15min/nextcloud /etc/s6.d/*/*

VOLUME /data /config /apps2

EXPOSE 8888

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily build"

CMD ["run.sh"]
