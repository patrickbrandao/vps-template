#!/bin/bash

# Definir config de rede inicial em ambiente DHCP e BIOS
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Config principal
    (
        echo;
        echo 'auto lo';
        echo 'iface lo inet loopback';
        echo;
        echo 'auto eth0';
        echo 'iface eth0 inet dhcp';
        echo;
    ) > /etc/network/interfaces;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;

