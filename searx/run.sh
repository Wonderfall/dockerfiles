#!/bin/sh
DEFAULT_CONFIG="/settings/settings.yml"
DEST_CONFIG="/usr/local/searx/searx/settings.yml"
if [[ -f $DEFAULT_CONFIG ]]; then
   cp -p $DEFAULT_CONFIG $DEST_CONFIG;
 else
   echo -e "No default settings given. Example at: https://raw.githubusercontent.com/asciimoo/searx/master/searx/settings.yml"
fi
sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" \
       -e "s/127.0.0.1/0.0.0.0/g" \
       ${DEST_CONFIG}
exec su-exec $UID:$GID /sbin/tini -- python /usr/local/searx/searx/webapp.py
