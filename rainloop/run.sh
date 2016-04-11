#!/bin/sh
addgroup -g ${GID} rainloop && adduser -h /rainloop -s /bin/sh -D -G rainloop -u ${UID} rainloop

chown -R rainloop:rainloop /rainloop /var/run/php-fpm.sock /var/lib/nginx /tmp
supervisord -c /usr/local/etc/supervisord.conf
