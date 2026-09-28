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
ensure_homebrew

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
    brew install "${packages_to_install[@]}" 2>&1 | tee -a "$LOG_FILE"
fi

# =============================================================================
# CLEANUP
# =============================================================================

print_section "Cleaning up"
brew cleanup 2>>"$LOG_FILE" || true
echo "✅ Cleanup complete"
