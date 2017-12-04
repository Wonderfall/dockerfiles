### wonderfall/cowrie

#### What is this?
Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and the shell interaction performed by the attacker. Cowrie is based on Kippo.

#### Build-time variables
- **MPFR_VERSION** : GNU MPFR version.
- **MPC_VERSION** : GNU MPC version.
- **GPG_** : fingerprints of signing keys.
- **SHA_** : fingerprints of tarballs

#### Environment variables
- **UID** *(default : 991)*
- **GID** *(default : 991)*

#### How to configure
You should provide your own configuration file from this base : https://raw.githubusercontent.com/micheloosterhof/cowrie/master/cowrie.cfg.dist
You can mount this single file to your Docker container.

#### Volumes
- **/cowrie/dl** : where downloads are stored.
- **/cowrie/log** : cowrie and tty sessions logs.
- **/cowrie/cowrie.cfg** : cowrie configuration file. **Provide yours!**
- **/custom** : customize cowrie structure with your own files

#### Docker compose (example)
```
cowrie:
  image: wonderfall/cowrie
  links:                           ### MySQL output
    - cowrie-db:cowrie-db          ### MySQL output
  ports:
    - "2222:2222"
  volumes:
    - /mnt/cowrie/dl:/cowrie/dl
    - /mnt/cowrie/log:/cowrie/log
    - /mnt/cowrie/custom:/custom
    - /mnt/cowrie/cowrie.cfg:/cowrie/cowrie.cfg
  environment:
    - GID=1000
    - UID=1000

### MySQL output
# First, you'll have to initialise tables with a .sql file
# mkdir -p /mnt/cowrie/sql
# wget https://raw.githubusercontent.com/micheloosterhof/cowrie/master/doc/sql/mysql.sql -P /mnt/cowrie/sql/cowrie.sql
# It needs also to be configured in the cowrie.cfg file

cowrie-db:
  image: mariadb:10
  volumes:
    - /mnt/cowrie/db:/var/lib/mysql
    - /mnt/cowrie/sql:/docker-entrypoint-initdb.d
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=cowrie
    - MYSQL_USER=cowrie
    - MYSQL_PASSWORD=supersecretpassword
```

