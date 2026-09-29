#!/bin/bash

# =============================================================================
# macOS Preferences
# Run standalone: bash scripts/macos.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Configuring macOS preferences"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Fast key repeat (fastest values available in System Preferences)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

killall Finder 2>/dev/null || true

echo "✅ macOS preferences"
