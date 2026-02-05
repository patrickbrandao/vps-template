#!/bin/bash

# Apagar conteudo (logs, rastros)
#==========================================================

    echo -n > /var/log/acpid.log;
    echo -n > /var/log/apk.log;
    echo -n > /var/log/dmesg;
    echo -n > /var/log/docker.log;
    echo -n > /var/log/messages;

exit 0;

