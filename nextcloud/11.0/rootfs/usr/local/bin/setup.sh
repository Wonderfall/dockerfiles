#!/bin/sh
# Nextcloud
##########################

#source setup/functions.sh # load our functions
#source /etc/mailinabox.conf # load global vars
CONFIGFILE=/config/config.php


# Create an initial configuration file.
instanceid=oc$(echo $PRIMARY_HOSTNAME | sha1sum | fold -w 10 | head -n 1)
cat > $CONFIGFILE <<EOF;
<?php
\$CONFIG = array (
  'datadirectory' => '/data',

  "apps_paths" => array (
      0 => array (
              "path"     => "/nextcloud/apps",
              "url"      => "/apps",
              "writable" => false,
      ),
      1 => array (
              "path"     => "/apps2",
              "url"      => "/apps2",
              "writable" => true,
      ),
  ),

  'memcache.local' => '\OC\Memcache\APCu',

  'instanceid' => '$instanceid',
);
?>
EOF

# Create an auto-configuration file to fill in database settings
# when the install script is run. Make an administrator account
# here or else the install can't finish.
adminpassword=$(dd if=/dev/urandom bs=1 count=40 2>/dev/null | sha1sum | fold -w 30 | head -n 1)
cat > /nextcloud/config/autoconfig.php <<EOF;
<?php
\$AUTOCONFIG = array (
  # storage/database
  'directory'     => '/data',
  'dbtype'        => '${DB_TYPE:-sqlite3}',
  'dbname'        => '${DB_NAME:-nextcloud}',
  'dbuser'        => '${DB_USER:-nextcloud}',
  'dbpass'        => '${DB_PASSWORD:-password}',
  'dbhost'        => '${DB_HOST:-nextcloud-db}',
  'dbtableprefix' => 'oc_',
EOF
if [[ ! -z "$ADMIN_USER"  ]]; then
  cat >> /nextcloud/config/autoconfig.php <<EOF;
  # create an administrator account with a random password so that
  # the user does not have to enter anything on first load of ownCloud
  'adminlogin'    => '${ADMIN_USER}',
  'adminpass'     => '${ADMIN_PASSWORD}',
EOF
fi
cat >> /nextcloud/config/autoconfig.php <<EOF;
);
?>
EOF

echo "Starting automatic configuration..."
# Execute ownCloud's setup step, which creates the ownCloud database.
# It also wipes it if it exists. And it updates config.php with database
# settings and deletes the autoconfig.php file.
(cd /nextcloud; php index.php &>/dev/null)
echo "Automatic configuration finished."

# Update config.php.
# * trusted_domains is reset to localhost by autoconfig starting with ownCloud 8.1.1,
#   so set it here. It also can change if the box's PRIMARY_HOSTNAME changes, so
#   this will make sure it has the right value.
# * Some settings weren't included in previous versions of Mail-in-a-Box.
# * We need to set the timezone to the system timezone to allow fail2ban to ban
#   users within the proper timeframe
# * We need to set the logdateformat to something that will work correctly with fail2ban
# Use PHP to read the settings file, modify it, and write out the new settings array.

CONFIG_TEMP=$(/bin/mktemp)
php <<EOF > $CONFIG_TEMP && mv $CONFIG_TEMP $CONFIGFILE
<?php
include("/config/config.php");

//\$CONFIG['memcache.local'] = '\\OC\\Memcache\\Memcached';
\$CONFIG['mail_from_address'] = 'administrator'; # just the local part, matches our master administrator address

\$CONFIG['logtimezone'] = '$TZ';
\$CONFIG['logdateformat'] = 'Y-m-d H:i:s';

echo "<?php\n\\\$CONFIG = ";
var_export(\$CONFIG);
echo ";";
?>
EOF

sed -i "s/localhost/$DOMAIN/g" /config/config.php

chown -R $UID:$GID /config /data
# Enable/disable apps. Note that this must be done after the ownCloud setup.
# The firstrunwizard gave Josh all sorts of problems, so disabling that.
# user_external is what allows ownCloud to use IMAP for login. The contacts
# and calendar apps are the extensions we really care about here.
if [[ ! -z "$ADMIN_USER"  ]]; then
  occ app:disable firstrunwizard
fi
