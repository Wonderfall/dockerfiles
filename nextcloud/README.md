## wonderfall/nextcloud

![](https://pix.schrodinger.io/lwq5gNX5/mSPk3B7c.png)

##### Features
- Based on **Alpine Linux** (edge).
- Image built upon recommendations (sha256 sum + PGP).
- **Ready to update** : data and apps persistence.
- **nginx**, **PHP 7**.
- **OPCache** (opcode cache) already configured.
- **APCu** (data store) already installed.
- **system cron** already configured.
- **MySQL/MariaDB/PG-SQL** compatibility (server not built-in).
- **UID/GID** flexibility.

This image is meant to be used behind a secure reverse proxy.

#### Tags
- **latest** : latest stable version.
- **9.0** : latest 9.0.x version.
- **daily** : latest code.

#### Build-time variables
- **NEXTCLOUD_VERSION** : version of nextcloud
- **APCU_VERSION** : version of apcu pecl ext
- **APCUBC_VERSION** : version of apcu_bc pecl ext
- **GPG_nextcloud** : fingerprint of the signing key

#### Environment variables
- **UID** : nextcloud user id *(default : 991)*
- **GID** : nextcloud group id *(default : 991)*

#### Volumes
- **/data** : nextcloud data.
- **/config** : configuration files.
- **/apps2** : nextcloud downloaded apps.

Add the following code to your `config.php` in order to enable apps persistence :

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

#### Database
You have to use an external database container. I suggest you to use MariaDB, which is a reliable database server. For example, you can use the official `mariadb` image available as an automated build that you can find on Docker Hub. Since sqlite is supected by Nextcloud to cause some troubles with sync clients, sqlite databases are not suported as they shouldn't be used. 

#### Setup
Go to your fresh Nextcloud instance, change `/nextcloud/data` to `/data` (recommended), and fill in all the fields to configure your database. Don't forget to provide with a strong password. You should choose another name for the administration account (not 'admin' which is the default one). The database host is the name of the database container, which is linked to the nexcloud container. You can see below an example of docker-compose.

#### Configure
`/config` should contain `config.php`, though this is not the file actually used by Nextcloud. Each time you restart the container, `/config/config.php` overwrites `/nextcloud/config/config.php`. Before that, `/nextcloud/config/config.php` is copied as `/nextcloud/config/config.php.bkp`, so you can easily revert changes.

In the admin pannel, you should switch from `AJAX cron` to `cron` (system cron). By the way, **I highly recommend encryption**! Why not?

To **enable APCU**, add this line to your config.php :

```
  'memcache.local' => '\OC\Memcache\APCu',
```

#### How do I update?
Just pull the newer image, and recreate the container.

#### Docker Compose (example)
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

#### Port
- **80**.

#### Reverse proxy
https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration

Headers are already sent by the container. It is strongly recommended to use Nextcloud through an encrypted connection (HTTPS).
