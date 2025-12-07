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
        apt-get -y install open-vm-tools;
        systemctl enable open-vm-tools;
        systemctl start  open-vm-tools;
    };

    # Agent de KVM, instalar somente se for virtualizado no kvm
    IS_KVM=no;
    egrep -i kvm /sys/devices/virtual/dmi/id/bios_vendor && IS_KVM=yes;
    egrep -i emu /sys/devices/virtual/dmi/id/bios_vendor && IS_KVM=yes;
    [ "$IS_KVM" = "yes" ] && {
        apt-get -y install qemu-guest-agent;
        systemctl enable qemu-guest-agent;
        systemctl start  qemu-guest-agent;
    };

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
