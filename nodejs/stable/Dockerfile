FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG NODE_VERSION=6.3.0
ARG NPM_VERSION=3
ARG BUILD_CORES

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    binutils-gold \
    openssl \
    ca-certificates" \
 && apk -U add \
    ${BUILD_DEPS} \
    libgcc \
    libstdc++ \
 && cd /tmp \
 && wget -qO- https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz | tar zxf - \
 && cd node-v${NODE_VERSION} \
 && ./configure --prefix=/usr --without-snapshot \
 && make -j ${NB_CORES} && make install && make clean \
 && paxctl -cm /usr/bin/node \
 && npm install -g npm@${NPM_VERSION} \
 && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
 && strip -s /usr/bin/node \
 && apk del ${BUILD_DEPS} \
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
