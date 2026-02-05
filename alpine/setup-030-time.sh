#!/bin/bash

# Configurar timezone e ntp para sincronia de tempo
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Definindo como America/Sao_Paulo (UTC-3):
    ln -sf /etc/zoneinfo/America/Sao_Paulo /etc/localtime;

    # OpenNTP
    apk add openntpd openntpd-openrc;

    # Configurando manualmente:
    (
        echo;
        echo 'servers pool.ntp.org';
        echo 'server time.cloudflare.com';
        echo 'sensor *';
        echo '';
        echo 'constraint from "9.9.9.9"              # quad9 v4 without DNS';
        echo 'constraint from "2620:fe::fe"          # quad9 v6 without DNS';
        echo 'constraints from "www.google.com"      # intentionally not 8.8.8.8';
        echo;
    ) >  /etc/systemd/timesyncd.conf;

    # Reiniciando o servico de ntp:
    service openntpd restart;

    # Ativar no boot
    rc-update add openntpd default;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
