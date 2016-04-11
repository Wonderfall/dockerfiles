#!/bin/sh
addgroup -g ${GID} piwik && adduser -h /piwik -s /bin/sh -D -G piwik -u ${UID} piwik

if [ -f /piwik/config/config.ini.php ] && [ ! -f /config/config.ini.php ]; then
  cp /piwik/config/config.ini.php /config/config.ini.php
elif [ -f /config/config.ini.php ]; then
  mv /piwik/config/config.ini.php /config/config.ini.php.bkp
  cp /config/config.ini.php /piwik/config/config.ini.php
fi

chown -R piwik:piwik /piwik /config /var/run/php-fpm.sock /var/lib/nginx /tmp
supervisord -c /usr/local/etc/supervisord.conf
