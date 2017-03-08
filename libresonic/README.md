## wonderfall/libresonic

![](https://i.goopics.net/LD38.png)

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
- $HTTS_PORT (example : 4050)

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse

https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration
