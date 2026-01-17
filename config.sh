#!/bin/bash

# =============================================================================
# Package Lists Configuration
# All installable packages defined in one place for easy editing
# =============================================================================

# CLI tools installed via Homebrew
BREW_PACKAGES=(
    git
    wget
    curl
    jq
    ripgrep
    fzf
    mise
    pnpm
    ffmpeg
    gh
)

# GUI applications installed via Homebrew Cask
CASK_APPS=(
    1password
    brave-browser
    docker
    ghostty
    rectangle
    scroll-reverser
    karabiner-elements
    cursor
    spotify
    steam
    transmission
    vlc
    proxyman
    obsidian
    syncthing-app
)

# Cursor extensions from marketplace
CURSOR_EXTENSIONS=(
    eamodio.gitlens
    stkb.rewrap
    typescriptteam.native-preview
)

# Cursor extensions installed from VSIX (not on marketplace)
CURSOR_VSIX_EXTENSIONS=(
    "azemoh.one-monokai"
    "astro-build.astro-vscode"
)

# Tools installed via mise (format: tool@version)
MISE_TOOLS=(
    node@lts
    bun@latest
    uv@latest
    rust@latest
)

