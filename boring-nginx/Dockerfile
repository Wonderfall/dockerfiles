FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV UID=991 GID=991

ARG NGINX_VERSION=1.11.0
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"
ARG SIGNATURE=secret
ARG BUILD_CORES

COPY boring.patch /tmp/boring.patch

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
    gnupg \
    cmake \
    go \
    clang \
    clang-dev" \
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
 && cd /tmp && git clone https://github.com/bagder/libbrotli && cd libbrotli \
 && ./autogen.sh && CC=clang CXX=clang++ ./configure \
 && make -j ${NB_CORES} && make install \
 && mkdir /tmp/ngx_brotli && cd /tmp/ngx_brotli \
 && wget -qO- https://github.com/google/ngx_brotli/archive/master.tar.gz | tar xz --strip 1 \
 && cd /tmp && git clone https://boringssl.googlesource.com/boringssl && cd boringssl \
 && mkdir build && cd build && CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j ${NB_CORES} && cd .. \
 && sed -i 's/OpenSSL 1.0.2 (compatible; BoringSSL)/BoringSSL/g' include/openssl/crypto.h \
 && mkdir -p .openssl/lib/ && cd .openssl && ln -s ../include && cd .. \
 && cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib && cd /tmp \
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
 && sed -i -e "s/\"Server: nginx\" CRLF/\"Server: ${SIGNATURE}\" CRLF/g" \
    -e "s/\"Server: \" NGINX_VER CRLF/\"Server: ${SIGNATURE}\" NGINX_VER CRLF/g" \
    src/http/ngx_http_header_filter_module.c \
 && patch -p1 < /tmp/boring.patch \
 && CC=clang CXX=clang++ ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --with-cc-opt='-g -O3 -fstack-protector-strong -fPIE -Wformat -Werror=format-security -Wno-c++11-extensions -I ../boringssl/.openssl/include/' \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -L ../boringssl/.openssl/lib' \
    --with-http_ssl_module \
    --with-http_v2_module \
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
    --http-proxy-temp-path=/tmp/proxy_temp \
    --http-client-body-temp-path=/tmp/client_body_temp \
    --http-fastcgi-temp-path=/tmp/fastcgi_temp \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --add-module=/tmp/ngx_brotli \
 && make -j ${NB_CORES} && make install && make clean \
 && strip -s /usr/local/sbin/nginx \
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
