## wonderfall/freshrss

A free, self-hostable aggregator : https://github.com/FreshRSS/FreshRSS

#### Features
- Based on Alpine Linux (wonderfall/nginx-php image)
- Bundled with nginx and PHP7.1.

#### Build-time variables
- **FRESHRSS_VER** : version of FreshRSS

#### Environment variables
- **UID** : user id
- **GID** : group id
- **MEMORY_LIMIT** : php memory limit *(default : 128M)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10M)*

#### Volumes
- **/freshrss/data**

#### Ports
- **8888** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)
