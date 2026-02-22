#!/bin/bash

THEMES_DIR="$HOME/.claude/themes"
ACTIVE_LINK="$HOME/.claude/play-retro-sounds.sh"

# Theme list: "key|Display Name"
THEMES=(
    "ao2|Age of Empires 2"
    "sc|StarCraft"
    "wc|Warcraft"
    "mk|Mortal Kombat"
    "ao2-full|Age of Empires 2"
    "sc-full|StarCraft"
    "wc-full|Warcraft"
    "mk-full|Mortal Kombat"
)

get_theme_key()  { echo "$1" | cut -d'|' -f1; }
get_theme_name() { echo "$1" | cut -d'|' -f2; }

get_current_theme() {
    if [ -L "$ACTIVE_LINK" ]; then
        basename "$(readlink "$ACTIVE_LINK")" | sed 's/play-//' | sed 's/\.sh//'
    else
        echo "none"
    fi
}

restore_terminal() {
    tput rmcup
    tput cnorm
}

trap restore_terminal EXIT

current=$(get_current_theme)
selected=0
count=${#THEMES[@]}

# Find index of active theme
for i in "${!THEMES[@]}"; do
    key=$(get_theme_key "${THEMES[$i]}")
    if [ "$key" = "$current" ]; then
        selected=$i
        break
    fi
done

draw_menu() {
    tput cup 0 0
    tput ed

    printf "\033[1;36mretro-claude-sounds\033[0m\n"
    printf "\033[2m%s\033[0m\n\n" "────────────────────────────────────────"
    printf "  \033[2m↑↓\033[0m navigate   \033[2mEnter\033[0m select   \033[2mq\033[0m quit\n\n"

    for i in "${!THEMES[@]}"; do
        key=$(get_theme_key "${THEMES[$i]}")
        name=$(get_theme_name "${THEMES[$i]}")

        # Append dim [full] tag for full variants
        if [[ "$key" == *-full ]]; then
            suffix="\033[2m [full]\033[0m"
        else
            suffix=""
        fi

        if [ "$i" -eq "$selected" ] && [ "$key" = "$current" ]; then
            printf "  \033[1;32m> %-20s%b \033[2m[active]\033[0m\n" "$name" "$suffix"
        elif [ "$i" -eq "$selected" ]; then
            printf "  \033[1;32m> %s%b\033[0m\n" "$name" "$suffix"
        elif [ "$key" = "$current" ]; then
            printf "  \033[33m  %-20s%b \033[2m[active]\033[0m\n" "$name" "$suffix"
        else
            printf "    %s%b\n" "$name" "$suffix"
        fi
    done
}

# Switch to alternate screen, hide cursor
tput smcup
tput civis
clear

while true; do
    draw_menu

    IFS= read -r -s -n1 key
    if [[ "$key" == $'\x1b' ]]; then
        IFS= read -r -s -n2 -t 0.1 key2
        key="$key$key2"
    fi

    case "$key" in
        $'\x1b[A') # Up
            ((selected--))
            [ "$selected" -lt 0 ] && selected=$((count - 1))
            ;;
        $'\x1b[B') # Down
            ((selected++))
            [ "$selected" -ge "$count" ] && selected=0
            ;;
        '') # Enter
            theme_key=$(get_theme_key "${THEMES[$selected]}")
            ln -sf "$THEMES_DIR/play-$theme_key.sh" "$ACTIVE_LINK"
            restore_terminal
            trap - EXIT
            printf "\033[1;32m> Theme set: %s\033[0m\n" "$theme_key"
            exit 0
            ;;
        q|Q)
            restore_terminal
            trap - EXIT
            exit 0
            ;;
    esac
done
