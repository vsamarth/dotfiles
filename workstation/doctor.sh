#!/usr/bin/env bash

set -u

workstation_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$workstation_dir/.." && pwd)"
failures=0

ok() { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }
note() { printf '%s\n' "---- $1"; }

if [[ "$(uname -s)" == 'Darwin' && "$(uname -m)" == 'arm64' ]]; then
  ok 'Apple silicon macOS'
else
  bad 'expected Apple silicon macOS'
fi

current_user="$(id -un)"
if [[ "$current_user" == 'samarth' ]]; then
  ok 'running as samarth'
else
  bad "expected account samarth, got $current_user"
fi

if [[ " $(id -Gn "$current_user") " == *' admin '* ]]; then
  ok 'samarth is an administrator'
else
  bad 'samarth is not an administrator'
fi

for command_name in age atuin bat brew btop bun colima croc direnv docker dockutil eza fd fzf gh git delta hyperfine jq just lazydocker lazygit nvim node pnpm python3.13 rg starship uv yazi zellij zoxide; do
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name is installed"
  else
    bad "$command_name is missing"
  fi
done

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  brew_command="$(command -v brew)"
  brew_owner="$(stat -f '%Su' "$brew_prefix")"

  if [[ "$brew_prefix" == '/opt/homebrew' && "$brew_command" == '/opt/homebrew/bin/brew' ]]; then
    ok 'Homebrew uses the supported Apple-silicon prefix'
  else
    bad "unexpected Homebrew command/prefix: $brew_command / $brew_prefix"
  fi

  if [[ "$brew_owner" == "$current_user" ]]; then
    ok 'Homebrew is owned by samarth'
  else
    bad "Homebrew is owned by $brew_owner instead of samarth"
  fi

fi

check_app() {
  local app_path="$1"
  if [[ -d "$app_path" ]]; then
    ok "$(basename "$app_path" .app) is installed"
  else
    bad "$app_path is missing"
  fi
}

check_app '/Applications/Bitwarden.app'
check_app '/Applications/Ghostty.app'
check_app '/Applications/Google Chrome.app'
check_app '/Applications/IINA.app'
check_app '/Applications/KeepingYouAwake.app'
check_app '/Applications/Rectangle.app'
check_app '/Applications/Secretive.app'

if [[ -d '/Applications/Bitwarden.app/Contents/_MASReceipt' ]]; then
  ok 'Bitwarden is the Mac App Store build'
else
  bad 'Bitwarden does not have a Mac App Store receipt'
fi

check_link() {
  local target_path="$1"
  local source_path="$2"
  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    ok "$target_path is linked to the workstation profile"
  else
    bad "$target_path is not linked to $source_path"
  fi
}

check_link "$HOME/.zprofile" "$workstation_dir/zsh/zprofile"
check_link "$HOME/.zshrc" "$workstation_dir/zsh/zshrc"
check_link "$HOME/.config/zsh" "$workstation_dir/zsh/config"
check_link "$HOME/.config/starship.toml" "$workstation_dir/starship.toml"
check_link "$HOME/.config/zellij" "$dotfiles_dir/server/zellij"
check_link "$HOME/.config/ghostty/config" "$workstation_dir/ghostty/config"
check_link "$HOME/.gitconfig" "$workstation_dir/gitconfig"
check_link "$HOME/.gitignore" "$dotfiles_dir/git/gitignore"
check_link "$HOME/.config/nvim" "$dotfiles_dir/nvim"
check_link "$HOME/.codex/AGENTS.md" "$workstation_dir/codex/AGENTS.md"
check_link "$HOME/.codex/config.toml" "$workstation_dir/codex/config.toml"

if [[ -e "$HOME/Library/Application Support/Code/User/settings.json" || -L "$HOME/Library/Application Support/Code/User/settings.json" ]]; then
  check_link "$HOME/Library/Application Support/Code/User/settings.json" "$workstation_dir/vscode/settings.json"
else
  note 'VS Code is optional and its settings are not linked'
fi

if zsh -n "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.config/zsh/"*.zsh; then
  ok 'Zsh configuration parses'
else
  bad 'Zsh configuration does not parse'
fi

if zellij setup --check 2>&1 | grep -q 'Well defined'; then
  ok 'Zellij configuration parses'
else
  bad 'Zellij configuration is not well defined'
fi

if '/Applications/Ghostty.app/Contents/MacOS/ghostty' +validate-config >/dev/null 2>&1; then
  ok 'Ghostty configuration parses'
else
  bad 'Ghostty configuration does not parse'
fi

if nvim --headless "+lua assert(require('diffview')); assert(require('oil')); assert(vim.g.colors_name == 'gruvbox')" +qa >/dev/null 2>&1; then
  ok 'Neovim reviewer profile loads'
else
  bad 'Neovim reviewer profile does not load'
fi

if fdesetup status 2>/dev/null | grep -q 'FileVault is On'; then
  ok 'FileVault is on'
else
  bad 'FileVault is not confirmed on'
fi

auto_login_user="$(defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null || true)"
if [[ -z "$auto_login_user" ]]; then
  ok 'automatic login is off'
else
  bad "automatic login is enabled for $auto_login_user"
fi

if gh auth status >/dev/null 2>&1; then
  ok 'GitHub CLI is authenticated'
else
  note 'GitHub CLI needs manual browser authentication: gh auth login'
fi

if ! command -v codex >/dev/null 2>&1; then
  note 'Codex is installed separately from the workstation package baseline'
elif codex login status >/dev/null 2>&1; then
  ok 'Codex is authenticated'
else
  note 'Codex needs manual browser/device authentication: codex login'
fi

if [[ "$failures" -gt 0 ]]; then
  printf '\n%s workstation check(s) failed.\n' "$failures" >&2
  exit 1
fi

printf '\nWorkstation checks passed. Review informational authentication lines above.\n'
