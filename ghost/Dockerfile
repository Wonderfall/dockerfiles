FROM alpine:3.5

ARG GHOST_VERSION=0.11.8

ENV GHOST_NODE_VERSION_CHECK=false \
    GID=991 \
    UID=991 \
    DOMAIN=my-ghost-blog.com \
    SSL=False \
    SYNTAX_HIGHLIGHTING=False \
    HIGHLIGHTER_COLOR=light \
    CUSTOM_SMTP=False \
    SMTP_HOST=mail.domain.tld \
    SMTP_PASS=123456 \
    SMTP_USER=user \
    SMTP_PORT=587 \
    SMTP_SENDER_MAIL=user@domain.tld \
    SMTP_SENDER_NAME=Ghost \
    ENABLE_ISSO=False \
    ISSO_HOST=isso.domain.tld \
    ISSO_AVATAR=false \
    ISSO_VOTE=false \
    ENABLE_DISQUS=False \
    DISQUS_SHORTNAME=shortname

VOLUME /ghost/content

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    libressl \
    ca-certificates \
    bash \
    grep \
    tini@commuedge \
    su-exec \
    nodejs \
 && wget -q https://github.com/TryGhost/Ghost/releases/download/${GHOST_VERSION}/Ghost-${GHOST_VERSION}.zip -P /tmp \
 && unzip -q /tmp/Ghost-${GHOST_VERSION}.zip -d /ghost \
 && cd /ghost \
 && npm install --production \
 && mv content/themes/casper casper \
 && mv config.example.js config.js \
 && sed -i 's/127.0.0.1/0.0.0.0/g' config.js \
 && npm cache clean \
 && rm -rf /tmp/* /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh
COPY smtp.conf /usr/local/etc/smtp.conf
COPY isso.conf /usr/local/etc/isso.conf
COPY disqus.conf /usr/local/etc/disqus.conf
COPY prism_light.js /ghost/prismjs/light/prism.js
COPY prism_light.css /ghost/prismjs/light/prism.css
COPY prism_dark.js /ghost/prismjs/dark/prism.js
COPY prism_dark.css /ghost/prismjs/dark/prism.css
COPY prism.js.conf /usr/local/etc/prism.js.conf
COPY prism.css.conf /usr/local/etc/prism.css.conf

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 2368

LABEL description="Ghost CMS ready for production" \
      ghost="Ghost v$VERSION" \
      maintainer="Wonderfall <wonderfall@targaryen.house>"

CMD ["run.sh"]
