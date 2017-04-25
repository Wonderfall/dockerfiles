![nginx-php](http://apmblog.dynatrace.com/wp-content/uploads/2014/10/PHP-on-Nginx.jpg)

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Description
What is [Nginx](http://nginx.org)?

nginx (engine x) is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, nginx served or proxied 24.29% busiest sites in December 2015. Here are some of the success stories: Netflix, Wordpress.com, FastMail.FM.

What is [PHP](https://secure.php.net/)?

PHP is a popular general-purpose scripting language that is especially suited to web development.
Fast, flexible and pragmatic, PHP powers everything from your blog to the most popular websites in the world.


## BUILD IMAGE
### Build arguments
* BUILD_CORES : Number of cpu's core for compile (default : empty for use all cores)
* NGINX_VER : Nginx version (default : latest version)
* NGINX_GPG : Nginx gpg fingerprint
* NGINX_CONF : Nginx build arguments (default : see Dockerfile)
* PHP_VER : PHP version (default : latest version)
* PHP_MIRROR: Mirror for download PHP (default : http://fr2.php.net)
* PHP_GPG : PHP gpg fingerprint
* PHP_CONF : PHP build arguments (default : see Dockerfile)
* PHP_EXT_LIST : PHP extensions list, for install there (default : see Dockerfile)
* CUSTOM_BUILD_PKGS : Necessary packages for build PHP extension, there packages are remove after build (default : see Dockerfile)
* CUSTOM_PKGS : Necessary package for PHP extension (default : see Dockerfile)

### simple build
```shell
docker build -t xataz/nginx-php github.com/xataz/dockerfiles.git#master:nginx-php
```

### Build with arguments
```shell
docker build -t xataz/nginx-php \
        --build-arg NGINX_VER=1.10.1 \
        --build-arg PHP_VER=5.6.27 \
        --build-arg PHP_EXT_LIST="gd mysqli gmp" \
        --build-arg CUSTOM_BUILD_PKGS="freetype-dev gmp-dev" \
        --build-arg CUSTOM_PKGS="freetype gmp" \
        github.com/xataz/dockerfiles.git#master:nginx-php
```


## Configuration
### Environments
* UID : Choose uid for launch rtorrent (default : 991)
* GID : Choose gid for launch rtorrent (default : 991)

### Volumes
* /nginx/sites-enabled : Place your vhost here
* /nginx/log : Log emplacement
* /nginx/run : Here is pid and lock file
* /nginx/conf/nginx.conf : General configuration of nginx
* /nginx/conf.d : folder for other configuration (ex : php.conf, headers_param.conf)

if you mount /nginx/conf.d, use this php.conf :
```shell
location ~ \.php$ {
    fastcgi_index index.php;
    fastcgi_pass unix:/php/run/php-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include /nginx/conf/fastcgi_params;
}
```

### Ports
* 8080


## Usage
### Simple launch
```shell
docker run -d -p 8080:8080 xataz/nginx-php
```
URI access : http://XX.XX.XX.XX:8080

### Advanced launch
```shell
docker run -d -p 80:8080 -p 443:8443 \
	  -v /docker/nginx/sites-enabled:/nginx/sites-enabled \
      -v /docker/nginx/certs:/nginx/certs \
	  -e UID=1001 \
	  -e GID=1001 \
	xataz/nginx-php
```
URI access : http://XX.XX.XX.XX

## Contributing
Any contributions, are very welcome !
