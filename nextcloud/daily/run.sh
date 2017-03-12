#!/bin/sh

sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /etc/nginx/nginx.conf /etc/php7.1/php-fpm.conf \
       -e "s/<APC_SHM_SIZE>/$APC_SHM_SIZE/g" /etc/php7.1/conf.d/apcu.ini \
       -e "s/<OPCACHE_MEM_SIZE>/$OPCACHE_MEM_SIZE/g" /etc/php7.1/conf.d/00_opcache.ini \
       -e "s/<CRON_MEMORY_LIMIT>/$CRON_MEMORY_LIMIT/g" /etc/s6.d/cron/run \
       -e "s/<CRON_PERIOD>/$CRON_PERIOD/g" /etc/s6.d/cron/run

# Put the configuration and apps into volumes
ln -sf /config/config.php /nextcloud/config/config.php &>/dev/null
ln -sf /apps2 /nextcloud &>/dev/null

# Create folder for php sessions if not exists
if [ ! -d /data/session ]; then
  mkdir -p /data/session;
fi

echo "Updating permissions..."
for dir in /nextcloud /data /config /apps2 /etc/nginx /etc/php7.1 /var/log /var/lib/nginx /tmp /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

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
