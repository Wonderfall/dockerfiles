#!/bin/sh
cd /cowrie

sed -i -e "s/hostname = svr04/hostname = ${HOSTNAME}/g" \
       -e "s/#download_limit_size = 10485760/download_limit_size = ${DL_LIMIT}/g" \
       -e "s/#internet_facing_ip = 9.9.9.9/internet_facing_ip = ${FACING_IP}/g" cowrie.cfg

if [ "${JSON_LOG}" == "False" ]; then
    sed -i -e "s/\[output_jsonlog\]/#\[output_jsonlog\]/g" \
           -e "s|logfile = log/cowrie.json|#logfile = log/cowrie.json|g" cowrie.cfg
fi

rm twistd.pid
mkdir -p /cowrie/log/tty
cp -R /cowrie/custom/* /cowrie
chown -R $UID:$GID /cowrie

COWRIEDIR=$(dirname $0)
export PYTHONPATH=${PYTHONPATH}:${COWRIEDIR}

exec su-exec $UID:$GID /sbin/tini -- twistd -n -l /cowrie/log/cowrie.log cowrie
