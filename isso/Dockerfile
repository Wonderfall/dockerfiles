FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV ISSO_VER=0.10.2 GID=1000 UID=1000

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    python \
    python-dev \
    libffi-dev \
    py-setuptools \
    py-pip \
    sqlite \
    ca-certificates \
    build-base \
    gosu@testing \
    tini@commuedge \
 && pip install --no-cache cffi \
 && pip install --no-cache misaka==1.0.2 \
 && wget https://github.com/posativ/isso/releases/download/$ISSO_VER/isso-$ISSO_VER.tar.gz -P /tmp \
 && pip install /tmp/isso-$ISSO_VER.tar.gz \
 && apk del \
    python-dev \
    libffi-dev \
    py-pip \
    build-base \
 && rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080
VOLUME /db /config
CMD ["tini","--","run.sh"]
