#!/bin/bash

# Renovar semente de entropia (nao tem no Alpine)
#==========================================================

    # Nao repetir execucao
    #f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Alterar semente de entropia
    #head -c 32 /dev/random > /var/lib/systemd/random-seed

    # Marcar essa tarefa como feita
    #echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
