## wonderfall/rutorrent
Originally forked from [xataz/rutorrent](https://github.com/xataz/dockerfiles/tree/master/rutorrent).

#### What is this?
This container contains both rtorrent (whis is a BitTorrent client) and rutorrent (which is a front-end for rtorrent). Filebolt is also included, the default behavior is set to create clean symlinks, so media players like Emby/Plex can easily detect your TV shows and movies.

![](https://pix.schrodinger.io/KDVxwnJA/nEMCzJEd.jpg)

#### Main features
- Lightweight, since it's based on Alpine Linux.
- Everything is almost compiled from source.
- Secured, don't bother about configuration files.
- Filebot is included, and creates symlinks in `/data/Media`.
- rutorrent : Material theme by phlo set by default.
- rutorrent : nginx + PHP7.

#### Ports

- **49184** (bind it).
- **80** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)

#### Volumes
- **/data** : your files, symlinks, and so on.
- **/var/www/torrent/share/users** : rutorrent settings.