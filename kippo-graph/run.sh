#!/bin/sh
chown -R $UID:$GID /kippo-graph /etc/nginx /etc/php5 /var/log /var/lib/nginx /tmp /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
