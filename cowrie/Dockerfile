FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV HOSTNAME=svr04 DL_LIMIT=10485760 FACING_IP=9.9.9.9 JSON_LOG=False CUSTOM=False GID=1000 UID=1000

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    build-base \
    libffi \
    libffi-dev \
    openssl \
    openssl-dev \
    python \
    python-dev \
    py-pip \
    tar \
    tini@commuedge \
    gosu@testing \
 && pip install --no-cache \
    pyasn1 \
    service_identity \
    pyOpenSSL \
    twisted==15.4.0 \
    pycrypto \
    cryptography \
 && apk del \
    build-base \
    libffi-dev \
    openssl-dev \
    python-dev \
    py-pip \
 && rm -f /var/cache/apk/*

RUN mkdir /cowrie && cd /cowrie \
 && wget -qO- https://github.com/micheloosterhof/cowrie/archive/master.tar.gz \
  | tar xz --strip 1 \
 && mv cowrie.cfg.dist cowrie.cfg \
 && sed -i "s|download_path = dl|download_path = /dl|g" cowrie.cfg \
 && sed -i "s|log_path = log|log_path = /log|g" cowrie.cfg

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

VOLUME /dl /log /honeyfs /data /txtcmds /utils
EXPOSE 2222
CMD ["tini","--","run.sh"]
