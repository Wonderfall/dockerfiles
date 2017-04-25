FROM alpine:3.5

ARG BUILD_CORES

ARG NGINX_VER=1.13.0

ARG NGINX_CONF=" \
    --prefix=/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --http-log-path=/nginx/logs/access.log \
    --error-log-path=/nginx/logs/error.log \
    --pid-path=/nginx/run/nginx.pid \
    --lock-path=/nginx/run/nginx.lock \
    --with-threads \
    --with-file-aio \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module"

ARG PHP_VER=7.1.4
ARG PHP_MIRROR=http://ch1.php.net

ARG LIBICONV_VERSION=1.15

ARG PHP_CONF=" \
    --enable-fpm \
    --with-config-file-path="/php" \
    --with-config-file-scan-dir="/php/conf.d" \
    --disable-cgi \
    --enable-mysqlnd \
    --enable-mbstring \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-iconv=/usr/local \
    --with-zlib"

ARG PHP_EXT_LIST=" \
    gd \
    mysqli \
    ctype \
    dom \
    json \
    xml \
    mbstring \
    posix \
    xmlwriter \
    zip \
    zlib \
    sqlite3 \
    pdo_sqlite \
    pdo_pgsql \
    pdo_mysql \
    pcntl \
    curl \
    fileinfo \
    bz2 \
    intl \
    mcrypt \
    openssl \
    ldap \
    simplexml \
    pgsql \
    ftp \
    exif \
    gmp"

ARG CUSTOM_BUILD_PKGS=" \
    freetype-dev \
    openldap-dev \
    gmp-dev \
    libmcrypt-dev \
    icu-dev \
    postgresql-dev"

ARG CUSTOM_PKGS=" \
    freetype \
    openldap \
    gmp \
    libmcrypt \
    libbz2 \
    icu \
    libpq"

ENV MEMORY_LIMIT=512M \
    UPLOAD_MAX_SIZE=1G

COPY rootfs /

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \

### Packages installation
 && BUILD_DEPS=" \
    linux-headers \
    libtool \
    build-base \
    pcre-dev \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    pkgconf \
    curl-dev \
    libedit-dev \
    libxml2-dev \
    libressl-dev \
    sqlite-dev \
    ca-certificates \
   ${CUSTOM_BUILD_PKGS}" \
 && apk -U add \
    ${BUILD_DEPS} \
    s6 \
    su-exec \
    curl \
    libedit \
    libxml2 \
    libressl \
    pcre \
    zlib \
    s6 \
    su-exec \
    ${CUSTOM_PKGS} \

### Source downloading
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
 && wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz -O /tmp/libiconv-${LIBICONV_VERSION}.tar.gz \
 && mkdir -p /php/conf.d \
 && mkdir -p /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
 && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
 && tar xzf /tmp/libiconv-${LIBICONV_VERSION}.tar.gz -C /usr/src \

### nginx installation
 && cd /usr/src/nginx-${NGINX_VER} \
 && ./configure --with-cc-opt="-O3 -fPIE -fstack-protector-strong" ${NGINX_CONF} \
 && make -j ${NB_CORES} \
 && make install \

### GNU Libiconv installation
 && cd /usr/src/libiconv-${LIBICONV_VERSION} \
 && ./configure --prefix=/usr/local \
 && make && make install && libtool --finish /usr/local/lib \

### PHP installation
 && mv /usr/src/php-${PHP_VER} /usr/src/php \
 && cd /usr/src/php \
 && ./configure ${PHP_CONF} \
 && make -j ${NB_CORES} \
 && make install \

### Strip, clean, install modules
 && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && make clean \
 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && docker-php-ext-install ${PHP_EXT_LIST} \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
 && mkdir -p /nginx/logs /nginx/run /php/php-fpm.d /php/logs /php/run
