## wonderfall/reverse

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/115px-Nginx_logo.svg.png)

#### What is this?
It is nginx statically linked against BoringSSL, with embedded Brotli support. Secured by default (no root processes, even the master one), it should be safe to use...

#### Features
- Based on Alpine Linux.
- nginx built against BoringSSL.
- nginx : HTTP/2 (+NPN) support.
- nginx : Brotli compression support (and configured).
- nginx : no root master process.
- nginx : AIO Threads support.
- nginx : no unnessary modules (except fastcgi).
- nginx : pcre jit enabled.
- nginx : optimized configuration.

#### Notes
It is required to chown your certs files with the right uid/pid and change the `listen` directive to 8000/4430 instead of 80/443. Linux 3.17+, and the latest Docker stable are recommended.

#### Volumes
- **/sites-enabled** : vhosts files (*.conf)
- **/conf.d** : additional configuration files
- **/certs** : SSL/TLS certificates
- **/var/log/nginx** : nginx logs
- **/passwds** : authentication files
- **/www** : put your websites there

#### Build-time variables
- **NGINX_VERSION** : version of nginx
- **GPG_NGINX** : fingerprint of signing key package
- **SIGNATURE** : HTTP signature of nginx, default is *secret*

#### Environment variables
- **GID** : nginx group id *(default : 991)*
- **UID** : nginx user id *(default : 991)*

#### How to use it?
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration

Some configuration files located in `/etc/nginx/conf` are already provided, you can use them with the `include` directive.

- `ssl_params` : TLS (1.0, 1.1, 1.2), CHACHA20, AES 256/128. Balance between compatibility and security.
- `headers_params` : HSTS (+ preload), XSS protection...
- `proxy_params` : useful with `proxy_pass`.
