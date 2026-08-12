# Samarth on den

This runbook recreates Samarth's clean daily workstation on the fresh Mac before the
separate `agent` account is prepared. It models the useful, reproducible parts of the
current laptop without copying credentials, private data, caches, histories, or
machine-management software.

The two profiles deliberately stay separate:

| Account | Role | Homebrew owner | Configuration |
| --- | --- | --- | --- |
| `samarth` | Human workstation, administrator, recovery authority | `samarth` | `workstation/` plus shared tracked configs |
| `agent` | Kit runtime and confidential work account | shared tools, read-only | `server/` and `SERVER_SETUP.md` |

Complete this runbook first. Do not run `just setup`; it is the legacy Fish-based
configuration and is retained only for compatibility until explicitly retired.

## What this recreates

- Zsh with Starship, completion, syntax highlighting, autosuggestions, Zoxide,
  Direnv, FZF, Yazi, and the `zj` repository-session helper.
- Ghostty, Zellij, Git/delta, Neovim, VS Code, Codex, and the common CLI stack.
- The current laptop's core daily applications, including ChatGPT, Chrome, Raycast,
  Rectangle, Notion, Linear, Slack, Spotify, WhatsApp, Telegram, Bitwarden, Secretive,
  IINA, Motrix, KeepingYouAwake, and Wispr Flow.
- Conservative Finder, Dock, screenshot, and text-input preferences.
- A clean VS Code configuration and a small, reviewable extension baseline.

VPNs, cloud-drive clients, device-management software, employer tooling, Apple Account
data, browser profiles, app databases, development containers, global language
packages, and every credential remain manual or intentionally excluded.

## 1. Finish the human account

Use Setup Assistant to create the administrator account with account name `samarth`.
Store its original password in your password manager on another trusted device.

From **System Settings**:

1. Install all macOS updates and restart until current.
2. Confirm automatic login is off.
3. Turn on FileVault and store its recovery key outside this Mac.
4. Sign into your Apple Account only if you want the corresponding personal data on
   this machine; do not let an agent make that decision.
5. Keep automatic macOS update installation off until the server recovery drill is
   complete. Checks, downloads, app updates, and security responses may stay on.

Do not create `agent` yet. This makes Homebrew ownership for the workstation
unambiguous.

## 2. Install prerequisites

Open Terminal as `samarth` and install Apple's Command Line Tools:

```bash
xcode-select --install
```

Install Homebrew using the current official instructions at
[brew.sh](https://brew.sh). Review the installer and enter your password directly in
Terminal. Homebrew must end up at `/opt/homebrew` owned by `samarth`.

Initialize it in the current shell and install the bootstrap tools:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git just
```

## 3. Clone and inspect

```bash
git clone https://github.com/vsamarth/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
less WORKSTATION_SETUP.md
less workstation/bootstrap.sh
```

Run the mutation-free prerequisite and collision check:

```bash
just workstation-preflight
```

If it reports an existing path, inspect and move that exact path aside yourself. The
bootstrap never overwrites a pre-existing configuration.

When preflight passes:

```bash
just workstation-bootstrap
```

The application download is intentionally substantial. The bootstrap may be rerun;
Homebrew and already-correct links are idempotent.

Open a fresh Terminal after it completes, then run:

```bash
just --justfile ~/.dotfiles/justfile workstation-doctor
```

## 4. Apply the reviewed preferences

Inspect the scripts before running either one:

```bash
less workstation/macos.sh
less workstation/dock.sh
```

The macOS script changes only per-user Finder, Dock, screenshot, and text-input
preferences. It does not weaken Gatekeeper, alter privacy permissions, change login
or network settings, or use `sudo`:

```bash
just workstation-macos
```

The Dock script removes the existing Dock entries and replaces them with the tracked
layout. Run it only if that is what you want:

```bash
just workstation-dock
```

## 5. Authenticate and personalize

Complete every sign-in through the application's own secure browser or system UI.
Never paste a password, token, one-time code, private key, or recovery key into Codex.

```bash
gh auth login
codex login
```

Then open and configure the applications you actually want:

- Bitwarden and Secretive;
- Chrome/browser profile;
- ChatGPT and Codex;
- VS Code Settings Sync if desired;
- Slack, Linear, Notion, Spotify, WhatsApp, Telegram, and Wispr Flow;
- Tailscale and one chosen VPN only after reviewing how they should coexist;
- Git signing only after you choose the identity and approve its access.

The tracked Git identity is Samarth Verma `<hi@samarthv.com>`. Confirm that address is
still correct before the first commit:

```bash
git config --global user.name
git config --global user.email
gh auth status
```

## 6. Restore data selectively

Clone repositories from their approved remotes into `~/Work` and `~/Projects`. Restore
documents through the service that owns them or from your encrypted backup.

Do not copy the old home directory wholesale. In particular, do not migrate:

- `~/.ssh`, `~/.gnupg`, Keychain files, browser profiles, `.env` files, auth caches,
  shell history, terminal scrollback, or Codex state;
- Homebrew Cellar contents, `node_modules`, virtual environments, Docker/Colima data,
  build outputs, caches, or application containers;
- JumpCloud or other organization-management software unless the organization
  explicitly requires and enrolls this Mac.

Reauthenticate instead of copying credential stores. Generate or import identities
through Bitwarden, Secretive, GitHub, and the relevant system interfaces yourself.

## 7. Create Kit's account

Once `samarth` is comfortable and recoverable, continue with
[`SERVER_SETUP.md`](SERVER_SETUP.md). That runbook creates `agent`, gives it a distinct
configuration and restricted access to the administrator-owned shared Homebrew
toolchain, and preserves the administrator/runtime boundary.

At that point tell Codex:

> Read `~/.dotfiles/SERVER_SETUP.md`, inspect the machine, and guide me through the setup—do everything safe yourself and pause whenever I need to authenticate or approve something.

## Intentionally excluded

- Hermes and all persistent agent services;
- credentials, private keys, recovery material, authentication state, and app data;
- automatic creation of SSH or signing identities;
- security/privacy permission grants, Full Disk Access, login items, VPN sign-in, or
  Apple Account sign-in;
- destructive cleanup or migration of an existing home directory;
- the old Fish shell, Firefox/Betterfox automation, broad macOS defaults, or forced
  default-browser changes;
- employer device management and organization-specific software.
