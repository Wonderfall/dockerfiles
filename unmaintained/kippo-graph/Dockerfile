FROM alpine:edge

ENV GID=991 UID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="tar libressl ca-certificates" \
 && apk -U upgrade && apk add \
    $BUILD_DEPS \
    nginx \
    s6 \
    su-exec \
    coreutils \
    bind-tools \
    php7-fpm@testing \
    php7-mysqlnd@testing \
    php7-pdo@testing \
    php7-pdo_mysql@testing \
    php7-openssl@testing \
    php7-gd@testing \
    php7-curl@testing \
    php7-phar@testing \
    php7-dom@testing \
 && mkdir kippo-graph && cd kippo-graph \
 && wget -qO- https://github.com/ikoniaris/kippo-graph/archive/master.tar.gz | tar xz --strip 1 \
 && chmod 777 generated-graphs \
 && mv config.php.dist config.php \
 && rm /kippo-graph/include/maxmind/GeoLite2-City.mmdb /kippo-graph/include/maxmind/geoip2.phar \
 && wget -q https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz -P /kippo-graph/include/maxmind \
 && gzip -d /kippo-graph/include/maxmind/GeoLite2-City.mmdb.gz \
 && wget -q https://github.com/maxmind/GeoIP2-php/releases/download/v2.4.5/geoip2.phar -P /kippo-graph/include/maxmind \
 && apk del $BUILD_DEPS \
 && rm -f /var/cache/apk/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY run.sh /usr/local/bin/run.sh
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /kippo-graph/generated-graphs

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
