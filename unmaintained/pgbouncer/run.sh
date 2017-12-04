#!/bin/sh
mkdir /run/pgbouncer
chown -R $UID:$GID /etc/pgbouncer /var/log/pgbouncer /run/pgbouncer
exec su-exec $UID:$GID /sbin/tini -- pgbouncer /etc/pgbouncer/pgbouncer.ini
