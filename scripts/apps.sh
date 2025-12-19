#!/bin/bash

# =============================================================================
# GUI Applications and Configs
# Run standalone: bash scripts/apps.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

# =============================================================================
# INSTALL GUI APPLICATIONS WITH BREW
# =============================================================================

print_section "Installing applications (${#CASK_APPS[@]} total)"

casks_to_install=()
for app in "${CASK_APPS[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        echo "  ✅ $app (brew)"
    else
        # Check if app exists in /Applications (handles manually installed apps)
        app_name=$(brew info --cask "$app" 2>/dev/null | grep -o '[A-Za-z0-9 ]*\.app' | head -1 || true)
        if [ -n "$app_name" ] && [ -d "/Applications/$app_name" ]; then
            echo "  ✅ $app (manual)"
        else
            casks_to_install+=("$app")
        fi
    fi
done

if [ ${#casks_to_install[@]} -gt 0 ]; then
    echo "  📦 Installing: ${casks_to_install[*]}"
    brew install --cask "${casks_to_install[@]}" 2>&1 | tee -a "$LOG_FILE" || true
fi

# =============================================================================
# OTHER APPS
# =============================================================================

if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
    echo "✅ Claude Code installed"
else
    echo "✅ Claude Code (exists)"
fi

# =============================================================================
# KARABINER CONFIG
# =============================================================================

KARABINER_SRC="$SETUP_DIR/karabiner.json"
KARABINER_DEST="$HOME/.config/karabiner/karabiner.json"

if [ -f "$KARABINER_SRC" ]; then
    mkdir -p "$HOME/.config/karabiner"
    if [ ! -f "$KARABINER_DEST" ] || ! diff -q "$KARABINER_SRC" "$KARABINER_DEST" &>/dev/null; then
        cp "$KARABINER_SRC" "$KARABINER_DEST"
        echo "✅ Karabiner config applied"
    else
        echo "✅ Karabiner config (unchanged)"
    fi
else
    echo "⚠️  No karabiner.json found - skipping"
fi

# =============================================================================
# SCROLL REVERSER CONFIG
# =============================================================================

SCROLL_REVERSER_SRC="$SETUP_DIR/scroll-reverser.plist"
SCROLL_REVERSER_DEST="$HOME/Library/Preferences/com.pilotmoon.scroll-reverser.plist"

if [ -f "$SCROLL_REVERSER_SRC" ]; then
    if [ ! -f "$SCROLL_REVERSER_DEST" ] || ! diff -q "$SCROLL_REVERSER_SRC" "$SCROLL_REVERSER_DEST" &>/dev/null; then
        cp "$SCROLL_REVERSER_SRC" "$SCROLL_REVERSER_DEST"
        echo "✅ Scroll Reverser config applied"
    else
        echo "✅ Scroll Reverser config (unchanged)"
    fi
else
    echo "⚠️  No scroll-reverser.plist found - skipping"
fi

# =============================================================================
# RECTANGLE CONFIG
# =============================================================================

RECTANGLE_SRC="$SETUP_DIR/rectangle.plist"

if [ -f "$RECTANGLE_SRC" ]; then
    defaults import com.knollsoft.Rectangle "$RECTANGLE_SRC"
    echo "✅ Rectangle config applied"
else
    echo "⚠️  No rectangle.plist found - skipping"
fi

# =============================================================================
# LOGIN ITEMS (Auto-start apps)
# =============================================================================

print_section "Configuring login items"

add_login_item "/Applications/Scroll Reverser.app"
add_login_item "/Applications/Rectangle.app"

# =============================================================================
# GHOSTTY CONFIG
# =============================================================================

GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
if [ ! -f "$GHOSTTY_CONFIG" ]; then
    mkdir -p "$(dirname "$GHOSTTY_CONFIG")"
    echo "cursor-style = bar" > "$GHOSTTY_CONFIG"
    echo "✅ Ghostty config created"
else
    echo "✅ Ghostty config (exists)"
fi
