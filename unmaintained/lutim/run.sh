#!/bin/bash
deluser lutim
addgroup --gid $GROUPID lutim
adduser --system --shell /bin/sh --no-create-home --ingroup lutim --uid $USERID lutim
sed -i -e 's/<contact>/'$CONTACT'/g' \
       -e 's/<secret>/'$SECRET'/g' \
       -e 's/<max_file_size>/'$MAX_FILE_SIZE'/g' \
       -e 's/<domain>/'$DOMAIN'/g' \
       -e 's|<webroot>|'$WEBROOT'|g' /lutim/lutim.conf
chown -R lutim:lutim /lutim /data
cd /lutim && exec su lutim -c "carton exec hypnotoad -f /lutim/script/lutim"
