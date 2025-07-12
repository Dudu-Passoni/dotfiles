#!/bin/sh

# Ícones para exibir na Polybar (Nerd Fonts)
ICON_PREV=""    # Anterior
ICON_NEXT=""    # Próximo
ICON_PLAY=""    # Play
ICON_PAUSE=""   # Pause
MAX_LENGTH=25    # Comprimento máximo do texto da música

# Obtem o estado atual
status_json=$(rmpc status)
state=$(echo "$status_json" | jq -r '.state')

# Se estiver parado, mostra apenas ícone de parada
if [ "$state" = "Stop" ]; then
  echo "%{A1:rmpc play:}  %{A}" 
  exit 0
fi

# Obtem informações da música
musica_json=$(rmpc song)
title=$(echo "$musica_json" | jq -r '.metadata.title // ""')
artist=$(echo "$musica_json" | jq -r '.metadata.artist // ""')

# Fallback para nome do arquivo se não tiver metadados
if [ -z "$title" ]; then
  file=$(echo "$musica_json" | jq -r '.file')
  title=$(basename "$file" | sed 's/\..*$//')
fi

# Formata texto da música
if [ -n "$artist" ] && [ -n "$title" ]; then
  music_text="$artist - $title"
elif [ -n "$title" ]; then
  music_text="$title"
else
  music_text="Música desconhecida"
fi

# Limita comprimento do texto
if [ ${#music_text} -gt $MAX_LENGTH ]; then
  music_text="${music_text:0:$MAX_LENGTH}…"
fi

# Adiciona controles de reprodução
if [ "$state" = "Pause" ]; then
  echo "%{A1:rmpc prev:}$ICON_PREV%{A} %{A1:rmpc play:}$ICON_PLAY%{A} %{A1:rmpc next:}$ICON_NEXT%{A} $music_text"
elif [ "$state" = "Play" ]; then
  echo "%{A1:rmpc prev:}$ICON_PREV%{A} %{A1:rmpc pause:}$ICON_PAUSE%{A} %{A1:rmpc next:}$ICON_NEXT%{A} $music_text"
fi
