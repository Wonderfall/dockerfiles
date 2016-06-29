FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG NEXTCLOUD_VERSION=9.0.51
ARG GPG_nextcloud="2880 6A87 8AE4 23A2 8372  792E D758 99B9 A724 937A"

ENV GID=991 UID=991 HTTP_PORT=80

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS="gnupg tar ca-certificates" \
 && apk -U add \
    ${BUILD_DEPS} \
    nginx \
    supervisor \
    openssl \
    tini@commuedge \
    php7@testing \
    php7-fpm@testing \
    php7-intl@testing \
    php7-mbstring@testing \
    php7-curl@testing \
    php7-gd@testing \
    php7-mcrypt@testing \
    php7-opcache@testing \
    php7-json@testing \
    php7-session@testing \
    php7-pdo@testing \
    php7-dom@testing \
    php7-ctype@testing \
    php7-iconv@testing \
    php7-pdo_mysql@testing \
    php7-pgsql@testing \
    php7-zlib@testing \
    php7-zip@testing \
    php7-xmlreader@testing \
    php7-posix@testing \
    php7-openssl@testing \
    php7-apcu@testing \
 && mkdir /nextcloud && cd /tmp \
 && NEXTCLOUD_TARBALL="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL} \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.sha256 \
 && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.asc \
 && wget -q https://nextcloud.com/nextcloud.asc \
 && echo "Verifying both integrity and authenticity of ${NEXTCLOUD_TARBALL}..." \
 && CHECKSUM_STATE=$(echo -n $(sha256sum -c ${NEXTCLOUD_TARBALL}.sha256) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && gpg --import nextcloud.asc \
 && FINGERPRINT="$(LANG=C gpg --verify ${NEXTCLOUD_TARBALL}.asc ${NEXTCLOUD_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_nextcloud}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${NEXTCLOUD_TARBALL}..." \
 && tar xjf ${NEXTCLOUD_TARBALL} --strip 1 -C /nextcloud \
 && sed -i "s/;env\[PATH\]/env\[PATH\]/g" /etc/php7/php-fpm.d/www.conf \
 && rm /etc/php7/conf.d/apcu.ini \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg \
 && if [ -n ${HTTP_PORT} ]; then sed -i "s/listen 80;/listen ${HTTP_PORT};/g" /etc/nginx/nginx.conf; fi

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7/conf.d/00_apcu.ini
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY run.sh /usr/local/bin/run.sh
COPY cron /etc/periodic/15min/nextcloud

RUN chmod +x /usr/local/bin/run.sh /etc/periodic/15min/nextcloud

VOLUME /data /config /apps2

EXPOSE $HTTP_PORT

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud v${NEXTCLOUD_VERSION}"

CMD ["/sbin/tini","--","run.sh"]
