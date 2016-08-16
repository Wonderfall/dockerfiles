#!/bin/sh
addgroup -g ${GID} nextcloud && adduser -h /nextcloud -s /bin/sh -D -G nextcloud -u ${UID} nextcloud

touch /var/run/php-fpm.sock
mkdir /tmp/fastcgi /tmp/client_body
chown -R nextcloud:nextcloud /nextcloud /data /config /apps2 /var/run/php-fpm.sock /var/lib/nginx /tmp
ln -s /config/config.php /nextcloud/config/config.php
ln -s /apps2 /nextcloud

supervisord -c /etc/supervisor/supervisord.conf
