#!/bin/bash

# =============================================================================
# Git Configuration
# Run standalone: PROFILE=personal|work bash scripts/git.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"
source "$SCRIPT_DIR/common.sh"

# Only set up error handling if running standalone
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_standalone
fi

print_section "Configuring Git"

git config --global core.editor "code --wait"
git config --global init.defaultBranch main

if [ "$PROFILE" = "personal" ]; then
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    echo "✅ Git configured for $GIT_NAME <$GIT_EMAIL>"
else
    # No global identity on work machines: repositories under WORK_GIT_DIR
    # get the work identity from ~/.gitconfig-work.
    WORK_GITCONFIG="$HOME/.gitconfig-work"

    # Reuse the work folder from an earlier run, if any
    previous_work_dir=""
    while IFS= read -r key; do
        if [ "$(git config --global --get "$key")" = "$WORK_GITCONFIG" ]; then
            previous_work_dir="${key#includeif.gitdir:}"
            previous_work_dir="${previous_work_dir%/.path}"
            break
        fi
    done < <(git config --global --name-only --get-regexp '^includeif\.gitdir:.*\.path$' 2>/dev/null || true)

    # Accept ~/acme, an absolute path, or a name relative to your home folder
    normalize_work_dir() {
        local dir="${1/#\~/$HOME}"
        [[ "$dir" == /* ]] || dir="$HOME/$dir"
        echo "${dir%/}"
    }

    if [ -n "$WORK_GIT_DIR" ]; then
        # Set up front (WORK_GIT_DIR=~/acme ./setup.sh --work): no prompt
        WORK_GIT_DIR="$(normalize_work_dir "$WORK_GIT_DIR")"
    else
        WORK_GIT_DIR="${previous_work_dir:-$HOME/work}"
        if [ -t 0 ]; then
            read -r -p "Work folder for Git repositories [${WORK_GIT_DIR/#$HOME/~}]: " work_dir_input || { work_dir_input=""; echo; }
            if [ -n "$work_dir_input" ]; then
                WORK_GIT_DIR="$(normalize_work_dir "$work_dir_input")"
            fi
        fi
    fi

    if [ -n "$previous_work_dir" ] && [ "$previous_work_dir" != "$WORK_GIT_DIR" ]; then
        git config --global --remove-section "includeIf.gitdir:$previous_work_dir/"
        echo "  Moved the work identity from ${previous_work_dir/#$HOME/~} to ${WORK_GIT_DIR/#$HOME/~}"
    fi

    mkdir -p "$WORK_GIT_DIR"
    git config --global "includeIf.gitdir:$WORK_GIT_DIR/.path" "$WORK_GITCONFIG"

    if ! git config --file "$WORK_GITCONFIG" user.email >/dev/null 2>&1 && [ -t 0 ]; then
        read -r -p "Work Git email (leave blank to skip): " work_email || { work_email=""; echo; }
        if [ -n "$work_email" ]; then
            git config --file "$WORK_GITCONFIG" user.name "$GIT_NAME"
            git config --file "$WORK_GITCONFIG" user.email "$work_email"
        fi
    fi

    if work_email=$(git config --file "$WORK_GITCONFIG" user.email 2>/dev/null); then
        echo "✅ Git configured for <$work_email> in $WORK_GIT_DIR"
    else
        echo "⚠️  No work Git identity yet. Set it with:"
        echo "   git config --file $WORK_GITCONFIG user.name \"Your Work Name\""
        echo "   git config --file $WORK_GITCONFIG user.email you@company.example"
    fi
fi
