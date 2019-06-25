FROM alpine:3.10

ENV UID=991 GID=991

ARG NGINX_VERSION=1.17.1
ARG GPG_NGINX="B0F4 2533 73F8 F6F5 10D4  2178 520A 9993 A1C0 52F8"
ARG BUILD_CORES

ARG NGINX_MODULES=" \
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
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module"

ARG NGINX_3RD_PARTY_MODULES=" \
    --add-module=/tmp/headers-more-nginx-module \
    --add-module=/tmp/ngx_brotli"

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \
 && apk -U upgrade \
 && apk add \
    ${BUILD_DEPS} \
    pcre \
    zlib \
    libgcc \
    libstdc++ \
    su-exec \
    libressl \
    bind-tools \
    tini \
 && apk add -t build-dependencies \
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
 && cd /tmp && git clone https://github.com/bagder/libbrotli --depth=1 \
 && cd libbrotli && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp && git clone https://github.com/google/ngx_brotli --depth=1 \
 && cd ngx_brotli && git submodule update --init \
 && cd /tmp && git clone https://github.com/openresty/headers-more-nginx-module --depth=1 \
 && git clone https://boringssl.googlesource.com/boringssl --depth=1 \
 && cd boringssl \
 && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j ${NB_CORES} && cd .. \
 && mkdir -p .openssl/lib/ && cd .openssl && ln -s ../include && cd .. \
 && cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib && cd /tmp \
 && NGINX_TARBALL="nginx-${NGINX_VERSION}.tar.gz" \
 && wget -q https://nginx.org/download/${NGINX_TARBALL} \
 && echo "Verifying ${NGINX_TARBALL} using GPG..." \
 && wget -q https://nginx.org/download/${NGINX_TARBALL}.asc \
 && wget -q https://nginx.org/keys/mdounin.key \
 && gpg --import mdounin.key \
 && FINGERPRINT="$(LANG=C gpg --verify ${NGINX_TARBALL}.asc ${NGINX_TARBALL} 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG_NGINX}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking ${NGINX_TARBALL}..." \
 && tar xzf ${NGINX_TARBALL} && cd nginx-${NGINX_VERSION} \
 && wget -q https://raw.githubusercontent.com/hoellen/dockerfiles/master/boring-nginx/dynamic_records.patch -O dynamic_records.patch \
 && patch -p1 < dynamic_records.patch \
 && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --with-cc-opt="-O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -Wno-deprecated-declarations -I ../boringssl/.openssl/include/" \
    --with-ld-opt="-lrt -Wl,-Bsymbolic-functions -Wl,-z,relro -L ../boringssl/.openssl/lib" \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    ${NGINX_MODULES} \
    ${NGINX_3RD_PARTY_MODULES} \
 && make -j ${NB_CORES} && make install && make clean \
 && strip -s /usr/sbin/nginx \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/* /root/.gnupg

COPY rootfs /

RUN chmod +x /usr/local/bin/*

EXPOSE 8000 4430

VOLUME /sites-enabled /www /conf.d /passwds /certs /var/log/nginx

LABEL description="nginx built from source" \
      openssl="BoringSSL" \
      nginx="nginx ${NGINX_VERSION}" \
      maintainer="hoellen <info@hoellen.eu>"

CMD ["run.sh"]
