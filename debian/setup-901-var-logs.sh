#!/bin/bash

# Apagar conteudo (logs, rastros)
#==========================================================

    echo -n > /var/log/btmp;
    echo -n > /var/log/vmware-vmtoolsd-root.log;
    echo -n > /var/log/vmware-vmsvc-root.log;
    echo -n > /var/log/apt/history.log;
    echo -n > /var/log/apt/term.log;
    echo -n > /var/log/lastlog;
    echo -n > /var/log/dpkg.log;
    echo -n > /var/log/alternatives.log;
    echo -n > /var/log/wtmp;
    echo -n > /var/log/fontconfig.log;
    echo -n > /var/log/installer/partman;
    echo -n > /var/log/installer/cdebconf/questions.dat;
    echo -n > /var/log/installer/syslog;
    echo -n > /var/log/installer/hardware-summary;
    echo -n > /var/log/local-down.log;
    echo -n > /var/log/local-up.log;

    rm -f /var/log/vmware-*.log;

    # Apagar logs journal
    rm -rf /var/log/journal/*;

exit 0;

