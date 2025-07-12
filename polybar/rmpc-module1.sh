#!/bin/sh

# Ícones para exibir na Polybar (você pode usar Nerd Fonts ou emojis)
ICON_PLAY=""
ICON_PAUSE=""

# Obtem o estado atual
status_json=$(rmpc status)
state=$(echo "$status_json" | jq -r '.state')

# Se estiver parado, não mostra nada
if [ "$state" = "Stop" ]; then
  echo " " 
    exit 0
fi

# Se estiver tocando ou pausado, pega os dados da música
# Substitua abaixo pela sua forma de obter esse JSON
musica_json=$(rmpc song)

# Extrai título e artista
info=$(echo "$musica_json" | jq -r '.metadata | "\(.title) - \(.albumartist)"')

# Decide o ícone conforme o estado
if [ "$state" = "Pause" ]; then
    echo "$ICON_PAUSE $info"
elif [ "$state" = "Play" ]; then
    echo "$ICON_PLAY $info"
fi

