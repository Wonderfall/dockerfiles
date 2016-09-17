#!/bin/sh
chown -R $UID:$GID /boinc && cd /boinc
exec su-exec $UID:$GID /sbin/tini -- boinc $@
