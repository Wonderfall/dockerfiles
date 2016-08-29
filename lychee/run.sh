#!/bin/sh
addgroup -g ${GID} lychee && adduser -h /lychee -s /bin/sh -D -G lychee -u ${UID} lychee
mkdir /lychee/uploads/big /lychee/uploads/import /lychee/uploads/medium /lychee/uploads/thumb
chown -R lychee:lychee /lychee /var/run/php-fpm.sock /var/lib/nginx /tmp
exec supervisord -c /usr/local/etc/supervisord.conf
