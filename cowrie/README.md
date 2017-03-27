x## wonderfall/cowrie

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
```

