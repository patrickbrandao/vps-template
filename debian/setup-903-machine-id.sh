#!/bin/bash


# Correcoes no identificador unico do Linux
#==========================================================

    # apagar machine-id (zerar para renovar)
    truncate -s 0 /etc/machine-id;
    truncate -s 0 /var/lib/dbus/machine-id;

exit 0;
