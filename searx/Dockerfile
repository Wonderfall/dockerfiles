FROM alpine:3.3
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV BASE_URL=False IMAGE_PROXY=False

RUN echo "@commuedge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    build-base \
    python \
    python-dev \
    py-pip \
    libxml2 \
    libxml2-dev \
    libxslt \
    libxslt-dev \
    libffi-dev \
    openssl \
    openssl-dev \
    ca-certificates \
    tar \
    tini@commuedge \
 && pip install --no-cache -r https://raw.githubusercontent.com/asciimoo/searx/master/requirements.txt \
 && apk del \
    build-base \
    python-dev \
    py-pip \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    ca-certificates \
 && rm -f /var/cache/apk/*

RUN adduser -D -h /usr/local/searx -s /bin/sh searx searx

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

USER searx

WORKDIR /usr/local/searx

RUN wget -qO- https://github.com/asciimoo/searx/archive/master.tar.gz | tar xz --strip 1 \
 && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml

EXPOSE 8888
LABEL description "A powerful meta-search engine"
CMD ["tini","--","run.sh"]
