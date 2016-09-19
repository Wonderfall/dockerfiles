#!/bin/sh

if [ ! -f /config/config.php ]; then
    echo -e "<?php\n\$CONFIG = array (\n  'datadirectory' => '/data',\n);" > /config/config.php
fi

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.conf

chown -R $UID:$GID /nextcloud /data /config /apps2 /etc/nginx /etc/php7 /var/log /var/lib/nginx /tmp /etc/s6.d
ln -s /config/config.php /nextcloud/config/config.php
ln -s /apps2 /nextcloud

crond
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
