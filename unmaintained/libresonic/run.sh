#!/bin/sh

mkdir -p /data/transcode
ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg
ln -s /usr/bin/lame /data/transcode/lame

chown -R $UID:$GID /data /playlists /libresonic

exec su-exec $UID:$GID tini -- \
java -Xmx256m \
  -Dserver.host=0.0.0.0 \
  -Dserver.port=4040 \
  -Dserver.contextPath=/ \
  -Dlibresonic.home=/data \
  -Dlibresonic.host=0.0.0.0 \
  -Dlibresonic.port=4040 \
  -Dlibresonic.contextPath=/ \
  -Dlibresonic.defaultMusicFolder=/musics \
  -Dlibresonic.defaultPodcastFolder=/podcasts \
  -Dlibresonic.defaultPlaylistFolder=/playlists \
  -Djava.awt.headless=true \
  -jar libresonic.war
