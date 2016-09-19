#!/bin/sh

if [ ! -f /config/config.php ]; then
    echo -e "<?php\n\$CONFIG = array (\n  'datadirectory' => '/data',\n);" > /config/config.php
fi

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.conf \
       -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /etc/php7/conf.d/apcu.ini \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /etc/php7/conf.d/00_opcache.ini

chown -R $UID:$GID /nextcloud /data /config /apps2 /etc/nginx /etc/php7 /var/log /var/lib/nginx /tmp /etc/s6.d
ln -s /config/config.php /nextcloud/config/config.php
ln -s /apps2 /nextcloud

crond
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
