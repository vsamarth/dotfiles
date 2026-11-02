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
- Touch ID for sudo: `sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template |
  sudo tee /etc/pam.d/sudo_local` (survives macOS updates; the password still
  works where Touch ID can't, such as over SSH)
Check: `brew --version`, `git -C ~/.dotfiles log -1`, and `sudo -k && sudo true`
prompts for Touch ID

## 2. Packages
`brew bundle --file=~/.dotfiles/Brewfile`
Check: `brew bundle check --file=~/.dotfiles/Brewfile`

## 3. Agents
- Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
- Rex (beta): not on Homebrew (the `rex` formula is an unrelated tool). Install
  the app from Rex's site and open it once. If `rex` is not on PATH, link the
  CLI from inside the app bundle into ~/.local/bin (the hook calls `rex` at
  every session start). Then run `rex skill setup` to give
  Claude Code Rex's skill and session hook. Rex writes its own hook into
  ~/.claude/settings.json; do not hand-write that hook.
- Computer use: agent-desktop, which reads and operates apps through the
  accessibility tree.
  - Install: `pnpm add -g agent-desktop --allow-build=agent-desktop` (the build
    step links the native binary), then `npx skills add
    https://github.com/vercel-labs/agent-desktop --skill agent-desktop -g -a claude-code -y`.
  - Permissions (mine to grant): Accessibility, which macOS 27 calls Device
    Control and Data Access, and Screen Recording, both for Rex Beta.
    `agent-desktop permissions --guide` opens the panes. Terminals run under
    the Rex Server helper, so if a permission still shows as denied, add
    `~/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app`
    as well.
  - Backup: Claude Code's built-in computer use, which works from screenshots.
    Enable it from `/mcp` per project.
- Skills from Matt Pocock: `DO_NOT_TRACK=1 npx skills add mattpocock/skills
  --skill writing-for-agents --skill retro -g -a claude-code -y`.
- Proton Pass CLI (`pass-cli`, beta, paid plan): installed by the Brewfile
  from Proton's tap.
Check: `claude --version`, `rex version`, `rex skill status`, `pass-cli --version`,
and `agent-desktop status` shows accessibility and screen_recording as granted

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
the live file (repo keys win, other keys such as Rex's hook are kept, and keys
deleted from the repo file since the last run are deleted live too); `--dry`
previews. Edit the repo file, then re-run it.

Check: every target above resolves into ~/.dotfiles (`ls -l`), and
`bin/claude-settings --dry` prints "Already up to date".

## 5. Accounts (mine to do; guide me through each)
- `gh auth login` (web flow), then `gh auth setup-git`
- Sign in to Proton Pass, Mail, Drive, VPN, Tailscale and Claude Code
- Hex (local dictation): grant Microphone and Accessibility, let it download its
  model, and set the push-to-talk hotkey
- Default browser: `~/.dotfiles/bin/default-browser` (Helium); I confirm the macOS
  dialog
- Login items: Raycast, Rectangle, Proton Pass, Hex and Tailscale (Tailscale's
  own "Launch at login" switch doesn't stick, so add it as a login item instead)
- Grant Accessibility to Raycast, Rectangle and Hex

## 6. macOS and always-on
- `bash ~/.dotfiles/macos/macos.sh` (Dock, Finder, keyboard, screenshots,
  trackpad, Caps Lock → Control). Log out once so key repeat takes effect.
- `bash ~/.dotfiles/macos/dock.sh` (Dock apps: Helium, Rex, Claude, Proton Mail,
  Calendar)
- Weekly agent retro: link `macos/local.weekly-retro.plist` into
  `~/Library/LaunchAgents` and load it with `launchctl bootstrap`. Every Sunday
  evening Sonnet and Opus each review the week's sessions and leave proposals
  on local `retro/<date>-<model>` branches, sandboxed with no network; they
  never push, because the transcripts are private.
- Lid-closed always-on: ASK. It needs sudo. Show me the exact `pmset` command and
  what it changes, wait for approval, then test: close the lid on power and reach
  the Mac over Tailscale.
- Tailscale and Proton VPN can conflict on macOS. Test them together once.

## 7. Verify
- `zsh -i -c exit` prints nothing, run in a Rex pane (an agent's own shell has
  no terminal, so zsh warns about `zle` there)
- Rex opens a plain zsh
- The Dock shows exactly Helium, Rex, Claude, Proton Mail and Calendar
- Caps Lock acts as Control, and screenshots land in ~/Pictures/Screenshots
- `claude` starts in a Rex pane with the status line and reports its Rex
  session; `/permissions` shows force-push under ask
- `git config user.email` is hi@samarthv.com and `gh auth status` succeeds

## Working on this repo
- Propose changes with the file contents before writing. No setup log.
- The repo is public. No work names, hosts, tokens or personal data. Anything
  machine-specific goes in an untracked `*.local` file.
