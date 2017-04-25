FROM alpine:3.5

ARG BUILD_CORES

ARG NGINX_VER=1.11.13
ARG NGINX_GPG="B0F4253373F8F6F510D42178520A9993A1C052F8"

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

ARG PHP_GPG=" \
    A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 \
    528995BFEDFBA7191D46839EF9BA0ADA31CBD89E \
    1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 \
    6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 \
    0BD78B5F97500D450838F95DFE857D9A90D90EC1 \
    0B96609E270F565C13292B24C13C70B87267B52D"

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
    --with-iconv \
    --with-iconv-dir=/usr/local \
    --with-zlib"

ENV PHP_MEMORY_LIMIT=512M \
    UPLOAD_MAX_SIZE=1G

COPY rootfs /

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \

### Packages installation
 && BUILD_DEPS=" \
    build-base \
    pcre-dev \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    url-dev \
    libedit-dev \
    ibxml2-dev \
    libressl-dev \
    sqlite-dev \
    ca-certificates" \
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

### Source downloading
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
 && wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz -O /tmp/libiconv-${LIBICONV_VERSION}.tar.gz \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$NGINX_GPG" \
 && gpg --batch --verify /tmp/nginx-${NGINX_VER}.tar.gz.asc /tmp/nginx-${NGINX_VER}.tar.gz \
 && gpg --keyserver pgp.mit.edu --recv-keys "$PHP_GPG" \
 && gpg --batch --verify /tmp/php-${PHP_VER}.tar.gz.asc /tmp/php-${PHP_VER}.tar.gz \
 && mkdir -p /php/conf.d \
 && mkdir -p /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
 && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
 && tar xzf /tmp/libiconv-${LIBICONV_VERSION}.tar.gz -C /usr/src \

### nginx installation
 && cd /usr/src/nginx-${NGINX_VER} \
 && ./configure ${NGINX_CONF} \            
 && make -j ${NB_CORES} \
 && make install \

### GNU Libiconv installation
 && cd /usr/src/ibiconv-${LIBICONV_VERSION} \
 && ./configure --prefix=/usr/local \
 && make && make install && libtool --finish /usr/local/lib \

### PHP installation
 && mv /usr/src/php-${PHP_VER} /usr/src/php \
 && cd /usr/src/php \
 && ./configure ${PHP_CONF} \
 && make -j ${NB_CORES} \
 && make install \

### Strip & clean
 && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && make clean \
 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/*