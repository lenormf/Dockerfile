##
## Dockerfile by lenormf
## The docker image has to run in privileged mode to allow `vivaldi` to
## be able to run the sandbox (namespaces)
##
## docker build --rm \
##   --build-arg DISPLAY=${DISPLAY} \
##   --build-arg UID=$(id -u) \
##   --build-arg GID=$(id -g) \
##   -t ${USER}/vivaldi .
## docker run --rm --privileged --name=vivaldi \
##   -v /tmp/.X11-unix:/tmp/.X11-unix \
##   -v ~/Downloads:/home/vivaldi/Downloads \
##   -v ~/.config/vivaldi:/home/vivaldi/.config/vivaldi \
##   -v /etc/localtime:/etc/localtime \
##   -v /dev/snd:/dev/snd \
##   -v /dev/shm:/dev/shm \
##   -v /var/run/dbus:/var/run/dbus \
##   ${USER}/vivaldi
##

FROM bitnami/minideb:unstable
MAINTAINER "Frank LENORMAND <lenormf@gmail.com>"
LABEL version="1.0" \
      description="Run `vivaldi` in a docker container" \
      source="https://vivaldi.com/"

ARG DISPLAY=:0
## Vivaldi version
ARG VERSION=2.0.1309.29-2_amd64
## Codecs version
ARG CODECS_VERSION=69.0.3497.100-0ubuntu1_amd64

## IDs of the user/group that will own the Downloads directory
ARG UID=1000
ARG GID=100

ENV DISPLAY ${DISPLAY}
ENV PULSE_SERVER unix:/var/run/user/${UID}/pulse/native
ENV PULSE_COOKIE /root/.config/pulse/cookie

VOLUME /tmp/.X11-unix/:/tmp/.X11-unix/
VOLUME /dev/shm:/dev/shm
VOLUME /var/run/dbus:/var/run/dbus
VOLUME /var/run/user/${UID}/pulse/
VOLUME /etc/localtime:/etc/localtime
VOLUME /home/vivaldi/Downloads/
VOLUME /home/vivaldi/.config/vivaldi/
VOLUME /home/vivaldi/.config/pulse/

WORKDIR /root

RUN \
    install_packages wget ca-certificates \
    && wget "https://downloads.vivaldi.com/stable/vivaldi-stable_${VERSION}.deb" \
    && apt-get update \
    && apt-get install -f -y \
        "./vivaldi-stable_${VERSION}.deb" \
    && rm -f "./vivaldi-stable_${VERSION}.deb"

RUN \
    install_packages binutils tar xz-utils \
    && wget "http://security.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_${CODECS_VERSION}.deb" \
    && ar p "chromium-codecs-ffmpeg-extra_${CODECS_VERSION}.deb" data.tar.xz | tar Jx ./usr/lib/chromium-browser/libffmpeg.so --strip 4 \
    && mkdir -p /home/vivaldi/.local/lib/vivaldi \
    && mv libffmpeg.so /home/vivaldi/.local/lib/vivaldi/libffmpeg.so \
    && rm -f "chromium-codecs-ffmpeg-extra_${CODECS_VERSION}.deb"

RUN \
    useradd -m -u ${UID} -g ${GID} vivaldi \
    && chown -R ${UID}:${GID} /home/vivaldi
USER vivaldi

WORKDIR /home/vivaldi

CMD vivaldi
