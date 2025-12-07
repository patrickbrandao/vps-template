#!/bin/bash

# Repositorios
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Populando repositórios principais:
    (
        . /etc/os-release;

        DIST="$VERSION_CODENAME";
        BASE="http://deb.debian.org";
        SECB="http://security.debian.org";

        echo;
        echo "deb $BASE/debian/ $DIST main non-free-firmware";
        echo "deb-src $BASE/debian/ $DIST main non-free-firmware";
        echo;
        echo "deb $SECB/debian-security $DIST-security main non-free-firmware";
        echo "deb-src $SECB/debian-security $DIST-security main non-free-firmware";
        echo;
        echo "deb $BASE/debian/ $DIST-updates main non-free-firmware";
        echo "deb-src $BASE/debian/ $DIST-updates main non-free-firmware";
        echo;

    ) > /etc/apt/sources.list;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;

exit 0;
