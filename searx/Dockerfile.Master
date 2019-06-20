FROM alpine:3.10

ARG VERSION=master

ENV BASE_URL=False IMAGE_PROXY=False \
    UID=991 GID=991

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    python3-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    git \
    ca-certificates \
 && apk add \
    su-exec \
    python3 \
    libxml2 \
    libxslt \
    openssl \
    tini \
 && mkdir /usr/local/searx && cd /usr/local/searx \
 && git clone https://github.com/asciimoo/searx/ . \
 && pip3 install --upgrade setuptools pip \
 && pip3 install --no-cache -r requirements.txt \
 && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml \
 && apk del build-dependencies \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8888

LABEL maintainer="hoellen <info@hoellen.eu>"

CMD ["run.sh"]
