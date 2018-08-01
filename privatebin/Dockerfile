FROM hoellen/nginx-php

ARG PRIVATEBIN_VER=1.2

ENV GID=991 UID=991 \
    UPLOAD_MAX_SIZE=10M \
    MEMORY_LIMIT=128M \
    PHP_MAX_CHILDREN=15 \
    PHP_START_SERVERS=2 \
    PHP_MIN_SPARE_SERVERS=1 \
    PHP_MAX_SPARE_SERVERS=6

RUN BUILD_DEPS="tar gnupg" \
 && apk -U upgrade && apk add $BUILD_DEPS \
 && mkdir privatebin && cd privatebin \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg2 --list-public-keys || /bin/true \
 && wget -qO- https://privatebin.info/key/security.asc | gpg2 --import - \
 && wget -qO /privatebin.tar.gz.asc https://github.com/PrivateBin/PrivateBin/releases/download/${PRIVATEBIN_VER}/PrivateBin-${PRIVATEBIN_VER}.tar.gz.asc \
 && wget -qO /privatebin.tar.gz https://github.com/PrivateBin/PrivateBin/archive/${PRIVATEBIN_VER}.tar.gz \
 && gpg2 --verify /privatebin.tar.gz.asc \
 && tar -xzf /privatebin.tar.gz --strip 1 \
 && mv cfg/conf.sample.php cfg/conf.php \
 && apk del $BUILD_DEPS \
 && rm -rf /var/cache/apk/* /privatebin.tar.gz* "${GNUPGHOME}"

COPY rootfs /

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /privatebin/data /php/session

EXPOSE 8888

LABEL maintainer="hoellen <info@hoellen.eu>" \
      description="A minimalist, open source online pastebin where the server has zero knowledge of pasted data" \
      version="PrivateBin 1.2"

CMD ["run.sh"]
