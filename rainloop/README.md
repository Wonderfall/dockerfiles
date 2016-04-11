## wonderfall/rainloop
[![](https://badge.imagelayers.io/wonderfall/rainloop:latest.svg)](https://imagelayers.io/?images=wonderfall/rainloop:latest 'Get your own badge on imagelayers.io')

![](https://i.goopics.net/nI.png)

#### What is this?
Rainloop is a SIMPLE, MODERN & FAST WEB-BASED EMAIL CLIENT. More info on the [official website](http://www.rainloop.net/).

#### Features
- Based on Alpine 3.3
- Latest Rainloop **Community Edition** (stable)
- Extremely lightweight
- Contacts (DB) : sqlite, or mysql (server not built-in)

#### Environment variables
- **GID** : rainloop group id.
- **UID** : rainloop user id.

#### Volumes
- **/rainloop/data** : rainloop's data

#### Docker Compose (example)
```
rainloop:
  image: wonderfall/rainloop
  environment:
    - GID=1000
    - UID=1000
  volumes:
    - /mnt/rainloop:/rainloop/data

# if using mysql as contacts database

db_rainloop:
  image: mariadb:10
  volumes:
    - /mnt/rainloop/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=rainloop
    - MYSQL_USER=rainloop
    - MYSQL_PASSWORD=supersecretpassword
```

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse
