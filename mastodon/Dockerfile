FROM alpine:3.6

ARG VERSION=master
ARG REPOSITORY=tootsuite/mastodon

ENV UID=991 GID=991 \
    RUN_DB_MIGRATIONS=true \
    SIDEKIQ_WORKERS=5 \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_ENV=production \
    NODE_ENV=production \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/mastodon/bin

WORKDIR /mastodon

RUN apk -U upgrade \
 && apk add \
    ca-certificates \
    ffmpeg \
    file \
    git \
    imagemagick \
    libpq \
    libressl \
    libxml2 \
    libxslt \
    nodejs-current-npm \
    nodejs-current \
    protobuf \
    ruby \
    ruby-bigdecimal \
    ruby-io-console \
    ruby-irb \
    ruby-json \
    s6 \
    su-exec \
 && apk add -t build-dependencies \
    build-base \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    protobuf-dev \
    python \
    ruby-dev \
    ruby-rdoc \
    tar \
 && update-ca-certificates \
 && wget -qO- https://github.com/${REPOSITORY}/archive/${VERSION}.tar.gz | tar xz --strip 1 \
 && gem install bundler \
 && bundle install --deployment --clean --no-cache --without test development \
 && npm install -g npm@3 && npm install -g yarn \
 && yarn --ignore-optional --pure-lockfile \
 && SECRET_KEY_BASE=$(rake secret) rake assets:precompile \
 && npm -g cache clean && yarn cache clean \
 && mv public/assets /tmp/assets && mv public/packs /tmp/packs \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/*

COPY rootfs /

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

VOLUME /mastodon/public/system /mastodon/public/assets /mastodon/public/packs

EXPOSE 3000 4000

LABEL maintainer="Wonderfall <wonderfall@targaryen.house>" \
      description="A GNU Social-compatible microblogging server"

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]
