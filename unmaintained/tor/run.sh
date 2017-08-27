#!/bin/sh
chown -R $UID:$GID /tor
exec su-exec $UID:$GID tini -- tor $@
