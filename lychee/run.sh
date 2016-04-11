#!/bin/sh
addgroup -g ${GID} lychee && adduser -h /lychee -s /bin/sh -D -G lychee -u ${UID} lychee
chown -R lychee:lychee /lychee /var/run/php-fpm.sock /var/lib/nginx /tmp
supervisord -c /usr/local/etc/supervisord.conf
