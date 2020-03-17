FROM bitnami/minideb:buster
LABEL \
    maintainer="Frank LENORMAND <lenormf@gmail.com>" \
    version="1.0" \
    description="Tor browser bundle"

# Version and language of the tor bundle
ARG VERSION=9.0.6

## IDs of the user/group that will own the Downloads directory
ARG UID=1000
ARG GID=100

ARG DISPLAY=:0

ENV DISPLAY ${DISPLAY}
ENV PULSE_SERVER unix:/var/run/user/${UID}/pulse/native
ENV PULSE_COOKIE /root/.config/pulse/cookie

VOLUME /tmp/.X11-unix/:/tmp/.X11-unix/
VOLUME /dev/shm:/dev/shm
VOLUME /var/run/dbus:/var/run/dbus
VOLUME /var/run/user/${UID}/pulse/
VOLUME /etc/localtime:/etc/localtime

VOLUME /home/tor-browser/Downloads

RUN \
    install_packages \
        wget gpg gpg-agent locales xz-utils file \
        dirmngr ca-certificates \
        libfreetype6 libfontconfig1 libxrender1 libdbus-glib-1-2 libgtk-3-0 libx11-xcb-dev libx11-xcb1 libxt6

RUN \
    echo en_US UTF-8 > /etc/locale.gen \
    && locale-gen

ENV LANG en_US.UTF-8

RUN \
    useradd -m -u ${UID} -g ${GID} tor-browser \
    && addgroup tor-browser users \
    && echo tor-browser:tor-browser | chpasswd \
    && chown -R tor-browser:users /home/tor-browser

USER tor-browser
WORKDIR /home/tor-browser

RUN \
    gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org \
    && gpg --output ./tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290

RUN \
    wget https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz \
    && wget https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz.asc \
    && gpgv --keyring ./tor.keyring tor-browser-linux64-${VERSION}_en-US.tar.xz.asc tor-browser-linux64-${VERSION}_en-US.tar.xz \
    && tar xfJ tor-browser-linux64-${VERSION}_en-US.tar.xz \
    && rm -f tor.keyring tor-browser-linux64-${VERSION}_en-US.tar.xz.asc tor-browser-linux64-${VERSION}_en-US.tar.xz

WORKDIR tor-browser_en-US

CMD ["./Browser/start-tor-browser", "--log", "/dev/stdout"]
