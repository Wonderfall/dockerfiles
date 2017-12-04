FROM alpine:3.6

ENV NODE_ENV=production \
    GID=991 UID=991 \
    INTERFACE=0.0.0.0 \
    PORT=8000 \
    ADDRESS=http://localhost/w/ \
    DOMAIN=localhost

RUN apk -U --no-cache add \
    ca-certificates \
    libressl \
    nodejs-current \
    nodejs-current-npm \
    s6 \
    git \
    su-exec \
 && git clone https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid --depth=1 \
 && cd parsoid && npm install

COPY rootfs /

RUN chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/*

EXPOSE 8000

ENTRYPOINT ["run.sh"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]
