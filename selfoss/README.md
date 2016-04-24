# hardware/selfoss

![selfoss](https://i.imgur.com/8hJyBgk.png "selfoss")

The new multipurpose rss reader, live stream, mashup, aggregation web application.

### Requirement

- Docker 1.0 or higher

### How to use

```
docker run -d \
  --name selfoss \
  -p 80:80 \
  -v /mnt/docker/selfoss:/selfoss/data \
  hardware/selfoss
```

### Environment variables

- **VERSION** = selfoss version (*optional*, default: 2.15)
- **GID** = selfoss user id (*optional*, default: 991)
- **UID** = selfoss group id (*optional*, default: 991)

### Docker-compose

#### Docker-compose.yml

```
selfoss:
  image: hardware/selfoss
  container_name: selfoss
  ports:
    - "80:80"
  volumes:
    - /mnt/docker/selfoss:/selfoss/data
```

#### Run !

```
docker-compose up -d
```
