FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG VERSION=2.16.1

ENV GID=991 UID=991

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    supervisor \
    libwebp \
    git \
    autoconf \
    build-base \
    geoip \
    geoip-dev \
    tini@commuedge \
    php7-fpm@testing \
    php7-gd@testing \
    php7-curl@testing \
    php7-session@testing \
    php7-json@testing \
    php7-ctype@testing \
    php7-mbstring@testing \
    php7-iconv@testing \
    php7-zlib@testing \
    php7-dom@testing \
    php7-openssl@testing \
    php7-mysqli@testing \
    php7-pdo_mysql@testing \
    php7-dev@testing \
    php7-pear@testing \
 && cd /tmp && git clone https://github.com/Zakay/geoip && cd geoip \
 && phpize7 && ./configure --with-php-config=/usr/bin/php-config7 && make && make install \
 && echo 'extension=geoip.so' >> /etc/php7/conf.d/00_geoip.ini \
 && echo 'geoip.custom_directory=/piwik/misc' >> /etc/php7/php.ini \
 && apk del git autoconf build-base php7-dev php7-pear geoip-dev \
 && rm -rf /var/cache/apk/* /tmp/*

RUN wget -qO- http://builds.piwik.org/piwik-$VERSION.tar.gz | tar xz \
 && wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -P /piwik/misc \
 && gzip -d /piwik/misc/GeoLiteCity.dat.gz \
 && mv /piwik/misc/GeoLiteCity.dat /piwik/misc/GeoIPCity.dat

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /config
EXPOSE 80

LABEL description "Open web analytics platform" \
      piwik "Piwik v$VERSION"
      
CMD ["tini","--","run.sh"]

