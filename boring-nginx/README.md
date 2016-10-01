## wonderfall/boring-nginx

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/115px-Nginx_logo.svg.png)

#### What is this?
It is nginx statically linked against BoringSSL, with embedded Brotli support. Secured by default (no root processes, even the master one), it should be safe to use...

#### Features
- Based on Alpine Linux.
- nginx built against **BoringSSL**.
- nginx : securely built using hardening gcc flags.
- nginx : HTTP/2 (+NPN) support.
- nginx : Brotli compression support (and configured).
- nginx : no root master process.
- nginx : AIO Threads support.
- nginx : no unnessary modules (except fastcgi).
- nginx : pcre jit enabled.
- nginx : optimized configuration.
- ngxpasswd : generates a htpasswd file easily.
- ngxproxy : generates a *proxy vhost* after asking you a few questions.

#### Notes
- It is required to change the `listen` directive to 8000/4430 instead of 80/443.
- Linux 3.17+, and the latest Docker stable are recommended.
- BoringSSL is naming ECDH curves differently, some modifications will be required if you want to use your own SSL/TLS config file. For example, `secp384r1` (OpenSSL, LibreSSL) is `P-384` (BoringSSL). BoringSSL does support multiple curves with its implementation of `SSL_CTX_set1_curves_list()`, an example is provided in the default `/etc/nginx/confssl_params`. `X25519` is actually the safest curve you can use so it should be the first curve in your list.
- BoringSSL can use cipher groups : a group is defined by brackets and ciphers are separated by `|` like this : `[cipher1|cipher2|cipher3]`. Ciphers in a group are considered equivalent on the server-side and let the client decide which cipher is the best. This can be useful when using ChaCha20, because AES remains faster than ChaCha20 on AES-NI devices.

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

You can use `ngxproxy` to generate a *vhost* through an easy process : `docker exec -ti nginx ngxproxy`. `ngxpasswd` can generate htpasswd files : `docker exec -ti nginx ngxpasswd`. Both utilites are interactive so you won't feel lost.

Some configuration files located in `/etc/nginx/conf` are already provided, you can use them with the `include` directive.

- `ssl_params` : Provides a nice balance between compatibility and security.
- `headers_params` : HSTS (+ preload), XSS protection, etc.
- `proxy_params` : use with `proxy_pass`.
