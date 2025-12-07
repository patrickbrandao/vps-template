#!/bin/bash

# Boot simplificado
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Atualizar opcoes de grub
    egrep -q mitigations /etc/default/grub || {
        # Adicionar opcoes
        # - net.ifnames=0 biosdevname=0 para nome eth0
        OPT01="net.ifnames=0 biosdevname=0";
        # - mitigations=off para desativar mitigacao de cpu, ambiente de software proprios
        OPT02="mitigations=off";
        # - default_hugepagesz=2M hugepagesz=2M hugepages=1024 para 2G de huge-pages, para ajudar softwares gordos
        OPT03="default_hugepagesz=2M hugepagesz=2M hugepages=512";

        # juntar opcoes
        OPTIONS=$(echo $OPT01 $OPT02 $OPT03);
        sed -i \
            "s#GRUB_CMDLINE_LINUX=.*#GRUB_CMDLINE_LINUX='$OPTIONS'#" \
            /etc/default/grub;
        # Compilar bootloader
        grub-mkconfig -o /boot/grub/grub.cfg;
    };

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;

