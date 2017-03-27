#!/bin/sh
cd /cowrie

rm twistd.pid &>/dev/null
mkdir -p /cowrie/log/tty &>/dev/null
cp -R /custom/* /cowrie &>/dev/null
chown -R $UID:$GID /cowrie

COWRIEDIR=$(dirname $0)
export PYTHONPATH=${PYTHONPATH}:${COWRIEDIR}

exec su-exec $UID:$GID /sbin/tini -- twistd -n -l /cowrie/log/cowrie.log cowrie
