FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV UID=991 GID=991

ARG NGINX_VERSION=1.11.1
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"
ARG BUILD_CORES

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
    bind-tools \
    tini@commuedge \
 && cd /tmp \
 && git clone https://github.com/bagder/libbrotli && cd libbrotli \
 && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp \
 && git clone https://github.com/google/ngx_brotli \
 && git clone https://github.com/openresty/headers-more-nginx-module \
 && git clone https://github.com/openssl/openssl.git && cd openssl && ./config \
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
 && if [ "${FINGERPRINT}" != "${GPG_NGINX}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${NGINX_TARBALL}..." \
 && tar xzf ${NGINX_TARBALL} && cd nginx-${NGINX_VERSION} \
 && wget https://raw.githubusercontent.com/felixbuenemann/sslconfig/b8ebac6a337e8e4e373dfee76e7dfac3cc6c56e6/patches/nginx_1_9_15_http2_spdy.patch -O spdy.patch \
 && patch -p1 < spdy.patch \
 && wget https://raw.githubusercontent.com/cloudflare/sslconfig/master/patches/nginx__dynamic_tls_records.patch \
 && patch -p1 < nginx__dynamic_tls_records.patch \
 && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --with-cc-opt='-O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security' \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
    --with-openssl=/tmp/openssl \
    --with-openssl-opt='no-ssl3 no-camellia no-dsa no-rc2 no-rc4 no-rc5 no-md2 no-md4 no-comp no-idea no-shared enable-ec_nistp_64_gcc_128 -DOPENSSL_NO_HEARTBEATS -D_FORTIFY_SOURCE=2 -fstack-protector-strong' \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_spdy_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-file-aio \
    --with-threads \
    --with-pcre-jit \
    --without-http_ssi_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_map_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --add-module=/tmp/headers-more-nginx-module \
    --add-module=/tmp/ngx_brotli \
 && make -j ${NB_CORES} && make install && make clean \
 && strip -s /usr/sbin/nginx \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY run.sh /usr/local/bin/run.sh
COPY ngxpasswd /usr/local/bin/ngxpasswd
COPY ngxproxy /usr/local/bin/ngxproxy
COPY vhost_http.conf /etc/nginx/conf/vhost_http.conf
COPY vhost_https.conf /etc/nginx/conf/vhost_https.conf
COPY ssl_params /etc/nginx/conf/ssl_params
COPY headers_params /etc/nginx/conf/headers_params
COPY proxy_params /etc/nginx/conf/proxy_params

RUN chmod +x /usr/local/bin/*

EXPOSE 8000 4430

VOLUME /sites-enabled /www /conf.d /passwds /certs /var/log/nginx

LABEL description="Secure nginx built from source." \
      openssl="BoringSSL (date of the container)." \
      nginx="nginx ${NGINX_VERSION}."

CMD ["/sbin/tini","--","run.sh"]
