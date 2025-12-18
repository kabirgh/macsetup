#!/bin/bash

# =============================================================================
# Common configuration and helper functions
# Source this file in other scripts: source "$(dirname "$0")/common.sh"
# =============================================================================

# Determine the root directory (parent of scripts/)
if [[ "${BASH_SOURCE[0]}" == *"/scripts/"* ]]; then
    SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
else
    SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

LOG_FILE="$SETUP_DIR/setup.log"

# =============================================================================
# CONFIGURATION
# =============================================================================

GIT_NAME="Kabir Khandpur"
GIT_EMAIL="kabir.khandpur@gmail.com"

BREW_PACKAGES=(
    git
    wget
    curl
    jq
    ripgrep
    fzf
    mise
)

CASK_APPS=(
    1password
    brave-browser
    ghostty
    rectangle
    scroll-reverser
    karabiner-elements
    cursor
    spotify
    steam
)

CURSOR_EXTENSIONS=(
    ms-python.python
    eamodio.gitlens
)

# Extensions not on Cursor marketplace (install from VSIX)
CURSOR_VSIX_EXTENSIONS=(
    "azemoh.one-monokai"
)

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# Log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Add a line to a file only if it doesn't already exist
add_line_if_missing() {
    local file="$1"
    local line="$2"
    [ -f "$file" ] || touch "$file"
    if ! grep -qxF "$line" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
    fi
}

# Add a block to a file only if it doesn't already exist
add_block_if_missing() {
    local file="$1"
    local block="$2"
    [ -f "$file" ] || touch "$file"
    if [[ "$(cat "$file")" != *"$block"* ]]; then
        echo "$block" >> "$file"
    fi
}

print_section() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Add a login item (auto-start app)
add_login_item() {
    local app_path="$1"
    local app_name=$(basename "$app_path" .app)
    
    if [ ! -d "$app_path" ]; then
        echo "  ⚠️  $app_name not found"
        return 1
    fi
    
    # Check if already a login item
    if osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null | grep -q "$app_name"; then
        echo "  ✅ $app_name (already set)"
    else
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app_path\", hidden:false}" 2>/dev/null
        echo "  ✅ $app_name (added)"
    fi
}

# Setup error handling for standalone scripts
setup_standalone() {
    set -euo pipefail
    trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"' ERR
    trap 'echo ""; echo "⚠️  Interrupted."; exit 130' INT
}
