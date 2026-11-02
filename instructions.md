# New Mac setup

Executed by an agent. Follow the sections in order, run each check, and stop to
ask before anything marked ASK. If you are unsure about a flag, read the
command's help first. Never read secret files and never ask me to paste a
secret; sign-ins are mine to do.

Target: a normal, lean personal MacBook with only the essentials. Rex is the
terminal and multiplexer; Claude Code runs in its panes. Anything not listed
here is left out on purpose. Add it when it is needed.

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
- Rex (beta): not on Homebrew (the `rex` formula is an unrelated tool). Install
  the app from Rex's site and open it once. Then run `rex skill setup` to give
  Claude Code Rex's skill and session hook. Rex writes its own hook into
  ~/.claude/settings.json; do not hand-write that hook.
- Proton Pass CLI (`pass-cli`, beta, paid plan): ASK, then install per
  Proton's current docs.
Check: `claude --version`, `rex version`, `rex skill status`, `pass-cli --version`

## 4. Link configs
Use `~/.dotfiles/bin/symlink <source> <target>`. It is idempotent and asks
before replacing a real file.

| Source (in ~/.dotfiles)           | Target                                                              |
| --------------------------------- | ------------------------------------------------------------------- |
| agents/AGENTS.md                  | ~/.claude/CLAUDE.md                                                 |
| agents/AGENTS.md                  | ~/.agents/AGENTS.md                                                 |
| claude/statusline.sh              | ~/.claude/statusline.sh                                             |
| git/gitconfig, git/gitignore      | ~/.gitconfig, ~/.gitignore                                          |
| zsh/                              | ~/.config/zsh                                                       |
| zsh/zprofile, zsh/zshrc           | ~/.zprofile, ~/.zshrc                                               |
| starship/starship.toml            | ~/.config/starship.toml                                             |

Claude settings are not linked: Claude Code and Rex write into
`~/.claude/settings.json`, which would replace a symlink. Run
`~/.dotfiles/bin/claude-settings` instead. It merges `claude/settings.json` into
the live file (repo keys win, other keys such as Rex's hook are kept); `--dry`
previews. Edit the repo file, then re-run it.

Check: every target above resolves into ~/.dotfiles (`ls -l`), and
`bin/claude-settings --dry` prints "Already up to date".

## 5. Accounts (mine to do; guide me through each)
- `gh auth login` (web flow), then `gh auth setup-git`
- Sign in to Proton Pass, Mail, Drive, VPN, Tailscale and Claude Code
- Superwhisper (dictation, paid): sign in with the subscription, grant Microphone
  and Accessibility, choose a local model and set the push-to-talk hotkey
- Default browser: `~/.dotfiles/bin/default-browser` (Helium); I confirm the macOS
  dialog
- Login items: Raycast, Rectangle, KeepingYouAwake, Proton Pass, Superwhisper
- Grant Accessibility to Raycast, Rectangle and Superwhisper

## 6. macOS and always-on
- `bash ~/.dotfiles/macos/macos.sh` (Dock, Finder, trackpad)
- `bash ~/.dotfiles/macos/dock.sh` (Dock apps: Helium, Rex, Claude, Proton Mail,
  Calendar)
- Lid-closed always-on: ASK. It needs sudo. Show me the exact `pmset` command and
  what it changes, wait for approval, then test: close the lid on power and reach
  the Mac over Tailscale.
- Tailscale and Proton VPN can conflict on macOS. Test them together once.

## 7. Verify
- `zsh -i -c exit` prints nothing
- Rex opens a plain zsh
- The Dock shows exactly Helium, Rex, Claude, Proton Mail and Calendar
- `claude` starts in a Rex pane with the status line and reports its Rex
  session; `/permissions` shows force-push under ask
- `git config user.email` is hi@samarthv.com and `gh auth status` succeeds

## Working on this repo
- Propose changes with the file contents before writing. No setup log.
- The repo is public. No work names, hosts, tokens or personal data. Anything
  machine-specific goes in an untracked `*.local` file.
