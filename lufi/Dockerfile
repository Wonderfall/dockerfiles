FROM debian:jessie
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV TINI_VER=0.9.0 \
    USERID=1000 \
    GROUPID=1000 \
    SECRET=ZyCnLAhYKBIJrukuKZZJ \
    CONTACT=contact@domain.tld \
    MAX_FILE_SIZE=1000000000 \
    WEBROOT=/ \
    DOMAIN=domain.tld

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    wget \
    perl \
    build-essential \
    ca-certificates \
 && cpan install Carton \
 && mkdir /lufi && cd /lufi \
 && wget -qO- https://github.com/ldidry/lufi/archive/master.tar.gz | tar xz --strip 1 \
 && carton install \
 && wget -q https://github.com/krallin/tini/releases/download/v$TINI_VER/tini_$TINI_VER.deb -P /tmp \
 && dpkg -i /tmp/tini_$TINI_VER.deb \ 
 && apt-get purge -y \
    wget \
    build-essential \
    ca-certificates \
 && apt-get autoremove --purge -y && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /root/.cpan* /lufi/local/cache/* /lufi/utilities /tmp/*

COPY run.sh /usr/local/bin/run.sh
COPY lufi.conf /lufi/lufi.conf

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080
VOLUME /data /files
CMD ["tini","--","run.sh"]
