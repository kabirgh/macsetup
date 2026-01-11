# macOS Setup

Personal macOS setup scripts. Idempotent, safe to run multiple times.

## Usage

```bash
bash setup.sh
```

Or run individual scripts:

```bash
bash scripts/macos.sh     # macOS preferences
bash scripts/homebrew.sh  # Homebrew + CLI tools + mise
bash scripts/apps.sh      # GUI apps + configs
bash scripts/ssh.sh       # SSH key
bash scripts/git.sh       # Git config
bash scripts/shell.sh     # ZSH + Oh My Zsh + Powerlevel10k
bash scripts/cursor.sh    # Cursor extensions
```

## After running

1. Log out/in (for key repeat settings)
2. Restart terminal or `source ~/.zshrc`
3. Add SSH key to GitHub

