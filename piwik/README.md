## wonderfall/piwik

![](https://i.goopics.net/m3.png)

#### What is this?
It is a web analytics platform. Piwik respects your privacy and gives you full control over your data.

#### Features
- Based on Alpine Linux.
- Latest Piwik stable.
- nginx stable + PHP7.
- mysql drivers (server not built-in).
- Latest GeoLite City Database from maxmind.com.

#### Build-time variables
- **VERSION** : version of Piwik
- **GPG_matthieu** : fingerprint of signing key

#### Environment variables
- **GID** : piwik group id *(default : 991)*
- **UID** : piwik user id *(default : 991)*

#### Volumes
- **/config** : configuration files

#### Update
Piwik can update itself. It works well. I'm also maintaing this Dockerfile, so if you don't want to do upgrades directly from Piwik, you can recreate the container as well whenever I push an update.

#### Configuration
According to Piwik, everything should be fine running this image. You shoudn't have any difficulties to setup your own instance of Piwik. Your `/config/config.ini.php` overwrites the one (in `/piwik/config`)used by Piwik each time the container is started. Moreover, the old config.ini.php is saved as `/config/config.ini.php.bkp` if you want to revert last changes. This should also guarantee transparency through Piwik's updates.

If you're running Piwik behind a reverse proxy (most likely you do), add this to your `config.ini.php` :

```
[General]
#assume_secure_protocol = 1 #uncomment if you use https
proxy_client_headers[] = HTTP_X_FORWARDED_FOR
proxy_client_headers[] = HTTP_X_REAL_IP
proxy_host_headers[] = HTTP_X_FORWARDED_HOST
```

#### Reverse proxy
Use port **8888**.
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration

#### Docker Compose (example)
```
piwik:
  image: wonderfall/piwik
  links:
    - db_piwik:db_piwik
  volumes:
    - /mnt/docker/piwik/config:/config
  environment:
    - GID=1000
    - UID=1000

db_piwik:
  image: mariadb:10
  volumes:
    - /mnt/docker/piwik/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=asupersecretpassword
    - MYSQL_DATABASE=piwik
    - MYSQL_USER=piwik
    - MYSQL_PASSWORD=asupersecretpassword
```
