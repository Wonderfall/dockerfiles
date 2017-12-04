FROM alpine:3.6

ENV UID=991 GID=991

RUN apk -U --no-cache add \
    pgbouncer \
    tini \
    su-exec

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

VOLUME /etc/pgbouncer

CMD ["run.sh"]
