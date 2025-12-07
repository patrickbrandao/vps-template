#!/bin/bash

# Swap em arquivo caso nao haja swap em particao
#==========================================================

    # Nao repetir execucao
    f=$(basename $0); egrep -q "$f" /etc/.vps-setup 2>/dev/null && exit 0;

	# Conferir se ja tem particao swap no disco
	SWAP_ON_DISK=no;
	fdisk -l | egrep -q 'Linux swap' && SWAP_ON_DISK=yes;

	# Conferir se ja tem particao swap no fstab
	SWAP_ON_FSTAB=no;
	fdisk -l | egrep -q 'swap' && SWAP_ON_FSTAB=yes;

	# Se a swap existe no disco e no fstab, nao precisa mexer
	[ "$SWAP_ON_DISK" = "yes" -a "$SWAP_ON_FSTAB" = "yes" ] && {
		echo "# - Swap nativa OK";
		exit 0;
	};

	# Sem particao e sem swap no fstab
	# vamos criar uma swap em arquivo para segurar as pontas
	# e evitar erros OOM
    if [ "$SWAP_ON_DISK" = "no" -a "$SWAP_ON_FSTAB" = "no" ]; then
    	# Registrar no fstab o arquivo /swap.bin
		(
			echo;
			echo '/swap.bin none            swap    sw              0       0';
			echo;
		) >> /etc/fstab;

		# Fazer setup inicial do arquivo pre-alocado (modo preguiçoso, sem gastar blocos)
		if [ -f /swap.bin ]; then
			echo "# SWAP - Arquivo /swap.bin presente.";
		else
			echo "# SWAP - Alocando /swap.bin";
			fallocate -l 1G /swap.bin;
			mkswap /swap.bin;
		fi;
		# Ajustando permissoes
		chmod 0600 /swap.bin;
		# Ativar imediatamente
		swapon -a;

		exit 0;
    fi;

    echo "# SWAP - Condicao nao tratada, falta fazer...";

    # Marcar essa tarefa como feita
    echo "$(date "+%Y-%m-%d %H:%M:%S") $f" >> /etc/.vps-setup;


exit 0;
