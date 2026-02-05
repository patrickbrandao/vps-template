#!/bin/bash

 # DNS inicial para ajustes
#========================================================================

    # Nao repetir execucao
    #f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Criando o arquivo "head" que será usado antes
    # do "dns-nameservers" do NetworkManager
    # mkdir -p /etc/resolvconf/resolv.conf.d;
    # (
    #     echo 'nameserver 8.8.8.8';
    #     echo 'nameserver 9.9.9.9';
    # ) > /etc/resolvconf/resolv.conf.d/head;

    # # Atualizar resolvconf:
    # resolvconf -u;


    # Marcar essa tarefa como feita
    #echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
