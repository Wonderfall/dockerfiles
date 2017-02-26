#!/bin/sh
chown -R $UID:$GID /zerobin /etc/nginx /etc/php7.1 /var/log /var/lib/nginx /tmp /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
