## wonderfall/libresonic

![](https://img.targaryen.house/wMkrBCxj/Fv8JINdd.png)

#### What is Libresonic?
Libresonic is an open-source web-based media streamer and jukebox. Supports MP3, OGG, AAC and other streamable audio and video formats. Indeed, this build comes with **transcoding abilities**. More info here : https://libresonic.github.io/

#### Build-time variables
- **VERSION** : version of libresonic

#### Environment variables
- **GID** : subsonic group id.
- **UID** : subsonic user id.
- **HTTPS_PORT** : set if you access Libresonic through HTTPS *(default : 0 = disabled)*

#### Volumes
- **/musics** : your music files
- **/data** : subsonic data

#### Port
- 4040

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse

https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration

Libresonic does not support SSL/TLS by itself. If you want to use Libresonic through https, this is what I'm using :

```
  location / {
    proxy_pass http://libresonic:4040;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Real-IP         $remote_addr;
    proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header Host              $http_host;
    proxy_max_temp_file_size           0;
    proxy_redirect                     http:// https://;
  }
```
