FROM debian:jessie
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG TINI_VER=0.9.0

ENV USERID=1000 \
    GROUPID=1000 \
    SECRET=ZyCnLAhYKBIJrukuKZZJ \
    CONTACT=contact@domain.tld \
    MAX_FILE_SIZE=100000000 \
    WEBROOT=/ \
    DOMAIN=domain.tld

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    wget \
    git \
    perl \
    make \
    gcc \
    ca-certificates \
    libssl-dev \
    shared-mime-info \
    perlmagick \
 && cpan install Carton \
 && git clone https://framagit.org/luc/lutim.git --depth=1 \
 && cd /lutim \
 && carton install \
 && wget -q https://github.com/krallin/tini/releases/download/v$TINI_VER/tini_$TINI_VER.deb -P /tmp \
 && dpkg -i /tmp/tini_$TINI_VER.deb \
 && apt-get purge -y \
    wget \
    git \
    make \
    gcc \
    libssl-dev \
    ca-certificates \
 && apt-get autoremove --purge -y && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /root/.cpan* /lutim/local/cache/* /lutim/utilities /tmp/*

COPY run.sh /usr/local/bin/run.sh
COPY lutim.conf /lutim/lutim.conf

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8181
VOLUME /data /lutim/files
CMD ["tini","--","run.sh"]
