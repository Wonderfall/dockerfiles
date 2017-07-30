#!/bin/sh
echo
echo ">>> wonderfall/parsoid container <<<"
echo

cd /parsoid
cp config.example.yaml config.yaml
sed -i "s|http://localhost/w/|$ADDRESS|g" config.yaml
sed -i "s|domain: 'localhost'|domain: '$DOMAIN'|g" config.yaml

echo "> Updating permissions..."
chown -R ${UID}:${GID} /parsoid /etc/s6.d

echo "> Executing process..."
if [ '$@' == '' ]; then
    exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
else
    exec su-exec ${UID}:${GID} "$@"
fi
