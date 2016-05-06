FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV GID=1000 UID=1000

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    php7-fpm@testing \
    php7-curl@testing \
    php7-iconv@testing \
    php7-xml@testing \
    php7-dom@testing \
    php7-openssl@testing \
    php7-json@testing \
    php7-zlib@testing \
    php7-pdo_mysql@testing \
    php7-pdo_sqlite@testing \
    php7-sqlite3@testing \
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
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /rainloop/data
EXPOSE 80
LABEL description "Fast, simple and modern webmail client"
CMD ["tini","--","run.sh"]
