# Zsh setup

Framework-free. This directory is linked to `~/.config/zsh`, and the two
standard Zsh entrypoints are intentionally tiny loaders:

- `~/.zprofile` → `zprofile` loads login-shell environment setup.
- `~/.zshrc` → `zshrc` loads interactive behavior in numeric order, then an
  untracked `~/.zshrc.local` if one exists.

| File | Owns |
| --- | --- |
| `profile.zsh` | Homebrew and native CLI PATH entries |
| `00-path.zsh` | PATH repair for non-login interactive shells |
| `10-history.zsh` | Shared history policy |
| `20-completion.zsh` | `compinit`, lazy generated completions, completion rules |
| `30-tools.zsh` | zoxide, direnv, fzf, and fzf-tab |
| `40-commands.zsh` | editor variables and aliases |
| `50-prompt.zsh` | Starship and autosuggestions |
| `60-atuin.zsh` | local enhanced history on `Ctrl-R` |
| `90-highlighting.zsh` | syntax highlighting; always load last |

Colours are ANSI names so they follow Ghostty's light/dark theme. Starship's
config is `starship/starship.toml`.

After an edit, run `reload`. Validate without opening a new terminal with:

```zsh
zsh -n ~/.zprofile ~/.zshrc ~/.config/zsh/*.zsh
```

`compinit` uses `~/.zcompdump` for fast startup and automatically rebuilds when
Homebrew's completion directories change. uv and pnpm generate their own
current completion only on first Tab in a shell.
