#!/bin/sh

if [ ! -f /config/config.ini.php ]; then
  cp /piwik/config/config.ini.php /config/config.ini.php
fi

ln -s /config/config.ini.php /piwik/config/config.ini.php
mv piwik fix && mv fix piwik # fix strange bug
chown -R $UID:$GID /piwik /config /var/log /etc/nginx /etc/php7 /var/lib/nginx /tmp /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
