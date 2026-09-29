#!/bin/bash

# =============================================================================
# macOS Setup Script (Idempotent)
# Run with: ./setup.sh --personal | --work
#
# Individual scripts can be run independently with a profile:
#   bash scripts/macos.sh                   - macOS preferences
#   PROFILE=work bash scripts/homebrew.sh   - Homebrew + CLI packages
#   bash scripts/shell.sh                   - ZSH + Oh My Zsh + Powerlevel10k
#   PROFILE=work bash scripts/mise.sh       - Mise activation (+ personal tools)
#   PROFILE=work bash scripts/apps.sh       - GUI apps and configs
#   PROFILE=work bash scripts/git.sh        - Git configuration
#   PROFILE=personal bash scripts/ssh.sh    - SSH key setup (personal only)
#   PROFILE=work bash scripts/vscode.sh     - VS Code extensions
# =============================================================================

set -euo pipefail

# Print error location on failure
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"' ERR

# Handle Ctrl+C gracefully
trap 'echo ""; echo "⚠️  Interrupted. Run again to continue."; exit 130' INT

usage() {
    echo "Usage: setup.sh --personal | --work" >&2
    exit 2
}

[ "$#" -eq 1 ] || usage

case "$1" in
    --personal) PROFILE=personal ;;
    --work) PROFILE=work ;;
    *) usage ;;
esac
export PROFILE

# =============================================================================
# SETUP
# =============================================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/config.sh"
source "$ROOT_DIR/scripts/common.sh"

echo "🚀 Starting macOS setup ($PROFILE)..."
log "Setup started ($PROFILE)"

# =============================================================================
# RUN ALL SETUP SCRIPTS
# =============================================================================

source "$ROOT_DIR/scripts/macos.sh"
source "$ROOT_DIR/scripts/homebrew.sh"
# Before mise: the Oh My Zsh installer replaces an existing ~/.zshrc.
source "$ROOT_DIR/scripts/shell.sh"
source "$ROOT_DIR/scripts/mise.sh"
source "$ROOT_DIR/scripts/apps.sh"
source "$ROOT_DIR/scripts/git.sh"
if [ "$PROFILE" = "personal" ]; then
    source "$ROOT_DIR/scripts/ssh.sh"
fi
source "$ROOT_DIR/scripts/vscode.sh"

# =============================================================================
# DONE
# =============================================================================

print_section "Setup Complete! 🎉"

echo ""
echo "Log: $LOG_FILE"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Next steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  - Log out and back in (for key repeat settings)"
echo "  - Restart your terminal (or: source ~/.zshrc)"
if [ "$PROFILE" = "personal" ]; then
    echo "  - Add SSH key to GitHub: https://github.com/settings/keys"
else
    echo "  - Set your work Git identity in each work repository (see README.md)"
    echo "  - Set up a work SSH key if needed (see README.md)"
fi
if cask_selected karabiner-elements; then
    echo "  - Open Karabiner-Elements and allow its driver extension and Input"
    echo "    Monitoring in System Settings"
    if [ "$PROFILE" = "work" ]; then
        echo "    (if device management blocks it, remove karabiner-elements from config.sh)"
    fi
fi
echo "  - Log into your applications"
echo ""

log "Setup completed ($PROFILE)"
