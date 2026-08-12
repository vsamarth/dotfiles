#!/usr/bin/env bash

set -euo pipefail

server_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$server_dir/.." && pwd)"
link_safe="$server_dir/bin/link-safe"
preflight_only=false

if [[ "${1:-}" == "--preflight" ]]; then
  preflight_only=true
elif [[ "$#" -gt 0 ]]; then
  printf 'usage: %s [--preflight]\n' "$0" >&2
  exit 2
fi

phase() { printf '\n[%s] %s\n' "$1" "$2"; }
preflight_failures=0
preflight_ok() { printf 'ok   %s\n' "$1"; }
preflight_bad() {
  printf 'FAIL %s\n' "$1" >&2
  preflight_failures=$((preflight_failures + 1))
}

phase '1/4' 'Preflight'

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  preflight_bad 'this profile supports Apple silicon macOS only'
else
  preflight_ok 'Apple silicon macOS'
fi

macos_major="$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)"
if [[ "$macos_major" =~ ^[0-9]+$ ]] && ((macos_major >= 26)); then
  preflight_ok "macOS $macos_major supports the documented FileVault recovery drill"
else
  preflight_bad "macOS 26 or later is required; found ${macos_major:-unknown}"
fi

current_user="$(id -un)"

if [[ "$current_user" != "agent" ]]; then
  preflight_bad "run this profile from the standard macOS account agent, not $current_user"
else
  preflight_ok 'running as agent'
fi

if [[ " $(id -Gn "$current_user") " == *" admin "* ]]; then
  preflight_bad 'the agent account belongs to the admin group'
else
  preflight_ok 'the current account is not an administrator'
fi

if ! command -v brew >/dev/null 2>&1; then
  preflight_bad 'Homebrew is missing; install the official package and rerun'
else
  brew_command="$(command -v brew)"
  if [[ "$brew_command" == "/opt/homebrew/bin/brew" ]]; then
    preflight_ok 'Homebrew command is /opt/homebrew/bin/brew'
  else
    preflight_bad "expected /opt/homebrew/bin/brew; found $brew_command"
  fi
fi

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"

  brew_prefix="$(brew --prefix)"
  if [[ "$brew_prefix" == "/opt/homebrew" ]]; then
    preflight_ok 'Homebrew prefix is /opt/homebrew'
  else
    preflight_bad "expected Homebrew prefix /opt/homebrew; found $brew_prefix"
  fi

  brew_owner="$(stat -f '%Su' "$brew_prefix")"
  if [[ "$brew_owner" == "$current_user" ]]; then
    preflight_ok "Homebrew is owned by $current_user"
  else
    preflight_bad "Homebrew at $brew_prefix is owned by $brew_owner, not $current_user; do not repair this with a broad chown"
  fi
fi

if xcode-select -p >/dev/null 2>&1; then
  preflight_ok 'Command Line Tools are selected'
else
  preflight_bad 'Command Line Tools are missing; run xcode-select --install'
fi

available_kib="$(df -Pk "$HOME" | awk 'NR == 2 {print $4}')"
if [[ "$available_kib" =~ ^[0-9]+$ ]] && ((available_kib >= 5242880)); then
  preflight_ok 'at least 5 GiB is available in the home volume'
else
  preflight_bad 'less than 5 GiB is available in the home volume'
fi

link_sources=(
  "$server_dir/zsh/zprofile"
  "$server_dir/zsh/zshrc"
  "$server_dir/zsh/config"
  "$server_dir/starship.toml"
  "$server_dir/zellij"
  "$server_dir/gitconfig"
  "$dotfiles_dir/git/gitignore"
  "$server_dir/codex/AGENTS.md"
  "$server_dir/codex/config.toml"
  "$server_dir/bin/kit-log"
  "$server_dir/bin/kit-checkpoint"
)
link_targets=(
  "$HOME/.zprofile"
  "$HOME/.zshrc"
  "$HOME/.config/zsh"
  "$HOME/.config/starship.toml"
  "$HOME/.config/zellij"
  "$HOME/.gitconfig"
  "$HOME/.gitignore"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.codex/config.toml"
  "$HOME/.local/bin/kit-log"
  "$HOME/.local/bin/kit-checkpoint"
)

for index in "${!link_sources[@]}"; do
  source_path="${link_sources[$index]}"
  target_path="${link_targets[$index]}"

  if [[ ! -e "$source_path" ]]; then
    preflight_bad "link source is missing: $source_path"
  elif [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    preflight_ok "existing managed link: $target_path"
  elif [[ -e "$target_path" || -L "$target_path" ]]; then
    preflight_bad "refusing existing unmanaged path: $target_path"
  else
    preflight_ok "link target is available: $target_path"
  fi
done

if [[ "$preflight_failures" -gt 0 ]]; then
  printf '\n%s preflight check(s) failed. Nothing was installed or linked.\n' "$preflight_failures" >&2
  exit 1
fi

if "$preflight_only"; then
  printf '\nPreflight passed. Run the bootstrap without --preflight when ready.\n'
  exit 0
fi

phase '2/4' 'Packages'
brew bundle install --file="$server_dir/Brewfile"
brew bundle check --file="$server_dir/Brewfile"

phase '3/4' 'Tracked configuration'
mkdir -p "$HOME/.config" "$HOME/.codex" "$HOME/.local/bin" "$HOME/Work" "$HOME/Projects"

for index in "${!link_sources[@]}"; do
  "$link_safe" "${link_sources[$index]}" "${link_targets[$index]}"
done

phase '4/4' 'Private continuity state'
kit_state_dir="$HOME/Kit"
install -d -m 700 "$kit_state_dir" "$kit_state_dir/journal"
chmod 700 "$kit_state_dir" "$kit_state_dir/journal"

install_state_file() {
  local source_path="$1"
  local target_path="$2"

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    printf 'Keeping existing continuity file %s\n' "$target_path"
    return
  fi

  install -m 600 "$source_path" "$target_path"
  printf 'Initialized continuity file %s\n' "$target_path"
}

install_state_file "$server_dir/kit/README.md" "$kit_state_dir/README.md"
install_state_file "$server_dir/kit/NOW.md" "$kit_state_dir/NOW.md"
install_state_file "$server_dir/kit/DECISIONS.md" "$kit_state_dir/DECISIONS.md"
install_state_file "$server_dir/kit/RECOVERY.md" "$kit_state_dir/RECOVERY.md"
install_state_file "$server_dir/kit/READINESS.md" "$kit_state_dir/READINESS.md"

printf '\nCore agent-server profile installed.\n'
printf 'Open a new terminal, then run: just --justfile %q server-doctor\n' "$dotfiles_dir/justfile"
printf 'Kit continuity state is private and mutable at %s.\n' "$kit_state_dir"
printf 'Security, networking, authentication, recovery drills, and power steps remain explicit human checkpoints.\n'
