#!/bin/bash

 # Debian prepare
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Sincronizando índice:
    apk update;

    # Atualizar pacotes
    apk upgrade;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;

exit 0;
