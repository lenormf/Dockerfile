##
## Dockerfile by lenormf
## docker build --rm -t kak-static .
## docker run --rm -v $(pwd):/deploy kak-static release=v2018.10.27 debug=no test -j
##

FROM alpine:latest

LABEL version="1.0" \
      maintainer="Frank LENORMAND <lenormf@gmail.com>" \
      description="Generate a static binary of the Kakoune editor" \
      source="https://github.com/mawww/kakoune/"

VOLUME /deploy

RUN apk update \
    && apk add g++ make ncurses ncurses-dev ncurses-static wget unzip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
