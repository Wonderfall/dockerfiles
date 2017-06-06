FROM wonderfall/nginx-php:7.1

ARG FRESHRSS_VER=1.7.0

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=10M \
    MEMORY_LIMIT=128M \
    CRON_PERIOD=30m

RUN apk -U add --no-cache \
    tar \
    libressl \
    ca-certificates \
 && mkdir freshrss && cd freshrss \
 && wget -qO- https://github.com/FreshRSS/FreshRSS/archive/${FRESHRSS_VER}.tar.gz | tar xz --strip 1 \
 && mv data data_tmp

COPY rootfs /

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /freshrss/data /php/session

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>" \
      description="A free, self-hostable aggregator" \
      version="FreshRSS ${FRESHRSS_VER}"

CMD ["run.sh"]
