#!/bin/bash

# CLI tools for the work profile. setup-work.sh installs Homebrew if needed.
WORK_BREW_PACKAGES=(
    jq
    ripgrep
    fzf
    git
    gh
    wget
    curl
    mise
    pnpm
    uv
    fd
    bat
)

# GUI apps installed with Homebrew Cask.
WORK_CASK_APPS=(
    visual-studio-code
    ghostty
    rectangle
    scroll-reverser
    karabiner-elements
    spotify
)

# Extensions from the personal VS Code profile.
WORK_VSCODE_EXTENSIONS=(
    azemoh.one-monokai
    dnut.rewrap-revived
    eamodio.gitlens
    astro-build.astro-vscode
    astral-sh.ty
    charliermarsh.ruff
    typescriptteam.native-preview
)
