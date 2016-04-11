#!/bin/bash
deluser www-data
addgroup --gid $GROUPID www-data
adduser --system --no-create-home --ingroup www-data --uid $USERID www-data
crontab -u www-data /etc/cron.conf

if [ -f /owncloud/config/config.php ] && [ ! -f /config/config.php ]; then
  cp /owncloud/config/config.php /config/config.php
elif [ -f /config/config.php ]; then
  mv /owncloud/config/config.php /config/config.php.bkp
  cp /config/config.php /owncloud/config/config.php
fi

chown -R www-data:www-data /owncloud /data /config /apps2
ln -s /apps2 /owncloud

supervisord -c /etc/supervisord.conf
