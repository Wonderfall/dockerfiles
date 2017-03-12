FROM alpine:edge

ARG GNU_LIBICONV_VERSION=1.15

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=10G \
    APC_SHM_SIZE=128M \
    OPCACHE_MEM_SIZE=128 \
    CRON_PERIOD=15m \
    CRON_MEMORY_LIMIT=1g \
    TZ=Etc/UTC \
    DB_TYPE=sqlite3 \
    DOMAIN=localhost

RUN echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    gnupg \
    tar \
    build-base \
    autoconf \
    automake \
    pcre-dev \
    libtool \
    samba-dev" \
 && apk -U upgrade && apk add \
    ${BUILD_DEPS} \
    nginx \
    s6 \
    libressl \
    ca-certificates \
    libsmbclient \
    samba-client \
    su-exec \
    tzdata \
    php7.1@testing \
    php7.1-fpm@testing \
    php7.1-intl@testing \
    php7.1-mbstring@testing \
    php7.1-curl@testing \
    php7.1-gd@testing \
    php7.1-fileinfo@testing \
    php7.1-mcrypt@testing \
    php7.1-opcache@testing \
    php7.1-json@testing \
    php7.1-session@testing \
    php7.1-pdo@testing \
    php7.1-dom@testing \
    php7.1-ctype@testing \
    php7.1-pdo_mysql@testing \
    php7.1-pdo_pgsql@testing \
    php7.1-pgsql@testing \
    php7.1-pdo_sqlite@testing \
    php7.1-sqlite3@testing \
    php7.1-zlib@testing \
    php7.1-zip@testing \
    php7.1-xmlreader@testing \
    php7.1-xml@testing \
    php7.1-xmlwriter@testing \
    php7.1-posix@testing \
    php7.1-openssl@testing \
    php7.1-ldap@testing \
    php7.1-imap@testing \
    php7.1-ftp@testing \
    php7.1-pcntl@testing \
    php7.1-exif@testing \
    php7.1-pear@testing \
    php7.1-dev@testing \
 && pecl install smbclient apcu redis \
 && cd /tmp && wget -q http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${GNU_LIBICONV_VERSION}.tar.gz \
 && tar xzf libiconv-${GNU_LIBICONV_VERSION}.tar.gz && cd libiconv-${GNU_LIBICONV_VERSION} \
 && ./configure --prefix=/usr/local \
 && make && make install && libtool --finish /usr/local/lib && cd /tmp \
 && wget -q http://is1.php.net/get/php-7.1.2.tar.gz/from/this/mirror -O php7.1.tar.gz \
 && tar xzf php7.1.tar.gz && cd /tmp/php-7.1.2/ext/iconv && phpize7.1 \
 && ./configure --with-iconv=/usr/local --with-php-config=/usr/bin/php-config7.1 \
 && make && cp modules/iconv.so /usr/lib/php7.1 && cd /tmp \
 && echo "extension=iconv.so" > /etc/php7.1/conf.d/00_iconv.ini \
 && echo "extension=smbclient.so" > /etc/php7.1/conf.d/00_smbclient.ini \
 && echo "extension=redis.so" > /etc/php7.1/conf.d/redis.ini \
 && sed -i 's|;session.save_path = "/tmp"|session.save_path = "/data/session"|g' /etc/php7.1/php.ini \
 && mkdir /nextcloud \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2 \
 && echo "Verifying checksum of latest.tar.bz2..." \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2.sha512 \
 && echo "$(cat latest.tar.bz2.sha512 | awk '{print $1;}')  latest.tar.bz2" > latest.tar.bz2.sha512 \
 && CHECKSUM_STATE=$(echo -n $(sha512sum -c latest.tar.bz2.sha512) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && tar xjf latest.tar.bz2 --strip 1 -C /nextcloud \
 && apk del ${BUILD_DEPS} php7.1-pear php7.1-dev \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7.1/php-fpm.conf
COPY opcache.ini /etc/php7.1/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7.1/conf.d/apcu.ini
COPY run.sh /usr/local/bin/run.sh
COPY setup.sh /usr/local/bin/setup.sh
COPY occ /usr/local/bin/occ
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /config /apps2 /nextcloud/themes

EXPOSE 8888

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
