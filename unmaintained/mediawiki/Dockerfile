FROM wonderfall/nginx-php:7.1

ARG MEDIAWIKI_VER=1.29
ARG SUB_VERSION=1

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=10M \
    MEMORY_LIMIT=128M

RUN apk -U add \
    tar \
    libressl \
    ca-certificates \
    git \
    lua \
    coreutils \
    diffutils \
    build-base \
    autoconf \
 && pecl install apcu \
 && mkdir mediawiki && cd mediawiki \
 && wget -qO- https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VER}/mediawiki-${MEDIAWIKI_VER}.${SUB_VERSION}.tar.gz | tar xz --strip 1 \
 && apk del build-base autoconf \
 && rm -rf /var/cache/apk/*

COPY rootfs /

RUN chmod +x /usr/local/bin/run.sh /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /config /skins /extensions /mediawiki/images /php/session

EXPOSE 8888

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>" \
      description="MediaWiki is a free software open source wiki package written in PHP" \
      version="MediaWiki ${MEDIAWIKI_VER}.${SUB_VERSION}"

CMD ["run.sh"]
