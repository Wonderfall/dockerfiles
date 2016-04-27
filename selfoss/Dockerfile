FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV GID=991 UID=991 VERSION=2.15

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && apk -U add \
    musl \
    nginx \
    libwebp@edge \
    php7-fpm@testing \
    php7-gd@testing \
    php7-json@testing \
    php7-zlib@testing \
    php7-xml@testing \
    php7-dom@testing \
    php7-curl@testing \
    php7-iconv@testing \
    php7-mcrypt@testing \
    php7-pdo_sqlite@testing \
    php7-ctype@testing \
    supervisor \
    ca-certificates \
    tini@commuedge \
 && rm -f /var/cache/apk/* \
 && sed -i -e 's/max_execution_time = 30/max_execution_time = 300/' /etc/php7/php.ini

RUN wget -q https://github.com/SSilence/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d /selfoss \
 && sed -i -e 's/base_url=/base_url=\//g' /selfoss/defaults.ini \
 && rm -rf /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup /usr/local/bin/startup
COPY cron /etc/periodic/15min/selfoss

RUN chmod +x /usr/local/bin/startup /etc/periodic/15min/selfoss

VOLUME /selfoss/data
EXPOSE 80
CMD ["tini","--","startup"]
