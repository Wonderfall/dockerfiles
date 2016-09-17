FROM wonderfall/node:stable
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG RTORRENT_VER=0.9.6
ARG LIBTORRENT_VER=0.13.6
ARG FILEBOT_VER=4.7.2
ARG BUILD_CORES

ENV UID=991 GID=991 \
    FLOOD_SECRET=supersecret \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories \
 && NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    build-base \
    git \
    libtool \
    automake \
    autoconf \
    wget \
    tar \
    subversion \
    cppunit-dev \
    openssl-dev \
    ncurses-dev \
    curl-dev \
    binutils" \
 && apk -U add \
    ${BUILD_DEPS} \
    ca-certificates \
    curl \
    gzip \
    zip \
    unrar \
    s6 \
    su-exec \
    python \
    openjdk8-jre@community \
 && cd /tmp && mkdir libtorrent rtorrent \
 && cd libtorrent && wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd ../rtorrent && wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && git clone https://github.com/mirror/xmlrpc-c.git \
 && git clone https://github.com/Rudde/mktorrent.git \
 && cd /tmp/mktorrent && make -j ${NB_CORES} && make install \
 && cd /tmp/xmlrpc-c/advanced && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/libtorrent && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install \
 && strip -s /usr/local/bin/rtorrent \
 && strip -s /usr/local/bin/mktorrent \
 && mkdir /filebot \
 && wget -q http://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.zip -P /tmp \
 && unzip -q /tmp/FileBot_${FILEBOT_VER}-portable.zip -d /filebot \
 && cd /usr && git clone https://github.com/jfurrow/flood && cd flood \
 && npm install \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY config.js /usr/flood/
COPY s6.d /etc/s6.d
COPY run.sh /usr/bin/
COPY postdl /usr/bin/
COPY postrm /usr/bin/
COPY config.js /usr/flood/
COPY rtorrent.rc /home/torrent/.rtorrent.rc

RUN chmod +x /usr/bin/* /etc/s6.d/*/* \
 && cd /usr/flood && ./node_modules/.bin/gulp dist

VOLUME /data /usr/flood/server/db

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end" \
      rtorrent="rTorrent BiTorrent client v$RTORRENT_VER" \
      libtorrent="libtorrent v$LIBTORRENT_VER" \
      filebot="Filebot v$FILEBOT_VER"

CMD ["run.sh"]
