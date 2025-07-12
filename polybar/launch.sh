#!/bin/bash

# Mata qualquer instância anterior da Polybar
killall -q polybar

# Aguarda até todas fecharem
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Inicia a Polybar (nome da barra: example)
polybar &

