FROM alpine:latest

ENV GID=1000 UID=1000 ISSO_SETTINGS=/config/isso.conf

RUN apk upgrade --update \
 && apk add -t build-dependencies \
    python3-dev \
    libffi-dev \
    build-base \
 && apk add \
    python3 \
    sqlite \
    openssl \
    ca-certificates \
 && update-ca-certificates \
 && pip3 install isso gunicorn gevent \
 && apk del build-dependencies \
 && rm -rf /tmp/* /var/cache/apk/*

VOLUME /config /db

EXPOSE 8080

CMD /usr/bin/gunicorn -k gevent -b 0.0.0.0:8080 -w 4 --preload isso.run
