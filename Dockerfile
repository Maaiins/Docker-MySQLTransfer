FROM alpine:3.4

MAINTAINER Lauser, Nicolai <nicolai@lauser.info>

ADD docker-entrypoint.sh /

RUN apk add --update mysql-client \
    && rm -rf /var/cache/apk/* \
    && chmod 775 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]