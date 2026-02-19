#!/bin/bash
# Plays an Age of Empires 2 villager sound based on event type (no submit sounds — use play-ao2-full.sh for that)
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
  #pretool)
  #  if (( RANDOM % 2 )); then
  #    play "yaparim.mp3"
  #  else
  #     play "hazir.mp3"
  #   fi
  #  ;;
  submit)
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
