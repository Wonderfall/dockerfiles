## wonderfall/nextcloud


[![](https://images.microbadger.com/badges/version/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/wonderfall/nextcloud:daily.svg)](https://microbadger.com/images/wonderfall/nextcloud:daily "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/wonderfall/nextcloud:daily.svg)](https://microbadger.com/images/wonderfall/nextcloud:daily "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/wonderfall/nextcloud:11.0.svg)](https://microbadger.com/images/wonderfall/nextcloud:11.0 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/wonderfall/nextcloud:11.0.svg)](https://microbadger.com/images/wonderfall/nextcloud:11.0 "Get your own image badge on microbadger.com")

![](https://s32.postimg.org/69nev7aol/Nextcloud_logo.png)

**This image was made for my own use and I have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

### Features
- Based on Alpine Linux.
- Bundled with nginx and PHP 7.1 (wonderfall/nginx-php image).
- Automatic installation using environment variables.
- Package integrity (SHA512) and authenticity (PGP) checked during building process.
- Data and apps persistence.
- OPCache (opcocde), APCu (local) installed and configured.
- system cron task running.
- MySQL, PostgreSQL (server not built-in) and sqlite3 support.
- Redis, FTP, SMB, LDAP, IMAP support.
- GNU Libiconv for php iconv extension (avoiding errors with some apps).
- No root processes. Never.
- Environment variables provided (see below).

### Tags
- **latest** : latest stable version. (12.0)
- **12.0** : latest 12.0.x version (stable)
- **11.0** : latest 11.0.x version (old stable)
- **10.0** : latest 10.0.x version (old stable) (unmaintained)
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
- **MEMORY_LIMIT** : php memory limit *(default : 512M)*
- **CRON_PERIOD** : time interval between two cron tasks *(default : 15m)*
- **CRON_MEMORY_LIMIT** : memory limit for PHP when executing cronjobs *(default : 1024m)*
- **TZ** : the system/log timezone *(default : Etc/UTC)*
- **ADMIN_USER** : username of the admin account *(default : none, web configuration)*
- **ADMIN_PASSWORD** : password of the admin account *(default : none, web configuration)*
- **DOMAIN** : domain to use during the setup *(default : localhost)*
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
- **/nextcloud/themes** : Nextcloud themes location.
- **/php/session** : php session files.

### Database
Basically, you can use a database instance running on the host or any other machine. An easier solution is to use an external database container. I suggest you to use MariaDB, which is a reliable database server. You can use the official `mariadb` image available on Docker Hub to create a database container, which must be linked to the Nextcloud container. PostgreSQL can also be used as well.

### Setup
Pull the image and create a container. `/mnt` can be anywhere on your host, this is just an example. Change `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` values (mariadb). You may also want to change UID and GID for Nextcloud, as well as other variables (see *Environment Variables*).

```
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
       -v /mnt/nextcloud/themes:/nextcloud/themes \
       -e UID=1000 -e GID=1000 \
       -e UPLOAD_MAX_SIZE=10G \
       -e APC_SHM_SIZE=128M \
       -e OPCACHE_MEM_SIZE=128 \
       -e CRON_PERIOD=15m \
       -e TZ=Etc/UTC \
       -e ADMIN_USER=mrrobot \
       -e ADMIN_PASSWORD=supercomplicatedpassword \
       -e DOMAIN=cloud.example.com \
       -e DB_TYPE=mysql \
       -e DB_NAME=nextcloud \
       -e DB_USER=nextcloud \
       -e DB_PASSWORD=supersecretpassword \
       -e DB_HOST=db_nextcloud \
       wonderfall/nextcloud:10.0
```

You are **not obliged** to use `ADMIN_USER` and `ADMIN_PASSWORD`. If these variables are not provided, you'll be able to configure your admin acccount from your browser.

**Below you can find a docker-compose file, which is very useful!**

Now you have to use a **reverse proxy** in order to access to your container through Internet, steps and details are available at the end of the README.md. And that's it! Since you already configured Nextcloud through setting environment variables, there's no setup page.

### ARM-based devices
You will have to build yourself using an Alpine-ARM image, like `orax/alpine-armhf:edge`.

### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).

### Update
Pull a newer image, then recreate the container as you did before (*Setup* step). None of your data will be lost since you're using external volumes. If Nextcloud performed a full upgrade, your apps could be disabled, enable them again.

### Docker-compose
I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run `docker-compose up -d nextcloud-db`, wait some 15 seconds for the database to come up, then run everything with `docker-compose up -d`, that's it! On subsequent runs,  a single `docker-compose up -d` is sufficient!

#### Docker-compose file
Don't copy/paste without thinking! It is a model so you can see how to do it correctly.

```
nextcloud:
  image: wonderfall/nextcloud
  links:
    - nextcloud-db:nextcloud-db   # If using MySQL
    - solr:solr                   # If using Nextant
    - redis:redis                 # If using Redis
  environment:
    - UID=1000
    - GID=1000
    - UPLOAD_MAX_SIZE=10G
    - APC_SHM_SIZE=128M
    - OPCACHE_MEM_SIZE=128
    - CRON_PERIOD=15m
    - TZ=Europe/Berlin
    - ADMIN_USER=admin            # Don't set to configure through browser
    - ADMIN_PASSWORD=admin        # Don't set to configure through browser
    - DOMAIN=localhost
    - DB_TYPE=mysql
    - DB_NAME=nextcloud
    - DB_USER=nextcloud
    - DB_PASSWORD=supersecretpassword
    - DB_HOST=nextcloud-db
  volumes:
    - /mnt/nextcloud/data:/data
    - /mnt/nextcloud/config:/config
    - /mnt/nextcloud/apps:/apps2
    - /mnt/nextcloud/themes:/nextcloud/themes

# If using MySQL
nextcloud-db:
  image: mariadb:10
  volumes:
    - /mnt/nextcloud/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=nextcloud
    - MYSQL_USER=nextcloud
    - MYSQL_PASSWORD=supersecretpassword
    
# If using Nextant
solr:
  image: solr:6-alpine
  container_name: solr
  volumes:
    - /mnt/docker/solr:/opt/solr/server/solr/mycores
  entrypoint:
    - docker-entrypoint.sh
    - solr-precreate
    - nextant

# If using Redis
redis:
  image: redis:alpine
  container_name: redis
  volumes:
    - /mnt/docker/redis:/data
```

You can update everything with `docker-compose pull` followed by `docker-compose up -d`.

### How to configure Redis
Redis can be used for distributed and file locking cache, alongside with APCu (local cache), thus making Nextcloud even more faster. As PHP redis extension is already included, all you have to is to deploy a redis server (you can do as above with docker-compose) and bind it to nextcloud in your config.php file :

```
'memcache.distributed' => '\OC\Memcache\Redis',
'memcache.locking' => '\OC\Memcache\Redis',
'memcache.local' => '\OC\Memcache\APCu',
'redis' => array(
   'host' => 'redis',
   'port' => 6379,
   ),
```

### How to configure Nextant
You will have to deploy a Solr server, I've shown an example above with docker-compose. Once Nextant app is installed, go to "additional settings" in your admin pannel and use http://solr:8983/solr as "Adress of your Solr Servlet". There you go. You may however experience the same issue as mine : https://github.com/nextcloud/server/pull/3160 (let's hope there'll be at least a backport...).

### Tip : how to use occ command
There is a script for that, so you shouldn't bother to log into the container, set the right permissions, and so on. Use `docker exec -ti nexcloud occ command`.

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
