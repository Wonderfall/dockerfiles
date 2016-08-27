FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG BOINC_USER_ID=35854

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
 && git clone https://github.com/BOINC/boinc.git --depth=1 \
 && cd boinc \
 && ./_autosetup \
 && ./configure --disable-server --enable-client CXXFLAGS="-O3 " \
 && make \
 && make install \
 && adduser -h /home/boinc -D -s /sbin/nologin -u ${BOINC_USER_ID} boinc \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

USER boinc
WORKDIR /home/boinc
VOLUME /home/boinc
ENTRYPOINT [ "boinc" ]
