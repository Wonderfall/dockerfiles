#!/bin/sh

mkdir -p /data/transcode
ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg
ln -s /usr/bin/lame /data/transcode/lame

chown -R $UID:$GID /data /playlists /subsonic

exec su-exec $UID:$GID tini -- \
java -Xmx256m \
  -Dsubsonic.home=/data \
  -Dsubsonic.host=0.0.0.0 \
  -Dsubsonic.port=4040 \
  -Dsubsonic.httpsPort=$HTTPSPORT \
  -Dsubsonic.contextPath=/ \
  -Dsubsonic.defaultMusicFolder=/musics \
  -Dsubsonic.defaultPodcastFolder=/podcasts \
  -Dsubsonic.defaultPlaylistFolder=/playlists \
  -Djava.awt.headless=true \
  -jar subsonic-booter-jar-with-dependencies.jar
