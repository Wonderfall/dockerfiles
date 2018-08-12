#!/bin/sh
sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MAX_CHILDREN>/$PHP_MAX_CHILDREN/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_START_SERVERS>/$PHP_START_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MIN_SPARE_SERVERS>/$PHP_MIN_SPARE_SERVERS/g" /php/etc/php-fpm.conf \
       -e "s/<PHP_MAX_SPARE_SERVERS>/$PHP_MAX_SPARE_SERVERS/g" /php/etc/php-fpm.conf

chown -R $UID:$GID /privatebin/data /nginx /php /tmp /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
