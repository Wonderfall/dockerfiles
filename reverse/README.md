## wonderfall/reverse
**SIZE : ±39MB**

![](https://i.goopics.net/lv.jpg) ![](https://i.goopics.net/lL.png) ![](https://upload.wikimedia.org/wikipedia/en/2/25/LibreSSL_logo.jpg)

#### What is this?
It is nginx latest mainline statically linked against LibreSSL latest snapshot, with embedded Brotli support.
Secured by default (no root processes, even the master one). I made this image for my own purpose, but I added some flexibility so you can use it easily.

#### Features
- Based on Alpine Linux (3.3) : lightweight and secure distribution.
- nginx mainline + LibreSSL snapshot
- HTTP/2 support.
- Brotli compression support.
- No root master process. Better security.
- AIO Threads support.
- No unnessary modules.
- Optimized nginx configuration.

#### Notes
It is required to :
- chown your certs files with the right uid/pid (no other way)
- change `listen` directive to 8000/4430 instead of 80/443

By the way, it is recommended to **build this image** (using docker-compose 1.6 and later for args compatibily) directly instead of pulling it from Docker Hub.

#### Volumes
- **/sites-enabled** : should contain your vhosts files (.conf)
- **/conf.d** : additional configuration files if you want
- **/certs** : SSL/TLS certificates
- **/var/log/nginx** : nginx logs (access and error)

#### Build arguments
- **NGINX_VER** : nginx's version, change it if needed but the default version is tested
- **LIBRESSL_VER** : same as NGINX_VER
- **GID** : nginx group id *(default : 991)*
- **UID** : nginx user id *(default : 991)*

#### Source (Dockerfile)
https://github.com/Wonderfall/dockerfiles/tree/master/reverse

#### Examples : compose, vhost, TLS conf

**NOTES** : 
- compose file must use version 2. [See more here](https://docs.docker.com/compose/compose-file/#version-2:91de898b5f5cdb090642a917d3dedf68).
- Docker 1.10+ and docker-compose 1.6+ are needed.
- if you're using docker-compose inside a container, pay attention to `context`.

```
# docker-compose.yml
nginx:
  #image: wonderfall/reverse
  build:
    context: /path/to/reverse/dockerfile
    dockerfile: Dockerfile
    args:
      - NGINX_VER=1.9.10
      - LIBRESSL_VER=2.3.2
      - GID=1000
      - UID=1000
      - BUILD_CORES=8
  ports:
    - "80:8000"
    - "443:4430"
  links:
    - container_1:container_1
    - container_2:container_2
    - container_n:container_n
  volumes:
    - /mnt/docker/nginx/sites:/sites-enabled
    - /mnt/docker/nginx/conf:/conf.d
    - /etc/letsencrypt:/certs
    - /mnt/docker/nginx/log:/var/log/nginx
```

```
# /mnt/docker/nginx/sites/service.conf
server {
  listen 8000;
  server_name service.domain.tld;
  return 301 https://$host$request_uri;
}

server {
  listen 4430 ssl http2;
  server_name service.domain.tld;
  ssl_certificate /certs/live/service.domain.tld/fullchain.pem;
  ssl_certificate_key /certs/live/service.domain.tld/privkey.pem;
  include /conf.d/ssl_params.conf;
  include /conf.d/headers.conf;
  #client_max_body_size 10M; #(M = Megabytes / G = Gigabytes)

  location / {
      proxy_pass http://container_n:$PORT;
      proxy_set_header        Host                 $host;
      proxy_set_header        X-Real-IP            $remote_addr;
      proxy_set_header        X-Forwarded-For      $proxy_add_x_forwarded_for;
      proxy_set_header        X-Remote-Port        $remote_port;
      proxy_set_header        X-Forwarded-Proto    $scheme;
      proxy_redirect          off;
  }
}
```

```
# /mnt/docker/conf/ssl_params.conf
ssl_protocols TLSv1.2;
ssl_ciphers "ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256";
ssl_prefer_server_ciphers on;
ssl_ecdh_curve secp384r1;

ssl_session_cache shared:SSL:10m;
ssl_session_timeout 5m;
ssl_session_tickets off;
```

```
# /mnt/docker/conf/headers.conf
add_header Strict-Transport-Security "max-age=31536000";
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
```
