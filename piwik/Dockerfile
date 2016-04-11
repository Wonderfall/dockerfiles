FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV VER=2.16.0 GID=991 UID=991

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    nginx \
    php-fpm \
    php-gd \
    php-curl \
    php-cli \
    php-json \
    php-ctype \
    php-iconv \
    php-zlib \
    php-dom \
    php-openssl \
    php-geoip@testing \
    php-mysqli \
    php-pdo_mysql \
    supervisor \
    tini@commuedge \
 && sed -i 's/;always_populate_raw_post_data/always_populate_raw_post_data/g' /etc/php/php.ini \
 && echo 'geoip.custom_directory=/piwik/misc' >> /etc/php/php.ini \
 && rm -f /var/cache/apk/*

RUN wget -qO- http://builds.piwik.org/piwik-$VER.tar.gz | tar xz

RUN wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -P /piwik/misc \
 && gzip -d /piwik/misc/GeoLiteCity.dat.gz \
 && mv /piwik/misc/GeoLiteCity.dat /piwik/misc/GeoIPCity.dat

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /config
EXPOSE 80

LABEL description "Open web analytics platform" \
      piwik "Piwik v$VER"
      
CMD ["tini","--","run.sh"]
