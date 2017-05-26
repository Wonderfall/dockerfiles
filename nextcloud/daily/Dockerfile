FROM wonderfall/nginx-php:7.1

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=10G \
    APC_SHM_SIZE=128M \
    OPCACHE_MEM_SIZE=128 \
    MEMORY_LIMIT=512M \
    CRON_PERIOD=15m \
    CRON_MEMORY_LIMIT=1g \
    TZ=Etc/UTC \
    DB_TYPE=sqlite3 \
    DOMAIN=localhost

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    gnupg \
    tar \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    libtool \
    samba-dev \
 && apk add \
    libressl \
    ca-certificates \
    libsmbclient \
    tzdata \
 && pecl install \
    smbclient \
    apcu \
    redis \
 && echo "extension=smbclient.so" > /php/conf.d/smbclient.ini \
 && echo "extension=redis.so" > /php/conf.d/redis.ini \
 && mkdir /nextcloud \
 && cd /tmp \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2 \
 && echo "Verifying checksum of latest.tar.bz2..." \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2.sha512 \
 && echo "$(cat latest.tar.bz2.sha512 | awk '{print $1;}')  latest.tar.bz2" > latest.tar.bz2.sha512 \
 && CHECKSUM_STATE=$(echo -n $(sha512sum -c latest.tar.bz2.sha512) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && tar xjf latest.tar.bz2 --strip 1 -C /nextcloud \
 && update-ca-certificates \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY rootfs /

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /config /apps2 /nextcloud/themes /php/session

EXPOSE 8888

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
