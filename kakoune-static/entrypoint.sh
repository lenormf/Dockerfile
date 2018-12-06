#!/bin/sh

set -e

RELEASE="master"
DEBUG="no"

log() {
    printf %s\\n "$*"
}

error() {
    log "$*" >&2
}

fatal() {
    error "$*"
    exit 1
}

main() {
    ac=0
    for i in "$@"; do
        if printf %s "${i}" | grep -q '^release='; then
            RELEASE="${i#*=}"
            ac=$((ac + 1))
        elif printf %s "${i}" | grep -q '^debug='; then
            DEBUG=$(printf %s "${i#*=}" | tr '[A-Z]' '[a-z]')
            ac=$((ac + 1))
        else
            break
        fi
    done
    shift ${ac}

    if [ -z "${RELEASE}" ]; then
        fatal "Ño release name given"
    elif [ -z "${DEBUG}" ]; then
        fatal "No debug value given ('yes' / 'no')"
    elif [ "${DEBUG}" != "yes" ] && [ "${DEBUG}" != "no" ]; then
        fatal "The debug variable has to be either 'yes' or 'no'"
    fi

    wget -O kakoune.zip https://github.com/mawww/kakoune/archive/"${RELEASE}".zip
    unzip kakoune.zip -d kakoune-build

    cd kakoune-build/kakoune-*/src
    make static=yes debug=${DEBUG} kak "$@"

    mv kak.* /deploy/kak
}

main "$@"
