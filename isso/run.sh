#!/bin/sh
chown -R $UID:$GID /db /config
gosu $UID:$GID isso -c /config/isso.conf run
