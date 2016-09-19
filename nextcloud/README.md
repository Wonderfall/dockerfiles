## wonderfall/nextcloud

[![](https://images.microbadger.com/badges/image/wonderfall/nextcloud.svg)](http://microbadger.com/images/wonderfall/nextcloud "Get your own image badge on microbadger.com")

![](https://pix.schrodinger.io/lwq5gNX5/mSPk3B7c.png)


#### Error 502?
Before https://github.com/Wonderfall/dockerfiles/commit/9cbccd93dcbe5048ee428d22965d2d4c9d68cb84, wonderfall/nextcloud used the listen port 80. Now it's **8888** due to OS restrictions (non-root user cannot use port 80). Sorry for the inconvenience!

#### Features
- Based on **Alpine Linux** (edge), with **nginx** and **PHP 7**.
- Package authenticity check during build process (sha256sum + GPG).
- Data and apps persistence (easy to update, just recreate the container).
- OPCache (opcode cache) & APCu (data store) already configured.
- system cron configured (15min periodic), replaces AJAX cron.
- MySQL, PostgreSQL (server not built-in) and sqlite3 support.
- Redis, FTP, SMB, LDAP support.
- UID/GID flexibility.

#### Tags
- **latest** : latest stable version.
- **10.0** : latest 10.0.x version (stable)
- **9.0** : latest 9.0.x version. (oldstable)
- **test** (if any) : latest test version provided by Nextcloud (RC, Beta...)
- **daily** : latest code (daily build).

#### Build-time variables
- **NEXTCLOUD_VERSION** : version of nextcloud
- **GPG_nextcloud** : fingerprint of the signing key

#### Environment variables
- **UID** : nextcloud user id *(default : 991)*
- **GID** : nextcloud group id *(default : 991)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10G)*
- **APC_SHM_SIZE** : apc memory size *(default : 128M)*
- **OPCACHE_MEM_SIZE** : opcache memory size in megabytes *(default : 128)*

#### Port
- **8888** (recently changed, nginx now runs without root)

#### Volumes
- **/data** : Nextcloud data.
- **/config** : config.php location.
- **/apps2** : Nextcloud downloaded apps.

#### Database (external container)
You have to use an **external** database container. I suggest you to use **MariaDB**, which is a reliable database server. You can use the official `mariadb` image available on Docker Hub to create a database container, which must be linked to the Nextcloud container.

#### Setup
Pull the image and create a container. `/mnt` can be **anywhere on your host**. Change MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD values (mariadb). You may also want to change UID and GID (nextcloud).

````
docker pull wonderfall/nextcloud && docker pull mariadb:10
docker run -d --name db_nextcloud -v /mnt/nextcloud/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=supersecretpassword -e MYSQL_DATABASE=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=supersecretpassword mariadb:10
docker run -d --name nextcloud --link db_nextcloud:db_nextcloud -e UID=1000 -e GID=1000 -v /mnt/nextcloud/data:/data -v /mnt/nextcloud/config:/config -v /mnt/nextcloud/apps:/apps2 wonderfall/nextcloud
```

**Below you can find a docker-compose file, which is very useful !**

Now you have to use a **reverse proxy** in order to access to your container through Internet, steps and details are available at the end of the README.md.

Browse to Nextcloud setup page, then :
- **Data folder** : change `/nextcloud/data` to `/data`.
- **Database** : fill in all the fields to configure your database.
  - user : MYSQL_USER.
  - password : MYSQL_PASSWORD.
  - name : MYSQL_DATABASE.
  - host : name of the mariadb container.
- **Don't forget** : use strong passwords, choose another name for the admin account.

#### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).
To **enable APCU**, add this line to your config.php :

```
  'memcache.local' => '\OC\Memcache\APCu',
```

Add the following lines to your `config.php` in order to enable apps persistence :

```
  "apps_paths" => array (
      0 => array (
              "path"     => "/nextcloud/apps",
              "url"      => "/apps",
              "writable" => false,
      ),
      1 => array (
              "path"     => "/apps2",
              "url"      => "/apps2",
              "writable" => true,
      ),
  ),
```

#### Update
Pull a newer image, then recreate the container :

```
docker pull wonderfall/nextcloud
docker rm nextcloud
docker run -d --name nextcloud --link db_nextcloud:db_nextcloud -e UID=1000 -e GID=1000 -v /mnt/nextcloud/data:/data -v /mnt/nextcloud/config:/config -v /mnt/nextcloud/apps:/apps2 wonderfall/nextcloud
```

If Nextcloud performed a full upgrade, your apps could be disabled. Enable them again.

#### Docker-compose

I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run everything with `docker-compose up -d`, that's it!

```
nextcloud:
  image: wonderfall/nextcloud
  links:
    - db_nextcloud:db_nextcloud
  environment:
    - UID=1000
    - GID=1000
  volumes:
    - /mnt/nextcloud/data:/data
    - /mnt/nextcloud/config:/config
    - /mnt/nextcloud/apps:/apps2

db_nextcloud:
  image: mariadb:10
  volumes:
    - /mnt/nextcloud/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=supersecretpassword
    - MYSQL_DATABASE=nextcloud
    - MYSQL_USER=nextcloud
    - MYSQL_PASSWORD=supersecretpassword
```
You can update everything with `docker-compose pull` followed by `docker-compose up -d`.

#### Reverse proxy
You should be familiar with reverse proxying, otherwise you should read some documentation about it. If you're using nginx, there are two possibilites :
- nginx is on the host : use the IP address you can get with `docker inspect nextcloud | grep IPAddress\" | head -n1 | grep -Eo "[0-9.]+" `. But whenever the container is restarted or recreated, its IP address can change.

- nginx is in a container, things are easier : https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration (example). If you don't get it : **nextcloud is linked to nginx** (containers) so you can use `proxy_pass http://nextcloud`. Very easy. I suggest you to use my image `wonderfall/nginx`, which provides a tool named `ngxproxy` aiming at automatically create a vhost file. You will be asked a few questions.

Headers are already sent by the container, including HSTS, so no need to add them again. **It is strongly recommended to use Nextcloud through an encrypted connection (HTTPS).** [Let's Encrypt](https://letsencrypt.org/) provides free SSL/TLS certificates (trustworthy!).
