#!/bin/bash

# =============================================================================
# Package Lists Configuration
# Shared lists apply to both profiles; PROFILE (personal | work) adds extras.
# Review the work selections against your employer's approved software list.
# =============================================================================

case "${PROFILE:-}" in
    personal|work) ;;
    *)
        echo "PROFILE must be 'personal' or 'work', e.g. PROFILE=work bash scripts/apps.sh" >&2
        exit 2
        ;;
esac

GIT_NAME="Kabir Khandpur"
GIT_EMAIL="kabirgh@users.noreply.github.com"

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
    gh
)

# GUI applications installed via Homebrew Cask
CASK_APPS=(
    ghostty
    rectangle
    scroll-reverser
    karabiner-elements
    visual-studio-code
    spotify
    raycast
)

# Terminal AI tools installed with their native installers (see scripts/ai.sh)
AI_CLIS=(
    claude
)

# VS Code extensions
VSCODE_EXTENSIONS=(
    azemoh.one-monokai
    dnut.rewrap-revived
    eamodio.gitlens
    astral-sh.ty
    charliermarsh.ruff
    typescriptteam.native-preview
)

if [ "$PROFILE" = "personal" ]; then
    BREW_PACKAGES+=(
        ffmpeg
        arduino-cli
    )

    CASK_APPS+=(
        1password
        brave-browser
        chatgpt
        claude
        calibre
        docker
        steam
        transmission
        vlc
        proxyman
        obsidian
        syncthing-app
        arduino-ide
    )

    AI_CLIS+=(
        codex
    )

    VSCODE_EXTENSIONS+=(
        astro-build.astro-vscode
    )

    # Tools installed globally via mise (format: tool@version)
    MISE_TOOLS=(
        node@lts
        bun@latest
        uv@latest
        rust@latest
    )

    SET_LOGIN_ITEMS=true
else
    BREW_PACKAGES+=(
        uv
        fd
        bat
    )

    # Work runtimes come from each project's mise configuration.
    MISE_TOOLS=()

    # Leave login items to the employer's device management.
    SET_LOGIN_ITEMS=false
fi
