## wonderfall/mediawiki

Host your own Wiki!

#### Features
- Based on Alpine Linux (wonderfall/nginx-php image)
- Bundled with nginx and PHP7.1.

#### Build-time variables
- **MEDIAWIKI_VER** : Mediawiki version
- **SUB_VERSION** : Mediawiki subversion

#### Environment variables
- **UID** : privatebin user id
- **GID** : privatebin group id
- **MEMORY_LIMIT** : php memorny limit *(default : 128M)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10M)*

#### Volumes
- /mediawiki/images
- /extensions
- /skins
- /config
- /mediawiki/custom

#### Ports
- **8888** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)

#### docker-compose.yml sample

```
mywiki:
  image: wonderfall/mediawiki
  container_name: mywiki
  links:
    - mywiki-db:mywiki-db
    - mywiki-parsoid:mywiki-parsoid
  environment:
    - UPLOAD_MAX_SIZE=20M
    - MEMORY_LIMIT=512M
    - UID=1668
    - GID=1668
  volumes:
    - /mnt/mywiki/images:/mediawiki/images
    - /mnt/mywiki/extensions:/extensions
    - /mnt/mywiki/skins:/skins
    - /mnt/mywiki/config:/config
    - /mnt/mywiki/custom:/mediawiki/custom

mywiki-db:
  image: mariadb:10.1
  container_name: mywiki-db
  volumes:
    - /mnt/mywiki/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecret
    - MYSQL_DATABASE=mywiki
    - MYSQL_USER=mywiki
    - MYSQL_PASSWORD=supersecret

mywiki-parsoid:
  image: wonderfall/parsoid
  container_name: mywiki-parsoid
  environment:
     - UID=1669
     - GID=1669
     - ADDRESS=https://wiki.domain.com/
     - DOMAIN=mywiki-parsoid
```
