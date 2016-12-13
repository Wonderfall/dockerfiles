## wonderfall/nextcloud

[![](https://images.microbadger.com/badges/version/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own image badge on microbadger.com")

![](https://s32.postimg.org/69nev7aol/Nextcloud_logo.png)

### Features
- Based on Alpine Linux Edge.
- Bundled with nginx and PHP 7.
- Automatic installation using environment variables.
- Package integrity and authenticity checked during building process.
- Data and apps persistence.
- OPCache (opcocde), APCu (local), Redis (file locking) installed and configured.
- system cron task running.
- MySQL, PostgreSQL (server not built-in) and sqlite3 support.
- Redis, FTP, SMB, LDAP support.
- GNU Libiconv for php iconv extension (avoiding errors with some apps).
- No root processes. Never.
- Environment variables provided (see below).

### Notes
- [It has been reported](https://github.com/Wonderfall/dockerfiles/issues/37) that this image might not work well with old versions of aufs. Please update aufs to 4.x or later, or use overlay/btrfs as a replacement.
- HTTP port has recently changed, it's now **8888**. You will have to modify your reverse proxy settings.
- A Redis sever is now running, so you may want to configure it for file locking cache if your config.php was not generated recently. [For best performance it is recommended by Nextcloud documentation](https://docs.nextcloud.com/server/10/admin_manual/configuration_server/caching_configuration.html#additional-notes-for-redis-vs-apcu-on-memory-caching). Add the following lines to your `config.php` :

```
  'memcache.locking' => '\OC\Memcache\Redis',
   'redis' => array(
        'host' => '/tmp/redis.sock',
        'port' => 0,
        'timeout' => 0.0,
         ),
```

### Tags
- **latest** : latest stable version. (11.0)
- **11.0** : latest 11.0.x version (stable)
- **10.0** : latest 10.0.x version (old stable)
- **9.0** : latest 9.0.x version. (old stable) (unmaintained)
- **daily** : latest code (daily build).

Other tags than `daily` are built weekly. For security reasons, you should occasionally update the container, even if you have the latest version of Nextcloud.

### Build-time variables
- **NEXTCLOUD_VERSION** : version of nextcloud
- **GNU_LIBICONV_VERSION** : version of GNU Libiconv
- **GPG_nextcloud** : signing key fingerprint

### Environment variables
- **UID** : nextcloud user id *(default : 991)*
- **GID** : nextcloud group id *(default : 991)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10G)*
- **APC_SHM_SIZE** : apc memory size *(default : 128M)*
- **OPCACHE_MEM_SIZE** : opcache memory size in megabytes *(default : 128)*
- **REDIS_MAX_MEMORY** : memory limit for Redis *(default : 64mb)*
- **CRON_PERIOD** : time interval between two cron tasks *(default : 15m)*
- **TZ** : the system/log timezone *(default : Etc/UTC)*
- **ADMIN_USER** : username of the admin account *(default : admin)*
- **ADMIN_PASSWORD** : password of the admin account *(default : admin)*
- **DB_TYPE** : database type (sqlite3, mysql or pgsql) *(default : sqlite3)*
- **DB_NAME** : name of database *(default : none)*
- **DB_USER** : username for database *(default : none)*
- **DB_PASSWORD** : password for database user *(default : none)*
- **DB_HOST** : database host *(default : none)*

Don't forget to use a **strong password** for the admin account!

### Port
- **8888** : HTTP Nextcloud port.

### Volumes
- **/data** : Nextcloud data.
- **/config** : config.php location.
- **/apps2** : Nextcloud downloaded apps.
- **/var/lib/redis** : Redis dumpfile location.

### Database
Basically, you can use a database instance running on the host or any other machine. An easier solution is to use an external database container. I suggest you to use MariaDB, which is a reliable database server. You can use the official `mariadb` image available on Docker Hub to create a database container, which must be linked to the Nextcloud container. PostgreSQL can also be used as well.

### Setup
Pull the image and create a container. `/mnt` can be anywhere on your host, this is just an example. Change `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` values (mariadb). You may also want to change UID and GID for Nextcloud, as well as other variables (see *Environment Variables*).

````
docker pull wonderfall/nextcloud:10.0 && docker pull mariadb:10

docker run -d --name db_nextcloud \
       -v /mnt/nextcloud/db:/var/lib/mysql \
       -e MYSQL_ROOT_PASSWORD=supersecretpassword \
       -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud \
       -e MYSQL_PASSWORD=supersecretpassword \
       mariadb:10
       
docker run -d --name nextcloud \
       --link db_nextcloud:db_nextcloud \
       -v /mnt/nextcloud/data:/data \
       -v /mnt/nextcloud/config:/config \
       -v /mnt/nextcloud/apps:/apps2 \
       -e UID=1000 -e GID=1000 \
       -e UPLOAD_MAX_SIZE=10G \
       -e APC_SHM_SIZE=128M \
       -e OPCACHE_MEM_SIZE=128 \
       -e REDIS_MAX_MEMORY=64mb \
       -e CRON_PERIOD=15m \
       -e TZ=Etc/UTC \
       -e ADMIN_USER=mrrobot \
       -e ADMIN_PASSWORD=supercomplicatedpassword \
       -e DB_TYPE=mysql \
       -e DB_NAME=nextcloud \
       -e DB_USER=nextcloud \
       -e DB_PASSWORD=supersecretpassword \
       -e DB_HOST=db_nextcloud \
       wonderfall/nextcloud:10.0
```

**Below you can find a docker-compose file, which is very useful!**

Now you have to use a **reverse proxy** in order to access to your container through Internet, steps and details are available at the end of the README.md. And that's it! Since you already configured Nextcloud through setting environment variables, there's no setup page.

### ARM-based devices
This image is available for `armhf` (Raspberry Pi 1 & 2, Scaleway C1, ...). Although Docker does support ARM-based devices, Docker Hub only builds for x86_64. That's why you will have to build this image yourself! Don't panic, this is easy.

```
git clone https://github.com/Wonderfall/dockerfiles.git
cd dockerfiles/nextcloud/10.0-armhf
docker build -t wonderfall/nextcloud .
```

The building process can take some time.

### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).

### Update
Pull a newer image, then recreate the container as you did before (*Setup* step). None of your data will be lost since you're using external volumes. If Nextcloud performed a full upgrade, your apps could be disabled, enable them again.

### Docker-compose
I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run `docker-compose up -d nextcloud-db`, wait some 15 seconds for the database to come up, then run everything with `docker-compose up -d`, that's it! On subsequent runs,  a single `docker-compose up -d` is sufficient!

#### Docker-compose file V2
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
      - REDIS_MAX_MEMORY=64mb
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
#   ports:
#     - 8888:8888
```

#### Docker-compose file V1
```
nextcloud:
  image: wonderfall/nextcloud
  links:
    - nextcloud-db:nextcloud-db
  environment:
    - UID=1000
    - GID=1000
    - UPLOAD_MAX_SIZE=10G
    - APC_SHM_SIZE=128M
    - OPCACHE_MEM_SIZE=128
    - REDIS_MAX_MEMORY=64mb
    - CRON_PERIOD=15m
    - TZ=Europe/Berlin
    - ADMIN_USER=admin
    - ADMIN_PASSWORD=admin
    - DB_TYPE=mysql
    - DB_NAME=nextcloud
    - DB_USER=nextcloud
    - DB_PASSWORD=supersecretpassword
    - DB_HOST=nextcloud-db
  volumes:
    - /mnt/nextcloud/data:/data
    - /mnt/nextcloud/config:/config
    - /mnt/nextcloud/apps:/apps2

nextcloud-db:
  image: mariadb:10
  volumes:
    - /mnt/nextcloud/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=nextcloud
    - MYSQL_USER=nextcloud
    - MYSQL_PASSWORD=supersecretpassword
```

You can update everything with `docker-compose pull` followed by `docker-compose up -d`.

### Reverse proxy
Of course you can use your own solution to do so! nginx, Haproxy, Caddy, h2o, there's plenty of choices and documentation about it on the Web.

Personally I'm using nginx, so if you're using nginx, there are two possibilites :

- nginx is on the host : get the Nextcloud container IP address with `docker inspect nextcloud | grep IPAddress\" | head -n1 | grep -Eo "[0-9.]+" `. But whenever the container is restarted or recreated, its IP address can change. Or you can bind Nextcloud HTTP port (8888) to the host (so the reverse proxy can access with `http://localhost:8888` or whatever port you set), but in this case you should consider using a firewall since it's also listening to `http://0.0.0.0:8888`.

- nginx is in a container, things are easier : you can link nextcloud container to an nginx container so you can use `proxy_pass http://nextcloud:8888`. If you're interested, I provide a nginx image available on Docker Hub : `wonderfall/boring-nginx`, and it comes with a script called `ngxproxy`, which does all the magic after asking you a few questions. Otherwise, an example of configuration would be :

```
server {
  listen 8000;
  server_name example.com;
  return 301 https://$host$request_uri;
}

server {
  listen 4430 ssl http2;
  server_name example.com;

  ssl_certificate /certs/example.com.crt;
  ssl_certificate_key /certs/example.com.key;

  include /etc/nginx/conf/ssl_params.conf;

  client_max_body_size 10G; # change this value it according to $UPLOAD_MAX_SIZE

  location / {
    proxy_pass http://nextcloud:8888;
    include /etc/nginx/conf/proxy_params;
  }
}
```


Headers are already sent by the container, including HSTS, so there's no need to add them again. **It is strongly recommended to use Nextcloud through an encrypted connection (HTTPS).** [Let's Encrypt](https://letsencrypt.org/) provides free SSL/TLS certificates (trustworthy!).
