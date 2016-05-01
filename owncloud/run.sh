#!/bin/sh
addgroup -g ${GID} owncloud && adduser -h /owncloud -s /bin/sh -D -G owncloud -u ${UID} owncloud

if [ -f /owncloud/config/config.php ] && [ ! -f /config/config.php ]; then
  cp /owncloud/config/config.php /config/config.php
elif [ -f /config/config.php ]; then
  if [ -f /owncloud/config/config.php ]; then
    sed -i "s/.*version.*/`grep "version" \/owncloud\/config\/config.php`/" /config/config.php
    CONFIG=`md5sum /config/config.php | awk '{ print $1 }'`
    CONFIGINS=`md5sum /owncloud/config/config.php | awk '{ print $1 }'`
    if [ $CONFIG != $CONFIGINS ]; then
      mv /owncloud/config/config.php /config/config.php.bkp
    fi
  fi
  cp /config/config.php /owncloud/config/config.php
fi

touch /var/run/php-fpm.sock
chown -R owncloud:owncloud /owncloud /data /config /apps2 /var/run/php-fpm.sock /var/lib/nginx /tmp
ln -s /apps2 /owncloud

supervisord -c /etc/supervisor/supervisord.conf
