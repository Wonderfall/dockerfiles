FROM node:8-alpine

ARG VERSION=1.10.1

WORKDIR /cryptpad

RUN apk add --no-cache git tini su-exec ca-certificates libressl tar \
 && wget -qO- https://github.com/xwiki-labs/cryptpad/archive/${VERSION}.tar.gz | tar xz --strip 1 \
 && npm install \
 && npm install -g bower \
 && bower install --allow-root

EXPOSE 3000

VOLUME /cryptpad/datastore
VOLUME /cryptpad/customize

ENV UID=991 GID=991
ENV USE_SSL=false
ENV STORAGE='./storage/file'
ENV LOG_TO_STDOUT=true

CMD ["/cryptpad/container-start.sh"]
