#!/bin/sh

mkdir -p /data/torrents
mkdir -p /data/.watch
mkdir -p /data/.session
mkdir -p /data/Media/Movies
mkdir -p /data/Media/TV
mkdir -p /data/Media/Animes
mkdir -p /data/Media/Music

sed -i -e "s|<FLOOD_SECRET>|$FLOOD_SECRET|g" /usr/flood/config.js
sed -i -e "s|<CONTEXT_PATH>|$CONTEXT_PATH|g" /usr/flood/config.js

rm -f /data/.session/rtorrent.lock
mv /usr/flood /usr/fix && mv /usr/fix /usr/flood # fix strange bug
chown -R $UID:$GID /data /home/torrent /tmp /filebot /usr/flood /flood-db /etc/s6.d

if [ ${RTORRENT_SCGI} -ne 0 ]; then
    sed -i -e 's|^scgi_local.*$|scgi_port = 0.0.0.0:'${RTORRENT_SCGI}'|' /home/torrent/.rtorrent.rc 
    sed -i -e 's|socket: true,|socket: false,|' -e 's|port: 5000,|port: '${RTORRENT_SCGI}',|' /usr/flood/config.js
fi

exec su-exec $GID:$UID /bin/s6-svscan /etc/s6.d
