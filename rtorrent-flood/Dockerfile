FROM wonderfall/node:stable
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG MEDIAINFO_VER=0.7.88
ARG RTORRENT_VER=0.9.6
ARG LIBTORRENT_VER=0.13.6
ARG FILEBOT_VER=4.7.2
ARG BUILD_CORES

ENV UID=991 \
    GID=991 \
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
    ffmpeg \
    ca-certificates \
    curl \
    gzip \
    zip \
    unrar \
    supervisor \
    geoip \
    tini@community \
    openjdk8-jre@community \
 && cd /tmp \
 && wget -q http://downloads.sourceforge.net/mktorrent/mktorrent-1.0.tar.gz \
 && tar xzvf mktorrent-1.0.tar.gz \
 && svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c \
 && mkdir libtorrent rtorrent \
 && cd libtorrent && wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd ../rtorrent && wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && wget -q http://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VER}/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && wget -q http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VER}/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && tar xzf MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && tar xzf MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && tar xzvf mktorrent-1.0.tar.gz \
 && cd /tmp/mktorrent-1.0 && make -j ${NB_CORES} && make install \
 && cd  /tmp/MediaInfo_DLL_GNU_FromSource && ./SO_Compile.sh \
 && cd /tmp/MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library && make install \
 && cd /tmp/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && make install \
 && cd /tmp/MediaInfo_CLI_GNU_FromSource && ./CLI_Compile.sh \
 && cd /tmp/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI && make install \
 && cd /tmp/xmlrpc-c && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/libtorrent && ./autogen.sh && ./configure \
 && make -j ${NB_CORES} && make install \
 && cd /tmp/rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c \
 && make -j ${NB_CORES} && make install \
 && mkdir /filebot \
 && wget -q http://downloads.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.zip -P /tmp \
 && unzip -q /tmp/FileBot_${FILEBOT_VER}-portable.zip -d /filebot \
 && strip -s /usr/local/bin/rtorrent \
 && strip -s /usr/local/bin/mediainfo \
 && cd /usr && git clone https://github.com/jfurrow/flood && cd flood \
 && npm install \
 && apk del ${BUILD_DEPS} \
 && deluser svn && delgroup svnusers \
 && rm -rf /var/cache/apk/* /tmp/*

COPY config.js /usr/flood/
COPY supervisord.ini /etc/supervisor.d/
COPY startup /usr/bin/
COPY postdl /usr/bin/
COPY postrm /usr/bin/
COPY config.js /usr/flood/
COPY rtorrent.rc /home/torrent/.rtorrent.rc

RUN chmod +x /usr/bin/* \
 && cd /usr/flood && ./node_modules/.bin/gulp dist

VOLUME /data /usr/flood/server/db

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end" \
      rtorrent="rTorrent BiTorrent client v$RTORRENT_VER" \
      libtorrent="libtorrent v$LIBTORRENT_VER" \
      mediainfo="mediainfo v$MEDIAINFO_VER" \
      filebot="Filebot v$FILEBOT_VER"

CMD ["/sbin/tini","--","startup"]
