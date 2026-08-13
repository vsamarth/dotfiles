#!/usr/bin/env bash

set -euo pipefail

workstation_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$workstation_dir/.." && pwd)"
link_safe="$dotfiles_dir/server/bin/link-safe"
preflight_only=false

if [[ "${1:-}" == "--preflight" ]]; then
  preflight_only=true
elif [[ "$#" -gt 0 ]]; then
  printf 'usage: %s [--preflight]\n' "$0" >&2
  exit 2
fi

phase() { printf '\n[%s] %s\n' "$1" "$2"; }
failures=0
ok() { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1" >&2; failures=$((failures + 1)); }

phase '1/4' 'Preflight'

if [[ "$(uname -s)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then
  ok 'Apple silicon macOS'
else
  bad 'this profile supports Apple silicon macOS only'
fi

current_user="$(id -un)"
if [[ "$current_user" == "samarth" ]]; then
  ok 'running as samarth'
else
  bad "run this profile from the macOS account samarth, not $current_user"
fi

if [[ " $(id -Gn "$current_user") " == *" admin "* ]]; then
  ok 'samarth is an administrator'
else
  bad 'the samarth recovery/workstation account must be an administrator'
fi

if command -v brew >/dev/null 2>&1; then
  brew_command="$(command -v brew)"
  brew_prefix="$(brew --prefix)"
  brew_owner="$(stat -f '%Su' "$brew_prefix")"

  if [[ "$brew_command" == '/opt/homebrew/bin/brew' && "$brew_prefix" == '/opt/homebrew' ]]; then
    ok 'Homebrew uses the supported Apple-silicon prefix'
  else
    bad "expected /opt/homebrew/bin/brew and prefix /opt/homebrew; got command $brew_command prefix $brew_prefix"
  fi

  if [[ "$brew_owner" == "$current_user" ]]; then
    ok "Homebrew is owned by $current_user"
  else
    bad "Homebrew is owned by $brew_owner, not $current_user; do not repair this with a broad chown"
  fi
else
  bad 'Homebrew is missing; install it from brew.sh and rerun'
fi

if xcode-select -p >/dev/null 2>&1; then
  ok 'Command Line Tools are selected'
else
  bad 'Command Line Tools are missing; run xcode-select --install'
fi

available_kib="$(df -Pk "$HOME" | awk 'NR == 2 {print $4}')"
if [[ "$available_kib" =~ ^[0-9]+$ ]] && ((available_kib >= 15728640)); then
  ok 'at least 15 GiB is available for applications and toolchains'
else
  bad 'less than 15 GiB is available in the home volume'
fi

link_sources=(
  "$workstation_dir/zsh/zprofile"
  "$workstation_dir/zsh/zshrc"
  "$workstation_dir/zsh/config"
  "$workstation_dir/starship.toml"
  "$dotfiles_dir/server/zellij"
  "$workstation_dir/ghostty/config"
  "$workstation_dir/gitconfig"
  "$workstation_dir/git/allowed_signers"
  "$dotfiles_dir/git/gitignore"
  "$dotfiles_dir/nvim"
  "$workstation_dir/vscode/settings.json"
  "$workstation_dir/codex/AGENTS.md"
  "$workstation_dir/codex/config.toml"
  '/opt/homebrew/lib/docker/cli-plugins/docker-buildx'
)
link_targets=(
  "$HOME/.zprofile"
  "$HOME/.zshrc"
  "$HOME/.config/zsh"
  "$HOME/.config/starship.toml"
  "$HOME/.config/zellij"
  "$HOME/.config/ghostty/config"
  "$HOME/.gitconfig"
  "$HOME/.config/git/allowed_signers"
  "$HOME/.gitignore"
  "$HOME/.config/nvim"
  "$HOME/Library/Application Support/Code/User/settings.json"
  "$HOME/.codex/AGENTS.md"
  "$HOME/.codex/config.toml"
  "$HOME/.docker/cli-plugins/docker-buildx"
)

for index in "${!link_sources[@]}"; do
  source_path="${link_sources[$index]}"
  target_path="${link_targets[$index]}"

  if [[ ! -e "$source_path" ]]; then
    bad "link source is missing: $source_path"
  elif [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    ok "existing managed link: $target_path"
  elif [[ -e "$target_path" || -L "$target_path" ]]; then
    bad "refusing existing unmanaged path: $target_path"
  else
    ok "link target is available: $target_path"
  fi
done

if [[ "$failures" -gt 0 ]]; then
  printf '\n%s preflight check(s) failed. Nothing was installed or linked.\n' "$failures" >&2
  exit 1
fi

if "$preflight_only"; then
  printf '\nPreflight passed. Run the bootstrap without --preflight when ready.\n'
  exit 0
fi

phase '2/4' 'Applications and command-line tools'
brew bundle install --file="$workstation_dir/Brewfile"
brew bundle check --file="$workstation_dir/Brewfile"

phase '3/4' 'Tracked configuration'
mkdir -p \
  "$HOME/.codex" \
  "$HOME/.config" \
  "$HOME/.config/ghostty" \
  "$HOME/.config/git" \
  "$HOME/.docker/cli-plugins" \
  "$HOME/.local/bin" \
  "$HOME/Library/Application Support/Code/User" \
  "$HOME/Projects" \
  "$HOME/Work"

for index in "${!link_sources[@]}"; do
  "$link_safe" "${link_sources[$index]}" "${link_targets[$index]}"
done

phase '4/4' 'Editor extensions'
while IFS= read -r extension; do
  [[ -n "$extension" ]] || continue
  if command -v code >/dev/null 2>&1; then
    code --install-extension "$extension" --force
  fi
done < "$workstation_dir/editor-extensions.txt"

printf '\nSamarth workstation profile installed.\n'
printf 'Open a new terminal, then run: just --justfile %q workstation-doctor\n' "$dotfiles_dir/justfile"
printf 'macOS preferences, Dock layout, identities, authentication, and app sign-ins remain explicit human steps.\n'
