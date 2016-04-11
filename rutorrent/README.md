# RuTorrent Image

## ImageLayer
* latest [![](https://badge.imagelayers.io/xataz/rutorrent:latest.svg)](https://imagelayers.io/?images=xataz/rutorrent:latest 'Get your own badge on imagelayers.io')
* latest-filebot, filebot [![](https://badge.imagelayers.io/xataz/rutorrent:filebot.svg)](https://imagelayers.io/?images=xataz/rutorrent:filebot 'Get your own badge on imagelayers.io')

## Tag available
* latest [(rutorrent/latest/Dockerfile)](https://github.com/xataz/dockerfiles/blob/master/rutorrent/latest/Dockerfile)
* latest-filebot, filebot [(rutorrent/latest-filebot/Dockerfile)](https://github.com/xataz/dockerfiles/blob/master/rutorrent/latest-filebot/Dockerfile)

## Description
What is [RuTorrent](https://github.com/Novik/ruTorrent) ?

ruTorrent is a front-end for the popular Bittorrent client rtorrent.
This project is released under the GPLv3 license, for more details, take a look at the LICENSE.md file in the source.

What is [rtorrent](https://github.com/rakshasa/rtorrent/) ?

rtorrent is the popular Bittorrent client.

## BUILD IMAGE

```shell
docker build -t xataz/rutorrent github.com/xataz/dockerfiles.git#master:rutorrent/latest
```

## Configuration
### Environments
* UID : Choose uid for launch rtorrent (default : 991)
* GID : Choose gid for launch rtorrent (default : 991)
* WEBROOT : (default : /)

### Volumes
* /data : Folder for download torrents

#### data Folder tree
* /data/.watch : Rtorrent watch this folder and add automatly torrent file
* /data/.session : Rtorrent save statement here
* /data/torrents : Rtorrent download torrent here
* /data/Media : If filebot version, rtorrent create a symlink 

### Ports
* 80

## Usage
### Simple launch
```shell
docker run -d -p 80:80 xataz/rutorrent
```
URI access : http://XX.XX.XX.XX

### Advanced launch
```shell
docker run -d -p 80:80 \
	-v /docker/data:/data \ 
	-e UID=1001 \
	-e GID=1001 \
    -e WEBROOT=/rutorrent \
	xataz/rutorrent:filebot
```
URI access : http://XX.XX.XX.XX/rutorrent
