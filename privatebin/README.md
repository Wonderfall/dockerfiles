## wonderfall/privatebin

Paste securely.

#### Features
- Based on Alpine Linux.
- Uses [PrivateBin](https://github.com/PrivateBin/PrivateBin), originally a fork of zerobin by elrido.
- Bundled with nginx and PHP7.

#### Environment variables
- **UID** : zerobin user id
- **GID** : zerobin group id

#### Volumes
- **/zerobin/data**

#### Ports
- **80** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)
