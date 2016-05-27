## wonderfall/reverse

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/115px-Nginx_logo.svg.png)

![](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/OpenSSL_logo.png/220px-OpenSSL_logo.png)

#### What is this?
It is nginx statically linked against a custom OpenSSL build, with embedded Brotli support. Secured by default (no root processes, even the master one), it should be safe to use...

#### Features
- Based on Alpine Linux.
- nginx built against OpenSSL.
- OpenSSL : no weak algorithms.
- OpenSSL : ChaCha20 ciphers support.
- nginx : HTTP/2 (+NPN) support.
- nginx : Brotli compression support (and configured).
- nginx : no root master process.
- nginx : AIO Threads support.
- nginx : no unnessary modules.
- nginx : optimized configuration.

#### Notes
It is required to chown your certs files with the right uid/pid and change the `listen` directive to 8000/4430 instead of 80/443. Linux 3.17+, and the latest Docker stable are recommended.

#### Volumes
- **/sites-enabled** : vhosts files (*.conf)
- **/conf.d** : additional configuration files
- **/certs** : SSL/TLS certificates
- **/var/log/nginx** : nginx logs
- **/passwds** : authentication files

#### Build-time variables
- **NGINX_VERSION** : version of nginx
- **OPENSSL_VERSION** : version of LibreSSL

#### Environment variables
- **GID** : nginx group id *(default : 991)*
- **UID** : nginx user id *(default : 991)*

#### How to use it?
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration
Some configuration files located in `/conf.d` are already provided, you can use them with the `include` directive. `ssl_params_d.conf` and `headers_params_d.conf` provide strong security, please check before or make your own configuration files...
