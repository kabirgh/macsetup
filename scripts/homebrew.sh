#!/bin/bash

# =============================================================================
# Homebrew and CLI Packages
# Run standalone: bash scripts/homebrew.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
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
# BUN PACKAGES
# =============================================================================

if command -v bun &>/dev/null; then
    print_section "Installing bun packages"
    BUN_GLOBAL_DIR="$HOME/.bun/install/global/node_modules"
    
    if [ -d "$BUN_GLOBAL_DIR/@openai/codex" ]; then
        echo "  ✅ codex (exists)"
    else
        CI=1 bun install -g @openai/codex 2>>"$LOG_FILE" && echo "  ✅ codex" || echo "  ❌ codex"
    fi
fi

# =============================================================================
# CLEANUP
# =============================================================================

print_section "Cleaning up"
brew cleanup 2>>"$LOG_FILE" || true
echo "✅ Cleanup complete"
