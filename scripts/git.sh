#!/bin/bash

# =============================================================================
# Git Configuration
# Run standalone: PROFILE=personal|work bash scripts/git.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Configuring Git"

git config --global core.editor "code --wait"
git config --global init.defaultBranch main

if [ "$PROFILE" = "personal" ]; then
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    echo "✅ Git configured for $GIT_NAME <$GIT_EMAIL>"
else
    # No global identity on work machines; set it per repository (see README.md)
    echo "✅ Git configured (work identity is set per repository)"
fi
