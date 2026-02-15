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
    visual-studio-code
    spotify
    steam
    transmission
    vlc
    proxyman
    obsidian
    syncthing-app
)

# VS Code extensions
VSCODE_EXTENSIONS=(
    azemoh.one-monokai
    dnut.rewrap-revived
    eamodio.gitlens
    astro-build.astro-vscode
    astral-sh.ty
    charliermarsh.ruff
    typescriptteam.native-preview
)

# Tools installed via mise (format: tool@version)
MISE_TOOLS=(
    node@lts
    bun@latest
    uv@latest
    rust@latest
)

