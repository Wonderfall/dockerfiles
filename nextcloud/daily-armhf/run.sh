#!/bin/sh

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7/php-fpm.conf \
       -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /etc/php7/conf.d/apcu.ini \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /etc/php7/conf.d/00_opcache.ini \
       -e "s/<REDIS_MAX_MEMORY>/$REDIS_MAX_MEMORY/g" /etc/redis.conf \
       -e "s/<CRON_PERIOD>/$CRON_PERIOD/g" /etc/s6.d/cron/run

# Put the configuration and apps into volumes
ln -sf /config/config.php /nextcloud/config/config.php &>/dev/null
ln -sf /apps2 /nextcloud &>/dev/null

for dir in /nextcloud /data /config /apps2 /etc/nginx /etc/php7 /var/log /var/lib/nginx /var/lib/redis /tmp /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    chown -R $UID:$GID $dir
  fi
done

if [ ! -f /config/config.php ]; then
    # New installation, run the setup
    /usr/local/bin/setup.sh
else
    occ upgrade
    if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then
        echo "Trying ownCloud upgrade again to work around ownCloud upgrade bug..."
        occ upgrade
        if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then exit 1; fi
        occ maintenance:mode --off
        echo "...which seemed to work."
    fi
fi

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
