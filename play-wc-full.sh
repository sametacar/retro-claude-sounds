#!/bin/bash
# Plays a peon sound based on event type (submit sounds included)
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
  submit)
    case $(( RANDOM % 3 )) in
      0) play "PeonWhat2.mp3" ;;
      1) play "PeonYesAttack3.mp3" ;;
      2) play "PeonYes3.mp3" ;;
    esac
    ;;
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
