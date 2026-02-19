#!/bin/bash
CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy files
cp -r "$REPO_DIR/sounds" "$CLAUDE_DIR/"
cp "$REPO_DIR/themes"/play-*.sh "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR"/play-*.sh

# Default theme: ao2
ln -sf "$CLAUDE_DIR/play-ao2.sh" "$CLAUDE_DIR/play.sh"

# Add sounds aliases to .zshrc (if not already present)
if ! grep -q "sounds-wc-full" "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" << 'EOF'

# Claude sound theme switcher
alias sounds-wc="ln -sf $HOME/.claude/play-wc.sh $HOME/.claude/play.sh && echo 'Theme: wc'"
alias sounds-mk="ln -sf $HOME/.claude/play-mk.sh $HOME/.claude/play.sh && echo 'Theme: mk'"
alias sounds-sc="ln -sf $HOME/.claude/play-sc.sh $HOME/.claude/play.sh && echo 'Theme: sc'"
alias sounds-ao2="ln -sf $HOME/.claude/play-ao2.sh $HOME/.claude/play.sh && echo 'Theme: ao2'"
alias sounds-wc-full="ln -sf $HOME/.claude/play-wc-full.sh $HOME/.claude/play.sh && echo 'Theme: wc-full'"
alias sounds-mk-full="ln -sf $HOME/.claude/play-mk-full.sh $HOME/.claude/play.sh && echo 'Theme: mk-full'"
alias sounds-sc-full="ln -sf $HOME/.claude/play-sc-full.sh $HOME/.claude/play.sh && echo 'Theme: sc-full'"
alias sounds-ao2-full="ln -sf $HOME/.claude/play-ao2-full.sh $HOME/.claude/play.sh && echo 'Theme: ao2-full'"
EOF
  echo "sounds-* aliases added to .zshrc. Run 'source ~/.zshrc' to apply."
fi

echo "Done! Usage: sounds-ao2 / sounds-sc / sounds-wc / sounds-mk (+ -full variants for submit sounds)"
