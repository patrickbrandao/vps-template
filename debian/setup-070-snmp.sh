#!/bin/bash

# SNMP
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Corrigir resiliencia do servico SNMP:
    grep -q "^Restart=" /lib/systemd/system/snmpd.service || \
        sed -i '/^\[Service\]/a Restart=always' /lib/systemd/system/snmpd.service;
    systemctl daemon-reload;

    # Ativar no boot:
    systemctl enable snmpd;

    # Backup da config inicial:
    [ -f /etc/snmp/orig-snmpd.conf ] || cp /etc/snmp/snmpd.conf /etc/snmp/orig-snmpd.conf;

    # Configuracao inicial - personalize as variaveis abaixo antes de colar:
    ADMIN="Aluno";
    COMMUNITY="Starter2025";
    GPSLOCATION="-22.224459,-54.806137"; # MS/GD
    PORT=48161;
    (
        echo;
        echo 'master agentx';
        echo 'agentXPerms 0777 0777';
        echo 'smuxpeer .1.3.6.1.2.1.83';
        echo 'smuxpeer .1.3.6.1.2.1.157';
        echo 'smuxsocket localhost';
        echo;
        echo "rocommunity $COMMUNITY";
        echo "rocommunity6 $COMMUNITY";
        echo;
        echo "syscontact \"$ADMIN\"";
        echo "syslocation $GPSLOCATION";
        echo "sysName $(hostname)";
        echo "SysDescr Debian-$(hostname)";
        echo;
        P=$PORT;
        echo "agentaddress unix:/run/snmpd.socket,udp:$P,udp6:$P,tcp6:$P,tcp:$P";
        echo;
        RS1='linkUpTrap linkUp ifIndex ifDescr ifType ifAdminStatus ifOperStatus';
        RS2='linkDownTrap linkDown ifIndex ifDescr ifType ifAdminStatus ifOperStatus';
        echo "notificationEvent $RS1";
        echo "notificationEvent $RS2";
        echo;
        echo 'monitor -r 10 -e linkUpTrap "Generate linkUp" ifOperStatus != 2';
        echo 'monitor -r 10 -e linkDownTrap "Generate linkDown" ifOperStatus == 2';
        echo;
        echo "com2sec notConfigUser  default       $COMMUNITY";
        echo 'group notConfigGroup v1 notConfigUser';
        echo 'group notConfigGroup v2c notConfigUser';
        echo;
        echo 'view    systemview           included      .1';
        echo;
        echo 'access notConfigGroup "" any noauth exact systemview none none';
        echo 'defaultMonitors yes';
        echo 'linkUpDownNotifications yes';
        echo;
    ) > /etc/snmp/snmpd.conf;

    # Reiniciar:
    systemctl restart snmpd;

    # Testando (usando community da variavel acima):
    snmpwalk -v2c -c $COMMUNITY  127.0.0.1:$PORT  .1.3.6.1.2.1.31.1.1.1.1;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
