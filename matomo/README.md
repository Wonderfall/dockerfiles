## hoellen/matomo

#### What is this?
It is a web analytics platform. Matomo respects your privacy and gives you full control over your data.

#### Features
- Based on wonderfall/dockerfiles (Thanks!)
- Based on Alpine Linux.
- Latest Matomo stable.
- nginx stable + PHP7.
- mysql drivers (server not built-in).
- Latest GeoLite City Database from maxmind.com.

#### Build-time variables
- **VERSION** : version of Matomo
- **GPG_matthieu** : fingerprint of signing key

#### Environment variables
- **GID** : matomo group id *(default : 991)*
- **UID** : matomo user id *(default : 991)*

#### Volumes
- **/config** : configuration files

#### Update
Matomo can update itself. It works well. I'm also maintaing this Dockerfile, so if you don't want to do upgrades directly from Matomo, you can recreate the container as well whenever I push an update.

#### Configuration
According to Matomo, everything should be fine running this image. You shoudn't have any difficulties to setup your own instance of Matomo. Your `/config/config.ini.php` overwrites the one (in `/matomo/config`)used by Matomo each time the container is started. Moreover, the old config.ini.php is saved as `/config/config.ini.php.bkp` if you want to revert last changes. This should also guarantee transparency through Matomo's updates.

If you're running Matomo behind a reverse proxy (most likely you do), add this to your `config.ini.php` :

```
[General]
#assume_secure_protocol = 1 #uncomment if you use https
proxy_client_headers[] = HTTP_X_FORWARDED_FOR
proxy_client_headers[] = HTTP_X_REAL_IP
proxy_host_headers[] = HTTP_X_FORWARDED_HOST
```

#### Reverse proxy
Use port **8888**.
https://github.com/hoellen/dockerfiles/tree/master/boring-nginx

#### Docker Compose (example)
```
matomo:
  image: hoellen/matomo
  links:
    - db_matomo:db_matomo
  volumes:
    - /mnt/docker/matomo/config:/config
  environment:
    - GID=1000
    - UID=1000

db_matomo:
  image: mariadb:10
  volumes:
    - /mnt/docker/matomo/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=asupersecretpassword
    - MYSQL_DATABASE=matomo
    - MYSQL_USER=matomo
    - MYSQL_PASSWORD=asupersecretpassword
```
