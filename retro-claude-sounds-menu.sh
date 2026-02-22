#!/bin/bash

THEMES_DIR="$HOME/.claude/themes"
ACTIVE_LINK="$HOME/.claude/play-retro-sounds.sh"

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

get_current_theme() {
    if [ -L "$ACTIVE_LINK" ]; then
        local t
        t=$(readlink "$ACTIVE_LINK")
        t="${t##*/}"   # basename
        t="${t#play-}" # remove play-
        t="${t%.sh}"   # remove .sh
        echo "$t"
    else
        echo "none"
    fi
}

OLD_STTY=$(stty -g)

cleanup() {
    tput rmcup
    tput cnorm
    stty "$OLD_STTY"
}

trap cleanup EXIT

current=$(get_current_theme)
selected=0
count=${#THEMES[@]}

for i in "${!THEMES[@]}"; do
    if [ "${THEMES[$i]%%|*}" = "$current" ]; then
        selected=$i
        break
    fi
done

draw_menu() {
    local buf="" i key name suffix line

    printf -v buf '%s' "$(tput cup 0 0)"
    buf+=$'\033[1;36mretro-claude-sounds\033[0m\033[K\n'
    buf+=$'\033[2m────────────────────────────────────────\033[0m\033[K\n'
    buf+=$'\033[K\n'
    buf+=$'  \033[2m↑↓\033[0m navigate   \033[2mEnter\033[0m select   \033[2mq\033[0m quit\033[K\n'
    buf+=$'\033[K\n'

    for i in "${!THEMES[@]}"; do
        key="${THEMES[$i]%%|*}"
        name="${THEMES[$i]#*|}"
        [[ "$key" == *-full ]] && suffix=$'\033[2m [full]\033[0m' || suffix=""

        if [ "$i" -eq "$selected" ] && [ "$key" = "$current" ]; then
            printf -v line "  \033[1;32m> %-20s%b \033[2m[active]\033[0m\033[K\n" "$name" "$suffix"
        elif [ "$i" -eq "$selected" ]; then
            printf -v line "  \033[1;32m> %s%b\033[0m\033[K\n" "$name" "$suffix"
        elif [ "$key" = "$current" ]; then
            printf -v line "  \033[33m  %-20s%b \033[2m[active]\033[0m\033[K\n" "$name" "$suffix"
        else
            printf -v line "    %s%b\033[K\n" "$name" "$suffix"
        fi
        buf+="$line"
    done

    printf '%s' "$buf"
}

tput smcup
tput civis
clear

# Raw mode: block until 1 char arrives (min 1, no timeout)
stty -echo -icanon min 1 time 0

while true; do
    draw_menu

    IFS= read -r -s -n1 key

    if [[ "$key" == $'\x1b' ]]; then
        # Switch to non-blocking with 0.1s timeout (stty time=1 = 1/10 sec)
        stty min 0 time 1
        IFS= read -r -s -n2 key2
        stty min 1 time 0
        key="${key}${key2}"
    fi

    case "$key" in
        $'\x1b[A')
            ((selected--))
            [ "$selected" -lt 0 ] && selected=$((count - 1))
            ;;
        $'\x1b[B')
            ((selected++))
            [ "$selected" -ge "$count" ] && selected=0
            ;;
        $'\r'|$'\n'|'')
            theme_key="${THEMES[$selected]%%|*}"
            ln -sf "$THEMES_DIR/play-$theme_key.sh" "$ACTIVE_LINK"
            cleanup
            trap - EXIT
            printf "\033[1;32m> Theme set: %s\033[0m\n" "$theme_key"
            exit 0
            ;;
        q|Q)
            cleanup
            trap - EXIT
            exit 0
            ;;
    esac
done
