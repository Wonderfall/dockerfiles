#!/bin/sh
chown -R $UID:$GID /etc/nginx /var/log/nginx /sites-enabled /conf.d /certs /www /tmp
chmod -R 700 /certs
chmod 666 /dev/std*
exec su-exec $UID:$GID /sbin/tini -- nginx
