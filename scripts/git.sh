#!/bin/bash

# =============================================================================
# Git Configuration
# Run standalone: bash scripts/git.sh
# =============================================================================

GIT_NAME="Kabir Khandpur"
GIT_EMAIL="kabirgh@users.noreply.github.com"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Configuring Git"

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "cursor"

echo "✅ Git configured for $GIT_NAME <$GIT_EMAIL>"
