FROM alpine:3.5

ARG ISSO_VER=0.10.6

ENV GID=1000 UID=1000

RUN echo "@community https://nl.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    python-dev \
    libffi-dev \
    py2-pip \
    build-base" \
 && apk -U add \
    ${BUILD_DEPS} \
    python \
    py-setuptools \
    sqlite \
    libressl \
    ca-certificates \
    su-exec \
    tini@community \
 && pip install --no-cache cffi \
 && pip install --no-cache misaka==1.0.2 \
 && wget -q https://github.com/posativ/isso/archive/$ISSO_VER.tar.gz -P /tmp \
 && pip install /tmp/$ISSO_VER.tar.gz \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8080

VOLUME /db /config

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
