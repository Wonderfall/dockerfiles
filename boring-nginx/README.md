## wonderfall/boring-nginx

![](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/115px-Nginx_logo.svg.png)

#### What is this?
This is nginx statically linked against BoringSSL, with embedded Brotli support.

#### Features
- Based on Alpine Linux.
- nginx built against **BoringSSL** with SSE/SHA, and AVX2 SIMD-instructions.
- **TLS 1.3** patch : use of TLS 1.3 DRAFT is enforced (haven't found another way yet).
- Built using hardening gcc flags.
- Dynamic TLS records patch (cloudflare).
- TTP/2 (+NPN) support.
- Brotli compression support (and configured).
- No root master process.
- AIO Threads support.
- No unnessary modules (except fastcgi).
- PCRE-jit enabled.
- Strong configurations included.
- Anonymous webserver signature (headers-more).
- ngxpasswd : generates a htpasswd file.
- ngxproxy : generates a proxy virtual host file.

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
- **BUILD_CORES** : number of cores used during compilation

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
