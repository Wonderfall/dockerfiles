#!/bin/sh

mkdir -p /data/torrents
mkdir -p /data/.watch
mkdir -p /data/.session
mkdir -p /data/Media/Movies
mkdir -p /data/Media/TV
mkdir -p /data/Media/Animes
mkdir -p /data/Media/Music

sed -i -e "s/<FLOOD_SECRET>/$FLOOD_SECRET/g" /usr/flood/config.js
rm -f /data/.session/rtorrent.lock
chown -R $UID:$GID /data /home/torrent /tmp /filebot /usr/flood/server /etc/s6.d

exec su-exec $GID:$UID /bin/s6-svscan /etc/s6.d
