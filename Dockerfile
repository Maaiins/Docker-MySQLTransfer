FROM alpine:3.6

MAINTAINER Lauser, Nicolai <nicolai@lauser.info>

ADD docker-entrypoint.sh /

RUN apk add --update mysql-client \
    && rm -rf /var/cache/apk/* \
    && chmod 775 /docker-entrypoint.sh \
    && mkdir -p /sql

VOLUME /sql
WORKDIR /sql

ENTRYPOINT ["/docker-entrypoint.sh"]