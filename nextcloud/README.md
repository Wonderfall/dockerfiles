## wonderfall/nextcloud

[![](https://images.microbadger.com/badges/version/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own image badge on microbadger.com")

![](https://s32.postimg.org/69nev7aol/Nextcloud_logo.png)

:warning: [It has been reported](https://github.com/Wonderfall/dockerfiles/issues/37) that his image might not work well with old versions of aufs. Please update aufs to 4.x or later, or use overlay/btrfs as a replacement.

:warning: HTTP port has recently changed, it's now **8888**. You will have to modify your reverse proxy settings.

#### Features
- Based on Alpine Linux.
- Bundled with nginx and PHP 7.
- Package integrity and authenticity checked during building process.
- Data and apps persistence.
- OPCache & APCu already configured.
- system cron task running.
- MySQL, PostgreSQL (server not built-in) and sqlite3 support.
- Redis, FTP, SMB, LDAP support.
- GNU Libiconv for php iconv extension (avoiding errors with some apps).
- No root processes. Never.
- Environment variables provided (see below).

#### Tags
- **latest** : latest stable version.
- **10.0** : latest 10.0.x version (stable)
- **9.0** : latest 9.0.x version. (old stable)
- **daily** : latest code (daily build).

Other tags than `daily` are built weekly. For security reasons, you should occasionally update the container, even if you have the latest version of Nextcloud.

#### Build-time variables
- **NEXTCLOUD_VERSION** : version of nextcloud
- **GNU_LIBICONV_VERSION** : version of GNU Libiconv
- **GPG_nextcloud** : signing key fingerprint

#### Environment variables
- **UID** : nextcloud user id *(default : 991)*
- **GID** : nextcloud group id *(default : 991)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10G)*
- **APC_SHM_SIZE** : apc memory size *(default : 128M)*
- **OPCACHE_MEM_SIZE** : opcache memory size in megabytes *(default : 128)*
- **CRON_PERIOD** : time interval between two cron tasks *(default : 15m)*
- **TZ** : The log timezone *(default : Europe/Berlin)*
- **ADMIN_USER** : Username of the administrator user *(default : admin)*
- **ADMIN_PASSWORD** : Password of the administrator user *(default : admin)*
- **DB_TYPE** : Database type (sqlite3, mysql or pgsql) *(default : sqlite3)*
- **DB_NAME** : Name of database *(default : none)*
- **DB_USER** : Username for database *(default : none)*
- **DB_PASSWORD** : Password for database user *(default : none)*
- **DB_HOST** : Database host *(default : none)*

#### Port
- **8888**

#### Volumes
- **/data** : Nextcloud data.
- **/config** : config.php location.
- **/apps2** : Nextcloud downloaded apps.

#### Database
Basically, you can use a database instance running on the host or any other machine. An easier solution is to use an external database container. I suggest you to use MariaDB, which is a reliable database server. You can use the official `mariadb` image available on Docker Hub to create a database container, which must be linked to the Nextcloud container. PostgreSQL can also be used as well.

#### Setup
Pull the image and create a container. `/mnt` can be anywhere on your host, this is just an example. Change MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD values (mariadb). You may also want to change UID and GID (nextcloud).

````
docker pull wonderfall/nextcloud && docker pull mariadb:10
docker run -d --name db_nextcloud -v /mnt/nextcloud/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=supersecretpassword -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=supersecretpassword mariadb:10
docker run -d --name nextcloud --link db_nextcloud:db_nextcloud -e UID=1000 -e GID=1000 -e DB_NAME=nextcloud -e DB_USER=nextcloud -e DB_PASSWORD=supersecretpassword -e DB_HOST=db_nextcloud -v /mnt/nextcloud/data:/data -v /mnt/nextcloud/config:/config -v /mnt/nextcloud/apps:/apps2 wonderfall/nextcloud
```

**Below you can find a docker-compose file, which is very useful!**

Now you have to use a **reverse proxy** in order to access to your container through Internet, steps and details are available at the end of the README.md.

Browse to Nextcloud setup page, then fill in the following fields :
- **Data folder** : change `/nextcloud/data` to `/data` (should be `/data` by default).
- **Database** :
  - user : MYSQL_USER.
  - password : MYSQL_PASSWORD.
  - name : MYSQL_DATABASE.
  - host : name of the mariadb container.
- **Don't forget** : use strong passwords, choose another name for the admin account.

#### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).
To **enable APCU**, add this line to your config.php :

```
  'memcache.local' => '\OC\Memcache\APCu',
```

Add the following lines to your `config.php` in order to enable apps persistence :

```
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
```

#### Update
Pull a newer image, then recreate the container :

```
docker pull wonderfall/nextcloud
docker rm nextcloud
docker run -d --name nextcloud --link db_nextcloud:db_nextcloud -e UID=1000 -e GID=1000 -v /mnt/nextcloud/data:/data -v /mnt/nextcloud/config:/config -v /mnt/nextcloud/apps:/apps2 wonderfall/nextcloud
```

If Nextcloud performed a full upgrade, your apps could be disabled. Enable them again.

#### Docker-compose

I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run `docker-compose up -d nextcloud-db`, wait some 15 seconds for the database to come up, then run everything with `docker-compose up -d`, that's it! On subsequent runs,  a single `docker-compose up -d` is sufficient!

```
version: '2'

volumes:
  nextcloud-db-data:
  nextcloud-data:
  nextcloud-config:
  nextcloud-apps:

services:
  nextcloud-db:
    image: mariadb
    volumes:
      - nextcloud-db-data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=1234
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=foo5678

  nextcloud:
    image: wonderfall/nextcloud
    environment:
      - UID=1000
      - GID=1000
      - UPLOAD_MAX_SIZE=10G
      - APC_SHM_SIZE=128M
      - OPCACHE_MEM_SIZE=128
      - CRON_PERIOD=15m
      - TZ=Europe/Berlin
      - ADMIN_USER=admin
      - ADMIN_PASSWORD=admin
      - DB_TYPE=mysql
      - DB_NAME=nextcloud
      - DB_USER=nextcloud
      - DB_PASSWORD=foo5678
      - DB_HOST=nextcloud-db
    depends_on:
      - nextcloud-db
    volumes:
      - nextcloud-data:/data
      - nextcloud-config:/config
      - nextcloud-apps:/apps2
    ports:
      - 8888:8888
```
You can update everything with `docker-compose pull` followed by `docker-compose up -d`.

#### Reverse proxy
If you're using nginx, there are two possibilites :

- nginx is on the host : get the Nextcloud container IP address with `docker inspect nextcloud | grep IPAddress\" | head -n1 | grep -Eo "[0-9.]+" `. But whenever the container is restarted or recreated, its IP address can change.

- nginx is in a container, things are easier : https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration (example). If you don't get it : **nextcloud is linked to nginx** (like containers) so you can use `proxy_pass http://nextcloud:8888`. If you're interested, I provide a nginx image available on Docker Hub : `wonderfall/nginx`.

Headers are already sent by the container, including HSTS, so there's no need to add them again. **It is strongly recommended to use Nextcloud through an encrypted connection (HTTPS).** [Let's Encrypt](https://letsencrypt.org/) provides free SSL/TLS certificates (trustworthy!).
