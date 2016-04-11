FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG VERSION=6.0.beta2 

ENV GID=991 UID=991

RUN echo "@community http://dl-4.alpinelinux.org/alpine/v3.3/community/" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && apk -U add \
    libva@edge \ #libva is temporary missing
    ffmpeg \
    openjdk8-jre@community \
    tini@commuedge \
 && rm -f /var/cache/apk/*

WORKDIR /subsonic
RUN wget -qO- http://subsonic.org/download/subsonic-$VERSION-standalone.tar.gz | tar zxf -

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 4040
VOLUME /data /musics /playlists /podcasts

LABEL description "Open source media streamer" \
      subsonisc "Subsonic v$VERSION"

CMD ["tini","--","run.sh"]
