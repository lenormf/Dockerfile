##
## Dockerfile by lenormf
##
## docker build --rm \
##   --build-arg DISPLAY=${DISPLAY} \
##   -t ${USER}/dolphin .
## docker run --rm --privileged \
##   -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
##   -v /dev/shm:/dev/shm \
##   -v /var/run/dbus:/var/run/dbus:ro \
##   -v /var/run/user/$(id -u)/pulse/native:/var/run/user/0/pulse/native:ro \
##   -v ~/.config/pulse/cookie:/root/.config/pulse/cookie:ro \
##   -v ???:/root/.dolphin-emu \
##   -v ???:/root/games:ro \
##   ${USER}/dolphin-emu
##

FROM debian:stretch
MAINTAINER "Frank LENORMAND <lenormf@gmail.com>"
LABEL version="1.0" \
      description="Run `dolphin` in a docker container"

ARG DISPLAY=:0

VOLUME /tmp/.X11-unix/
VOLUME /dev/shm/
VOLUME /var/run/dbus/
VOLUME /var/run/user/0/pulse/
VOLUME /root/.dolphin-emu/
VOLUME /root/games/
VOLUME /root/.config/pulse/

ENV PATH /usr/games:$PATH
ENV DISPLAY ${DISPLAY}
ENV PULSE_SERVER unix:/var/run/user/0/pulse/native
ENV PULSE_COOKIE /root/.config/pulse/cookie

RUN \
    apt-get update \
    && apt-get install -y dolphin-emu dolphin-plugins locales

RUN \
    echo en_US UTF-8 > /etc/locale.gen \
    && locale-gen \
    && echo export LANG=en_US.UTF-8 > /etc/profile.d/utf8.sh \
    && chmod +x /etc/profile.d/utf8.sh

CMD dolphin-emu
