#!/bin/sh
mkdir /run/pgbouncer
chown -R $UID:$GID /etc/pgbouncer /var/log/pgbouncer /run/pgbouncer
su-exec $UID:$GID pgbouncer /etc/pgbouncer/pgbouncer.ini
