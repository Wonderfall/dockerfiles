FROM node:8-alpine

ARG VERSION=1.10.1

ENV UID=991 GID=991

WORKDIR /cryptpad

RUN apk add --no-cache git tini su-exec ca-certificates libressl tar \
 && wget -qO- https://github.com/xwiki-labs/cryptpad/archive/${VERSION}.tar.gz | tar xz --strip 1 \
 && npm install \
 && npm install -g bower \
 && bower install --allow-root

EXPOSE 3000

VOLUME /cryptpad/datastore /cryptpad/customize

CMD ["/cryptpad/container-start.sh"]
