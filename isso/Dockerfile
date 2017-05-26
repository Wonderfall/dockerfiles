FROM alpine:3.6

ARG ISSO_VER=0.10.6

ENV GID=1000 UID=1000

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    python-dev \
    libffi-dev \
    py2-pip \
    build-base \
 && apk add \
    python \
    py-setuptools \
    sqlite \
    libressl \
    ca-certificates \
    su-exec \
    tini \
 && pip install --no-cache cffi \
 && pip install --no-cache misaka==1.0.2 \
 && pip install --no-cache "isso==${ISSO_VER}" \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080

VOLUME /db /config

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
