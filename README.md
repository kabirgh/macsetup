# macOS Setup

Personal macOS setup scripts, plus a separate work laptop profile.

## Personal laptop

```bash
./setup.sh --personal
```

Or run individual scripts:

```bash
bash scripts/macos.sh     # macOS preferences
bash scripts/homebrew.sh  # Homebrew + CLI tools + mise
bash scripts/apps.sh      # GUI apps + configs
bash scripts/ssh.sh       # SSH key
bash scripts/git.sh       # Git config
bash scripts/shell.sh     # ZSH + Oh My Zsh + Powerlevel10k
bash scripts/vscode.sh    # VS Code extensions
```

## After running

1. Log out/in (for key repeat settings)
2. Restart terminal or `source ~/.zshrc`
3. Add SSH key to GitHub

The personal setup installs Claude Desktop and ChatGPT Desktop, which includes the Codex interface. It also installs the separate `claude-code` and `codex` Homebrew casks for the `claude` and `codex` terminal commands. An existing CLI from another installer does not replace the Homebrew install.

## Work laptop

Review the selections in `work-config.sh` against your employer's approved software list before running:

```bash
./setup.sh --work
```

The work profile applies the same macOS preferences as the personal setup: Finder hidden files, path bar and status bar, faster key repeat, and tap to click. It installs Homebrew if needed and adds its path to `~/.zprofile`, then installs the selected CLI tools, apps, and VS Code extensions. It applies the saved Karabiner and Scroll Reverser configurations when selected, replacing those apps' existing settings. It also runs the same shell setup: Oh My Zsh, Powerlevel10k, Git shortcuts, and fzf integration in `~/.zshrc`. Work installs and activates mise in Zsh; use project mise configuration to select runtimes. The personal setup uses the same Homebrew installation helper. The work profile leaves login items, other app settings, global Git identity, and SSH configuration alone.

Set your work Git identity separately in each work repository:

```bash
git -C /path/to/work/repo config --local user.name "Your Work Name"
git -C /path/to/work/repo config --local user.email "you@company.example"
```

If your employer uses SSH for Git, create a dedicated work key with `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work` (which prompts for a passphrase). Add a host-specific entry to `~/.ssh/config`, replacing the example host with your work Git host:

```sshconfig
Host work-git
    HostName git.company.example
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

Use `work-git` in work repository remote URLs. Register the public key with your work Git service using your employer's process. Do not add the work key under `Host *` or reuse a personal key for work.
