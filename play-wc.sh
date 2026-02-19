#!/bin/bash
# Plays a peon sound based on event type (no submit sounds — use play-wc-full.sh for that)
SOUNDS_DIR="$HOME/.claude/sounds/warcraftsounds"

play() {
  afplay "$SOUNDS_DIR/$1" &
}

case "$1" in
  stop)
    play "PeonBuildingComplete1.mp3"
    ;;
  sessionstart)
    play "PeonReady1.mp3"
    ;;
  sessionend)
    play "PeonPissed2.mp3"
    ;;
  #pretool)
  #  if (( RANDOM % 2 )); then
  #    play "PeonWhat3.mp3"
  #  else
  #    play "PeonYesAttack1.mp3"
  #  fi
  #  ;;
  question)
    play "PeonWhat2.mp3"
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
