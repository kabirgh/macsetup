#!/bin/bash

# Work laptop profile. The personal setup-personal.sh is independent.
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_DIR/work-config.sh"
source "$ROOT_DIR/scripts/common.sh"

print_section "Configuring macOS preferences"
source "$ROOT_DIR/scripts/macos.sh"

ensure_homebrew

if [ "${#WORK_BREW_PACKAGES[@]}" -gt 0 ]; then
    for package in "${WORK_BREW_PACKAGES[@]}"; do
        if brew list --formula "$package" >/dev/null 2>&1; then
            echo "Already installed: $package"
        else
            brew install "$package"
        fi
    done
else
    echo "No Homebrew tools selected in work-config.sh."
fi

if [ "${#WORK_CASK_APPS[@]}" -gt 0 ]; then
    for app in "${WORK_CASK_APPS[@]}"; do
        if brew list --cask "$app" >/dev/null 2>&1; then
            echo "Already installed: $app"
        else
            brew install --cask "$app"
        fi
    done
fi

work_cask_selected() {
    local selected
    for selected in "${WORK_CASK_APPS[@]}"; do
        [ "$selected" = "$1" ] && return 0
    done
    return 1
}

if work_cask_selected karabiner-elements; then
    karabiner_config="$HOME/.config/karabiner/karabiner.json"
    mkdir -p "$(dirname "$karabiner_config")"
    if [ ! -f "$karabiner_config" ] || ! cmp -s "$ROOT_DIR/karabiner.json" "$karabiner_config"; then
        cp "$ROOT_DIR/karabiner.json" "$karabiner_config"
        echo "Applied Karabiner configuration"
    fi
fi

if work_cask_selected scroll-reverser; then
    scroll_reverser_config="$HOME/Library/Preferences/com.pilotmoon.scroll-reverser.plist"
    mkdir -p "$(dirname "$scroll_reverser_config")"
    if [ ! -f "$scroll_reverser_config" ] || ! cmp -s "$ROOT_DIR/scroll-reverser.plist" "$scroll_reverser_config"; then
        cp "$ROOT_DIR/scroll-reverser.plist" "$scroll_reverser_config"
        echo "Applied Scroll Reverser configuration"
    fi
fi

source "$ROOT_DIR/scripts/shell.sh"

if command -v mise >/dev/null 2>&1; then
    add_line_if_missing "$HOME/.zshrc" 'eval "$(mise activate zsh)"'
fi

if [ "${#WORK_VSCODE_EXTENSIONS[@]}" -gt 0 ]; then
    if ! command -v code >/dev/null 2>&1; then
        echo "The VS Code 'code' CLI is required for the selected extensions." >&2
        exit 1
    fi

    for extension in "${WORK_VSCODE_EXTENSIONS[@]}"; do
        code --install-extension "$extension"
    done
else
    echo "No VS Code extensions selected in work-config.sh."
fi

cat <<'EOF'

Work Git and SSH setup is per repository and host. See the work laptop section in README.md.
EOF
