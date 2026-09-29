# macOS Setup

macOS setup scripts with a personal and a work profile. Both profiles run the same scripts; `config.sh` holds the shared lists plus each profile's extras.

```bash
./setup.sh --personal
./setup.sh --work
```

Or run individual scripts with a profile:

```bash
bash scripts/macos.sh                   # macOS preferences
PROFILE=work bash scripts/homebrew.sh   # Homebrew + CLI tools
bash scripts/shell.sh                   # ZSH + Oh My Zsh + Powerlevel10k
PROFILE=work bash scripts/mise.sh       # mise activation (+ global tools on personal)
PROFILE=work bash scripts/apps.sh       # GUI apps + configs
PROFILE=work bash scripts/ai.sh         # Terminal AI tools (native installers)
PROFILE=work bash scripts/git.sh        # Git config
PROFILE=personal bash scripts/ssh.sh    # SSH key (personal only)
PROFILE=work bash scripts/vscode.sh     # VS Code extensions
```

## What each profile does

Both profiles apply the macOS preferences (Finder hidden files, path bar and status bar, faster key repeat, tap to click), install Homebrew and the shared CLI tools, apps and VS Code extensions, install Claude Code with its native installer, and set up the shell: Oh My Zsh, Powerlevel10k, Git shortcuts, fzf integration and mise activation in `~/.zshrc`. Saved Karabiner, Scroll Reverser and Rectangle configs are applied when those apps are selected, replacing the apps' existing settings. Apps already installed outside Homebrew, for example by IT, are left as they are.

The personal profile also installs its extra apps, the `codex` CLI, the Astro VS Code extension and global mise runtimes, adds Rectangle and Scroll Reverser as login items, sets the global Git identity and creates an SSH key.

The work profile leaves login items, global Git identity and SSH configuration alone. Use project mise configuration to select runtimes.

## After running

1. Log out/in (for key repeat settings)
2. Restart terminal or `source ~/.zshrc`
3. Personal: add the SSH key to GitHub
4. Open Karabiner-Elements and allow its driver extension and Input Monitoring in System Settings

The personal setup installs Claude Desktop and ChatGPT Desktop, which includes the Codex interface. The `claude` and `codex` terminal commands come from their native installers, which install into `~/.local/bin` and update themselves; `~/.local/bin` is added to `PATH` in `~/.zprofile` if it isn't already there. A tool already in `~/.local/bin` is skipped. If a Homebrew, npm or bun copy is also installed, setup warns so you can remove it.

## Work laptop

Review the work selections in `config.sh` against your employer's approved software list before running. Karabiner-Elements needs a driver extension, which device management may block; if so, remove it from `CASK_APPS`.

### Git identity

`git.sh` asks which folder holds your work repositories, for example `~/acme` (default `~/work`), and points every repository under it at `~/.gitconfig-work`. The answer is remembered and offered as the default next time; entering a different folder moves the work identity there. It also asks for your work email the first time. To skip the folder prompt, set it up front: `WORK_GIT_DIR=~/acme ./setup.sh --work`. To set or change the identity later:

```bash
git config --file ~/.gitconfig-work user.name "Your Work Name"
git config --file ~/.gitconfig-work user.email "you@company.example"
```

### SSH

If your employer uses SSH for Git, create a dedicated work key with `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work` (which prompts for a passphrase). Add a host-specific entry to `~/.ssh/config`, replacing the example host with your work Git host:

```sshconfig
Host work-git
    HostName git.company.example
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

Use `work-git` in work repository remote URLs. Register the public key with your work Git service using your employer's process. Do not add the work key under `Host *` or reuse a personal key for work.
