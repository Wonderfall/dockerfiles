FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG VERSION=2.16.1

ARG GPG_matthieu="814E 346F A01A 20DB B04B  6807 B5DB D592 5590 A237"

ENV GID=991 UID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    git \
    tar \
    build-base \
    autoconf \
    geoip-dev \
    openssl \
    ca-certificates \
    gnupg" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    supervisor \
    libwebp \
    geoip \
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
 && mkdir /piwik && cd /tmp \
 && PIWIK_TARBALL="piwik-${VERSION}.tar.gz" \
 && wget -q https://builds.piwik.org/${PIWIK_TARBALL} \
 && wget -q https://builds.piwik.org/${PIWIK_TARBALL}.asc \
 && wget -q https://builds.piwik.org/signature.asc \
 && echo "Verifying authenticity of ${PIWIK_TARBALL}..." \
 && gpg --import signature.asc \
 && FINGERPRINT="$(LANG=C gpg --verify ${PIWIK_TARBALL}.asc ${PIWIK_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_matthieu}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${PIWIK_TARBALL}..." \
 && tar xzf ${PIWIK_TARBALL} --strip 1 -C /piwik \
 && wget -q https://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -P /piwik/misc \
 && gzip -d /piwik/misc/GeoLiteCity.dat.gz \
 && mv /piwik/misc/GeoLiteCity.dat /piwik/misc/GeoIPCity.dat \
 && cd /piwik/libs/MaxMindGeoIP && rm geoip.inc \
 && wget -q https://raw.githubusercontent.com/cerlestes/piwik/cerlestes-patch-1/libs/MaxMindGeoIP/geoip.inc \
 && chmod +x geoip.inc \
 && apk del ${BUILD_DEPS} php7-dev php7-pear \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /config
EXPOSE 80

LABEL description "Open web analytics platform" \
      piwik "Piwik v${VERSION}"
      
CMD ["/sbin/tini","--","run.sh"]
