## wonderfall/rutorrent
Originally forked from [xataz/rutorrent](https://github.com/xataz/dockerfiles/tree/master/rutorrent).

#### What is this?
This container contains both rtorrent (whis is a BitTorrent client) and rutorrent (which is a front-end for rtorrent). Filebolt is also included, the default behavior is set to create clean symlinks, so media players like Emby/Plex can easily detect your TV shows and movies.


#### Main features
- Lightweight, since it's based on Alpine Linux.
- Everything is almost compiled from source.
- Secured, don't bother about configuration files.
- Filebot is included, and creates symlinks in /data/Media.
- FlatUI themes for rutorrent are included.

#### Ports
There's one port to bind to your host (both tcp/udp) : 49184 (arbitrary chosen).

#### Volumes
- **/data** : your files, symlinks, etc. everything you must care of.
- **/var/www/torrent/share/users** : rutorrent settings, as you don't want them to go away each time you update the container.

#### How to use it?
Basically you just have to run the container behind a reverse proxy.
This may help you : https://hub.docker.com/r/wonderfall/reverse/

Here is an example of a docker-compose.yml file :

```
nginx:
  image: wonderfall/reverse:1.9
  container_name: nginx
  environment:
    - UID=1000
    - GID=1000
  ports:
    - "80:8000"
    - "443:4430"
  links:
    - rutorrent:rutorrent
  volumes:
    - /home/docker/nginx/sites:/sites-enabled
    - /home/docker/nginx/conf:/conf.d
    - /home/docker/nginx/passwds:/passwds
    - /home/docker/nginx/log:/var/log/nginx
    - /home/docker/nginx/certs:/certs
    
rutorrent:
  image: wonderfall/rutorrent
  container_name: rutorrent
  environment:
    - WEBROOT=/
    - UID=1000
    - GID=1000
  ports:
    - "49184:49184"
    - "49184:49184/udp"
  volumes:
    - /home/user/seedbox:/data
    - /home/user/seedbox/rutorrent:/var/www/torrent/share/users
```
