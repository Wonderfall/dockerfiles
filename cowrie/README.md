## wonderfall/cowrie

#### What is this?
Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and the shell interaction performed by the attacker. Cowrie is based on Kippo.

#### Build-time variables
- **MPFR_VERSION** : GNU MPFR version.
- **MPC_VERSION** : GNU MPC version.
- **GPG_** : fingerprints of signing keys.
- **SHA_** : fingerprints of tarballs

#### Environment variables
- **HOSTNAME** : the hostname displayed in the honeypot. 
- **DL_LIMIT** : the maximum size (in bytes!) of a stored downloaded file (0 = no limit). 
- **FACING_IP** : your IP (you have to set it manually because cowrie fails to detect it when running in Docker). 
- **JSON_LOG** : disables json logging if set to False.

#### Volumes
- **/cowrie/dl** : where downloads are stored.
- **/cowrie/log** : cowrie and tty sessions logs.
- **/cowrie/custom** : feel free to customize cowrie structure.

#### Docker compose (example)
```
cowrie:
  image: wonderfall/cowrie
  ports:
    - "2222:2222"
  volumes:
    - /mnt/cowrie/dl:/dl
    - /mnt/cowrie/log:/log
  environment:
    - HOSTNAME=foobar
    - DL_LIMIT=2048
    - FACING_IP=9.9.9.9
    - JSON_LOG=False
    - GID=1000
    - UID=1000
```

