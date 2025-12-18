#!/bin/bash

# =============================================================================
# Homebrew and CLI Packages
# Run standalone: bash scripts/homebrew.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

# =============================================================================
# HOMEBREW INSTALLATION
# =============================================================================

print_section "Installing Homebrew"

if ! command -v brew &>/dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure Homebrew is in PATH
add_line_if_missing ~/.zprofile 'eval "$(/opt/homebrew/bin/brew shellenv)"'
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true

echo "✅ Homebrew"

# =============================================================================
# CLI PACKAGES
# =============================================================================

print_section "Installing CLI packages (${#BREW_PACKAGES[@]} total)"

packages_to_install=()
for package in "${BREW_PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "  ✅ $package (exists)"
    else
        packages_to_install+=("$package")
    fi
done

if [ ${#packages_to_install[@]} -gt 0 ]; then
    echo "  📦 Installing: ${packages_to_install[*]}"
    brew install "${packages_to_install[@]}" 2>&1 | tee -a "$LOG_FILE" || true
fi

# =============================================================================
# MISE TOOLS
# =============================================================================

if command -v mise &>/dev/null; then
    print_section "Installing tools via mise"
    
    eval "$(mise activate bash)" 2>/dev/null || true
    
    # Configure mise settings
    MISE_CONFIG="$HOME/.config/mise/config.toml"
    mkdir -p "$(dirname "$MISE_CONFIG")"
    add_line_if_missing "$MISE_CONFIG" '[settings]'
    add_line_if_missing "$MISE_CONFIG" 'python.uv_venv_auto = true'
    
    # Install tools globally (check if already installed first)
    if mise ls node 2>/dev/null | grep -q "node"; then
        echo "  ✅ node (exists)"
    else
        mise use --global node@lts 2>>"$LOG_FILE" && echo "  ✅ node" || echo "  ❌ node"
    fi
    
    if mise ls bun 2>/dev/null | grep -q "bun"; then
        echo "  ✅ bun (exists)"
    else
        mise use --global bun@latest 2>>"$LOG_FILE" && echo "  ✅ bun" || echo "  ❌ bun"
    fi
    
    if mise ls uv 2>/dev/null | grep -q "uv"; then
        echo "  ✅ uv (exists)"
    else
        mise use --global uv@latest 2>>"$LOG_FILE" && echo "  ✅ uv" || echo "  ❌ uv"
    fi
    
    # Install global bun packages
    if command -v bun &>/dev/null; then
        BUN_GLOBAL_DIR="$HOME/.bun/install/global/node_modules"
        
        if [ -d "$BUN_GLOBAL_DIR/@anthropic-ai/claude-code" ]; then
            echo "  ✅ claude-code (exists)"
        else
            CI=1 bun install -g @anthropic-ai/claude-code 2>>"$LOG_FILE" && echo "  ✅ claude-code" || echo "  ❌ claude-code"
        fi
        
        if [ -d "$BUN_GLOBAL_DIR/@openai/codex" ]; then
            echo "  ✅ codex (exists)"
        else
            CI=1 bun install -g @openai/codex 2>>"$LOG_FILE" && echo "  ✅ codex" || echo "  ❌ codex"
        fi
    fi
    
    add_line_if_missing ~/.zshrc 'eval "$(~/.local/bin/mise activate zsh)"'
else
    echo ""
    echo "⚠️  mise not found - skipping tool installation"
fi

# =============================================================================
# CLEANUP
# =============================================================================

print_section "Cleaning up"
brew cleanup 2>>"$LOG_FILE" || true
echo "✅ Cleanup complete"
