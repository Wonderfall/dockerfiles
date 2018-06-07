#!/bin/sh
sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /php/conf.d/opcache.ini \
       -e "s/<PHP_MAX_CHILDREN>/$PHP_MAX_CHILDREN/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_START_SERVERS>/$PHP_START_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MIN_SPARE_SERVERS>/$PHP_MIN_SPARE_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MAX_SPARE_SERVERS>/$PHP_MAX_SPARE_SERVERS/g" /php/etc/php-fpm.conf

if [ ! -f /config/config.ini.php ]; then
  cp /matomo/config/config.ini.php /config/config.ini.php
fi

ln -s /config/config.ini.php /matomo/config/config.ini.php
mv matomo fix && mv fix matomo # fix strange bug
chown -R $UID:$GID /matomo /config /var/log /php /nginx /tmp /usr/share/GeoIP /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
