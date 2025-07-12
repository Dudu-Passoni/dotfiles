#!/bin/bash
# ~/.config/polybar/power-menu.sh

option=$(echo -e "󰐥 Desligar\n↺ Reiniciar\n Suspender\n Sair" | \
rofi -dmenu -p "Menu de Energia" -theme-str 'window {width: 20%; height: 25%;}')

case $option in
    "󰐥 Desligar")
        systemctl poweroff
        ;;
    "↺ Reiniciar")
        systemctl reboot
        ;;
    " Suspender")
        systemctl suspend
        ;;
    " Sair")
        loginctl terminate-session ${XDG_SESSION_ID-}
        ;;
esac
