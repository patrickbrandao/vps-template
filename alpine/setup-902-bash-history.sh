#!/bin/bash

# Apagar historico e rastro de acoes
#==========================================================

    (
        rm -f /root/.bash_history;
        rm -f /home/*/.bash_history;
        rm -f /root/.wget-hsts;
        rm -rf /root/.local;
        rm -rf /root/.config;
        rm -rf /root/.cache;
    ) 2>/dev/null;

exit 0;
