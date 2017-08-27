#!/bin/bash
echo
echo ">>> wonderfall/ghost container <<<"
echo

echo "> Initializing content folder..."
cd content
mkdir apps data images themes logs adapters &>/dev/null
rm -rf /ghost/content/themes/casper &>/dev/null
cp -r /ghost/casper themes/casper &>/dev/null
cd /ghost

if [ ! -f /ghost/content/ghost.conf ]; then
  echo
  echo "INFO : No configuration file was provided, an example will be used"
  echo "       You can access and modify it in the volume you mounted"
  echo "       Restart in order to apply your changes!"
  echo
  mv /usr/local/etc/ghost.example.conf /ghost/content/ghost.conf
fi

if [ ! -f /ghost/config.production.json ]; then
  ln -s content/ghost.conf config.production.json
fi

echo "> Applying preferences..."

sed -i -e "s|https://my-ghost-blog.com|${ADDRESS}|g" /ghost/content/ghost.conf

if [ "$ENABLE_ISSO" == "True" ] && ! grep -q 'isso' /ghost/content/themes/casper/post.hbs; then
    cd /usr/local/etc
    sed -i -e "/\/author/r isso.conf" /ghost/content/themes/casper/post.hbs
    sed -i -e '/isso-thread/{n;d}' /ghost/content/themes/casper/post.hbs
    sed -i -e "s/<HOST>/$ISSO_HOST/g" \
           -e "s/<AVATAR>/$ISSO_AVATAR/g" \
           -e "s/<VOTE>/$ISSO_VOTE/g" /ghost/content/themes/casper/post.hbs
fi

echo "> Updating permissions..."
chown -R ${UID}:${GID} /ghost /etc/s6.d

echo "> Executing process..."
if [ '$@' == '' ]; then
    exec su-exec ${UID}:${GID} /bin/s6-svscan /etc/s6.d
else
    exec su-exec ${UID}:${GID} "$@"
fi
