#!/bin/bash

# =============================================================================
# VS Code Extensions
# Run standalone: bash scripts/vscode.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

if command -v code &>/dev/null; then
    print_section "Installing VS Code extensions (${#VSCODE_EXTENSIONS[@]})"

    for ext in "${VSCODE_EXTENSIONS[@]}"; do
        if code --install-extension "$ext" --force 2>>"$LOG_FILE"; then
            echo "  ✅ $ext"
        else
            echo "  ❌ $ext"
        fi
    done
else
    echo ""
    echo "⚠️  VS Code CLI not found - skipping extensions"
    echo "   Run 'Shell Command: Install code command in PATH' from VS Code"
fi
