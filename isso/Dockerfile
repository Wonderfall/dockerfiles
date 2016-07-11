FROM alpine:3.4
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ARG ISSO_VER=0.10.4

ENV GID=1000 UID=1000

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    python-dev \
    libffi-dev \
    py-pip \
    build-base" \
 && apk -U add \
    ${BUILD_DEPS} \
    python \
    py-setuptools \
    sqlite \
    openssl \
    ca-certificates \
    su-exec \
    tini@commuedge \
 && pip install --no-cache cffi \
 && pip install --no-cache misaka==1.0.2 \
 && wget https://github.com/posativ/isso/releases/download/$ISSO_VER/isso-$ISSO_VER.tar.gz -P /tmp \
 && pip install /tmp/isso-$ISSO_VER.tar.gz \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080
VOLUME /db /config
CMD ["/sbin/tini","--","run.sh"]
