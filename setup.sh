#!/bin/bash

# =============================================================================
# macOS Setup Script (Idempotent)
# Run with: bash setup.sh
#
# Individual scripts can be run independently:
#   bash scripts/macos.sh    - macOS preferences
#   bash scripts/homebrew.sh - Homebrew + CLI packages
#   bash scripts/mise.sh     - Mise tools (node, bun, uv, rust)
#   bash scripts/apps.sh     - GUI apps and configs
#   bash scripts/ssh.sh      - SSH key setup
#   bash scripts/git.sh      - Git configuration
#   bash scripts/shell.sh    - ZSH + Oh My Zsh + Powerlevel10k
#   bash scripts/cursor.sh   - Cursor extensions
# =============================================================================

set -euo pipefail

# Print error location on failure
trap 'echo "❌ Error on line $LINENO: $BASH_COMMAND"' ERR

# Handle Ctrl+C gracefully
trap 'echo ""; echo "⚠️  Interrupted. Run again to continue."; exit 130' INT

# =============================================================================
# SETUP
# =============================================================================

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common config and helpers
source "$ROOT_DIR/scripts/common.sh"

echo "🚀 Starting macOS setup..."
log "Setup started"

# =============================================================================
# RUN ALL SETUP SCRIPTS
# =============================================================================

source "$ROOT_DIR/scripts/macos.sh"
source "$ROOT_DIR/scripts/homebrew.sh"
source "$ROOT_DIR/scripts/mise.sh"
source "$ROOT_DIR/scripts/apps.sh"
source "$ROOT_DIR/scripts/ssh.sh"
source "$ROOT_DIR/scripts/git.sh"
source "$ROOT_DIR/scripts/shell.sh"
source "$ROOT_DIR/scripts/cursor.sh"

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
echo "  1. Log out and back in (for key repeat settings)"
echo "  2. Restart your terminal (or: source ~/.zshrc)"
echo "  3. Add SSH key to GitHub: https://github.com/settings/keys"
echo "  4. Log into your applications"
echo ""

log "Setup completed"
