#!/bin/bash

# Instalar pacotes fundamentais
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Pacotes nativos do Debian, mas que devem estar presentes,
    # rode esse comando para garantir que nao faltou nenhum pacote basico:
    apt -y install \
        bash  bind9-dnsutils  bind9-host bsdextrautils \
        bsdutils busybox bzip2 ca-certificates coreutils \
        cpio cron cron-daemon-common debianutils dmidecode dmsetup \
        e2fsprogs eject ethtool fdisk file findutils \
        fuse3 grep gzip \
        hostname iproute2 iputils-ping \
        kmod less locales logrotate lsof \
        mawk mount nano \
        nftables openssh-client openssh-server openssh-sftp-server openssl \
        pci.ids pciutils procps \
        sed tar traceroute \
        tzdata unzip util-linux wget \
        whiptail xz-utils zstd;


    # Programas de compressao
    apt -y install tar;
    apt -y install zstd;
    apt -y install xz-utils;
    apt -y install zip;

    # Sudo
    apt -y install sudo;

    # Pacote com comando curl, vital para testes de HTTP e chamadas de API REST
    apt -y install curl;

    # Lista de CAs root para certificados SSL/TLS
    apt -y install ca-certificates;

    # Ferramentas de criptografia basica:
    apt -y install gnupg2 openssl;

    # Servidor SSH para acesso remoto
    apt -y install openssh-client openssh-server rsync;
    systemctl enable ssh;
    systemctl start  ssh;

    # Comando ip (ip addr show, ip route show, ip rule show, ip nei show)
    apt -y install iproute2;

    # Comandos de rede: mtr, traceroute, ping, fping, whois
    apt -y install mtr traceroute iputils-ping fping whois;

    # Comando para sniffer de rede e analise de pacotes
    # ex.: tcpdump -pnevas0 -i eth0
    apt -y install tcpdump;

    # Editor: mcedit
    apt -y install mc;

    # Comandos para conferir uso de CPU/RAM: htop
    apt -y install htop psmisc;

    # Monitor de consumo de I/O
    apt -y install iotop;

    # Programa de firewall
    # - nftables.: nft list ruleset
    # - conntrack: conntrack -L
    apt -y install nftables conntrack;

    # Gerador de UUID personalizado ( uuidgen -t,  uuidgen -r, ...)
    apt -y install uuid uuid-runtime;

    # Suporte a VLANs (vconfig, vlans 802.1q, 802.1ad)
    apt -y install vlan;

    # Strace para debug
    apt -y install strace;

    # Bridge (brctl)
    apt -y install bridge-utils;

    # Instalar Unbound:
    apt -y install unbound;
    apt -y install unbound-anchor;

    # Instalar ferramentas de DNS:
    apt -y install dnsutils;

    # resolvconf
    apt -y install resolvconf;
    resolvconf -u;

    # Instalar servidor snmp
    apt -y install snmp snmpd;


    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;

