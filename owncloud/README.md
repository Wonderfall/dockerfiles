## wonderfall/owncloud
[![](https://badge.imagelayers.io/wonderfall/owncloud:latest.svg)](https://imagelayers.io/?images=wonderfall/owncloud:latest 'Get your own badge on imagelayers.io')

![](https://i.goopics.net/lu.png)

#### Features
- Based on `debian/jessie`.
- **Lightweight**, even though it's based on Debian, I did my best.
- **Functional by design**, and even through updates.
- **nginx 1.9.10** (mainline) is the webserver.
- **PHP 7.0.3** (latest stable) is used.
- **supervisor** is running the services.
- **OPCache** is configured to provide best performances.
- **system cron** is already configured (you can disable AJAX cron).
- **MySQL/MariaDB** compatibility (server not built-in)
- **Secure installation**, it verifies both integrity and authenticity (sha256sum && gpg).
- **UID/GID flexibility**, so you won't bother about permissions.

#### Tags
- `latest`, `8.2` : ownCloud 8.2.x (actual version : 8.2.2).
- `dev` *(if present)* : don't use it unless you have a reason.

If you want some security, versioning with tags should be available since 8.2 (e.g. the next tags will be 8.3, 8.4, etc. major updates as you can notice). I do not make tags for minor updates, like 8.2.1, 8.2.2, 8.2.x, since it's only bugfixes and security patches, which are strongly recommended.

#### Environment variables
- **USERID** : owncloud user id.
- **GROUPID** : owncloud group id.

#### Volumes
- **/data** : owncloud data (e.g. your files)
- **/config** : configuration files
- **/apps2** : owncloud downloaded apps

#### About the database
You have to use an external database container, thus allowing better security and less complexity. I suggest you to use MySQL/MariaDB, a reliable database server. For instance, you can use the official `mariadb` build, which is very easy to run and of course available on Docker Hub. I decided not to use sqlite since it's not recommended by ownCloud (sqlite is supected to cause some troubles with sync clients).

#### Once runned!
Go to your ownCloud instance, change `/ocwww/data` to `/data` (recommended), and fill in all the fields to configure your database. **Note #1 :** when you mount `/config`, you don't really mount `/ocwww/owncloud/config`. `/config` should contain `config.php`, although this is not the one actually used by ownCloud. However, each time you restart the container, `/config/config.php` overwrites `/ocwww/config/config.php`. Before that, `/ocwww/config/config.php` is copied as `/config/config.php.bkp`, so you can easily revert changes you're not satisfied of. **Note #2 :** this build doesn't make use of https, because I use it behind a reverse proxy (nginx), which is using https. You can do the same, it's easy to setup : take a look at my build `wonderfall/reverse` if you're interested.

#### Configure
Now, ownCloud should be 100% functionnal. APCu was installed and configured before, but I had too many problems using this... on top of that, I didn't notice any performance improvement over Opcache + PHP7. As ownCloud recommends, **system cron is already active**. You should switch from `AJAX cron` to `cron` (system cron) in the admin pannel. By the way, I highly recommend encryption! My buid is fully-compatible with the encryption module. 

*config.php parameters can be found [here](https://doc.owncloud.org/server/8.2/admin_manual/configuration_server/config_sample_php_parameters.html) and [there](https://doc.owncloud.org/server/8.2/admin_manual/installation/apps_management_installation.html)* This is espacially useful when you're using a reverse proxy, and/or if you'd like to keep your 3rd-party plugins across updates (you should use the /apps volume to do that). **READ THE DOCUMENTATION, I WON'T DO SOME MAGIC TRICKS FOR YOU.**

#### How do I update?
Just pull the newer image, and recreate the container. As you may know, backups are highly recommended (don't fear that, Docker just makes things a lot easier!), and even if it's boring, do it, do it, do it! There should be no issue with config.php, but if you see the setup screen, don't panic (your volumes should be intact...) and just restart the container and check `/ocwww/config/config.php`. 

#### config.php (example, behind reverse proxy + external apps path)
```
<?php
$CONFIG = array (
  ...
  'trusted_domains' => 
  array (
    0 => 'owncloud',
    1 => 'your.domain.tld',
  ),
  ...
  "apps_paths" => array (
      0 => array (
              "path"     => "/owncloud/apps",
              "url"      => "/apps",
              "writable" => false,
      ),
      1 => array (
              "path"     => "/apps2",
              "url"      => "/apps2",
              "writable" => true,
      ),
  ),
  ...
  'overwritehost' => 'your.domain.tld',
  'overwriteprotocol' => 'https',
  'updatechecker' => false,
  ...
);
```

#### Docker Compose (example)
```
reverse: # if any
  ...
  links:
    - owncloud:owncloud
  ...

owncloud:
  image: wonderfall/owncloud:8.2
  links:
    - db_owncloud:db_owncloud
  environment:
    - USERID=1000
    - GROUPID=1000
  volumes:
    - /mnt/owncloud/data:/data
    - /mnt/owncloud/config:/config
    - /mnt/owncloud/apps:/apps2

db_owncloud:
  image: mariadb:10
  volumes:
    - /mnt/owncloud/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=owncloud
    - MYSQL_USER=owncloud
    - MYSQL_PASSWORD=supersecretpassword
```

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
