#!/bin/bash

# Configurações
DEFAULT_ICON="  "  # Ícone do Arch Linux
DEFAULT_COLOR="#fabd2f"

# Mapeamento de aplicativos para ícones
declare -A APP_MAP=(
    ["kitty"]="  ;#b8bb26"
    ["firefox"]=" 󰈹 ;#FF6600"
    ["steam"]="  ;#1277a9"
    ["flameshot"]=" 󰹑 ;#ffc0cb"
    ["pcsx2"]=" 󰊗 ;#1277a9"
    ["rpcs3"]=" 󰊗 ;#ff0000"
    ["virt-manager"]=" 󰟀 ;#5277a9"
    ["rustdesk"]=" 󰢹 ;#00AAFF"
)

# Obter workspaces
WORKSPACES=$(i3-msg -t get_workspaces | jq -r '.[] | .name')

for WORKSPACE in $WORKSPACES; do

    WINDOWS=$(i3-msg -t get_tree | jq -r ".nodes[].nodes[].nodes[] | select(.name==\"$WORKSPACE\") | .. | objects | select(.window_type==\"normal\") | .window_properties.class")
    
    ICON="$DEFAULT_ICON"
    COLOR="$DEFAULT_COLOR"
    
    if [ -n "$WINDOWS" ]; then
        CLASS=$(echo "$WINDOWS" | head -n1 | tr '[:upper:]' '[:lower:]')
        
        if [ -n "${APP_MAP[$CLASS]}" ]; then
            IFS=';' read -r ICON COLOR <<< "${APP_MAP[$CLASS]}"
        else
            ICON="  "
            COLOR="#fabd2f"
        fi
    fi

    if i3-msg -t get_workspaces | jq -e ".[] | select(.name==\"$WORKSPACE\" and .focused)" > /dev/null; then
        echo -n "%{F$COLOR}$ICON%{F-} "
    else
        echo -n "%{A1:i3-msg workspace $WORKSPACE:}%{F#555555}$ICON%{F-}%{A} "
    fi
done
