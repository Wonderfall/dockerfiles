FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG NODE_VER=6.2.2
ARG NPM_VER=3
ARG BUILD_CORES

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    git \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    grep \
    binutils \
    binutils-gold \
    openssl \
    ca-certificates" \
 && apk -U add \
    $BUILD_DEPS \
    libgcc \
    libstdc++ \
 && cd /tmp \
 && wget -qO- https://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER.tar.gz | tar zxf - \
 && cd node-v$NODE_VER \
 && ./configure --prefix=/usr --without-snapshot \
 && make -j $NB_CORES && make install && make clean \
 && paxctl -cm /usr/bin/node \
 && npm install -g npm@$NPM_VER \
 && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
 && strip -s /usr/bin/node \
 && apk del $BUILD_DEPS \
 && rm -rf \
    /tmp/* \
    /var/cache/apk/* \
    /root/.npm \
    /root/.node-gyp \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/share/man

CMD ["node", "-v"]
