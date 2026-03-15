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

# Add a block to a file, using marker comments to detect and replace existing blocks.
# If a block with the same start marker exists, it gets replaced. Otherwise appended.
# Markers are detected as lines starting with "## -- start" and "## -- end".
add_block_if_missing() {
    local file="$1"
    local block="$2"
    [ -f "$file" ] || touch "$file"

    # Extract the start/end marker lines from the block
    local start_marker end_marker
    start_marker=$(echo "$block" | grep -m1 '^## -- start')
    end_marker=$(echo "$block" | grep -m1 '^## -- end')

    if [[ -n "$start_marker" ]] && [[ -n "$end_marker" ]] && grep -qF "$start_marker" "$file" 2>/dev/null; then
        # Remove old block between markers (inclusive), then append new block
        sed -i '' "/$start_marker/,/$end_marker/d" "$file"
        echo "$block" >> "$file"
    elif [[ "$(cat "$file")" != *"$block"* ]]; then
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
