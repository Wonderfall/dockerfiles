#!/bin/sh

# Creating customize folder
mkdir -p customize
[ -z "$(ls -A customize)" ] && echo "Creating customize folder" \
  && cp -R customize.dist/* customize/ \
  && cp config.example.js customize/config.js

# Linking config.js
[ ! -h config.js ] && echo "Linking config.js" && ln -s customize/config.js config.js

chown -R $UID:$GID /cryptpad
exec su-exec $UID:$GID /sbin/tini -- node ./server.js
