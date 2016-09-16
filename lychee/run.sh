#!/bin/sh
mkdir /lychee/uploads/big /lychee/uploads/import /lychee/uploads/medium /lychee/uploads/thumb
chown -R $UID:$GID /lychee /etc/nginx /etc/php7 /var/log /var/lib/nginx /tmp /etc/s6.d
exec su-exec $UID:$GID /sbin/tini -- /bin/s6-svscan /etc/s6.d
