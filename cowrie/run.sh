#!/bin/sh
cd /cowrie
sed -i "s/hostname = svr04/hostname = $HOSTNAME/g" cowrie.cfg
sed -i "s/#download_limit_size = 10485760/download_limit_size = $DL_LIMIT/g" cowrie.cfg
sed -i "s/#internet_facing_ip = 9.9.9.9/internet_facing_ip = $FACING_IP/g" cowrie.cfg

if [ "$JSON_LOG" == "False" ]; then
    sed -i "s/\[output_jsonlog\]/#\[output_jsonlog\]/g" cowrie.cfg
    sed -i "s|logfile = log/cowrie.json|#logfile = log/cowrie.json|g" cowrie.cfg
fi

mkdir -p /cowrie/log/tty
mv -f /cowrie/custom/* /cowrie
chown -R $UID:$GID /cowrie

su-exec $UID:$GID twistd -n -l /cowrie/log/cowrie.log cowrie
