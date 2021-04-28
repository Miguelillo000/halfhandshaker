# HalfHandshaker
![banner](/images/banner.png)

🇪🇸 - El objetivo de HalfHandshaker es la obtención de **handshakes sin la necesidad** de tener **alcance** a AP víctima, sino a un cliente de esta red que tenga la red memorizada en alguno de sus dispositivos.

Se crea un AP falso con el mismo nombre que el AP víctima y, **automáticamente**, el dispositivo del objetivo **trata de conectarse**, obteniendo así la **contraseña** cifrada o handshake.

Desde que se reescribió la herramienta únicamente se necesita **una interfaz de red** y **no se necesita modo monitor**.

---

🇬🇧 - The objective of HalfHandshaker is to obtain **handshakes without** the need of **being near** the victim AP, otherways it makes use of someone who has the wifi network saved in one of their devices.

A fake AP with the same name as the victim AP is created and, **automatically**, the target device or client **attempt to connect**, obtaining the encrypted **password** or handshake.

Since the script was totally rewritten it only requires **a unique network interface** and it does **not need monitor mode**. 

---

![gif](/images/gif.gif)

---

Click for demo:
[![Youtube Video](/images/yt.png)](https://www.youtube.com/watch?v=jj3prBX_h3g  "Youtube Video Demo")

---

🇪🇸 - El script está recién salido de beta. Por favor, ¡**reportad cualquier error**, problema o duda!

🇬🇧 - This script is just exitted from the beta version. Please, **report any issue**, problem or doubt!

---

## Ejemplos // Examples
```bash
 ./halfhandshaker.sh -i wlan0 -e "Hotel-Wifi" -o "hotel"
```
```bash
 ./halfhandshaker.sh -i wlan0 -e "Hospital-RE" -r
```
```bash
 ./halfhandshaker.sh -i wlan0 -e "Wifi123" -r -o "wifi1"
```

---

## Autores // Authors
🇪🇸 Desarrollado por **Miguelillo**
con la ayuda de fromCharCode

🇬🇧 Developed by **Miguelillo**
with the help of fromCharCode