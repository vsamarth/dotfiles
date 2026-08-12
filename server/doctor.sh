#!/usr/bin/env bash

set -u

failures=0

ok() { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }
note() { printf '---- %s\n' "$1"; }

if [[ "$(uname -s)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then
  ok "Apple silicon macOS"
else
  bad "expected Apple silicon macOS"
fi

macos_major="$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)"
if [[ "$macos_major" =~ ^[0-9]+$ ]] && ((macos_major >= 26)); then
  ok "macOS $macos_major supports the documented FileVault recovery drill"
else
  bad "expected macOS 26 or later; got ${macos_major:-unknown}"
fi

computer_name="$(scutil --get ComputerName 2>/dev/null || true)"
local_hostname="$(scutil --get LocalHostName 2>/dev/null || true)"
if [[ "$computer_name" == "den" && "$local_hostname" == "den" ]]; then
  ok "computer name and local hostname are den"
else
  bad "expected computer name and local hostname den; got ComputerName='$computer_name' LocalHostName='$local_hostname'"
fi

current_user="$(id -un)"
if [[ "$current_user" == "agent" ]]; then
  ok "running as the dedicated agent account"
else
  bad "expected the dedicated account name agent, got $current_user"
fi

if [[ " $(id -Gn "$current_user") " == *" admin "* ]]; then
  bad "the agent account belongs to the admin group"
else
  ok "the agent account is not an administrator"
fi

for command_name in brew codex gh git jq node pnpm rg starship uv zellij; do
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name is installed"
  else
    bad "$command_name is missing"
  fi
done

server_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$server_dir/.." && pwd)"

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  brew_owner="$(stat -f '%Su' "$brew_prefix")"
  brew_command="$(command -v brew)"
  if [[ "$brew_prefix" == "/opt/homebrew" && "$brew_command" == "/opt/homebrew/bin/brew" ]]; then
    ok "Homebrew uses the supported Apple-silicon prefix"
  else
    bad "expected /opt/homebrew/bin/brew and prefix /opt/homebrew; got command $brew_command prefix $brew_prefix"
  fi
  if [[ "$brew_owner" == 'samarth' ]]; then
    ok "Homebrew is controlled by the samarth administrator account"
  else
    bad "Homebrew is owned by $brew_owner instead of samarth"
  fi

  if env HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$server_dir/Brewfile" >/dev/null 2>&1; then
    ok "server Brewfile is satisfied"
  else
    bad "server Brewfile has missing dependencies"
  fi
fi

check_link() {
  local target_path="$1"
  local source_path="$2"
  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    ok "$target_path is linked to the server profile"
  else
    bad "$target_path is not linked to $source_path"
  fi
}

check_link "$HOME/.zprofile" "$server_dir/zsh/zprofile"
check_link "$HOME/.zshrc" "$server_dir/zsh/zshrc"
check_link "$HOME/.config/zsh" "$server_dir/zsh/config"
check_link "$HOME/.config/starship.toml" "$server_dir/starship.toml"
check_link "$HOME/.config/zellij" "$server_dir/zellij"
check_link "$HOME/.gitconfig" "$server_dir/gitconfig"
check_link "$HOME/.gitignore" "$dotfiles_dir/git/gitignore"
check_link "$HOME/.codex/AGENTS.md" "$server_dir/codex/AGENTS.md"
check_link "$HOME/.codex/config.toml" "$server_dir/codex/config.toml"
check_link "$HOME/.local/bin/kit-log" "$server_dir/bin/kit-log"
check_link "$HOME/.local/bin/kit-checkpoint" "$server_dir/bin/kit-checkpoint"

check_private_path() {
  local target_path="$1"
  local expected_mode="$2"

  if [[ ! -e "$target_path" ]]; then
    bad "$target_path is missing"
    return
  fi

  local owner mode
  owner="$(stat -f '%Su' "$target_path")"
  mode="$(stat -f '%Lp' "$target_path")"

  if [[ "$owner" == "$current_user" && "$mode" == "$expected_mode" ]]; then
    ok "$target_path is owned by $current_user with mode $expected_mode"
  else
    bad "$target_path expected owner $current_user mode $expected_mode; got owner $owner mode $mode"
  fi
}

check_private_path "$HOME/Kit" 700
check_private_path "$HOME/Kit/journal" 700
for continuity_file in README.md NOW.md DECISIONS.md RECOVERY.md READINESS.md; do
  check_private_path "$HOME/Kit/$continuity_file" 600
done

if zsh -n "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.config/zsh/"*.zsh; then
  ok "Zsh configuration parses"
else
  bad "Zsh configuration does not parse"
fi

if zellij setup --check 2>&1 | grep -q 'Well defined'; then
  ok "Zellij configuration parses"
else
  bad "Zellij configuration is not well defined"
fi

if fdesetup status 2>/dev/null | grep -q 'FileVault is On'; then
  ok "FileVault is on"
else
  bad "FileVault is not confirmed on"
fi

if /usr/bin/nc -z 127.0.0.1 22 >/dev/null 2>&1; then
  ok "Remote Login is listening on TCP 22"
else
  note "Remote Login is not listening on TCP 22"
fi

if pmset -g custom | sed -n '/AC Power:/,$p' | grep -Eq '^[[:space:]]*sleep[[:space:]]+0$'; then
  ok "idle system sleep is disabled on AC power"
else
  bad "idle system sleep is not disabled on AC power"
fi

if gh auth status >/dev/null 2>&1; then
  ok "GitHub CLI is authenticated"
else
  note "GitHub CLI needs manual authentication: gh auth login"
fi

if codex login status >/dev/null 2>&1; then
  ok "Codex is authenticated"
else
  note "Codex needs manual authentication: codex login"
fi

if command -v tailscale >/dev/null 2>&1 && tailscale status >/dev/null 2>&1; then
  ok "Tailscale is connected"
else
  note "Tailscale CLI/status is unavailable; complete the selected variant's setup"
fi

if [[ "$failures" -gt 0 ]]; then
  printf '\n%s required check(s) failed.\n' "$failures" >&2
  exit 1
fi

printf '\nCore checks passed. Review the informational lines above, then run server-readiness after the recovery drills.\n'
