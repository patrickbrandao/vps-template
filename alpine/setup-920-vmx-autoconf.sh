#!/bin/bash


# Criar servico de configuracao inicial da VM
#==========================================================


    ## /usr/share/vmware/set-hostname.sh
    #-------------------------------------------------------

    mkdir -p /usr/share/cloud;
    (
        echo '#!/bin/bash';
        echo;
        echo '    _log(){';
        echo '         echo "# $@";';
        echo '         NOWDT=$(date "+%Y-%m-%d %H:%M:%S");';
        echo '         echo "$NOWDT $@" >> /var/log/set-hostname.log;';
        echo '    };';
        echo;
        echo '    # Verificar se estamos no vmware';
        echo '    IS_VMWARE=no;';
        echo '    egrep -i vmware /sys/devices/virtual/dmi/id/bios_vendor && IS_VMWARE=yes;';
        echo '    hostnamectl | grep -qi vmware && IS_VMWARE=yes;';
        echo '    if [ "$IS_VMWARE" = "no" ]; then';
        echo '        _log "Nao estamos no vmware."';
        echo '        exit 0;';
        echo '    fi;';
        echo;
        echo '    # Conferir se o vmtoolsd existe';
        echo '    if [ ! -x /usr/bin/vmtoolsd ]; then';
        echo '        _log "Comando vmtoolsd nao existe."';
        echo '        exit 0;';
        echo '    fi;';
        echo;
        echo '    # Conferir se o hostname ja foi definido para';
        echo '    # essa versao de configuracao da VM';
        echo '    NEED_CONF=no;';
        echo '    CFG_VERSION="";';
        echo '    VMX_VERSION="";';
        echo '    if [ -f "/etc/vmx-set-hostname" ]; then';
        echo '        # Arquivo existe, conferir versao';
        echo '        LOC_VERSION=$(head -1 "/etc/vmx-set-hostname");';
        echo '        VMX_VERSION=$(vmtoolsd --cmd "info-get guestinfo.cfgv");';
        echo '        _log "Versao da configuracao local: $LOC_VERSION";';
        echo '        _log "Versao da configuracao da vm: $VMX_VERSION";';
        echo '        if [ "$LOC_VERSION" = "$VMX_VERSION" ]; then';
        echo '            _log "Configuracao OK, nada alterado";';
        echo '        else';
        echo '            _log "Administrador mudou a versao, reaplicar";';
        echo '            NEED_CONF=yes;';
        echo '        fi';
        echo '    else';
        echo '        # Arquivo nao existe, primeira vez';
        echo '        NEED_CONF=yes;';
        echo '    fi';
        echo '    # Carregar versao vmx caso ausente';
        echo '    [ "x$VMX_VERSION" = "x" ] && VMX_VERSION=$(vmtoolsd --cmd "info-get guestinfo.cfgv");';
        echo;
        echo '    # Realizar nova configuracao';
        echo '    if [ "$NEED_CONF" = "yes" ]; then';
        echo '        _log "Requer configuracao, iniciando";';
        echo '        VMX_FQDN=$(vmtoolsd --cmd "info-get guestinfo.fqdn");';
        echo '        VMX_IPV4=$(vmtoolsd --cmd "info-get guestinfo.ipv4");';
        echo '        VMX_IPV6=$(vmtoolsd --cmd "info-get guestinfo.ipv6");';
        echo;
        echo '        _log "Versao da configuracao VMX..: $VMX_VERSION";';
        echo '        _log "Nome de dns completo (FQDN).: $VMX_FQDN";';
        echo '        _log "Endereco IPv4 oficial.......: $VMX_IPV4";';
        echo '        _log "Endereco IPv6 oficial.......: $VMX_IPV6";';
        echo;
        echo '        if [ "x$VMX_FQDN" = "x" -o "x$VMX_IPV4" = "x" ]; then';
        echo '            # Incapaz de definir';
        echo '            _log "Falhou, FQDN e IPV4 sao mandatorios";';
        echo '        else';
        echo '            # Definir';
        echo '            VMX_NAME=$(echo $VMX_FQDN | cut -f1 -d.);';
        echo '            _log "Gravando arquivos hosts ($VMX_FQDN, $VMX_IPV4, $VMX_IPV6)";';
        echo '            (';
        echo '                echo;';
        echo '                echo "127.0.0.1    localhost";';
        echo '                echo "127.0.1.1    $VMX_FQDN    $VMX_NAME";';
        echo '                echo;';
        echo '                # Entrada ipv4 publica';
        echo '                echo "$VMX_IPV4    $VMX_FQDN    $VMX_NAME";';
        echo '                echo;';
        echo '                # Entrada ipv6 global';
        echo '                if [ "x$VMX_IPV6" = "x" ]; then';
        echo '                    _log "(ipv6 ausente)";';
        echo '                else';
        echo '                    echo "$VMX_IPV6    $VMX_FQDN    $VMX_NAME";';
        echo '                fi;';
        echo '                echo;';
        echo '                echo "::1      localhost   ip6-localhost   ip6-loopback";';
        echo '                echo "ff02::1  ip6-allnodes";';
        echo '                echo "ff02::2  ip6-allrouters";';
        echo '                echo;';
        echo '            ) > /etc/hosts;';
        echo '            echo;';
        echo '            _log "Definindo hostname ($VMX_FQDN)";';
        echo '            hostnamectl set-hostname $VMX_FQDN;';
        echo '            echo;';
        echo '            _log "Gravando versao da configuracao ($VMX_VERSION)";';
        echo '            echo "$VMX_VERSION" > /etc/vmx-set-hostname;';
        echo '            echo;';
        echo '        fi;';
        echo '    fi;';
        echo;
        echo '    # Fim';
        echo '    exit 0;';
    ) > /usr/share/cloud/vmware-set-hostname.sh
    chmod +x /usr/share/cloud/vmware-set-hostname.sh;

    # Unity de servico no SystemD
    # (
    #     echo '[Unit]';
    #     echo 'Description=Configure hostname from VMware';
    #     echo 'Documentation=man:vmtoolsd(8)';
    #     echo 'After=vmtoolsd.service network-online.target';
    #     echo 'Wants=vmtoolsd.service';
    #     echo 'Before=network.target network-online.target systemd-hostnamed.service';
    #     echo 'ConditionVirtualization=vmware';
    #     echo;
    #     echo '[Service]';
    #     echo 'Type=oneshot';
    #     echo 'RemainAfterExit=yes';
    #     echo 'User=root';
    #     echo 'Group=root';
    #     echo 'ExecStart=/usr/share/cloud/vmware-set-hostname.sh';
    #     echo 'Restart=on-failure';
    #     echo 'RestartSec=10';
    #     echo 'TimeoutStartSec=30';
    #     echo 'Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"';
    #     echo 'NoNewPrivileges=false';
    #     echo 'ProtectSystem=no';
    #     echo 'ProtectHome=yes';
    #     echo 'ReadWritePaths=/etc /var/log';
    #     echo 'SyslogIdentifier=set-hostname';
    #     echo;
    #     echo '[Install]';
    #     echo 'WantedBy=multi-user.target';
    # ) > /etc/systemd/system/vmware-set-hostname.service;

    # # Atualizar systemd:
    # systemctl daemon-reload;
    # systemctl enable vmware-set-hostname;

    # Apagar arquivo de versao para forcar proxima execucao
    rm -f /etc/vmx-set-hostname     2>/dev/null;
    rm -f /var/log/set-hostname.log 2>/dev/null;


exit 0;


