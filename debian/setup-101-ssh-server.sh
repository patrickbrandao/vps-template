#!/bin/bash

# Correcoes no servico de SSH
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Apagar chaves para gerar novamente no boot
    (
        rm -f /etc/ssh/ssh_host_ecdsa_key;
        rm -f /etc/ssh/ssh_host_ecdsa_key.pub;
        rm -f /etc/ssh/ssh_host_rsa_key;
        rm -f /etc/ssh/ssh_host_rsa_key.pub;
        rm -f /etc/ssh/ssh_host_ed25519_key.pub;
        rm -f /etc/ssh/ssh_host_ed25519_key;
    ) 2>/dev/null;

    # Rodar rotina de geracao de novas chaves privadas durante o boot
    # em caso de ausencia das chaves
    # > dpkg-reconfigure openssh-server
    egrep -q ssh_host_rsa_key /lib/systemd/system/ssh.service || {
        NEW_CMD="/usr/sbin/dpkg-reconfigure -f noninteractive openssh-server";
        NEW_LINE="ExecStartPre=/bin/bash -c 'if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then $NEW_CMD; fi'";
        sed -i "/EnvironmentFile=/a $NEW_LINE" /lib/systemd/system/ssh.service;
    };


# SSH
#========================================================================

    # Abrir porta padrao 22:
    echo "Port                   22" > /etc/ssh/sshd_config.d/inc-port-main.conf;

    # Abrir portas em IPv4 e IPv6
    echo "AddressFamily         any"  > /etc/ssh/sshd_config.d/inc-addr-family.conf;

    # Endereço IPv4 de escuta, 0.0.0.0 = todos os IPv4 do servidor
    echo "ListenAddress     0.0.0.0"  > /etc/ssh/sshd_config.d/inc-listen-ipv4.conf;

    # Endereço IPv6 de escuta, :: = todos os IPv6 do servidor
    echo "ListenAddress          ::"  > /etc/ssh/sshd_config.d/inc-listen-ipv6.conf;

    # Desativar exibição do motd do OpenSSH, ainda mantem o /etc/motd do bash
    echo "PrintMotd              no"  > /etc/ssh/sshd_config.d/inc-motd.conf;

    # Flags de cabeçalho IP para tratamento QoS diferenciado
    echo "IPQoS  lowdelay throughput" > /etc/ssh/sshd_config.d/inc-ipv4-qos.conf;

    # Ativar keep-alive de TCP (camada 4)
    echo "TCPKeepAlive            yes" > /etc/ssh/sshd_config.d/inc-tcp-alive.conf;

    # Ativar keep-alive de SSH (camada 5)
    echo "ClientAliveInterval       3" >  /etc/ssh/sshd_config.d/inc-ssh-alive.conf;
    echo "ClientAliveCountMax      15" >> /etc/ssh/sshd_config.d/inc-ssh-alive.conf;

    # Permitir encaminhamento pelo ssh-agent
    echo "AllowAgentForwarding   yes" > /etc/ssh/sshd_config.d/inc-agent-forward.conf;

    # Permitir encaminhamento de porta remota
    echo "AllowTcpForwarding      yes" > /etc/ssh/sshd_config.d/inc-tcp-forward.conf;

    # Permitir encaminhamento de servidor X11 por meio de conexao SHS
    echo "X11Forwarding           yes" > /etc/ssh/sshd_config.d/inc-x11.conf;

    # Permitir que o cliente especifique ips e portas para encaminhamento
    echo "GatewayPorts clientspecified" > /etc/ssh/sshd_config.d/inc-gateway-ports.conf;

    # Permitir que o cliente especifique IPs a escutar em portas remotas
    echo "PermitListen            any" > /etc/ssh/sshd_config.d/inc-permit-listen.conf;

    # Permitir abertura de terminal (necessario para usuario conseguir um shell)
    echo "PermitTTY               yes" > /etc/ssh/sshd_config.d/inc-tty.conf;

    # Permitir usar o SSH para fazer VPN
    echo "PermitTunnel            yes" > /etc/ssh/sshd_config.d/inc-tunnel.conf;

    # Nao exibir o ultimo login do usuario ao entrar no shell via SSH
    echo "PrintLastLog             no" > /etc/ssh/sshd_config.d/inc-lastlog.conf;

    # Desativar compressão de dados (shell mais responsivo)
    echo "Compression              no" > /etc/ssh/sshd_config.d/inc-compression.conf;

    # Nao consultar DNS reverso do ip do usuário no inicio da conexão
    echo "UseDNS                   no" > /etc/ssh/sshd_config.d/inc-dns.conf;

    # Especificar fingerprint de versão
    echo "VersionAddendum    OpenSSH_11" >> /etc/ssh/sshd_config.d/inc-version.conf;

    # Permitir que o root faça login usando senha
    echo "PermitRootLogin          yes" >  /etc/ssh/sshd_config.d/inc-permit-root.conf;

    # Permitir autenticação usando chave publica
    echo "PubkeyAuthentication     yes" >  /etc/ssh/sshd_config.d/inc-pubkey.conf;

    # Renegociar chaves simetricas a cada 1G transferido ou a cada 1h de sessão
    echo "RekeyLimit              1G 1h" >  /etc/ssh/sshd_config.d/inc-rekey.conf;

    # Tamanho ma­nimo da chave RSA aceita:
    echo "RequiredRSASize          2048" >  /etc/ssh/sshd_config.d/inc-rsa-size.conf;

    # Testar configuracao:
    sshd -t -f /etc/ssh/sshd_config && { echo; echo CONFIG SSHD OK; echo; }

    # Reiniciar servidor ssh para aplicar:
    service ssh restart;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;



exit 0;
