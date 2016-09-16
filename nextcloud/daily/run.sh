#!/bin/sh

if [ ! -f /config/config.php ]; then
    echo -e "<?php\n\$CONFIG = array (\n  'datadirectory' => '/data',\n);" > /config/config.php
fi

mkdir /tmp/fastcgi /tmp/client_body
chown -R $UID:$GID /nextcloud /data /config /apps2 /etc/nginx /etc/php7 /var/log/nginx /var/log/php7 /var/lib/nginx /tmp /etc/s6.d
ln -s /config/config.php /nextcloud/config/config.php
ln -s /apps2 /nextcloud

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
