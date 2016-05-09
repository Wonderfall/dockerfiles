FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG NGINX_VERSION=1.10.0
ARG LIBRESSL_VERSION=2.3.4
ARG SIGNATURE=secret
ARG BUILD_CORES

ARG GPG_brent="A1EB 079B 8D3E B92B 4EBD  3139 663A F51B D5E4 D8D5"
ARG GPG_mdounin="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"

ENV UID=991 GID=991

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \
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
    binutils \
    gnupg" \
 && apk -U add \
    ${BUILD_DEPS} \
    pcre \
    zlib \
    libgcc \
    libstdc++ \
    su-exec \
    openssl \
    tini@commuedge \
 && cd /tmp && git clone https://github.com/bagder/libbrotli && cd libbrotli \
 && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && mkdir /tmp/ngx_brotli && cd /tmp/ngx_brotli \
 && wget -qO- https://github.com/google/ngx_brotli/archive/master.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && LIBRESSL_TARBALL="libressl-${LIBRESSL_VERSION}.tar.gz" \
 && wget -q http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${LIBRESSL_TARBALL} \
 && echo "Verifying ${LIBRESSL_TARBALL} using GPG..." \
 && wget -q http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${LIBRESSL_TARBALL}.asc \
 && wget -q http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl.asc \
 && gpg --import libressl.asc \
 && FINGERPRINT="$(LANG=C gpg --verify ${LIBRESSL_TARBALL}.asc ${LIBRESSL_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_brent}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${LIBRESSL_TARBALL}..." \
 && tar xzf ${LIBRESSL_TARBALL} && cd libressl-${LIBRESSL_VERSION} \
 && ./configure \
    LDFLAGS=-lrt \
    CFLAGS=-fstack-protector-strong \
    --prefix=/tmp/libressl/.openssl/ \
    --enable-shared=no \
 && make install-strip -j ${NB_CORES} \
 && cd /tmp \
 && NGINX_TARBALL="nginx-${NGINX_VERSION}.tar.gz" \
 && wget -q http://nginx.org/download/${NGINX_TARBALL} \
 && echo "Verifying ${NGINX_TARBALL} using GPG..." \
 && wget -q http://nginx.org/download/${NGINX_TARBALL}.asc \
 && wget -q http://nginx.org/keys/mdounin.key \
 && gpg --import mdounin.key \
 && FINGERPRINT="$(LANG=C gpg --verify ${NGINX_TARBALL}.asc ${NGINX_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_mdounin}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${NGINX_TARBALL}..." \
 && tar xzf ${NGINX_TARBALL} && cd nginx-${NGINX_VERSION} \
 && sed -i -e "s/\"Server: nginx\" CRLF/\"Server: ${SIGNATURE}\" CRLF/g" \
    -e "s/\"Server: \" NGINX_VER CRLF/\"Server: ${SIGNATURE}\" NGINX_VER CRLF/g" \
    src/http/ngx_http_header_filter_module.c \
 && ./configure \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-openssl=/tmp/libressl-${LIBRESSL_VERSION} \
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
 && make -j ${NB_CORES} && make install \
 && make clean \
 && strip -s /usr/local/sbin/nginx \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/*

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY run.sh /usr/local/bin/run.sh
COPY ngxpasswd /usr/local/bin/ngxpasswd

RUN chmod +x /usr/local/bin/*

EXPOSE 8000 4430
VOLUME /sites-enabled /conf.d /passwds /certs /var/log/nginx

LABEL description="Secure reverse proxy using nginx" \
      libressl="LibreSSL v${LIBRESSL_VERSION}" \
      nginx="nginx v${NGINX_VERSION}"

CMD ["/sbin/tini","--","run.sh"]
