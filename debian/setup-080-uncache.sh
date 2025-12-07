#!/bin/bash

# unCache
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Criar script de limpeza de cache
    (
        echo '#!/bin/bash';
        echo;
        echo '# Limpar cache/buffer de ram';
        echo 'echo 1 > /proc/sys/vm/drop_caches;';
        echo 'echo 2 > /proc/sys/vm/drop_caches;';
        echo 'echo 3 > /proc/sys/vm/drop_caches;';
        echo;
        echo 'BLIST=$(lsblk -d -n -o NAME | sed "s/^/\/dev\//");';
        echo 'for bdev in $BLIST; do';
        echo '    blockdev --flushbufs $bdev;';
        echo 'done';
        echo;
        echo '# Sincronizar escrita atrasada no disco';
        echo 'sync;';
        echo;
    ) > /usr/share/drop-cache.sh;
    chmod +x /usr/share/drop-cache.sh;

    # Colocar para rodar todo dia:
    # - para ambientes com muita carga de I/O (banco de dados) o cache faz bem
    cp -rav /usr/share/drop-cache.sh /etc/cron.daily/drop-cache;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
