#!/bin/sh
sed -i -e "s/<UPLOAD_MAX_SIZE>/$UPLOAD_MAX_SIZE/g" /nginx/conf/nginx.conf /php/etc/php-fpm.conf \
       -e "s/<MEMORY_LIMIT>/$MEMORY_LIMIT/g" /php/etc/php-fpm.conf \
       -e "s/<CRON_PERIOD>/$CRON_PERIOD/g" /etc/s6.d/cron/run

[ ! "$(ls -A /freshrss/data)" ] && cp -R /freshrss/data_tmp/* /freshrss/data/
chown -R $UID:$GID /freshrss /nginx /php /tmp /etc/s6.d
exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
