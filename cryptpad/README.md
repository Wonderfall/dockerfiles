## wonderfall/cryptpad

The Zero Knowledge Cloud.

#### Features
- Based on Alpine Linux
- Bundled with latest node.js available.

#### Build-time variables
- **VERSION** : version of Cryptpad

#### Environment variables
- **UID** : user id *(default : 991)*
- **GID** : group id *(default : 991)*

#### Volumes
- **/cryptpad/datastore** : Cryptpad data
- **/cryptpad/customize** : Cryptpad custom files

#### Ports
- **3000** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)

#### docker-compose.yml sample

```
cryptpad:
  image: wonderfall/cryptpad
  container_name: cryptpad
  environment:
    - UID=1444
    - GID=1444
  volumes:
    - /mnt/docker/cryptpad/files:/cryptpad/datastore
    - /mnt/docker/cryptpad/customize:/cryptpad/customize
```
