##
## Dockerfile by lenormf
## The docker image has to run in privileged mode to allow `chromium` to
## be able to run the sandbox (namespaces)
##
## docker build --rm \
##   --build-arg DISPLAY=${DISPLAY} \
##   --build-arg UID=$(id -u) \
##   --build-arg GID=$(id -g) \
##   -t ${USER}/chromium .
## docker run --rm --privileged --name=chromium \
##   -v /tmp/.X11-unix:/tmp/.X11-unix \
##   -v ~/Downloads:/home/chromium/Downloads \
##   -v ~/.config/chromium:/home/chromium/.config/chromium \
##   -v /etc/localtime:/etc/localtime \
##   -v /dev/snd:/dev/snd \
##   -v /dev/shm:/dev/shm \
##   -v /var/run/dbus:/var/run/dbus \
##   ${USER}/chromium
##

FROM debian:stretch
MAINTAINER "Frank LENORMAND <lenormf@gmail.com>"
LABEL version="1.1" \
      description="Run `ungoogled-chromium` in a docker container" \
      source="https://github.com/Eloston/ungoogled-chromium"

ARG DISPLAY=:0
## Chromium version
ARG VERSION=55.0.2883.75-1

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
VOLUME /home/chromium/Downloads/
VOLUME /home/chromium/.config/chromium/
VOLUME /home/chromium/.config/pulse/

WORKDIR /root

RUN \
    apt-get update \
    && apt-get install -y wget lsb-release \
    && wget https://github.com/Eloston/ungoogled-chromium/releases/download/${VERSION}/chromedriver_${VERSION}_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium/releases/download/${VERSION}/chrome-sandbox_${VERSION}_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium/releases/download/${VERSION}/chromium_${VERSION}_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium/releases/download/${VERSION}/chromium-l10n_${VERSION}_all.deb

RUN \
    apt-get install -f -y \
        ./chromedriver_${VERSION}_amd64.deb \
        ./chrome-sandbox_${VERSION}_amd64.deb \
        ./chromium_${VERSION}_amd64.deb \
        ./chromium-l10n_${VERSION}_all.deb

RUN \
    rm chromedriver_${VERSION}_amd64.deb \
       chrome-sandbox_${VERSION}_amd64.deb \
       chromium_${VERSION}_amd64.deb \
       chromium-l10n_${VERSION}_all.deb

RUN \
    useradd -m -u ${UID} -g ${GID} chromium \
    && chown -R ${UID}:${GID} /home/chromium
USER chromium

WORKDIR /home/chromium

CMD chromium