## wonderfall/rtorrent-flood

#### Main features
- Lightweight, since it's based on Alpine Linux.
- Everything is almost compiled from source.
- Secured, don't bother about configuration files.
- Filebot is included, and creates symlinks in `/data/Media`.
- Flood WebUI

#### Ports

- **49184** (bind it).
- **3000** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)

#### Volumes
- **/data** : your files, symlinks, and so on.
