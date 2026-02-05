#!/bin/bash

# Repositorios
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Populando repositórios principais:
    (
        . /etc/os-release;

        AVER=$(echo $VERSION_ID | cut -f1,2 -d.);

        echo;
        echo "http://dl-cdn.alpinelinux.org/alpine/v$AVER/main";
        echo "http://dl-cdn.alpinelinux.org/alpine/v$AVER/community";
        echo;
    ) > /etc/apk/repositories;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;

exit 0;

