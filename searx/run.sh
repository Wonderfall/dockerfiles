#!/bin/sh
sed -i "s|base_url : False|base_url : $BASE_URL|g" searx/settings.yml
sed -i "s/image_proxy : False/image_proxy : $IMAGE_PROXY/g" searx/settings.yml
sed -i "s/ultrasecretkey/`openssl rand -hex 16`/g" searx/settings.yml
python searx/webapp.py
