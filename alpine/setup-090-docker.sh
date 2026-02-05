#!/bin/bash

# Docker
#========================================================================

    # Instalar
    [ -x /usr/bin/docker ] || {
        apk add docker;
    };

    # Ativar no boot
    rc-update add docker default;

    # Reiniciar:
    service docker restart;

    # Comando para parar e destruir um container:
    (
        echo '#!/bin/sh';
        echo;
        echo 'for x in $@; do';
        echo '    echo -n "Stop and delete [$1] ";';
        echo '    docker stop $x 2>/dev/null 1>/dev/null;'
        echo '    echo -n ".";';
        echo '    docker stop $x 2>/dev/null 1>/dev/null;'
        echo '    echo -n ".";';
        echo '    docker rm -f $x 2>/dev/null 1>/dev/null;'
        echo '    echo -n ".";';
        echo '    echo "OK";';
        echo 'done';
        echo;
    ) > /usr/bin/undocker;
    chmod +x /usr/bin/undocker;


    # Comando para entrar no shell (/bin/sh ou comando informado) de um container:
    (
        echo '#!/bin/sh';
        echo;
        echo 'cmd="$2";';
        echo '[ "x$cmd" = "x" ] && cmd="bash"';
        echo 'docker exec --user=root -it $1 $cmd;';
        echo;
    ) > /usr/bin/dsh;
    chmod +x /usr/bin/dsh;


    # Comando para inspecionar container
    (
        echo '#!/bin/sh';
        echo;
        echo 'which jq 2>/dev/null 1>/dev/null;';
        echo 'jqfound="$?";';
        echo 'if [ "$jqfound" = "0" ]; then';
        echo '    docker inspect $1 | jq;';
        echo 'else';
        echo '    docker inspect $1;';
        echo 'fi;';
        echo;
    ) > /usr/bin/di;
    chmod +x /usr/bin/di;


    # Comando para visualizar logs do container
    (
        echo '#!/bin/sh';
        echo;
        echo 'docker logs $1;';
        echo;
    ) > /usr/bin/dlog;
    chmod +x /usr/bin/dlog;


    # Comando para visualizar logs do container em tempo real
    (
        echo '#!/bin/sh';
        echo;
        echo 'docker logs -f $1;';
        echo;
    ) > /usr/bin/dtail;
    chmod +x /usr/bin/dtail;


    # Comando para listar containers em execucao (inclusive parados):
    (
        echo '#!/bin/sh';
        echo;
        echo 'EXTRA="";';
        echo '[ "x$1" = "x" ] || EXTRA="-f name=$1";';
        echo 'echo;';
        echo 'docker ps -a $EXTRA;';
        echo 'echo;';
        echo;
    ) > /usr/bin/dps;
    chmod +x /usr/bin/dps;


    # Parar containers por busca no nome
    (
        echo '#!/bin/sh';
        echo;
        echo 'FIND="$1";';
        echo '[ "x$FIND" = "x" ] && FIND="foobar";';
        echo 'echo;';
        echo 'docker ps -a | egrep "$FIND";';
        echo "didlist=\$(docker ps -a | egrep "\$FIND" | awk '{print \$1}');";
        echo 'for did in $didlist; do docker stop $did; done;';
        echo 'echo;';
        echo;
    ) > /usr/bin/dstop;
    chmod +x /usr/bin/dstop;


    # Iniciar containers por busca no nome
    (
        echo '#!/bin/sh';
        echo;
        echo 'FIND="$1";';
        echo '[ "x$FIND" = "x" ] && FIND="foobar";';
        echo 'echo;';
        echo 'docker ps -a | egrep "$FIND";';
        echo "didlist=\$(docker ps -a | egrep "\$FIND" | awk '{print \$1}');";
        echo 'for did in $didlist; do docker start $did; done;';
        echo 'echo;';
        echo;
    ) > /usr/bin/dstart;
    chmod +x /usr/bin/dstart;


    # Deletar containers por busca no nome
    (
        echo '#!/bin/sh';
        echo;
        echo 'FIND="$1";';
        echo '[ "x$FIND" = "x" ] && FIND="foobar";';
        echo 'echo;';
        echo 'docker ps -a | egrep "$FIND";';
        echo "didlist=\$(docker ps -a | egrep "\$FIND" | awk '{print \$1}');";
        echo 'for did in $didlist; do';
        echo '    docker stop $did; docker rm $did; docker rm -f $did;';
        echo 'done 2>/dev/null;';
        echo 'echo;';
        echo;
    ) > /usr/bin/ddelete;
    chmod +x /usr/bin/ddelete;


    # Lista simples de containers (sem portas estragando a listagem)
    (
        echo '#!/bin/sh';
        echo;
        echo 'EXTRA="";';
        echo 'ONLY_RUNNING=yes;';
        echo '[ "x$1" = "x" ] || {';
        echo '    EXTRA="-f name=$1";';
        echo '    ONLY_RUNNING="no";';
        echo '};';
        echo 'CLS1="{{.ID}}\t{{.Names}}\t{{.Networks}}";';
        echo 'CLS2="\t{{.Status}}\t{{.Size}}\t{{.Image}}";';
        echo 'COLS="table $CLS1\t$CLS2";';
        echo 'echo;';
        echo 'if [ "$ONLY_RUNNING" = "yes" ]; then';
        echo '    docker ps --format "$COLS" $EXTRA;';
        echo 'else';
        echo '    docker ps -a --format "$COLS" $EXTRA;';
        echo 'fi;';
        echo 'echo;';
        echo;
    ) > /usr/bin/dlist;
    chmod +x /usr/bin/dlist;


exit 0;

