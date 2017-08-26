FROM alpine:3.6

ARG VERSION=1.13.0

ENV UID=991 GID=991

WORKDIR /cryptpad

RUN apk -U add --no-cache \
    git \
    tini \
    su-exec \
    ca-certificates \
    libressl \
    tar \
    nodejs-current \
    nodejs-current-npm \
 && wget -qO- https://github.com/xwiki-labs/cryptpad/archive/${VERSION}.tar.gz | tar xz --strip 1 \
 && npm install \
 && npm install -g bower \
 && bower install --allow-root

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 3000

VOLUME /cryptpad/datastore /cryptpad/customize

CMD ["run.sh"]
