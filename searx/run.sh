#!/bin/sh
sed -i -e "s|base_url : False|base_url : ${BASE_URL}|g" \
       -e "s/image_proxy : False/image_proxy : ${IMAGE_PROXY}/g" \
       -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" \
       /usr/local/searx/searx/settings.yml

exec su-exec $UID:$GID /sbin/tini -- python /usr/local/searx/searx/webapp.py
