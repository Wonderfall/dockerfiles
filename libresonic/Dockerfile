FROM alpine:3.5

ARG VERSION=6.2.beta3

ENV UID=991 GID=991

WORKDIR /libresonic

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
 && apk -U upgrade && apk add \
    ffmpeg \
    su-exec \
    libressl \
    ca-certificates \
    openjdk8-jre@community \
    tini@community \
 && wget -q https://github.com/Libresonic/libresonic/releases/download/v${VERSION}/libresonic-v${VERSION}.war -O libresonic.war \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 4040

VOLUME /data /musics /playlists /podcasts

LABEL description "Open source media streamer" \
      libresonic "Libresonic v$VERSION" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
