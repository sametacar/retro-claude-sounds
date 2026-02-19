#!/bin/bash
# Plays an Age of Empires 2 villager sound based on event type (submit sounds included)
SOUNDS_DIR="$HOME/.claude/sounds/ageofsounds"

play() {
  afplay "$SOUNDS_DIR/$1" &
}

case "$1" in
  stop)
    play "yaparim.mp3"
    ;;
  sessionstart)
    play "hazir.mp3"
    ;;
  sessionend)
    play "oduncu.mp3"
    ;;
  submit)
    case $(( RANDOM % 4 )) in
      0) play "yaparim.mp3" ;;
      1) play "oduncu.mp3" ;;
      2) play "usta.mp3" ;;
      3) play "madenci.mp3" ;;
    esac
    ;;
  question)
    play "emrin.mp3"
    ;;
  *)
    # rastgele çal
    sounds=()
    while IFS= read -r -d $'\0' f; do
      sounds+=("$f")
    done < <(find "$SOUNDS_DIR" -maxdepth 1 -type f -name "*.mp3" -print0 2>/dev/null)
    if [ ${#sounds[@]} -gt 0 ]; then
      afplay "${sounds[RANDOM % ${#sounds[@]}]}" &
    fi
    ;;
esac
