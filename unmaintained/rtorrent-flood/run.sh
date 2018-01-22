#!/bin/sh

mkdir -p /data/torrents
mkdir -p /data/.watch
mkdir -p /data/.session
mkdir -p /data/Media/Movies
mkdir -p /data/Media/TV
mkdir -p /data/Media/Animes
mkdir -p /data/Media/Music

sed -i -e "s|<FLOOD_SECRET>|$FLOOD_SECRET|g" \
       -e "s|<CONTEXT_PATH>|$CONTEXT_PATH|g" /usr/flood/config.js


sed -i -e 's#<FILEBOT_RENAME_MOVIES>#'"$FILEBOT_RENAME_MOVIES"'#' \
       -e 's#<FILEBOT_RENAME_METHOD>#'"$FILEBOT_RENAME_METHOD"'#' \
       -e 's#<FILEBOT_RENAME_MUSICS>#'"$FILEBOT_RENAME_MUSICS"'#' \
       -e 's#<FILEBOT_RENAME_SERIES>#'"$FILEBOT_RENAME_SERIES"'#' \
       -e 's#<FILEBOT_RENAME_ANIMES>#'"$FILEBOT_RENAME_ANIMES"'#' /usr/bin/postdl

rm -f /data/.session/rtorrent.lock

chown -R $UID:$GID /data /home/torrent /tmp /filebot /usr/flood /flood-db /etc/s6.d

if [ ${RTORRENT_SCGI} -ne 0 ]; then
    sed -i -e 's|^scgi_local.*$|scgi_port = 0.0.0.0:'${RTORRENT_SCGI}'|' /home/torrent/.rtorrent.rc
    sed -i -e 's|socket: true,|socket: false,|' -e 's|port: 5000,|port: '${RTORRENT_SCGI}',|' /usr/flood/config.js
fi

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
