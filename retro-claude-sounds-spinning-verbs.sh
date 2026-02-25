#!/bin/bash
# Updates spinnerVerbs in ~/.claude/settings.json based on the given theme.
# Usage: retro-claude-sounds-spinning-verbs.sh <theme-key>

THEME="${1:-none}"

# Strip -full suffix to reuse base theme verbs
BASE_THEME="${THEME%-full}"

python3 - "$BASE_THEME" << 'EOF'
import json, os, sys

theme = sys.argv[1]
settings_path = os.path.expanduser("~/.claude/settings.json")
vscode_settings_path = os.path.expanduser("~/Library/Application Support/Code/User/settings.json")

VERBS = {
    "ao2": ["⚒️ Building barracks", "💰 Gold please", "🧑‍🌾 Training villagers", "🪵 Gathering wood", "👷 Mining gold", "📜 Researching", "🧙‍♂️ Monk! I need a monk", "🏰 Nice town, I'll take it", "🏹 Raiding party!", "😎 You should see the other guy", "Wololoo", "⏳ What age are you in?"],
    "sc":  ["👾 Spawning zerglings", "💎 Mining minerals", "✨ Warping in", "⚒️ Building supply depot", "👨‍🚀 Training marines", "🔥 Barbecuing", "🎺 Da da da daaa dow, da da da dow dow!", "🔮 Excellenting!", "🛰️ Hailing frequencies open"],
    "wc":  ["⚔️ Training grunts", "⛏️ Sending peons", "🩸 Casting bloodlust", ⚒️ Building stronghold", "👹 Summoning ogres", "⛏️ Zug Zug", "⚔️ Lok'tar", "😈 When my Work is finished, I'm coming back for you", "🪓 Chop chop!", "😩 I don't want to do this!", "💬 Zog tog", "💬 Dabu!", "🫡 You da boss", "❓ We're ready, master... I'm not ready!" ],
    "mk":  ["🕹️ Selecting fighter", "🔮 Choosing your destiny", "🦂 Getting over here!", "🥷❄️ Training Lin Kuei", "👊 Fighting..", "☠️ Finishing him!", "🥷 Noobing Saibot"],
}

def update_settings(path, key, theme):
    try:
        with open(path) as f:
            settings = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        settings = {}

    if theme in VERBS:
        settings[key] = {
            "mode": "replace",
            "verbs": VERBS[theme]
        }
    else:
        settings.pop(key, None)

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(settings, f, indent=2)

update_settings(settings_path, "spinnerVerbs", theme)
update_settings(vscode_settings_path, "claudeCode.spinnerVerbs", theme)
EOF
