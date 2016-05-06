#!/bin/sh
chown -R $UID:$GID /db /config
su-exec $UID:$GID isso -c /config/isso.conf run
