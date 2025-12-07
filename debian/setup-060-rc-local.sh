#!/bin/bash

# Local-UP/Down
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Criar script para chamadas durante o boot:
    touch /etc/rc.local-up;   chmod +x /etc/rc.local-up;
    touch /etc/rc.local-down; chmod +x /etc/rc.local-down;

    # Diretorios para colocar os scripts que serao acionados
    mkdir -p /etc/local-up.d;
    mkdir -p /etc/local-down.d;

    # Conteudo de exemplo:
    # - script de boot
    (
        echo '#!/bin/sh';
        echo;
        echo 'echo "$(date) - Boot registrado" >> /var/log/local-up.log';
        echo "run-parts --regex '.*' /etc/local-up.d";
        echo;
        echo 'exit 0';
    ) > /etc/rc.local-up;

    # - script de desligamento
    (
        echo '#!/bin/sh';
        echo;
        echo 'echo "$(date) - Desligamento registrado" >> /var/log/local-down.log';
        echo "run-parts --regex '.*' /etc/local-down.d";
        echo;
        echo 'exit 0';
    ) > /etc/rc.local-down;

    # Servico de local-up
    (
        echo '[Unit]';
        echo 'Description=Boot script entrypoint';
        echo 'After=multi-user.target network-online.target';
        echo 'Wants=network-online.target';
        echo;
        echo '[Service]';
        echo 'Type=oneshot';
        echo 'ExecStart=/etc/rc.local-up';
        echo 'RemainAfterExit=yes';
        echo;
        echo '[Install]';
        echo 'WantedBy=multi-user.target';
        echo;
    ) > /etc/systemd/system/rc-local-up.service;

    # Servico de local-down
    (
        echo '[Unit]';
        echo 'Description=Shutdown script entrypoint';
        echo 'Before=shutdown.target reboot.target halt.target';
        echo 'DefaultDependencies=no';
        echo;
        echo '[Service]';
        echo 'Type=oneshot';
        echo 'ExecStart=/etc/rc.local-down';
        echo 'RemainAfterExit=yes';
        echo;
        echo '[Install]';
        echo 'WantedBy=halt.target reboot.target shutdown.target';
        echo;
    ) > /etc/systemd/system/rc-local-down.service;

    # Atualizar SystemD para ele detectar as novas units
    systemctl daemon-reload;

    # Ativar servicos rc-local-up e rc-local-down
    systemctl enable rc-local-up;
    systemctl enable rc-local-down;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
