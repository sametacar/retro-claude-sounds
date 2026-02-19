#!/bin/bash
CLAUDE_DIR="$HOME/.claude"
THEMES_DIR="$CLAUDE_DIR/themes"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy files
cp -r "$REPO_DIR/sounds" "$CLAUDE_DIR/"
mkdir -p "$THEMES_DIR"
cp "$REPO_DIR/themes"/play-*.sh "$THEMES_DIR/"
chmod +x "$THEMES_DIR"/play-*.sh

# Default theme: ao2
ln -sf "$THEMES_DIR/play-ao2.sh" "$CLAUDE_DIR/play.sh"

# Add/update hooks in settings.json
python3 -c "
import json, os

home = os.path.expanduser('~')
settings_path = home + '/.claude/settings.json'
play_sh = home + '/.claude/play.sh'

try:
    with open(settings_path) as f:
        settings = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    settings = {}

hooks = settings.setdefault('hooks', {})

events = {
    'SessionStart': 'sessionstart',
    'Stop': 'stop',
    'Notification': 'question',
    'UserPromptSubmit': 'submit',
    'SessionEnd': 'sessionend',
}

for event, arg in events.items():
    # Remove any existing play.sh hooks for this event
    existing = hooks.get(event, [])
    cleaned = [
        h for h in existing
        if not any('play.sh' in hook.get('command', '') for hook in h.get('hooks', []))
    ]
    # Add fresh hook
    cleaned.append({
        'hooks': [{
            'type': 'command',
            'command': play_sh + ' ' + arg
        }]
    })
    hooks[event] = cleaned

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
"
echo "Hooks updated in settings.json."

# Add sounds aliases to .zshrc (if not already present)
if ! grep -q "sounds-wc-full" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" << 'EOF'

# Claude sound theme switcher
alias sounds-wc="ln -sf $HOME/.claude/themes/play-wc.sh $HOME/.claude/play.sh && echo 'Theme: wc'"
alias sounds-mk="ln -sf $HOME/.claude/themes/play-mk.sh $HOME/.claude/play.sh && echo 'Theme: mk'"
alias sounds-sc="ln -sf $HOME/.claude/themes/play-sc.sh $HOME/.claude/play.sh && echo 'Theme: sc'"
alias sounds-ao2="ln -sf $HOME/.claude/themes/play-ao2.sh $HOME/.claude/play.sh && echo 'Theme: ao2'"
alias sounds-wc-full="ln -sf $HOME/.claude/themes/play-wc-full.sh $HOME/.claude/play.sh && echo 'Theme: wc-full'"
alias sounds-mk-full="ln -sf $HOME/.claude/themes/play-mk-full.sh $HOME/.claude/play.sh && echo 'Theme: mk-full'"
alias sounds-sc-full="ln -sf $HOME/.claude/themes/play-sc-full.sh $HOME/.claude/play.sh && echo 'Theme: sc-full'"
alias sounds-ao2-full="ln -sf $HOME/.claude/themes/play-ao2-full.sh $HOME/.claude/play.sh && echo 'Theme: ao2-full'"
EOF
  echo "sounds-* aliases added to .zshrc. Run 'source ~/.zshrc' to apply."
fi

echo "Done! Usage: sounds-ao2 / sounds-sc / sounds-wc / sounds-mk (+ -full variants for submit sounds)"
