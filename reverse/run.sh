#!/bin/sh
touch /var/run/nginx.pid
chown -R $UID:$GID /etc/nginx /var/log/nginx /var/run/nginx.pid /sites-enabled /conf.d /certs
chmod -R 700 /certs
gosu $UID:$GID nginx
