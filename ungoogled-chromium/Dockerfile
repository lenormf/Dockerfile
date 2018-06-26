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

FROM bitnami/minideb:stretch
MAINTAINER "Frank LENORMAND <lenormf@gmail.com>"
LABEL version="1.1" \
      description="Run `ungoogled-chromium` in a docker container" \
      source="https://github.com/Eloston/ungoogled-chromium"

ARG DISPLAY=:0
## Chromium version
ARG VERSION=67.0.3396.87-1

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
    install_packages wget ca-certificates \
    && wget https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium_${VERSION}.stretch_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium-common_${VERSION}.stretch_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium-driver_${VERSION}.stretch_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium-driver_${VERSION}.stretch_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium-shell_${VERSION}.stretch_amd64.deb \
            https://github.com/Eloston/ungoogled-chromium-binaries/releases/download/${VERSION}/ungoogled-chromium-l10n_${VERSION}.stretch_all.deb

RUN \
    apt-get update \
    && apt-get install -f -y \
        ./ungoogled-chromium_${VERSION}.stretch_amd64.deb \
        ./ungoogled-chromium-common_${VERSION}.stretch_amd64.deb \
        ./ungoogled-chromium-driver_${VERSION}.stretch_amd64.deb \
        ./ungoogled-chromium-shell_${VERSION}.stretch_amd64.deb \
        ./ungoogled-chromium-l10n_${VERSION}.stretch_all.deb

RUN \
    rm \
       ungoogled-chromium_${VERSION}.stretch_amd64.deb \
       ungoogled-chromium-common_${VERSION}.stretch_amd64.deb \
       ungoogled-chromium-driver_${VERSION}.stretch_amd64.deb \
       ungoogled-chromium-shell_${VERSION}.stretch_amd64.deb \
       ungoogled-chromium-l10n_${VERSION}.stretch_all.deb

RUN \
    install_packages lsb-release \
    && chown 0:0 /usr/lib/chromium/chrome-sandbox \
    && chmod 4755 /usr/lib/chromium/chrome-sandbox

RUN \
    useradd -m -u ${UID} -g ${GID} chromium \
    && chown -R ${UID}:${GID} /home/chromium
USER chromium

WORKDIR /home/chromium

CMD ungoogled-chromium
