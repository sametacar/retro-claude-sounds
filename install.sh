#!/bin/bash
CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy files
cp -r "$REPO_DIR/sounds" "$CLAUDE_DIR/"
cp "$REPO_DIR"/play-*.sh "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR"/play-*.sh

# Default theme: ao2
ln -sf "$CLAUDE_DIR/play-ao2.sh" "$CLAUDE_DIR/play.sh"

# Add sounds function to .zshrc (if not already present)
if ! grep -q "sounds()" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" << 'EOF'

# Claude sound theme switcher

sounds() {
  ln -sf "$HOME/.claude/play-$1.sh" "$HOME/.claude/play.sh" && echo "Theme: $1"
}
EOF
  echo "sounds() added to .zshrc. Run 'source ~/.zshrc' to apply."
fi

echo "Done! Usage: sounds ao2 / sounds sc / sounds wc"
