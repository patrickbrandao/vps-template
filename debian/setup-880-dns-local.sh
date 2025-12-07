#!/bin/bash

 # Cliente DNS final no recursivo local
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # usar loopback como dns primario
    mkdir -p /etc/resolvconf/resolv.conf.d;
    (
        echo 'nameserver 127.0.0.1';
    ) > /etc/resolvconf/resolv.conf.d/head;

    # Atualizar resolvconf:
    resolvconf -u;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
