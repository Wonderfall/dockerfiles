#!/bin/sh
addgroup -g ${GID} subsonic && adduser -h /subsonic -s /bin/sh -D -G subsonic -u ${UID} subsonic

mkdir -p /data/transcode
ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg
ln -s /usr/bin/lame /data/transcode/lame

chown -R subsonic:subsonic /data /playlists /subsonic

su subsonic << EOF
java -Xmx200m \
  -Dsubsonic.home=/data \
  -Dsubsonic.host=0.0.0.0 \
  -Dsubsonic.port=4040 \
  -Dsubsonic.httpsPort=0 \
  -Dsubsonic.contextPath=/ \
  -Dsubsonic.defaultMusicFolder=/musics \
  -Dsubsonic.defaultPodcastFolder=/podcasts \
  -Dsubsonic.defaultPlaylistFolder=/playlists \
  -Djava.awt.headless=true \
  -jar subsonic-booter-jar-with-dependencies.jar
EOF
