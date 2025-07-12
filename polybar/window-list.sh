#!/bin/bash

# Configurações personalizáveis
SEPARATOR="|"
DEFAULT_ICON=""  # Ícone padrão (cubo)
DEFAULT_COLOR="#FFFFFF"  # Cor padrão (branco)

# Mapeamento de aplicativos para ícones e cores
declare -A APP_MAP=(
    ["kitty"]="    ;#b8bb26"        # Ícone: terminal, Cor: verde
    ["firefox"]="    ;#FF6600"      # Ícone: firefox, Cor: laranja
    ["dolphin"]="    ;#00AAFF"      # Ícone: pasta, Cor: azul
    ["steam"]="    ;#1277a9"         # Ícone: code, Cor: magenta
    ["spectacle"]="  󰹑  ;#ffc0cb"
    ["pcsx2"]="  󰊗  ;#1277a9"
    ["rpcs3"]="  󰊗  ;#ff0000"
    ["virt-manager"]="  󰟀  ;#5277a9"

    # Adicione outros aplicativos aqui no formato:
    # ["nome-da-classe"]="ícone;cor"
)

# Obtém o ID do desktop atual
current_desktop=$(wmctrl -d | awk '/\*/ {print $1}')

# Lista as janelas no desktop atual
window_list=$(wmctrl -l | awk -v desk="$current_desktop" '$2 == desk {print $1}')

# Processa cada janela
output=""
for window_id in $window_list; do
    # Obtém a classe da janela (mais confiável que o título)
    class=$(xprop -id $window_id WM_CLASS 2> /dev/null | awk -F'"' '{print $4}')
    [ -z "$class" ] && continue  # Ignora se não encontrar classe
    
    # Converte para minúsculas para melhor correspondência
    class_lower=${class,,}
    
    # Verifica se temos um ícone configurado
    if [ -n "${APP_MAP[$class_lower]}" ]; then
        icon_info=${APP_MAP[$class_lower]}
        icon=${icon_info%;*}  # Parte antes do ;
        color=${icon_info#*;} # Parte depois do ;
        item="%{F$color}$icon%{F-}"
    else
        # Fallback: mostra as 4 primeiras letras do nome da classe
        short_name=${class:0:14}
        item="%{F$DEFAULT_COLOR}$short_name%{F-}"
    fi
    
    # Adiciona separador se não for o primeiro item
    [ -n "$output" ] && output+=" %{F#555555}$SEPARATOR%{F-} "
    output+="$item"
done

echo "$output"
