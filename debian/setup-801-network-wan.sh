#!/bin/bash

# Definir config de rede inicial em ambiente DHCP e BIOS
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Config principal
    (
		echo;
		echo '# The loopback network interface';
		echo 'auto lo';
		echo 'iface lo inet loopback';
		echo;
		echo 'source /etc/network/interfaces.d/*';
		echo;
		echo;
    ) > /etc/network/interfaces;

    # Interfaces em DHCP
    ETHERNET_LIST=$(ls -1 /sys/class/net/ | egrep '(en|et)');
    ETHERNET_LIST="$ETHERNET_LIST eth0";
    ETHERNET_LIST=$(for x in $ETHERNET_LIST; do echo $x; done | sort -u)
    for dev in $ETHERNET_LIST; do
		(
			echo;
			echo "allow-hotplug $dev";
			echo "iface $dev inet dhcp";
			#echo "iface $dev inet6 dhcp"
			echo;
		) > /etc/network/interfaces.d/$dev;
    done;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
