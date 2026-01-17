#!/bin/bash

# =============================================================================
# Mise Tools
# Run standalone: bash scripts/mise.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

if command -v mise &>/dev/null; then
    print_section "Installing tools via mise (${#MISE_TOOLS[@]} total)"
    
    eval "$(mise activate bash)" 2>/dev/null || true
    
    # Configure mise settings
    MISE_CONFIG="$HOME/.config/mise/config.toml"
    mkdir -p "$(dirname "$MISE_CONFIG")"
    add_line_if_missing "$MISE_CONFIG" '[settings]'
    add_line_if_missing "$MISE_CONFIG" 'python.uv_venv_auto = true'
    
    # Install tools globally (check if already installed first)
    for tool_spec in "${MISE_TOOLS[@]}"; do
        tool="${tool_spec%%@*}"
        if mise ls "$tool" 2>/dev/null | grep -q "$tool"; then
            echo "  ✅ $tool (exists)"
        else
            mise use --global "$tool_spec" 2>>"$LOG_FILE" && echo "  ✅ $tool" || echo "  ❌ $tool"
        fi
    done
    
    add_line_if_missing ~/.zshrc 'eval "$(~/.local/bin/mise activate zsh)"'
else
    echo ""
    echo "⚠️  mise not found - skipping tool installation"
    echo "   Install mise first via homebrew.sh"
fi

