#!/bin/bash
# Plays a StarCraft sound based on event type
SOUNDS_DIR="$HOME/.claude/sounds/starcraftsounds"

play() {
  afplay "$SOUNDS_DIR/$1" &
}

case "$1" in
  stop)
    play "job-s-finished.mp3"
    ;;
  sessionstart)
    play "battle-cruiser-operational.mp3"
    ;;
  sessionend)
    play "i-m-gone.mp3"
    ;;
  #pretool)
  #  if (( RANDOM % 2 )); then
  #    play "in-the-pipe-five-by-five.mp3"
  #  else
  #    play "all-right.mp3"
  #  fi
  #  ;;
  submit)
    case $(( RANDOM % 2 )) in
      0) play "all-right.mp3" ;;
      1) play "in-the-pipe-five-by-five.mp3" ;;
    esac
    ;;
  question)
    play "i-can-t-build-there.mp3"
    ;;
  *)
    # rastgele çal
    sounds=()
    while IFS= read -r -d $'\0' f; do
      sounds+=("$f")
    done < <(find "$SOUNDS_DIR" -maxdepth 1 -type f \( -name "*.wav" -o -name "*.mp3" -o -name "*.aiff" \) -print0 2>/dev/null)
    if [ ${#sounds[@]} -gt 0 ]; then
      afplay "${sounds[RANDOM % ${#sounds[@]}]}" &
    fi
    ;;
esac
