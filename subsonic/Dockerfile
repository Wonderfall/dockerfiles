FROM alpine:3.5

ARG VERSION=6.0

ENV UID=991 GID=991 \
    HTTPSPORT=0

WORKDIR /subsonic

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories \
 && apk -U add \
    ffmpeg \
    su-exec \
    openjdk8-jre@community \
    tini@community \
 && wget -qO- http://subsonic.org/download/subsonic-${VERSION}-standalone.tar.gz | tar zxf - \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 4040 4050

VOLUME /data /musics /playlists /podcasts

LABEL description "Open source media streamer" \
      subsonic "Subsonic v$VERSION" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
