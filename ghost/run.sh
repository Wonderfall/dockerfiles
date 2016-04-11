#!/bin/bash
cd /ghost/content
mkdir apps data images themes

sed -i "s|my-ghost-blog.com|$DOMAIN|g" /ghost/config.js

if [ "$SSL" == "True" ] && ! grep -q 'urlSSL' /ghost/config.js; then
    sed -i "/url/a \ \ \ \ \ \ \ \ urlSSL: 'https://$DOMAIN'," /ghost/config.js
fi

if [ "$CUSTOM_SMTP" == "True" ]; then
    cd /usr/local/etc
    sed -i -e "/mail: {},/r smtp.conf" \
           -e "/mail: {},/d" /ghost/config.js
    sed -i -e "s/<HOST>/$SMTP_HOST/g" \
           -e "s/<PORT>/$SMTP_PORT/g" \
           -e "s/<USER>/$SMTP_USER/g" \
           -e "s/<PASS>/$SMTP_PASS/g" /ghost/config.js
fi

if [ ! -d /ghost/content/themes/casper ]; then
    cp -r /ghost/casper /ghost/content/themes/casper
else
    CASPER=`md5sum /ghost/casper/package.json | awk '{ print $1 }'`
    INSTALLED_CASPER=`md5sum /ghost/content/themes/casper/package.json | awk '{ print $1 }'`
    if [ "$CASPER" != "$INSTALLED_CASPER" ]; then
      rm -rf /ghost/content/themes/casper
      cp -r /ghost/casper /ghost/content/themes/casper
    fi
fi

if [ "$ENABLE_ISSO" == "True" ] && ! grep -q 'isso' /ghost/content/themes/casper/post.hbs; then
    cd /usr/local/etc
    sed -i -e "/\/author/r isso.conf" /ghost/content/themes/casper/post.hbs
    sed -i -e "s/<HOST>/$ISSO_HOST/g" \
           -e "s/<AVATAR>/$ISSO_AVATAR/g" \
           -e "s/<VOTE>/$ISSO_VOTE/g" /ghost/content/themes/casper/post.hbs
fi

if [ "$SYNTAX_HIGHLIGHTING" == "True" ] && [ ! -f /ghost/content/themes/casper/assets/js/prism.js ]; then
    cp /ghost/prismjs/$HIGHLIGHTER_COLOR/prism.css /ghost/content/themes/casper/assets/css
    cp /ghost/prismjs/$HIGHLIGHTER_COLOR/prism.js /ghost/content/themes/casper/assets/js
    cd /usr/local/etc
    sed -i -e "/Styles'n'Scripts/r prism.css.conf" \
           -e "/The main JavaScript file for Casper/r prism.js.conf" \
           /ghost/content/themes/casper/default.hbs
fi

chown -R $UID:$GID /ghost && cd /ghost
gosu $UID:$GID npm start --production
