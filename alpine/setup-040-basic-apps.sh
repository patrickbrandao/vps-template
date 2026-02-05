#!/bin/bash

# Instalar pacotes fundamentais
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Pacotes basicos
    apk   add   bash;
    apk   add   sudo;
    apk   add   wget;
    apk   add   curl;
    apk   add   tcpdump;
    apk   add   mtr;
    apk   add   iproute2;
    apk   add   bridge-utils;
    apk   add   fping;
    apk   add   vlan;
    apk   add   mc;
    apk   add   htop;
    apk   add   strace;
    apk   add   openssh;
    apk   add   openssh-server;
    apk   add   iputils-arping;
    apk   add   iputils-ping;
    apk   add   apache2-utils;
    apk   add   rsync;
    apk   add   ca-certificates;
    apk   add   lsblk;
    apk   add   dhcpcd;

    # Firewall
    apk   add   iptables;
    apk   add   nftables;
    apk   add   nftables-openrc;
    apk   add   conntrack-tools;

    # Hacker tools
    apk   add   nmap;

    # SNMP
    apk   add   net-snmp;
    apk   add   net-snmp-tools;
    apk   add   net-snmp-openrc;
    apk   add   net-snmp-agent-libs;

    # Zip
    apk   add  xz;
    apk   add  tar;
    apk   add  zstd;
    apk   add  gzip;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;

