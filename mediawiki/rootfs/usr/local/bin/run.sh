#!/bin/sh
sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /php/conf.d/apcu.ini

chown -R $UID:$GID /mediawiki /nginx /php /tmp /etc/s6.d

if [ -f /config/LocalSettings.php ] && [ ! -f /mediawiki/LocalSettings.php ]; then
    ln -s /config/LocalSettings.php /mediawiki/LocalSettings.php
fi

cp -r /skins/* /mediawiki/skins/
cp -r /extensions/* /mediawiki/extensions/

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
