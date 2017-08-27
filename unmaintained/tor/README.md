## wonderfall/tor

![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Tor-logo-2011-flat.svg/612px-Tor-logo-2011-flat.svg.png)

#### Features
- Based on Alpine Linux.
- Tor built from source.
- ARM included, allowing real-time monitoring.

#### Usages
- As a relay ([french article](https://wonderfall.xyz/un-relais-tor-avec-docker/)).
- As a hidden service dir.

### Build-time variables
- **TOR_VERSION** : version of Tor.
- **TOR_USER_ID** : tor user id *(default : 45553)*
- **ARM_VERSION** : version of ARM
- **GPG_** : fingerprints of signing keys

#### Environment variables
- **TERM** = xterm (ARM requirement)
- **UID** = tor user id
- **GID** = tor group id

#### Volumes
- **/tor/config** : tor configuration files.
- **/tor/data** : tor data.

#### Ports
- **9001** (bind it) : ORPort.
- **9030** (bind it) : DirPort.
