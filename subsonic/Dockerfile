FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ARG VERSION=6.0
ENV GID=991 UID=991
WORKDIR /subsonic

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    ffmpeg \
    openjdk8-jre@commuedge \
    tini@commuedge \
 && wget -qO- http://subsonic.org/download/subsonic-${VERSION}-standalone.tar.gz | tar zxf - \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 4040
VOLUME /data /musics /playlists /podcasts

LABEL description "Open source media streamer" \
      subsonic "Subsonic v$VERSION"

CMD ["/sbin/tini","--","run.sh"]
