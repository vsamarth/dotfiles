#!/usr/bin/env bash

set -euo pipefail

server_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$server_dir/.." && pwd)"
link_safe="$server_dir/bin/link-safe"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  printf 'This profile supports Apple silicon macOS only.\n' >&2
  exit 1
fi

current_user="$(id -un)"

if [[ "$current_user" != "agent" ]]; then
  printf 'Run this profile from the standard macOS account named agent, not %s.\n' "$current_user" >&2
  exit 1
fi

if [[ " $(id -Gn "$current_user") " == *" admin "* ]]; then
  printf 'The agent account must remain a standard user and must not belong to the admin group.\n' >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Install it from https://brew.sh and rerun.\n' >&2
  exit 1
fi

eval "$(brew shellenv)"

brew_prefix="$(brew --prefix)"
brew_owner="$(stat -f '%Su' "$brew_prefix")"
if [[ "$brew_owner" != "$current_user" ]]; then
  printf 'Homebrew at %s is owned by %s, not %s. Follow SERVER_SETUP.md; do not repair this with a broad chown.\n' \
    "$brew_prefix" "$brew_owner" "$current_user" >&2
  exit 1
fi

brew bundle install --file="$server_dir/Brewfile"

mkdir -p "$HOME/.config" "$HOME/.codex" "$HOME/.local/bin" "$HOME/Work" "$HOME/Projects"

"$link_safe" "$server_dir/zsh/zprofile" "$HOME/.zprofile"
"$link_safe" "$server_dir/zsh/zshrc" "$HOME/.zshrc"
"$link_safe" "$server_dir/zsh/config" "$HOME/.config/zsh"
"$link_safe" "$server_dir/starship.toml" "$HOME/.config/starship.toml"
"$link_safe" "$server_dir/zellij" "$HOME/.config/zellij"
"$link_safe" "$server_dir/gitconfig" "$HOME/.gitconfig"
"$link_safe" "$dotfiles_dir/git/gitignore" "$HOME/.gitignore"
"$link_safe" "$server_dir/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
"$link_safe" "$server_dir/codex/config.toml" "$HOME/.codex/config.toml"
"$link_safe" "$server_dir/bin/kit-log" "$HOME/.local/bin/kit-log"
"$link_safe" "$server_dir/bin/kit-checkpoint" "$HOME/.local/bin/kit-checkpoint"

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

printf '\nCore agent-server profile installed.\n'
printf 'Open a new terminal, then run: just --justfile %q server-doctor\n' "$dotfiles_dir/justfile"
printf 'Kit continuity state is private and mutable at %s.\n' "$kit_state_dir"
printf 'Security, networking, authentication, and power steps remain manual.\n'
