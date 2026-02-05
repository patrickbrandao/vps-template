#!/bin/bash

# Agente Guest de VM
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Agent de VMWARE, instalar somente se for virtualizado no vmware
    IS_VMWARE=no;
    egrep -i vmware /sys/devices/virtual/dmi/id/bios_vendor && IS_VMWARE=yes;
    hostnamectl | grep -qi vmware && IS_VMWARE=yes;
    [ "$IS_VMWARE" = "yes" ] && {
        apk add open-vm-tools;
        rc-update add open-vm-tools default;
    };

    # Agent de KVM, instalar somente se for virtualizado no kvm
    IS_KVM=no;
    egrep -i kvm /sys/devices/virtual/dmi/id/bios_vendor && IS_KVM=yes;
    egrep -i emu /sys/devices/virtual/dmi/id/bios_vendor && IS_KVM=yes;
    [ "$IS_KVM" = "yes" ] && {
        apk add qemu-guest-agent;
        rc-update add qemu-guest-agent default;
    };

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
