#!/bin/bash

# Configurar timezone e ntp para sincronia de tempo
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Definindo como America/Sao_Paulo (UTC-3):
    timedatectl set-timezone America/Sao_Paulo;


    # Instalar pacote de sincronismo NTP via systemd (costuma vir instalado)
    apt -y install systemd-timesyncd;


    # Configurando manualmente:
    (
        echo;
        echo '[Time]';
        echo 'NTP=200.160.0.8 200.189.40.8 2001:12ff::8 2001:12f8:9:1::8';
        echo 'FallbackNTP=200.20.186.75 200.20.186.94 200.20.224.100 200.20.224.101';
        echo 'RootDistanceMaxSec=5';
        echo 'PollIntervalMinSec=32';
        echo 'PollIntervalMaxSec=2048';
        echo 'ConnectionRetrySec=30';
        echo 'SaveIntervalSec=60';
        echo
    ) >  /etc/systemd/timesyncd.conf;


    # Reiniciando o servico de timesync:
    systemctl restart systemd-timesyncd;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
