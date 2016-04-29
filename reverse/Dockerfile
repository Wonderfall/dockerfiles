FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG NGINX_VER=1.10.0
ARG LIBRESSL_VER=2.3.3
ARG SIGNATURE=secret
ARG BUILD_CORES

ENV UID=991 GID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    build-base \
    linux-headers \
    ca-certificates \
    automake \
    autoconf \
    git \
    tar \
    libtool \
    pcre-dev \
    zlib-dev \
    binutils" \
 && apk -U add \
    $BUILD_DEPS \
    pcre \
    zlib \
    libgcc \
    libstdc++ \
    su-exec \
    tini@commuedge \
 && cd /tmp && git clone https://github.com/bagder/libbrotli && cd libbrotli \
 && ./autogen.sh && ./configure && make -j $NB_CORES && make install \
 && mkdir /tmp/ngx_brotli && cd /tmp/ngx_brotli \
 && wget -qO- https://github.com/google/ngx_brotli/archive/master.tar.gz | tar xz --strip 1 \
 && mkdir /tmp/libressl && cd /tmp/libressl \
 && wget -qO- http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$LIBRESSL_VER.tar.gz | tar xz --strip 1 \
 && ./configure \
    LDFLAGS=-lrt \
    CFLAGS=-fstack-protector-strong \
    --prefix=/tmp/libressl/.openssl/ \
    --enable-shared=no \
 && make install-strip -j $NB_CORES \
 && mkdir /tmp/nginx && cd /tmp/nginx \
 && wget -qO- http://nginx.org/download/nginx-$NGINX_VER.tar.gz | tar zxf - \
 && cd nginx-$NGINX_VER \
 && sed -i -e "s/\"Server: nginx\" CRLF/\"Server: $SIGNATURE\" CRLF/g" \
    -e "s/\"Server: \" NGINX_VER CRLF/\"Server: $SIGNATURE\" NGINX_VER CRLF/g" \
    src/http/ngx_http_header_filter_module.c \
 && ./configure \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-openssl=/tmp/libressl \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security' \
    --with-ld-opt="-lrt" \
    --with-file-aio \
    --with-threads \
    --without-http_ssi_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-http_fastcgi_module \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_map_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module \
    --prefix=/etc/nginx \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --sbin-path=/usr/local/sbin/nginx \
    --add-module=/tmp/ngx_brotli \
 && make -j $NB_CORES && make install \
 && make clean \
 && strip -s /usr/local/sbin/nginx \
 && apk del $BUILD_DEPS \
 && rm -rf /tmp/* /var/cache/apk/*

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/*

EXPOSE 8000 4430
VOLUME /sites-enabled /conf.d /passwds /certs /var/log/nginx

LABEL description="Secure reverse proxy using nginx" \
      libressl="LibreSSL v$LIBRESSL_VER" \
      nginx="nginx v$NGINX_VER"

CMD ["tini","--","run.sh"]
