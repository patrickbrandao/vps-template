#!/bin/bash

# Banner
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Apagar banner pos-login
    #echo -n > /etc/motd;

    _echo_part0(){ /bin/echo -e "\033[0;34m$@\033[0m"; }
    _echo_part1(){ /bin/echo -ne "\033[0;34m$@\033[0m"; }
    _echo_part2(){ /bin/echo -e "\x1B[96m$@\033[0m"; };

    # https://patorjk.com/software/taag/#p=display&f=Colossal&t=+ISP+AI&x=none&v=4&h=4&w=80&we=false
    (
        echo;
        echo;
        _echo_part1 '            d8888 888          d8b                   '; _echo_part2 '  8888888b.                    888';
        _echo_part1 '           d88888 888          Y8P                   '; _echo_part2 '  888  "Y88b                   888';
        _echo_part1 '          d88P888 888                                '; _echo_part2 '  888    888                   888';
        _echo_part1 '         d88P 888 888 88888b.  888 88888b.   .d88b.  '; _echo_part2 '  888    888  .d88b.   .d8888b 888  888  .d88b.  888d888';
        _echo_part1 '        d88P  888 888 888 "88b 888 888 "88b d8P  Y8b '; _echo_part2 '  888    888 d88""88b d88P"    888 .88P d8P  Y8b 888P"';
        _echo_part1 '       d88P   888 888 888  888 888 888  888 88888888 '; _echo_part2 '  888    888 888  888 888      888888K  88888888 888';
        _echo_part1 '      d8888888888 888 888 d88P 888 888  888 Y8b.     '; _echo_part2 '  888  .d88P Y88..88P Y88b.    888 "88b Y8b.     888';
        _echo_part1 '     d88P     888 888 88888P"  888 888  888  "Y8888  '; _echo_part2 '  8888888P"   "Y88P"   "Y8888P 888  888  "Y8888  888';
        _echo_part0 '                      888';
        _echo_part0 '                      888';
        _echo_part0 '                      888';
        echo;
        echo;
    ) > /etc/motd;
    clear; cat /etc/motd;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;

exit 0;
