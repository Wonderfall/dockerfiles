#!/bin/sh
cd /cowrie
sed -i "s/hostname = svr04/hostname = $HOSTNAME/g" cowrie.cfg
sed -i "s/#download_limit_size = 10485760/download_limit_size = $DL_LIMIT/g" cowrie.cfg
sed -i "s/#internet_facing_ip = 9.9.9.9/internet_facing_ip = $FACING_IP/g" cowrie.cfg

if [ "$JSON_LOG" == "False" ]; then
    sed -i "s/\[output_jsonlog\]/#\[output_jsonlog\]/g" cowrie.cfg
    sed -i "s|logfile = log/cowrie.json|#logfile = log/cowrie.json|g" cowrie.cfg
fi
    
if [ "$CUSTOM" == "True"]; then
    sed -i "s|contents_path = honeyfs|contents_path = /honeyfs|g" cowrie.cfg
    sed -i "s|data_path = data|data_path = /data|g" cowrie.cfg
    sed -i "s|txtcmds_path = txtcmds|txtcmds_path = /txtcmds|g" cowrie.cfg
    
    if [ -d honeyfs ] && [ ! -d /honeyfs/etc ]; then
        mv honeyfs/* /honeyfs
    fi
    
    if [ -d data ] && [ ! -f /data/userdb.txt ]; then
        mv data/* /data
    fi
    
    if [ -d txtcmds ] && [ ! -d /txtcmds/bin ]; then
        mv txtcmds/* /txtcmds
    fi
    
    if [ -d utils ]; then
        rm -rf /utils/*
        mv utils/* /utils
    fi

    rm -rf honeyfs data txtcmds utils
    ln -s /data data #fix
    chown -R $UID:$GID /honeyfs /data /txtcmds /utils
fi

mkdir /log/tty
chown -R $UID:$GID /cowrie /dl /log
gosu $UID:$GID twistd -n -l /log/cowrie.log cowrie
