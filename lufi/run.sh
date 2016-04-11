#!/bin/bash
deluser lufi
addgroup --gid $GROUPID lufi
adduser --system --shell /bin/sh --no-create-home --ingroup lufi --uid $USERID lufi
sed -i -e 's/<contact>/'$CONTACT'/g' \
       -e 's/<secret>/'$SECRET'/g' \
       -e 's/<max_file_size>/'$MAX_FILE_SIZE'/g' \
       -e 's/<domain>/'$DOMAIN'/g' \
       -e 's|<webroot>|'$WEBROOT'|g' /lufi/lufi.conf
chown -R lufi:lufi /lufi /data /files
cd /lufi && su lufi -c "carton exec hypnotoad -f /lufi/script/lufi"
