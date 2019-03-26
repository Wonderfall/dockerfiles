FROM hoellen/nginx-php:7.2

ARG VERSION=3.9.1
ARG GPG_matthieu="814E 346F A01A 20DB B04B  6807 B5DB D592 5590 A237"

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=10M \
    MEMORY_LIMIT=256M \
    OPCACHE_MEM_SIZE=128M \
    PHP_MAX_CHILDREN=15 \
    PHP_START_SERVERS=2 \
    PHP_MIN_SPARE_SERVERS=1 \
    PHP_MAX_SPARE_SERVERS=6

RUN BUILD_DEPS=" \
    tar \
    openssl \
    ca-certificates \
    gnupg" \
 && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    tzdata \
 && mkdir /matomo && cd /tmp \
 && MATOMO_TARBALL="matomo-${VERSION}.tar.gz" \
 && wget -q https://builds.matomo.org/${MATOMO_TARBALL} \
 && wget -q https://builds.matomo.org/${MATOMO_TARBALL}.asc \
 && wget -q https://builds.matomo.org/signature.asc \
 && echo "Verifying authenticity of ${MATOMO_TARBALL}..." \
 && gpg --import signature.asc \
 && FINGERPRINT="$(LANG=C gpg --verify ${MATOMO_TARBALL}.asc ${MATOMO_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_matthieu}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${MATOMO_TARBALL}..." \
 && tar xzf ${MATOMO_TARBALL} --strip 1 -C /matomo \
 && cd /matomo/misc && wget -qO- https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz | tar xz --strip 1 \
 && apk del ${BUILD_DEPS} php7-dev php7-pear \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg

COPY rootfs /

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /config

EXPOSE 8888

LABEL description "Open web analytics platform" \
      matomo "Matomo v${VERSION}" \
      maintainer="hoellen <info@hoellen.eu>"

CMD ["run.sh"]
