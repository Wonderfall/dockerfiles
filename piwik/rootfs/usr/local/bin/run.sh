#!/bin/sh
sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /php/conf.d/opcache.ini

if [ ! -f /config/config.ini.php ]; then
  cp /piwik/config/config.ini.php /config/config.ini.php
fi

ln -s /config/config.ini.php /piwik/config/config.ini.php
mv piwik fix && mv fix piwik # fix strange bug
chown -R $UID:$GID /piwik /config /var/log /php /nginx /tmp /usr/share/GeoIP /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
