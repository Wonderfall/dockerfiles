## wonderfall/subsonic
[![](https://badge.imagelayers.io/wonderfall/subsonic:latest.svg)](https://imagelayers.io/?images=wonderfall/subsonic:latest 'Get your own badge on imagelayers.io')

![](https://i.goopics.net/lr.png)

#### What is Subsonic?
Subsonic is an open-source web-based media streamer and jukebox. Supports MP3, OGG, AAC and other streamable audio and video formats. Indeed, this build comes with **transcoding abilities**.

#### Tags
- **Stable 5.x** : `5.3`, `latest`, `old-5.3`
- **Beta 6.0** : `6.0b1`, `6`

#### Environment variables
- **GID** : subsonic group id.
- **UID** : subsonic user id.

#### Volumes
- **/musics** : your music files
- **/data** : subsonic data
- **/playlists** : subsonic playlists

#### Known issues (only with alpine) :
- Can't retrieve pictures through TLS (although it's not automatic, you have to choose clear-HTTP sources only when picking a cover picture) -> **fixed !**
- "Default covers" (when no cover image is detected) are not generated (not sure it's a problem since I find this feature useless... such ugly fonts/colors)

#### Docker Compose (example)
```
subsonic:
  image: wonderfall/subsonic
  volumes: 
    - /mnt/music:/musics
    - /mnt/subsonic:/data
    - /mnt/playlists:/playlists
  environment:
    - GID=1000
    - UID=1000
```

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
Fully working configuration with TLS :

```
  location / {
      proxy_pass http://subsonic:4040;
      proxy_set_header        X-Real-IP            $remote_addr;
      proxy_set_header        X-Forwarded-For      $proxy_add_x_forwarded_for;
      proxy_set_header        X-Remote-Port        $remote_port;
      proxy_set_header        X-Forwarded-Proto    $scheme;
  }
```
