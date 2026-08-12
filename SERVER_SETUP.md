# Agent Server Setup

This runbook prepares an Apple-silicon MacBook as a mostly headless personal-agent
server. It installs the operating environment but intentionally does **not** install,
configure, authorize, or run Hermes.

The existing `instructions.md` and default `just setup` recipe describe the older
workstation configuration. Do not run them on this server.

## Intended posture

- FileVault stays enabled; automatic login stays disabled.
- The Mac stays on AC power with idle system sleep disabled.
- The lid stays open for reliable operation. A closed MacBook lid can force sleep.
- Tailscale is the private remote network. Do not forward SSH or other ports on the router.
- Remote Login is limited to your account. Full Disk Access for remote users starts off.
- Codex is used to prepare and maintain the host with workspace-scoped permissions.
- `~/Work` holds confidential work repositories; `~/Projects` holds personal projects.
- Credentials, private keys, recovery keys, `.env` files, and agent runtime state remain
  local and untracked.

## 1. Finish macOS first

1. Keep the MacBook connected to power and the working display adapter.
2. Install every macOS update from **System Settings → General → Software Update**.
3. Restart, check again, and continue only when no update remains.
4. Open **Automatic Updates** on that page and enable update checks, downloads,
   macOS updates, app updates, and security responses/system files.
5. In **System Settings → Users & Groups**, confirm automatic login is off.
6. Choose a stable computer name in **System Settings → General → About → Name**.
   A short name such as `agentbook` is convenient, but changing identity is your decision.

Do not sign the server into unnecessary personal apps or enable broad iCloud syncing.

## 2. Enable FileVault

Open **System Settings → Privacy & Security → FileVault** and turn FileVault on.

- Use a personal recovery key if offered.
- Store it in a secure location outside this Mac.
- Never put the recovery key in this repository, a terminal command, a screenshot, or
  a Codex prompt.
- Confirm FileVault later with `fdesetup status`; do not print the recovery key.

On Apple silicon with macOS 26 or later, Apple supports unlocking FileVault over SSH
after a restart when Remote Login is enabled and a compatible network is available.
Test this from your own network before depending on it. Preboot networking may not
have Tailscale, so retain a physical-unlock plan.

## 3. Install the bootstrap prerequisites

Open Terminal and install Apple's Command Line Tools:

```bash
xcode-select --install
```

Complete the graphical installer. Then install Homebrew using the command currently
published at [brew.sh](https://brew.sh). Review that command on the site rather than
copying an old installer command from this repository.

Add Homebrew to the **current shell only** after installation:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Do not append a Homebrew line to `~/.zprofile`; the server bootstrap will provide the
tracked login-shell configuration. Then install Git, Just, and Codex:

```bash
brew install git just
brew install --cask codex
```

The Homebrew Codex cask installs the terminal CLI. Do not launch it yet; its portable
configuration should be linked first.

## 4. Clone the dotfiles and inspect them

Clone over public HTTPS initially so no SSH identity is required:

```bash
git clone https://github.com/vsamarth/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git status --short --branch
```

Read the bootstrap before running it:

```bash
less SERVER_SETUP.md
less server/bootstrap.sh
```

The bootstrap:

- installs the command-line packages in `server/Brewfile`;
- creates `~/Work` and `~/Projects`;
- links the server-specific Zsh, Git, Starship, Zellij, and Codex configuration;
- refuses to replace any existing file or symlink;
- does not use `sudo`, change macOS settings, authenticate services, or install Hermes.

When you are satisfied, run:

```bash
just server-bootstrap
```

If `just` is not yet available, run the equivalent entrypoint:

```bash
bash server/bootstrap.sh
```

If the bootstrap refuses an existing path, inspect it and move it aside yourself. Do
not tell Codex to overwrite or delete an unknown configuration automatically.

Open a new Terminal window after the bootstrap.

Now complete Codex authentication through its secure browser/device flow and launch
it from the repository:

```bash
cd ~/.dotfiles
codex login
codex
```

Do not use an API key unless you have independently decided that key-based access is
appropriate. Ask Codex to read `SERVER_SETUP.md`, inspect the repository state, and
run `just server-doctor`. It should pause at every manual security or authentication
step rather than trying to complete those steps for you.

## 5. Authenticate GitHub

Authenticate through GitHub CLI's secure browser flow:

```bash
gh auth login
```

Choose GitHub.com, HTTPS, and browser authentication. Do not paste the one-time code
or any credential into a Codex conversation. Verify without printing credentials:

```bash
gh auth status
git config --global user.name
git config --global user.email
```

The server profile uses HTTPS plus GitHub CLI's credential helper. It does not create,
copy, or configure a private SSH key.

## 6. Configure Tailscale

Install Tailscale's current standalone macOS package using the official instructions
at [tailscale.com/docs/install/mac](https://tailscale.com/docs/install/mac). Tailscale
recommends the standalone variant. Review the installer and terms yourself; this step
is deliberately outside the bootstrap because it installs a privileged network
component.

Open Tailscale from Applications. Approve its macOS network extension and complete
the sign-in yourself. Use the same tailnet as the controlling Mac.

In Tailscale settings:

- keep Tailscale connected;
- enable launch at login if offered;
- do not enable an exit node or advertise routes unless you deliberately need them;
- give this device a recognizable name;
- confirm it is visible from the controlling Mac.

Wired Ethernet is preferable for an always-on server when practical. It is also the
most predictable preboot network for FileVault recovery. Wi-Fi can remain the fallback.

Do not expose SSH through router port forwarding. Tailscale should be the route to
the server during normal operation.

## 7. Configure Remote Login

Open **System Settings → General → Sharing**. Open the details for **Remote Login**:

1. Turn Remote Login on.
2. Set **Allow access for** to **Only these users**.
3. Add only your server account.
4. Leave **Allow full disk access for remote users** off initially.

From the controlling Mac, test the command shown in that settings panel, first on the
local network and then using the Tailscale device name or Tailscale IP:

```bash
ssh <server-user>@<tailscale-name-or-ip>
```

Use password authentication only for initial setup. For durable key-based SSH, create
or select the client identity yourself, install **only its public key** into
`~/.ssh/authorized_keys` on the server, and test a second SSH session before disabling
password authentication. Never copy a private key to the server or into this repo.

Do not change SSH authentication policy until key login has been tested and you retain
a local recovery route.

After both local-network and Tailscale SSH work, enable the macOS firewall in
**System Settings → Network → Firewall**. Retest both SSH paths immediately. Do not
enable **Block all incoming connections**, because Remote Login must remain reachable.

## 8. Configure AC-power behavior

Keep the lid open. Then review the current settings:

```bash
pmset -g custom
```

The following change affects AC power only. It prevents idle system and disk sleep,
keeps network wake/keepalive enabled, and asks the Mac to restart after power returns:

```bash
sudo pmset -c sleep 0 disksleep 0 womp 1 tcpkeepalive 1 autorestart 1
```

Enter the administrator password directly in Terminal. Codex must not request or enter
it. Verify afterwards:

```bash
pmset -g custom
```

Set display sleep separately in **System Settings → Lock Screen**; display sleep is
fine and does not need to keep the monitor illuminated.

Because FileVault remains enabled, a restart can stop at preboot unlock even when
`autorestart` succeeds. Validate remote unlock on your network before relying on
unattended recovery. Otherwise plan to unlock the Mac physically after a restart.

## 9. Optional Screen Sharing

SSH should be the normal administration path. If occasional GUI recovery is useful,
turn on **Screen Sharing** in **System Settings → General → Sharing**, restrict it to
your account, and connect only over Tailscale. Do not enable both Screen Sharing and
Remote Management without a specific need.

Screen Sharing is not a substitute for FileVault preboot unlock.

## 10. Validate

From `~/.dotfiles`, run:

```bash
just server-doctor
```

The doctor is read-only. It checks the core command line tools, Zsh, Zellij, FileVault,
Remote Login visibility, and authentication status without reading credentials.

Then test the operating loop from the controlling Mac:

```bash
ssh <server-user>@<tailscale-name-or-ip>
cd ~/Work
zj
```

Detach from Zellij with `Ctrl-o`, then `d`, disconnect SSH, reconnect, and run `zj`
again. The same repository session should resume.

## 11. Reboot drill

Do this while you can physically reach the server:

1. Confirm FileVault, Remote Login, Tailscale, and AC power settings.
2. Restart the server.
3. Attempt FileVault unlock over SSH from the local network if available.
4. If it is unavailable, unlock physically.
5. Confirm Tailscale reconnects after login.
6. Confirm SSH works over Tailscale.
7. Run `just --justfile ~/.dotfiles/justfile server-doctor`.

Do not call the server unattended-ready until this drill succeeds.

## 12. Backups and maintenance

An autonomous agent can delete or corrupt anything its account can write. Keep at least
one recovery path outside that account's ordinary reach.

- Push important repositories only to remotes already approved for that data.
- Do not treat unpushed Git history as a backup.
- Use an encrypted Time Machine destination or another existing trusted backup system
  for non-repository state. Choose and authorize that destination yourself.
- Keep the FileVault recovery key separate from both the server and its backup disk.
- Do not grant an agent permission to erase backup history or administer the backup
  destination merely for convenience.

For routine maintenance, connect over SSH, review pending updates, and then run:

```bash
brew update
brew bundle install --file=~/.dotfiles/server/Brewfile
brew upgrade
just --justfile ~/.dotfiles/justfile server-doctor
```

Schedule reboots only when you can verify FileVault unlock and remote recovery.

## Intentionally excluded

This profile does not install or configure:

- Hermes or any persistent personal-agent runtime;
- agent gateways, messaging bots, background agent services, or launch agents;
- API keys, OAuth grants, passwords, recovery keys, or private SSH keys;
- password managers, personal browsers, mail, messages, cloud drives, or social apps;
- Docker, local model runtimes, databases, or language toolchains not yet required;
- automatic login, public port forwarding, passwordless `sudo`, or blanket Full Disk Access;
- the legacy Fish shell, Firefox customization, Dock layout, or broad macOS defaults.

Add those later as explicit, independently reviewed decisions. In particular, Hermes
setup remains entirely separate from this repository and runbook.
