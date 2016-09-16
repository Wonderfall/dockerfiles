## wonderfall/rainloop

![](https://i.goopics.net/nI.png)

#### What is this?
Rainloop is a simple, modern & fast web-based client. More info on the [official website](http://www.rainloop.net/).

#### Features
- Based on Alpine 3.3
- Latest Rainloop **Community Edition**
- Contacts (DB) : sqlite, or mysql (server not built-in)
- nginx + PHP7

#### Build-time variables
- **GPG_rainloop** : fingerprint of signing key

#### Environment variables
- **GID** : rainloop group id *(default : 991)*
- **UID** : rainloop user id *(default : 991)*

#### Volumes
- **/rainloop/data** : data files.

#### Ports
- **8888***

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration
