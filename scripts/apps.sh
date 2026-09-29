#!/bin/bash

# =============================================================================
# GUI Applications and Configs
# Run standalone: PROFILE=personal|work bash scripts/apps.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
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
        # Skip apps installed outside Homebrew (manually or by IT), which
        # brew install --cask would refuse to overwrite
        app_name=$(brew info --cask "$app" 2>/dev/null | grep -o '[A-Za-z0-9 ]*\.app' | head -1 || true)
        if [ -n "$app_name" ] && { [ -d "/Applications/$app_name" ] || [ -d "$HOME/Applications/$app_name" ]; }; then
            echo "  ✅ $app (manual)"
        else
            casks_to_install+=("$app")
        fi
    fi
done

if [ ${#casks_to_install[@]} -gt 0 ]; then
    echo "  📦 Installing: ${casks_to_install[*]}"
    brew install --cask "${casks_to_install[@]}" 2>&1 | tee -a "$LOG_FILE"
fi

# =============================================================================
# APP CONFIGS (only for selected apps)
# =============================================================================

print_section "Applying app configs"

# Copy a saved config file into place, replacing the app's existing settings
apply_config_file() {
    local name="$1" src="$2" dest="$3"
    if [ ! -f "$src" ]; then
        echo "⚠️  No $(basename "$src") found - skipping"
    elif [ ! -f "$dest" ] || ! cmp -s "$src" "$dest"; then
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "✅ $name config applied"
    else
        echo "✅ $name config (unchanged)"
    fi
}

if cask_selected karabiner-elements; then
    apply_config_file "Karabiner" "$SETUP_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi

if cask_selected scroll-reverser; then
    apply_config_file "Scroll Reverser" "$SETUP_DIR/scroll-reverser.plist" \
        "$HOME/Library/Preferences/com.pilotmoon.scroll-reverser.plist"
fi

if cask_selected rectangle; then
    RECTANGLE_SRC="$SETUP_DIR/rectangle.plist"
    if [ -f "$RECTANGLE_SRC" ]; then
        defaults import com.knollsoft.Rectangle "$RECTANGLE_SRC"
        echo "✅ Rectangle config applied"
    else
        echo "⚠️  No rectangle.plist found - skipping"
    fi
fi

if cask_selected ghostty; then
    GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
    if [ ! -f "$GHOSTTY_CONFIG" ]; then
        mkdir -p "$(dirname "$GHOSTTY_CONFIG")"
        echo "cursor-style = bar" > "$GHOSTTY_CONFIG"
        echo "✅ Ghostty config created"
    else
        echo "✅ Ghostty config (exists)"
    fi
fi

# =============================================================================
# LOGIN ITEMS (Auto-start apps)
# =============================================================================

if [ "$SET_LOGIN_ITEMS" = true ]; then
    print_section "Configuring login items"

    if cask_selected scroll-reverser; then
        add_login_item "/Applications/Scroll Reverser.app"
    fi
    if cask_selected rectangle; then
        add_login_item "/Applications/Rectangle.app"
    fi
fi
