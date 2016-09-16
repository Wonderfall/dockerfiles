#!/bin/sh
chown -R $UID:$GID /etc/nginx /var/log/nginx /var/run/nginx.pid /sites-enabled /conf.d /certs /www /tmp
chmod -R 700 /certs
exec su-exec $UID:$GID /sbin/tini -- nginx
