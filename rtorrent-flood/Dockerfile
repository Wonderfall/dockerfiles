FROM alpine:3.6

ARG RTORRENT_VER=0.9.6
ARG LIBTORRENT_VER=0.13.6
ARG MEDIAINFO_VER=0.7.98
ARG FILEBOT_VER=4.7.9
ARG CHROMAPRINT_VER=1.4.2
ARG LIBZEN_VER=0.4.36
ARG FLOOD_VER=1.0.0
ARG BUILD_CORES

ENV UID=991 GID=991 \
    FLOOD_SECRET=supersecret \
    CONTEXT_PATH=/ \
    RTORRENT_SCGI=0 \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

ENV FILEBOT_RENAME_METHOD="symlink" \
    FILEBOT_RENAME_MOVIES="{n} ({y})" \
    FILEBOT_RENAME_SERIES="{n}/Season {s.pad(2)}/{s00e00} - {t}" \
    FILEBOT_RENAME_ANIMES="{n}/{e.pad(3)} - {t}" \
    FILEBOT_RENAME_MUSICS="{artist}/{album}/{fn}"

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    git \
    libtool \
    automake \
    autoconf \
    wget \
    tar \
    xz \
    zlib-dev \
    cppunit-dev \
    libressl-dev \
    ncurses-dev \
    curl-dev \
    binutils \
 && apk add \
    ca-certificates \
    curl \
    ncurses \
    libressl \
    gzip \
    zip \
    zlib \
    unrar \
    s6 \
    su-exec \
    python \
    nodejs \
    nodejs-npm \
    openjdk8-jre \
    java-jna-native \
 && cd /tmp && mkdir libtorrent rtorrent \
 && cd libtorrent && wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd ../rtorrent && wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && git clone https://github.com/mirror/xmlrpc-c.git \
 && git clone https://github.com/Rudde/mktorrent.git \
 && git clone https://github.com/acoustid/chromaprint.git \
 && cd /tmp/mktorrent && make -j ${NB_CORES} && make install \
 && cd /tmp/xmlrpc-c/stable && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/libtorrent && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install \
 && cd /tmp \
 && wget -q http://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VER}/MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && wget -q http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VER}/MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && wget -q https://github.com/MediaArea/ZenLib/archive/v${LIBZEN_VER}.tar.gz -O libzen.tar.gz \
 && tar xzf MediaInfo_DLL_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && tar xzf MediaInfo_CLI_${MEDIAINFO_VER}_GNU_FromSource.tar.gz \
 && tar xzf libzen.tar.gz \
 && cd /tmp/ZenLib-${LIBZEN_VER}/Project/GNU/Library \
 && ./autogen.sh && ./configure --prefix=/usr --enable-shared --disable-static && make && make install \
 && cd /tmp/MediaInfo_DLL_GNU_FromSource && ./SO_Compile.sh \
 && cd /tmp/MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library && make install \
 && cd /tmp/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && make install \
 && cd /tmp/MediaInfo_CLI_GNU_FromSource && ./CLI_Compile.sh \
 && cd /tmp/MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI && make install \
 && strip -s /usr/local/bin/rtorrent \
 && strip -s /usr/local/bin/mktorrent \
 && strip -s /usr/local/bin/mediainfo \
 && mkdir /filebot && cd /filebot \
 && wget https://github.com/acoustid/chromaprint/releases/download/v${CHROMAPRINT_VER}/chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
 && tar xvf chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64.tar.gz \
 && mv chromaprint-fpcalc-${CHROMAPRINT_VER}-linux-x86_64/fpcalc /usr/local/bin \
 && strip -s /usr/local/bin/fpcalc \
 && wget -q https://netcologne.dl.sourceforge.net/project/filebot/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz \
 && tar xJf FileBot_${FILEBOT_VER}-portable.tar.xz && rm FileBot_${FILEBOT_VER}-portable.tar.xz \
 && mkdir /usr/flood && cd /usr/flood && wget -qO- https://github.com/jfurrow/flood/archive/v${FLOOD_VER}.tar.gz | tar xz --strip 1 \
 && npm install --production \
 && ln -sf /usr/local/lib/libmediainfo.so.0.0.0 /filebot/lib/x86_64/libmediainfo.so \
 && ln -sf /usr/local/lib/libzen.la /filebot/lib/x86_64/libzen.so \
 && ln -sf /usr/local/bin/mediainfo /usr/bin/mediainfo \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

COPY config.js /usr/flood/
COPY s6.d /etc/s6.d
COPY run.sh /usr/bin/
COPY postdl /usr/bin/
COPY postrm /usr/bin/
COPY config.js /usr/flood/
COPY rtorrent.rc /home/torrent/.rtorrent.rc

RUN chmod +x /usr/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /data /flood-db

EXPOSE 3000 49184 49184/udp

LABEL description="BitTorrent client with WebUI front-end" \
      rtorrent="rTorrent BiTorrent client v$RTORRENT_VER" \
      libtorrent="libtorrent v$LIBTORRENT_VER" \
      filebot="Filebot v$FILEBOT_VER" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
