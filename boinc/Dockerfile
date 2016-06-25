FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

RUN BUILD_DEPS=" \
    build-base \
    git \
    m4 \
    automake \
    autoconf \
    libtool \
    curl-dev \
    libnotify-dev" \
 && apk -U add \
    ${BUILD_DEPS} \
    libnotify \
    libstdc++ \
    curl \
 && cd /tmp \
 && git clone https://github.com/BOINC/boinc.git \
 && cd boinc \
 && ./_autosetup \
 && ./configure --disable-server --enable-client CXXFLAGS="-O3 " \
 && make \
 && make install \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

ENTRYPOINT [ "boinc" ]
