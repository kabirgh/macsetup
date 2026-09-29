#!/bin/bash

# =============================================================================
# Terminal AI Tools (native installers, which keep themselves up to date)
# Run standalone: PROFILE=personal|work bash scripts/ai.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

if [ ${#AI_CLIS[@]} -gt 0 ]; then
    print_section "Installing terminal AI tools (${#AI_CLIS[@]} total)"

    # Both installers put their binary here
    NATIVE_BIN_DIR="$HOME/.local/bin"
    export PATH="$NATIVE_BIN_DIR:$PATH"
    if ! grep -qs '\.local/bin' "$HOME/.zprofile" "$HOME/.zshrc"; then
        add_line_if_missing "$HOME/.zprofile" 'export PATH="$HOME/.local/bin:$PATH"'
    fi

    for cli in "${AI_CLIS[@]}"; do
        case "$cli" in
            claude)
                installer_url="https://claude.ai/install.sh" installer_shell=bash cask=claude-code ;;
            codex)
                installer_url="https://chatgpt.com/codex/install.sh" installer_shell=sh cask=codex ;;
            *)
                echo "  ❌ $cli: no native installer known - add it to scripts/ai.sh"
                continue ;;
        esac

        if [ -x "$NATIVE_BIN_DIR/$cli" ]; then
            echo "  ✅ $cli (exists)"
        else
            echo "  📦 Installing $cli..."
            curl -fsSL "$installer_url" | CODEX_NON_INTERACTIVE=1 "$installer_shell" 2>&1 | tee -a "$LOG_FILE"
            echo "  ✅ $cli installed"
        fi

        # Flag other installs that would shadow or duplicate the native one
        if brew list --cask "$cask" &>/dev/null; then
            echo "  ⚠️  Homebrew $cask is also installed. Remove it with: brew uninstall --cask $cask"
        fi
        resolved="$(command -v "$cli" || true)"
        if [ -n "$resolved" ] && [ "$resolved" != "$NATIVE_BIN_DIR/$cli" ]; then
            echo "  ⚠️  $resolved comes before the native $cli on PATH"
        fi
    done
fi
