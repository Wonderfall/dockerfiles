## wonderfall/reverse

![](https://i.goopics.net/lv.jpg) ![](https://i.goopics.net/lL.png) ![](https://upload.wikimedia.org/wikipedia/en/2/25/LibreSSL_logo.jpg)

#### What is this?
It is nginx statically linked against LibreSSL, with embedded Brotli support. Secured by default (no root processes, even the master one).

#### Features
- Based on Alpine Linux.
- nginx built against LibreSSL.
- HTTP/2 support.
- Brotli compression support.
- No root master process.
- AIO Threads support.
- No unnessary modules.
- Optimized nginx configuration.

#### Notes
It is required to :

- chown your certs files with the right uid/pid
- change `listen` directive to 8000/4430 instead of 80/443

LibreSSL recommends Linux 3.17+.

#### Volumes
- **/sites-enabled** : vhosts files (*.conf)
- **/conf.d** : additional configuration files
- **/certs** : SSL/TLS certificates
- **/var/log/nginx** : nginx logs
- **/passwds** : authentication files

#### Build-time variables
- **NGINX_VERSION** : version of nginx
- **LIBRESSL_VERSION** : version of LibreSSL

#### Environment variables
- **GID** : nginx group id *(default : 991)*
- **UID** : nginx user id *(default : 991)*

#### How to use it?
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration
