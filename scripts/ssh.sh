#!/bin/bash

# =============================================================================
# SSH Key Setup
# Run standalone: PROFILE=personal bash scripts/ssh.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Setting up SSH keys"

SSH_KEY="$HOME/.ssh/id_ed25519"

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f "$SSH_KEY" ]; then
    echo "🔐 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
    
    echo ""
    echo "📋 Your public SSH key:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "${SSH_KEY}.pub"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "✅ SSH key exists"
fi

SSH_CONFIG_BLOCK='
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519'

add_block_if_missing ~/.ssh/config "$SSH_CONFIG_BLOCK"
chmod 600 ~/.ssh/config

eval "$(ssh-agent -s)" 2>/dev/null || true
ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY" 2>/dev/null || true

echo "✅ SSH configured"
