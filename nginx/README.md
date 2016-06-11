## wonderfall/nginx

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/115px-Nginx_logo.svg.png)

#### What is this?
It is nginx statically linked against LibreSSL, with the following modules embedded : ngx_brotli (Brotli compression support) and headers_more. Secured by default (no root processes, even the master one), so it should be safe to use.

#### Features
- Based on Alpine Linux Edge.
- nginx built against **LibreSSL**.
- nginx : Cloudfare's SPDY patch.
- nginx : Cloudfare's dynamic TLS records patch.
- nginx : securely built using hardening gcc flags.
- nginx : HTTP/2 (+NPN) support.
- nginx : Brotli compression support (and configured).
- nginx : Headers More module.
- nginx : no root master process.
- nginx : AIO Threads support.
- nginx : no unnessary modules (except fastcgi).
- nginx : pcre-jit enabled.
- nginx : optimized configuration.
- ngxpasswd : generates a htpasswd file easily.
- ngxproxy : generates a *proxy vhost* after asking you a few questions.

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
- **LIBRESSL_VERSION** : version of LibreSSL
- **GPG_NGINX** : fingerprint of signing key package
- **GPG_LIBRESSL** : fingerprint of signing key package
- **BUILD_CORES** : number of cores you'd like to build with (default : all)

#### Environment variables
- **GID** : nginx group id *(default : 991)*
- **UID** : nginx user id *(default : 991)*

#### How to use it?
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration

You can use `ngxproxy` to generate a *vhost* through an easy process : `docker exec -ti nginx ngxproxy`. `ngxpasswd` can generate htpasswd files : `docker exec -ti nginx ngxpasswd`. Both utilites are interactive so you won't feel lost.

Some configuration files located in `/etc/nginx/conf` are already provided, you can use them with the `include` directive.

- `ssl_params` : Provides a nice balance between compatibility and security.
- `headers_params` : HSTS (+ preload), XSS protection, etc.
- `proxy_params` : use with `proxy_pass`.
