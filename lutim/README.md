## wonderfall/lutim

![](https://i.goopics.net/rf.png)

#### What is this?
LUTIM means Let's Upload That Image.
It stores images and allows you to see them, download them or share them on social networks. From version 0.5, the gif images can be displayed as animated gifs in Twitter, but you need a HTTPS server (Twitter requires that. Lutim detects if you have a HTTPS server and displays an static image twitter card if you don't);

Images are indefinitly stored unless you request that they will be deleted at first view or after 24 hours / one week / one month / one year.

#### Build-time variables
- **TINI_VER** : version of `tini`.

#### Environment variables
- **GROUPID** : lutim group id. *(default : 1000)*
- **USERID** : lutim user id. *(default : 1000)*
- **SECRET** : random string used to encrypt cookies. *(default : ZyCnLAhYKBIJrukuKZZJ)*
- **CONTACT** : lutim contact. *(default : contact@domain.tld)*
- **MAX_FILE_SIZE** : maximum file size of an uploaded file in bytes. *(default : 1GB)*
- **WEBROOT** : webroot of lutim. *(default : /)*
- **DOMAIN** : your domain used with lutim *(default : domain.tld)*

*Tip : you can use the following command to generate SECRET.*
`cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 20 | head -n 1`

#### Volumes
- **/data** : where lutim's database is stored.
- **/lutim/files** : location of uploaded files.

#### Ports
- **8181** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration).