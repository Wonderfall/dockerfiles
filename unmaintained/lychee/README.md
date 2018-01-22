## wonderfall/lychee

![](http://lychee.electerious.com/assets/images/showcase.jpg)

#### What is this?
Lychee is a free photo-management tool, which runs on your server or web-space. Installing is a matter of seconds. Upload, manage and share photos like from a native application. Lychee comes with everything you need and all your photos are stored securely.

#### Features
- Based on Alpine Linux.
- nginx + PHP7.
- Active Imagemagick + pecl ext.

#### Build-time variables
- **LYCHEE_VERSION** : version of Lychee.
- **IMAGICK_EXT_VERSION** : version of imagick pecl extension.

#### Environment variables
- **UID** : lychee user id *(default : 991)*.
- **GID** : lychee group id *(default : 991)*.

#### Volumes
- **/lychee/uploads** : uploads.
- **/lychee/data** : data files.

#### Ports
- **8888** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)
