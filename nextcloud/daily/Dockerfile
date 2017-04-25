FROM alpine:3.5

ARG GNU_LIBICONV_VERSION=1.15
ARG PHP_SOURCES_VERSION=7.0.18

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

RUN echo " https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
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
    php7 \
    php7-fpm \
    php7-intl \
    php7-mbstring \
    php7-curl \
    php7-gd \
    php7-fileinfo \
    php7-mcrypt \
    php7-opcache \
    php7-json \
    php7-session \
    php7-pdo \
    php7-dom \
    php7-ctype \
    php7-mysqlnd \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pgsql \
    php7-pdo_sqlite \
    php7-sqlite3 \
    php7-zlib \
    php7-zip \
    php7-xmlreader \
    php7-xml \
    php7-xmlwriter \
    php7-posix \
    php7-openssl \
    php7-ldap \
    php7-imap \
    php7-ftp \
    php7-pcntl \
    php7-exif \
    php7-pear \
    php7-dev \
 && pecl install smbclient apcu redis \
 && cd /tmp && wget -q http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${GNU_LIBICONV_VERSION}.tar.gz \
 && tar xzf libiconv-${GNU_LIBICONV_VERSION}.tar.gz && cd libiconv-${GNU_LIBICONV_VERSION} \
 && ./configure --prefix=/usr/local \
 && make && make install && libtool --finish /usr/local/lib && cd /tmp \
 && wget -q http://is1.php.net/get/php-${PHP_SOURCES_VERSION}.tar.gz/from/this/mirror -O php7.tar.gz \
 && tar xzf php7.tar.gz && cd /tmp/php-${PHP_SOURCES_VERSION}/ext/iconv && phpize7 \
 && ./configure --with-iconv=/usr/local --with-php-config=/usr/bin/php-config7 \
 && make && cp modules/iconv.so /usr/lib/php7/modules && cd /tmp \
 && echo "extension=iconv.so" > /etc/php7/conf.d/00_iconv.ini \
 && echo "extension=smbclient.so" > /etc/php7/conf.d/00_smbclient.ini \
 && echo "extension=redis.so" > /etc/php7/conf.d/redis.ini \
 && sed -i 's|;session.save_path = "/tmp"|session.save_path = "/data/session"|g' /etc/php7/php.ini \
 && mkdir /nextcloud \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2 \
 && echo "Verifying checksum of latest.tar.bz2..." \
 && wget -q https://download.nextcloud.com/server/daily/latest.tar.bz2.sha512 \
 && echo "$(cat latest.tar.bz2.sha512 | awk '{print $1;}')  latest.tar.bz2" > latest.tar.bz2.sha512 \
 && CHECKSUM_STATE=$(echo -n $(sha512sum -c latest.tar.bz2.sha512) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && tar xjf latest.tar.bz2 --strip 1 -C /nextcloud \
 && apk del ${BUILD_DEPS} php7-pear php7-dev \
 && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY opcache.ini /etc/php7/conf.d/00_opcache.ini
COPY apcu.ini /etc/php7/conf.d/apcu.ini
COPY run.sh /usr/local/bin/run.sh
COPY setup.sh /usr/local/bin/setup.sh
COPY occ /usr/local/bin/occ
COPY s6.d /etc/s6.d

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /config /apps2 /nextcloud/themes

EXPOSE 8888

LABEL description="A server software for creating file hosting services" \
      nextcloud="Nextcloud daily build" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
