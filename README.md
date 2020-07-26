¡Atencion! Esta herramienta esta en desarrollo, por favor, comentar cualquier error // Warning! This tool is in developing, please, report any error

# HalfHandshaker
![banner](/images/banner.png)

🇪🇸 - HalfHanshaker es una simple herramienta para **generar APs falsos**, conociendo de antemano el essid, con la finalidad de que una víctima estudiada establezca conexión automáticamente por haberse conectado anteriormente a una red **con el mismo nombre** y así **capturar un handshake** que posteriormente puede ser crackeado.

🇬🇧 - HalfHanshaker is a simple tool for **generate fake APs**, previously knowing the essid, in order for a specific victim to automatically connect to the network for having the name memorized for having connected to a network **with the same essid**, **capturing the hanshake** to crack it later.

![gif](/images/gif.gif)

Youtube video:
[![Youtube Video](https://img.youtube.com/vi/mVM-643zqsM/0.jpg)](https://www.youtube.com/watch?v=mVM-643zqsM)

## Ejemplo // Example

⬇️ 🇪🇸 Aquí unos ejemplos de la sintaxis del script // 🇬🇧 Here some examples of the script syntax ⬇️
```bash
./halfhanshaker.sh -m 1 -i wlan1 -i2 wlan0 -e "Hotel-09" -o "hotel-net" --hccapx -r
```
```bash
./halfhanshaker.sh -m 2 -i wlan1 -e "Hospital-RE" -o "hospital-wifi" --hccapx
```
```bash
./halfhanshaker.sh -m 1 -i wlan1 -i2 wlan0 -e "Wifi123" -o "wifi" --hccapx -r -d --d-hotspot-mac XX:XX:XX:XX:XX:XX --d-client-mac YY:YY:YY:YY:YY:YY 
```

⬇️ 🇪🇸 Opción de escaneo de wifi probes // 🇬🇧 Wifi probe scan option ⬇️
```bash
./halfhanshaker.sh -s -i wlan1
```
![wifi probes scan](/images/probe-scan.png)
## Autores // Authors
🇪🇸 Desarrollado por Miguelillo
con la ayuda de fromCharCode -> muchas gracias :)

🇬🇧 Developed by Miguelillo
with the help of fromCharCode -> thanks bro! :)
