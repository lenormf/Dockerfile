##
## Dockerfile by lenormf
##
## docker build --rm -t ${USER}/dolphin .
## docker run --privileged --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
##                              -v /var/run/dbus:/var/run/dbus:ro \
##                              -v /etc/localtime:/etc/localtime:ro \
##                              -v /var/run/user/${UID}/pulse/native:/var/run/user/${UID}/pulse/native:ro \
##                              -v ~/roms/:/home/dolphin/games/ \
##                              -v ~/.dolphin-emu:/home/dolphin/.dolphin-emu/ \
##                              ${USER}/dolphin
##

FROM alpine:edge
LABEL version="1.0" \
      description="Run `dolphin` in a docker container" \
      maintainer="Frank LENORMAND <lenormf@gmail.com>" \
      source="https://github.com/dolphin-emu/dolphin/"

ARG DOLPHIN_VERSION=master
ARG DISPLAY=:0

ARG UID=1000
ARG GID=100

ENV DISPLAY ${DISPLAY}
ENV PULSE_SERVER unix:/var/run/user/${UID}/pulse/native
ENV PULSE_COOKIE /home/dolphin/.config/pulse/cookie

VOLUME /tmp/.X11-unix/:/tmp/.X11-unix/
VOLUME /var/run/dbus/:/var/run/dbus/:ro
VOLUME /var/run/user/${UID}/pulse/native:/var/run/user/${UID}/pulse/native:ro
VOLUME /etc/localtime:/etc/localtime:ro
VOLUME /home/dolphin/games/
VOLUME /home/dolphin/.dolphin-emu/

RUN \
    apk update \
    && apk add wget ca-certificates unzip \
               cmake make gcc g++ \
               libx11-dev libevdev-dev libxi-dev libusb-dev libxrandr-dev \
               eudev-dev freeglut-dev pulseaudio-dev qt5-qtbase-x11 qt5-qtbase-dev \
               mesa-dri-intel ttf-opensans xdg-utils

RUN \
    wget -O dolphin-git.zip "https://github.com/dolphin-emu/dolphin/archive/${DOLPHIN_VERSION}.zip" \
    && unzip dolphin-git.zip \
    && rm -f dolphin-git.zip \
    && cd dolphin-${DOLPHIN_VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j3 \
    && make install \
    && rm -rf /dolphin-${DOLPHIN_VERSION}

# Group 97 is a hack to access the host input devices
RUN \
    addgroup -S -g 97 host_input \
    && { adduser -G host_input -u ${UID} dolphin || true; } \
    && adduser dolphin video \
    && adduser dolphin audio \
    && adduser dolphin input \
    && mkdir /home/dolphin/.config/ \
    && chown -R ${UID}:${GID} /home/dolphin

USER dolphin

WORKDIR /home/dolphin

CMD dolphin-emu
