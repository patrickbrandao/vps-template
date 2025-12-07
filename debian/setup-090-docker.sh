#!/bin/bash

# Docker
#========================================================================

    # Instalar
    [ -x /usr/bin/docker ] || {
        # Baixar script instalador oficial:
        curl -fsSL get.docker.com -o /tmp/get-docker.sh;

        # Executar script instalador:
        sh /tmp/get-docker.sh;
    };


    # Comando para parar e destruir um container:
    [ -x /usr/bin/undocker ] || {
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
    };

    # Comando para entrar no shell (/bin/sh) de um container:
    [ -x /usr/bin/dsh ] || {
		(
		    echo '#!/bin/sh';
		    echo;
		    echo 'cmd="$2";';
		    echo '[ "x$cmd" = "x" ] && cmd="bash"';
		    echo 'docker exec --user=root -it $1 $cmd;';
		    echo;
		) > /usr/bin/dsh;
		chmod +x /usr/bin/dsh;
    };

    # Comando para listar containers em execucao (inclusive parados):
    [ -x /usr/bin/dps ] || {
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
    };

    # Lista simples de containers (sem portas estragando a listagem)
    [ -x /usr/bin/dlist ] || {
        (
            echo '#!/bin/sh';
            echo;
            echo 'EXTRA=""';
            echo '[ "x$1" = "x" ] || EXTRA="-f name=$1";';
            echo 'CLS1="{{.ID}}\t{{.Names}}\t{{.Networks}}";';
            echo 'CLS2="\t{{.Status}}\t{{.Size}}\t{{.Image}}";';
            echo 'COLS="table $CLS1\t$CLS2";';
            echo 'echo;';
            echo 'docker ps --format "$COLS" $EXTRA;';
            echo 'echo;';
            echo;
        ) > /usr/bin/dlist;
        chmod +x /usr/bin/dlist;
    };

exit 0;

