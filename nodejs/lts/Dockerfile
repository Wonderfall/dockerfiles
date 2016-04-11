FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG NODE_VER=4.4.2
ARG NPM_VER=3

RUN apk -U add \
    git \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    libgcc \
    libstdc++ \
    binutils-gold \
    ca-certificates \
 && NB_CORES=`getconf _NPROCESSORS_CONF` \
 && cd /tmp \
 && wget -qO- https://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER.tar.gz | tar zxf - \
 && cd node-v$NODE_VER \
 && ./configure --prefix=/usr \
 && make -j$NB_CORES && make install \
 && paxctl -cm /usr/bin/node \
 && npm install -g npm@$NPM_VER \
 && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
 && apk del \
    git \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    binutils-gold \
    grep \
    ca-certificates \
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
