FROM alpine:3.4

ARG BUILD_CORES

ENV UID=991 GID=991

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
 && NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
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
    su-exec \
    tini@community \
    libnotify \
    libstdc++ \
    curl \
 && cd /tmp \
 && git clone https://github.com/BOINC/boinc.git --depth=1 \
 && cd boinc \
 && ./_autosetup \
 && ./configure --disable-server --enable-client CXXFLAGS="-O3 " \
 && make -j ${NB_CORES} \
 && make install \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /boinc

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

ENTRYPOINT ["run.sh"]
