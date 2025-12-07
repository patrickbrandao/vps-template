#!/bin/bash

# Unbound - DNS Recursivo e Cache local
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Correcao de sobrevivencia do processo
    # Restart=on-failure para Restart=always
    sed -i 's#Restart=on-failure#Restart=always#' /lib/systemd/system/unbound.service;
    systemctl daemon-reload;

    # Ativar no systemd para subir durante o boot:
    systemctl enable unbound;

    # Baixar lista de root-servers atualizada:
    mkdir -p /etc/unbound;
    wget https://www.internic.net/domain/named.root -4 -O /etc/unbound/named.cache;

    # Produzir listas em formato intercambiável para uso nos
    # scripts diversos e de monitoramento
    cat /etc/unbound/named.cache | egrep -v '^;'         > /tmp/nc-nocmts.txt;
    cat /tmp/nc-nocmts.txt       | egrep -v NS           > /tmp/nc-ipaddr.txt;
    cat /tmp/nc-ipaddr.txt       | awk '{print $1";"$4}' > /tmp/nc-table.dat;
    cat /tmp/nc-table.dat        | cut -f2 -d';'         > /tmp/nc-iponly.dat;

    # Arquivos finais:
    cat /tmp/nc-table.dat   >  /etc/unbound/root-servers-table.dat;
    cat /tmp/nc-iponly.dat  >  /etc/unbound/root-servers-ips.dat;
    cat /tmp/nc-iponly.dat | egrep -v ':'  >  /etc/unbound/root-servers-ipv4.dat;
    cat /tmp/nc-iponly.dat | egrep    ':'  >  /etc/unbound/root-servers-ipv6.dat;

    # Garantir config padrao no formato /etc/unbound/unbound.conf.d/
    mkdir -p /etc/unbound/unbound.conf.d;
    rm    -f /etc/unbound/unbound.conf.d/* 2>/dev/null;

    # Recriar todas as configs do zero:
    # - Config principal:
    (
        echo;
        echo 'server:';
        echo '    module-config: "respip validator iterator"';
        echo;
        echo 'include-toplevel: "/etc/unbound/unbound.conf.d/*.conf"';
        echo;
    ) > /etc/unbound/unbound.conf;


    # - Chave pública da raiz do DNS (Root Zone Key), usado para DNSSEC:
    (
        echo;
        echo 'server:';
        echo;
        echo '    auto-trust-anchor-file: "/var/lib/unbound/root.key"';
        echo;
    ) > /etc/unbound/unbound.conf.d/21-root-auto-trust-anchor-file.conf;

    # - Gerador de estatísticas:
    (
        echo 'server:';
        echo '    statistics-interval: 0';
        echo '    extended-statistics: yes';
        echo '    statistics-cumulative: no';
        echo
    ) > /etc/unbound/unbound.conf.d/31-statisticas.conf;

    # - Protocolos - ativar todos
    # - Nota: coloque "no" no do-ip6 se você não tem IPv6 no servidor
    (
        echo;
        echo 'server:';
        echo;
        echo '    do-ip4: yes';
        echo '    do-ip6: yes';
        echo '    do-udp: yes';
        echo '    do-tcp: yes';
        echo;
    ) > /etc/unbound/unbound.conf.d/41-protocols.conf;

    # - ACL de uso - IPs locais (loopback e privados) confiaveis
    # - Nota: IPs privados definidos em RFC para IPv4:
    #         rfc  922, rfc  919, rfc 1112, rfc 1122,
    #         rfc 1918, rfc 2544, rfc 3068, rfc 3171,
    #         rfc 3330, rfc 3927, rfc 5735, rfc 5736,
    #         rfc 5737, rfc 6598,
    #
    # - Nota: IPs privados/não-globais definidos em RFC para IPv6:
    #         rfc 3849, rfc 9637
    #
    (
        echo;
        echo 'server:';
        echo;
        echo '    # Loopback';
        echo '    access-control: 127.0.0.1/32        allow';
        echo '    access-control: ::1/128             allow';
        echo;
        echo '    # Todas as faixas privadas RFCs';
        echo '    access-control: 0.0.0.0/8           allow';
        echo '    access-control: 10.0.0.0/8          allow';
        echo '    access-control: 100.64.0.0/10       allow';
        echo '    access-control: 127.0.0.0/8         allow';
        echo '    access-control: 169.254.0.0/16      allow';
        echo '    access-control: 172.16.0.0/12       allow';
        echo '    access-control: 192.0.0.0/24        allow';
        echo '    access-control: 192.0.2.0/24        allow';
        echo '    access-control: 192.88.99.0/24      allow';
        echo '    access-control: 192.168.0.0/16      allow';
        echo '    access-control: 198.18.0.0/15       allow';
        echo '    access-control: 198.51.100.0/24     allow';
        echo '    access-control: 203.0.113.0/24      allow';
        echo '    access-control: 224.0.0.0/4         allow';
        echo '    access-control: 240.0.0.0/4         allow';
        echo '    access-control: 255.255.255.255/32  allow';
        echo;
        echo '    # Faixas IPv6 privadas';
        echo '    access-control: 2001:db8::/32       allow';
        echo;
        echo '    # Faixas IPv6 nao-globais';
        echo '    access-control: ::/3                allow';
        echo '    access-control: 4000::/2            allow';
        echo '    access-control: 8000::/1            allow';
        echo
    ) > /etc/unbound/unbound.conf.d/51-acls-locals.conf;

    # - ACL de uso - IPs locais públicos (IPv4) e globais (IPv6)
    # - Nota: Coloque seus prefixos de IPs publicos,
    #         prefixos de IPs delegados pelo seu provedor,
    #         prefixos de IPs do seu ASN,
    #         informe IPv4 e IPv6, mesmo se não usar o IPv6
    #
    (
        echo;
        echo 'server:';
        echo;
        echo '    # IPs publicos (IPv4) delegados e proprios:';
        echo '    access-control: 45.171.60.0/22    allow';
        echo '    access-control: 200.192.152.0/22  allow';
        echo;
        echo '    # IPs globais (IPv6) delegados e proprios:';
        echo '    access-control: 2804:5964::/32    allow';
        echo;
    ) > /etc/unbound/unbound.conf.d/52-acls-trusteds.conf;

    # - ACL padrao - descartar tudo de IPs nao confiaveis
    # - Nota: nao use "refuse" como padrão pois ele gera resposta
    #         e pode fazer seu DNS ser explorado em DDoS
    #         usar "deny" pois ele descarta silenciosamente
    #         os pacotes de IPs desconhecidos
    (
        echo;
        echo 'server:';
        echo;
        echo '    # Nao responder para IPs desconhecidos';
        echo '    access-control: 0.0.0.0/0 deny';
        echo '    access-control: ::/0      deny';
        echo;
    ) > /etc/unbound/unbound.conf.d/59-acls-default-policy.conf;

    # Parametros gerais (tuning) - padrao para 4 nucleos, 64M de Cache em RAM
    (
        echo;
        echo 'server:';
        echo '    outgoing-range: 8192';
        echo '    outgoing-port-avoid: 0-1024';
        echo '    outgoing-port-permit: 1025-65535';
        echo '    num-threads: 4';
        echo '    num-queries-per-thread: 1024';
        echo '    msg-cache-size: 64m'; # Aumente a gosto, 1G, 2G, 4G...
        echo '    msg-cache-slabs: 4';
        echo '    rrset-cache-size: 8m';
        echo '    rrset-cache-slabs: 4';
        echo '    cache-min-ttl: 60';
        echo '    cache-max-ttl: 3600';
        echo '    infra-host-ttl: 60';
        echo '    infra-lame-ttl: 120';
        echo '    infra-cache-numhosts: 10000';
        echo '    infra-cache-lame-size: 10k';
        echo '    infra-cache-slabs: 4';
        echo '    key-cache-slabs: 4';
        echo '    rrset-roundrobin: yes';
        echo;
        echo '    hide-identity: yes';
        echo '    hide-version: yes';
        echo '    harden-glue: yes';
        echo '    harden-algo-downgrade: yes';
        echo '    harden-below-nxdomain: yes';
        echo '    harden-dnssec-stripped: yes';
        echo '    harden-large-queries: yes';
        echo '    harden-referral-path: no';
        echo '    harden-short-bufsize: yes';
        echo '    do-not-query-address: 127.0.0.1/8';
        echo '    do-not-query-localhost: yes';
        echo '    edns-buffer-size: 1472';
        echo '    aggressive-nsec: yes';
        echo '    delay-close: 10000';
        echo '    neg-cache-size: 4M';
        echo '    qname-minimisation: yes';
        echo '    deny-any: yes';
        echo '    ratelimit: 1000';
        echo '    unwanted-reply-threshold: 10000';
        echo '    use-caps-for-id: yes';
        echo '    val-clean-additional: yes';
        echo '    minimal-responses: yes';
        echo '    prefetch: yes';
        echo '    prefetch-key: yes';
        echo '    serve-expired: yes';
        echo '    so-reuseport: yes';
        echo;
    ) > /etc/unbound/unbound.conf.d/61-configs.conf;


    # Informar em quais enderecos IP locais o unbound deve abrir
    # a porta 53/tcp e 53/udp para escuta de requisicoes
    # - Escutar sempre nos ips de loopback
    (
        echo;
        echo 'server:';
        echo '    interface: 127.0.0.1';
        echo '    interface: ::1';
        echo;
    ) > /etc/unbound/unbound.conf.d/62-listen-loopback.conf;

    # - Escutar sempre nos ips externos
    #   * usar 0.0.0.0 não é uma boa ideia, embora funcione
    #     essa config causa assincronia no ip de resposta
    #     nos casos em que o servidor tem mais de um IP
    #   * correto: crie uma linha 'interface:' para cada IP
    #     publico ou de loopback
    (
        echo;
        echo 'server:';
        echo '    interface: 0.0.0.0';
        echo '    interface: ::';
        echo;
    ) > /etc/unbound/unbound.conf.d/63-listen-interfaces.conf;


    # - Hyperlocal Cache (opcional)
    # -- Requer lista de root-servers do inicio do tutorial!
    if [ -f /etc/unbound/root-servers-ips.dat ]; then
        (
            echo;
            echo 'server:';
            echo '    auth-zone:';
            echo '        name: "."';
            for addr in $(cat /etc/unbound/root-servers-ips.dat); do
                echo "            master: $addr";
            done;
            echo '        fallback-enabled: yes';
            echo '        for-downstream: no';
            echo '        for-upstream: yes';
            echo '        zonefile: ""';
            echo;
        ) > /etc/unbound/unbound.conf.d/89-hyperlocal-cache.conf;
    fi

    # - Controle remoto local do processo:
    # - Nota: somente localhost, por isso nao precisa de certificado
    (
        echo;
        echo 'remote-control:';
        echo '    control-enable: yes';
        echo '    control-interface: 127.0.0.1';
        echo '    control-port: 953';
        echo '    control-use-cert: "no"';
        echo '    control-interface: /run/unbound.ctl';
        echo;
    ) > /etc/unbound/unbound.conf.d/99-remote-control.conf;


    # Diretorio base da chave:
    mkdir -p /var/lib/unbound;

    # Executar o unbound-anchor para baixar a chave raiz
    unbound-anchor     -a /var/lib/unbound/root.key;
    # Link de referencia oficial em XML:
    #    https://data.iana.org/root-anchors/root-anchors.xml

    # Ajustar as permissões
    chown unbound:unbound /var/lib/unbound/root.key;
    chmod 644             /var/lib/unbound/root.key;

    # Conferindo:
    cat /var/lib/unbound/root.key;

    # Conferir:
    unbound-checkconf  /etc/unbound/unbound.conf;

    # Reiniciar e deixar pronto pra uso:
    systemctl stop  unbound;
    systemctl start unbound;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
