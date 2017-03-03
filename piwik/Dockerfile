FROM alpine:edge

ARG VERSION=3.0.2
ARG GPG_matthieu="814E 346F A01A 20DB B04B  6807 B5DB D592 5590 A237"

ENV UID=991 GID=991

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    git \
    tar \
    build-base \
    autoconf \
    geoip-dev \
    libressl \
    ca-certificates \
    gnupg" \
 && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    nginx \
    s6 \
    su-exec \
    geoip \
    tzdata \
    php7.1-fpm@testing \
    php7.1-gd@testing \
    php7.1-curl@testing \
    php7.1-session@testing \
    php7.1-json@testing \
    php7.1-ctype@testing \
    php7.1-mbstring@testing \
    php7.1-iconv@testing \
    php7.1-zlib@testing \
    php7.1-dom@testing \
    php7.1-openssl@testing \
    php7.1-mysqli@testing \
    php7.1-pdo_mysql@testing \
    php7.1-dev@testing \
    php7.1-pear@testing \
 && sed -i "$ s|\-n||g" /usr/bin/pecl && pecl install geoip-1.1.1 \
 && echo 'extension=geoip.so' >> /etc/php7.1/conf.d/00_geoip.ini \
 && echo 'geoip.custom_directory=/piwik/misc' >> /etc/php7.1/php.ini \
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
 && apk del ${BUILD_DEPS} php7.1-dev php7.1-pear \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7.1/php-fpm.conf
COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /config

EXPOSE 8888

LABEL description "Open web analytics platform" \
      piwik "Piwik v${VERSION}" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
