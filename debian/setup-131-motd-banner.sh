#!/bin/bash

# Banner
#========================================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

    # Apagar banner pos-login
    #echo -n > /etc/motd;

    _echo_part1(){ /bin/echo -ne "\033[0;34m$@\033[0m"; }
    _echo_part2(){ /bin/echo -e "\x1B[96m$@\033[0m"; };


    # https://patorjk.com/software/taag/#p=display&f=Colossal&t=+ISP+AI&x=none&v=4&h=4&w=80&we=false
    (
        echo;
        echo;
        _echo_part1 '      8888888 .d8888b.  8888888b.  '; _echo_part2 '       d8888 8888888';
        _echo_part1 '        888  d88P  Y88b 888   Y88b '; _echo_part2 '      d88888   888';
        _echo_part1 '        888  Y88b.      888    888 '; _echo_part2 '     d88P888   888';
        _echo_part1 '        888   "Y888b.   888   d88P '; _echo_part2 '    d88P 888   888';
        _echo_part1 '        888      "Y88b. 8888888P"  '; _echo_part2 '   d88P  888   888';
        _echo_part1 '        888        "888 888        '; _echo_part2 '  d88P   888   888';
        _echo_part1 '        888  Y88b  d88P 888        '; _echo_part2 ' d8888888888   888';
        _echo_part1 '      8888888 "Y8888P"  888        '; _echo_part2 'd88P     888 8888888';
        echo;
        echo;
    ) > /etc/motd;
    clear; cat /etc/motd;

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
