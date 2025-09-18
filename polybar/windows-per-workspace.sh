#!/bin/bash

# Configurações personalizáveis
SEPARATOR="|"
DEFAULT_ICON=""
DEFAULT_COLOR="#FFFFFF"

# Mapeamento de aplicativos
declare -A APP_MAP=(
    ["kitty"]="    ;#b8bb26"
    ["firefox"]="    ;#FF6600"
    ["dolphin"]="    ;#00AAFF"
    ["steam"]="    ;#1277a9"
    ["spectacle"]="  󰹑  ;#ffc0cb"
    ["pcsx2"]="  󰊗  ;#1277a9"
    ["rpcs3"]="  󰊗  ;#ff0000"
    ["virt-manager"]="  󰟀  ;#5277a9"
)

# Obter workspace alvo (argumento ou atual)
if [ $# -eq 0 ]; then
    # Se nenhum argumento, pega o workspace atual
    current_desktop=$(wmctrl -d | awk '/\*/ {print $1}')
    TARGET_WS=$current_desktop
else
    # Converter número do workspace para formato do wmctrl
    TARGET_WS=$(($1))
fi

# Listar janelas no workspace especificado
window_list=$(wmctrl -l | awk -v ws="$TARGET_WS" '$2 == ws {print $1}')

# Processar cada janela
output=""
for window_id in $window_list; do
    # Obtém a classe da janela (usando WM_CLASS)
    class=$(xprop -id $window_id WM_CLASS 2>/dev/null | awk -F'"' '{print $4}')
    
    # Se não encontrar classe, tenta obvia o título
    if [ -z "$class" ]; then
        title=$(xprop -id $window_id WM_NAME 2>/dev/null | awk -F'"' '{print $2}')
        # Ignora títulos contendo "HDMI" ou "DP"
        if [[ "$title" == *"HDMI"* ]] || [[ "$title" == *"DP"* ]]; then
            continue
        fi
        class="$title"
    fi

    [ -z "$class" ] && continue

    class_lower=${class,,}
    if [ -n "${APP_MAP[$class_lower]}" ]; then
        icon_info=${APP_MAP[$class_lower]}
        icon=${icon_info%;*}
        color=${icon_info#*;}
        item="%{F$color}$icon%{F-}"
    else
        # Fallback: mostra as 4 primeiras letras do nome da classe
        short_name=${class:0:4}
        item="%{F$DEFAULT_COLOR}$short_name%{F-}"
    fi

    [ -n "$output" ] && output+=" %{F#555555}$SEPARATOR%{F-} "
    output+="$item"
done

echo "$output"
