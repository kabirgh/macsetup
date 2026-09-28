#!/bin/bash

# =============================================================================
# Shell Setup (ZSH, Oh My Zsh, Powerlevel10k)
# Run standalone: bash scripts/shell.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Configuring shell"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "📦 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR" 2>>"$LOG_FILE"
fi

ZSHRC="$HOME/.zshrc"

# Set Powerlevel10k as the theme (only if not already set)
if grep -q '^ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC" 2>/dev/null; then
    : # Already set, do nothing
elif grep -q '^ZSH_THEME=' "$ZSHRC" 2>/dev/null; then
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
else
    add_line_if_missing "$ZSHRC" 'ZSH_THEME="powerlevel10k/powerlevel10k"'
fi

add_block_if_missing "$ZSHRC" '## -- start git --
unalias gb
function gb {
  git --no-pager branch | cat -n
}

unalias gco
function gco {
  git checkout $(git branch | cut -c 3- | sed -n "${1}p")
}

unalias gbd
function gbd {
  local branches=()
  for num in $@
  do
    branches+=$(git branch | cut -c 3- | sed -n "${num}p")
  done

  git branch -D "${branches[@]}"
}

### rebase
function gri {
  branch=${1:-master}
  git fetch origin $branch:$branch
  git rebase -i $branch
}

function grc {
  git rebase --continue
}

### misc
function grso {
  git reset --soft HEAD~${1:-1}
}

function gcap {
  git add . && git commit -m "$1" && ggp
}
## -- end git --'

add_block_if_missing "$ZSHRC" '## -- start shortcuts --
alias c="code"
alias cl="claude"
alias sz="source ~/.zshrc"
alias cz="code ~/.zshrc"
## -- end shortcuts --'

add_line_if_missing "$ZSHRC" 'source <(fzf --zsh)'

echo "✅ Shell configured"
