## wonderfall/lufi
[![](https://badge.imagelayers.io/wonderfall/lufi:latest.svg)](https://imagelayers.io/?images=wonderfall/lufi:latest 'Get your own badge on imagelayers.io')

![](https://pix.schrodinger.io/H1JZuROt/zh7BXdOK.png)

#### What is this?
Lufi means Let's Upload that FIle.
Is that all? No. All the files are encrypted by the browser! It means that your files never leave your computer unencrypted. The administrator of the Lufi instance you use will not be able to see what is in your file, neither will your network administrator, or your ISP.

#### Environment variables
- **GROUPID** : lufi group id. *(default : 1000)*
- **USERID** : lufi user id. *(default : 1000)*
- **SECRET** : random string used to encrypt cookies. *(default : ZyCnLAhYKBIJrukuKZZJ)*
- **CONTACT** : lufi contact. *(default : contact@domain.tld)*
- **MAX_FILE_SIZE** : maximum file size of an uploaded file in bytes. *(default : 1GB)*
- **WEBROOT** : webroot of lufi. *(default : /)*
- **DOMAIN** : domain used with lufi. *(default : domain.tld)*

*Tip : you can use the following command to generate SECRET.*
`cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 20 | head -n 1`

#### Volumes
- **/data** : where lufi's database is stored.
- **/files** : location of uploaded files.

#### Reverse proxy
https://github.com/Wonderfall/dockerfiles/tree/master/reverse

#### Docker-compose (example)
```
lufi:
  image: wonderfall/lufi
  environment:
    - GROUPID=1000
    - USERID=1000
    - SECRET=EFDLZGzfvzvbpdghZZopg
    - CONTACT=john.doe@domain.tld
    - WEBROOT=/
    - MAX_FILE_SIZE=1000000000
    - DOMAIN=domain.tld
  volumes:
    - /mnt/lufi/files:/files
    - /mnt/lufi/data:/data
```
