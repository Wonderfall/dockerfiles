## wonderfall/cowrie
[![](https://badge.imagelayers.io/wonderfall/cowrie:latest.svg)](https://imagelayers.io/?images=wonderfall/cowrie:latest 'Get your own badge on imagelayers.io')

![](https://i.goopics.net/lO.jpg)

#### What is this?
Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and the shell interaction performed by the attacker. Cowrie is based on Kippo.

#### Environment variables
- **HOSTNAME** is the hostname displayed in the honeypot. 
- **DL_LIMIT** is the maximum size (in bytes!) of a stored downloaded file (0 = no limit). 
- **FACING_IP** is your IP (you have to set it manually because cowrie fails to detect it when running in Docker). 
- **JSON_LOG** equals False by default, so json logging is disabled. If you want this feature enabled, set `$JSON_LOG` to True (or anything else...).

#### Volumes
- **/dl** : where downloads are stored.
- **/log** : cowrie and tty sessions logs.

#### Custom mode
`$CUSTOM` can be interpreted as a custom mode. You have access, if set to True, to :
- **honeyfs dir** (/honeyfs) : file contents for the fake filesystem, feel free to copy a real system here
- **data dir** (/data) : fake filesystem + users database
- **txtcmds dir** (/txtcmds) : modify, or add new text commands (if new, must be added to the fake fs)
- **utils dir** (/utils) : useful for fake fs creation

You have to know that, once these directories are polluted by the run.sh script, nothing will be done for you. You'll have to update manually (except utils) and things may break in the future. Always backup your changes. If you just want to run the honeypot without any customisation, do not enable this mode.

#### Docker compose (example)
```
cowrie:
  image: wonderfall/cowrie
  ports:
    - "2222:2222"
  volumes:
    - /mnt/cowrie/dl:/dl
    - /mnt/cowrie/log:/log
    ### IF CUSTOM MODE
    #- /mnt/cowrie/honeyfs:/honeyfs
    #- /mnt/cowrie/data:/data
    #- /mnt/cowrie/txtcmds:/txtcmds
    #- /mnt/cowrie/utils:/utils
  environment:
    - HOSTNAME=foobar
    - DL_LIMIT=2048
    - FACING_IP=9.9.9.9
    - JSON_LOG=False
    - CUSTOM=False
    - GID=1000
    - UID=1000
```
