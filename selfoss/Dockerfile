FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV GID=991 UID=991 VERSION=2.15

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    musl \
    nginx \
    php-fpm \
    php-gd \
    php-json \
    php-zlib \
    php-xml \
    php-dom \
    php-curl \
    php-iconv \
    php-mcrypt \
    php-pdo_sqlite \
    php-ctype \
    supervisor \
    ca-certificates \
    tini@commuedge \
 && rm -f /var/cache/apk/* \
 && sed -i -e 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/php.ini

RUN wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && rm -rf /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup
COPY cron /etc/periodic/15min/selfoss

RUN chmod +x /usr/local/bin/startup /etc/periodic/15min/selfoss

VOLUME /selfoss/data
EXPOSE 80
CMD ["tini","--","startup"]
