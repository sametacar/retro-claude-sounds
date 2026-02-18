# retro-claude-sounds

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Retro game sounds for Claude Code hooks. Plays nostalgic sound effects on tool calls, submits, and session events.

## Installation

```bash
git clone https://github.com/sametacar/retro-claude-sounds
cd retro-claude-sounds
./install.sh
source ~/.zshrc
```

## Switch Themes

```bash
sounds mk    # Mortal Kombat
sounds sc    # StarCraft
sounds wc    # Warcraft
sounds ao2   # Age of Empires 2
```

> **Note:** Run `source ~/.zshrc` and `sounds <theme>` as separate commands. They cannot be combined on the same line.

## How It Works

`install.sh` copies files to `~/.claude/` and adds a `sounds()` function to `.zshrc`. Claude Code hooks trigger `play.sh` on the following events:

- `sessionstart` — when a session begins
- `sessionend` — when a session ends
- `submit` — when a message is sent
- `stop` — when a tool call is stopped

## Requirements

- macOS (`afplay` required)
- Claude Code
