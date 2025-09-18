#!/bin/bash
# ~/.config/polybar/audio-devices.sh

# Obter lista de sinks com informações detalhadas
device_list=$(pactl list sinks | 
  awk -F': ' '
    /Name:/ {name=$2}
    /Description:/ {desc=$2; print name "::" desc}
  ')

# Processar a lista para exibir apenas descrições
selected=$(echo "$device_list" | 
  awk -F'::' '{print $2}' | 
  rofi -dmenu -p "Selecionar dispositivo de áudio" -theme-str 'window {width: 25%;}')

# Encontrar o nome do dispositivo correspondente à descrição selecionada
if [ -n "$selected" ]; then
  device_name=$(echo "$device_list" | 
    awk -F'::' -v sel="$selected" '$2 == sel {print $1; exit}')
  
  # Definir o dispositivo selecionado como padrão e mover todas as entradas para ele
  pactl set-default-sink "$device_name"
  pactl list short sink-inputs | 
    awk '{print $1}' | 
    xargs -I{} pactl move-sink-input {} "$device_name"
fi
