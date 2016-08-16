#!/bin/sh
addgroup -g ${GID} nextcloud && adduser -h /nextcloud -s /bin/sh -D -G nextcloud -u ${UID} nextcloud

if [ -f /nextcloud/config/config.php ] && [ ! -f /config/config.php ]; then
  mv /nextcloud/config/config.php /config/config.php
fi
ln -s /config/config.php /nextcloud/config/config.php

touch /var/run/php-fpm.sock
mkdir /tmp/fastcgi /tmp/client_body
chown -R nextcloud:nextcloud /nextcloud /data /config /apps2 /var/run/php-fpm.sock /var/lib/nginx /tmp
ln -s /apps2 /nextcloud

supervisord -c /etc/supervisor/supervisord.conf
