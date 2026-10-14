# New Mac setup

Executed by an agent. Follow the sections in order, run each check, and stop to
ask before anything marked ASK. If you are unsure about a flag, read the
command's help first. Never read secret files and never ask me to paste a
secret; sign-ins are mine to do.

Target: a normal, lean personal MacBook with only the essentials. Ghostty opens
into herdr, where Claude Code and pi run. Anything not listed here is left out
on purpose. Add it when it is needed.

## 1. Foundation
- Command Line Tools: `xcode-select --install`
- Homebrew from brew.sh, then `eval "$(/opt/homebrew/bin/brew shellenv)"`
- Clone: `git clone https://github.com/vsamarth/dotfiles.git ~/.dotfiles`
Check: `brew --version` and `git -C ~/.dotfiles log -1`

## 2. Packages
`brew bundle --file=~/.dotfiles/Brewfile`
Check: `brew bundle check --file=~/.dotfiles/Brewfile`

## 3. Agents
- Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
- pi: `curl -fsSL https://pi.dev/install.sh | sh`
- herdr: look up the current install command in its docs, show it to me, then
  run it. Then install herdr's Claude Code integration. herdr writes its own
  hook into ~/.claude/settings.json; do not hand-write that hook.
- Proton Pass CLI (`pass-cli`, beta, paid plan): ASK, then install per
  Proton's current docs.
Check: `claude --version`, `pi --version`, `herdr --version`, `pass-cli --version`

## 4. Link configs
Use `~/.dotfiles/bin/symlink <source> <target>`. It is idempotent and asks
before replacing a real file.

| Source (in ~/.dotfiles)           | Target                                                              |
| --------------------------------- | ------------------------------------------------------------------- |
| agents/AGENTS.md                  | ~/.claude/CLAUDE.md and ~/.pi/agent/AGENTS.md                       |
| claude/settings.json              | ~/.claude/settings.json                                             |
| claude/statusline.sh              | ~/.claude/statusline.sh                                             |
| pi/settings.json                  | ~/.pi/agent/settings.json                                           |
| herdr/config.toml                 | ~/.config/herdr/config.toml                                         |
| ghostty/config.ghostty            | ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty  |
| git/gitconfig, git/gitignore      | ~/.gitconfig, ~/.gitignore                                          |
| zsh/zprofile, zsh/zshrc           | ~/.zprofile, ~/.zshrc                                               |

Check: every target resolves into ~/.dotfiles (`ls -l`).

## 5. Accounts (mine to do; guide me through each)
- `gh auth login` (web flow), then `gh auth setup-git`
- Sign in to Proton Pass, Mail, Drive, VPN, Tailscale, Claude Code and pi
- Login items: Raycast, Rectangle, KeepingYouAwake, Proton Pass
- Grant Accessibility to Raycast, Rectangle and Ghostty

## 6. macOS and always-on
- `bash ~/.dotfiles/macos/macos.sh` (Dock, Finder, trackpad)
- Lid-closed always-on: ASK. It needs sudo. Show me the exact `pmset` command and
  what it changes, wait for approval, then test: close the lid on power and reach
  the Mac over Tailscale.
- Tailscale and Proton VPN can conflict on macOS. Test them together once.

## 7. Verify
- `zsh -i -c exit` prints nothing
- Ghostty opens into herdr; Ctrl+' opens the drop-down
- `claude` starts in a herdr pane with the status line; `/permissions` shows
  force-push under ask
- `git config user.email` is hi@samarthv.com and `gh auth status` succeeds

## Working on this repo
- Propose changes with the file contents before writing. No setup log.
- The repo is public. No work names, hosts, tokens or personal data. Anything
  machine-specific goes in an untracked `*.local` file.
