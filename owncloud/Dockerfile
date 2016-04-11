FROM debian:jessie
MAINTAINER Wonderfall <wonderfall@mondedie.fr>

ENV VERSION=9.0.0 TINI_VER=0.9.0 USERID=1000 GROUPID=1000

ADD https://www.dotdeb.org/dotdeb.gpg /tmp/dotdeb.gpg
ADD http://nginx.org/keys/nginx_signing.key /tmp/nginx.key

RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
 && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list \
 && echo "deb-src http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list \
 && apt-key add /tmp/dotdeb.gpg \
 && apt-key add /tmp/nginx.key

RUN apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
    cron \
    nginx \
    openssl \
    supervisor \
    php7.0-fpm \
    php7.0-cli \
    php7.0-intl \
    php7.0-curl \
    php7.0-gd \
    php7.0-mcrypt \
    php7.0-mysql \
 && mkdir /run/php && touch /run/php/php7.0-fpm.sock \
 && chown www-data:www-data /run/php/php7.0-fpm.sock \
 && sed -i "s/;env\[PATH\]/env\[PATH\]/g" /etc/php/7.0/fpm/pool.d/www.conf \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    bzip2 \
    wget \
    ca-certificates \
 && mkdir /owncloud && cd /tmp \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.sha256 \
 && wget -q https://download.owncloud.org/community/owncloud-$VERSION.tar.bz2.asc \
 && wget -q https://owncloud.org/owncloud.asc \
 && sha256sum -c owncloud-$VERSION.tar.bz2.sha256 \
 && gpg --import owncloud.asc \
 && gpg --verify owncloud-$VERSION.tar.bz2.asc \
 && tar xjf /tmp/owncloud-$VERSION.tar.bz2 --strip 1 -C /owncloud \
 && wget -q https://github.com/krallin/tini/releases/download/v$TINI_VER/tini_$TINI_VER.deb \
 && dpkg -i tini_$TINI_VER.deb \
 && apt-get purge -y wget bzip2 ca-certificates && apt-get autoremove -y --purge \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY cron.conf /etc/cron.conf
COPY opcache.ini /etc/php/mods-available/opcache.ini
COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /data /config /apps2
EXPOSE 80

LABEL description="A server software for creating file hosting services" \
      owncloud="ownCloud v$VERSION"

CMD ["tini","--","run.sh"]
