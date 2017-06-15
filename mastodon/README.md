## wonderfall/mastodon

![Mastodon](https://github.com/tootsuite/mastodon/blob/master/app/javascript/images/mastodon-getting-started.png?raw=true)

A GNU Social-compatible microblogging server : https://github.com/tootsuite/mastodon

#### Why this image?
This image is not the official one. The main difference you can notice is that all processes (web, streaming, sidekiq) are running in a single container, thanks to s6 (a supervision suite). Therefore it's easier to deploy, but not recommended for scaling on more than one machine.

#### Features
- Based on Alpine Linux 3.6.
- As lightweight as possible. 
- All-in-one container (s6).
- Assets are precompiled.
- Database migrations can be run at startup.
- No root processes.

#### Docker Hub tags
- **master** : latest code for adventurers (builds daily on Docker Hub)
- **stable** : latest stable version (builds weekly on Docker Hub)
- **targaryen** : Targaryen-themed stable version (builds weekly on Docker Hub)

#### Build-time variables
- **VERSION** : version of Mastodon, can be `v1.4.1` or `master`. *(default : master)*
- **REPOSITORY** : location of the code *(default : tootsuite/mastodon)*

#### Environment variables you should change
- **UID** : mastodon user id *(default : 991)*
- **GID** : mastodon group id *(default : 991)*
- **RUN_DB_MIGRATIONS** : run `rake db:migrate` at startup *(default : true)*
- **SIDEKIQ_WORKERS** :  number of Sidekiq workers *(default : 5)*
- Other environment variables : https://github.com/tootsuite/mastodon/blob/master/.env.production.sample

#### Volumes
- **/mastodon/public/system** : shit like media attachments, avatars, etc.
- **/mastodon/public/assets** : Mastodon assets
- **/mastodon/public/packs** : Mastodon assets
- **/mastodon/log** : Mastodon logfiles (mount if you prefer to)

#### Ports
- **3000** : Mastodon web
- **4000** : Mastodon streaming

#### docker-compose sample

```
mastodon:
  image: wonderfall/mastodon:stable
  restart: always
  container_name: mastodon
  env_file: /home/docker/mastodon/.env.production
  environment:
    - WEB_CONCURRENCY=16
    - MAX_THREADS=20
    - SIDEKIQ_WORKERS=25
    - RUN_DB_MIGRATIONS=true
  links:
    - mastodon-pgb
    - mastodon-redis
  volumes:
    - /home/docker/mastodon/public/system:/mastodon/public/system
    - /home/docker/mastodon/public/assets:/mastodon/public/assets
    - /home/docker/mastodon/public/packs:/mastodon/public/packs
```

