#!/bin/sh
addgroup -g ${GID} nextcloud && adduser -h /nextcloud -s /bin/sh -D -G nextcloud -u ${UID} nextcloud

if [ -f /nextcloud/config/config.php ] && [ ! -f /config/config.php ]; then
  cp /nextcloud/config/config.php /config/config.php
elif [ -f /config/config.php ]; then
  if [ -f /nextcloud/config/config.php ]; then
    sed -i "s/.*version.*/`grep "version" \/nextcloud\/config\/config.php`/" /config/config.php
    CONFIG=`md5sum /config/config.php | awk '{ print $1 }'`
    CONFIGINS=`md5sum /nextcloud/config/config.php | awk '{ print $1 }'`
    if [ $CONFIG != $CONFIGINS ]; then
      mv /nextcloud/config/config.php /config/config.php.bkp
    fi
  fi
  cp /config/config.php /nextcloud/config/config.php
fi

touch /var/run/php-fpm.sock
mkdir /tmp/fastcgi /tmp/client_body
chown -R nextcloud:nextcloud /nextcloud /data /config /apps2 /var/run/php-fpm.sock /var/lib/nginx /tmp
ln -s /apps2 /nextcloud

supervisord -c /etc/supervisor/supervisord.conf
