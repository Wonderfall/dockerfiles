FROM alpine:edge
MAINTAINER Wonderfall <wonderfall@schrodinger.io>

ENV BASE_URL=False IMAGE_PROXY=False

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    build-base \
    python-dev \
    py-pip \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    tar \
    ca-certificates" \
 && apk -U add \
    ${BUILD_DEPS} \
    python \
    libxml2 \
    libxslt \
    openssl \
    tini@commuedge \
 && pip install --no-cache -r https://raw.githubusercontent.com/asciimoo/searx/master/requirements.txt \
 && mkdir /usr/local/searx && cd /usr/local/searx \
 && wget -qO- https://github.com/asciimoo/searx/archive/master.tar.gz | tar xz --strip 1 \
 && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml \
 && adduser -D -h /usr/local/searx -s /bin/sh searx searx \
 && chown -R searx:searx /usr/local/searx \
 && apk del ${BUILD_DEPS} \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

USER searx

EXPOSE 8888

CMD ["/sbin/tini","--","run.sh"]
