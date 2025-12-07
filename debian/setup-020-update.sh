#!/bin/bash

 # Debian prepare
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    alias apt='apt-get --no-install-recommends --assume-yes -o Dpkg::Options::="--force-confold"';

    # Sincronizando índice:
    apt -y update;

    # Atualizar pacotes
    apt -y upgrade;

    # Atualizar pacotes centrais:
    apt -y dist-upgrade;
    apt -y full-upgrade;

    # Limpar pacotes desnecessarios:
    apt -y autoremove;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;

exit 0;
