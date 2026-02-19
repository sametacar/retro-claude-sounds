#!/bin/bash
# Plays a Mortal Kombat sound based on event type (no submit sounds — use play-mk-full.sh for that)
SOUNDS_DIR="$HOME/.claude/sounds/mortalkombatsounds"

play() {
  afplay "$SOUNDS_DIR/$1" &
}

case "$1" in
  stop)
    case $(( RANDOM % 2 )) in
      0) play "impressive.mp3" ;;
      1) play "superb.mp3" ;;
    esac
    ;;
  sessionstart)
    play "fight.mp3"
    ;;
  sessionend)
    play "laughter.mp3"
    ;;
  submit)
    ;;
  question)
     case $(( RANDOM % 2 )) in
      0) play "fatality.mp3" ;;
      1) play "finish-him.mp3" ;;
    esac
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
