FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV GID=1000 UID=1000

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    php-fpm \
    php-curl \
    php-iconv \
    php-xml \
    php-dom \
    php-openssl \
    php-json \
    php-zlib \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-sqlite3 \
    supervisor \
    gnupg \
    tini@commuedge \
 && wget -q http://repository.rainloop.net/v2/webmail/rainloop-community-latest.zip -P /tmp \
 && wget -q http://repository.rainloop.net/v2/webmail/rainloop-community-latest.zip.asc -P /tmp \
 && wget -q http://repository.rainloop.net/RainLoop.asc -P /tmp \
 && gpg --import /tmp/RainLoop.asc \
 && gpg --verify /tmp/rainloop-community-latest.zip.asc \
 && mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
 && find /rainloop -type d -exec chmod 755 {} \; \
 && find /rainloop -type f -exec chmod 644 {} \; \
 && apk del gnupg \
 && rm -rf /tmp/* /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /rainloop/data
EXPOSE 80
LABEL description "Fast, simple and modern webmail client"
CMD ["tini","--","run.sh"]
