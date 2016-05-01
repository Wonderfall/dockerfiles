## wonderfall/subsonic

![](https://i.goopics.net/lr.png)

#### What is Subsonic?
Subsonic is an open-source web-based media streamer and jukebox. Supports MP3, OGG, AAC and other streamable audio and video formats. Indeed, this build comes with **transcoding abilities**.

#### Environment variables
- **GID** : subsonic group id.
- **UID** : subsonic user id.

#### Volumes
- **/musics** : your music files
- **/data** : subsonic data

#### Docker Compose (example)
```
subsonic:
  image: wonderfall/subsonic
  volumes: 
    - /mnt/music:/musics
    - /mnt/subsonic:/data
  environment:
    - GID=1000
    - UID=1000
```

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
Working configuration with HTTPS :

```
  location / {
      proxy_pass http://subsonic:4040;
      proxy_set_header        X-Real-IP            $remote_addr;
      proxy_set_header        X-Forwarded-For      $proxy_add_x_forwarded_for;
      proxy_set_header        X-Remote-Port        $remote_port;
      proxy_set_header        X-Forwarded-Proto    $scheme;
  }
```
