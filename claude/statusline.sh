#!/usr/bin/env bash
# Claude Code status line — Everforest accents, matched to ~/.config/starship.toml
set -uo pipefail

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "claude"')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
style=$(printf '%s' "$input" | jq -r '.output_style.name // ""')

# Everforest (256-colour approximations)
GREEN=$'\033[38;5;108m'   # #a7c080  model
BLUE=$'\033[38;5;109m'    # #7fbbb3  directory
YELLOW=$'\033[38;5;179m'  # #dbbc7f  branch
ORANGE=$'\033[38;5;173m'  # #e69875  dirty / counts
GREY=$'\033[38;5;245m'    # #859289  separators
RESET=$'\033[0m'
DIM=$'\033[2m'

# ~-relative, and inside a repo show <repo>/<path-from-root>
pretty_dir() {
  local root rel
  if root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null); then
    rel="${dir#"$root"}"
    printf '%s%s' "$(basename "$root")" "$rel"
  elif [ "$dir" = "$HOME" ]; then
    printf '~'
  elif [ "${dir#"$HOME"/}" != "$dir" ]; then
    printf '~/%s' "${dir#"$HOME"/}"
  else
    printf '%s' "$dir"
  fi
}

git_part() {
  local branch dirty ahead behind out
  branch=$(git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null) || return
  out="${YELLOW}${branch}${RESET}"

  dirty=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ "${dirty:-0}" -gt 0 ] && out+=" ${ORANGE}●${dirty}${RESET}"

  read -r behind ahead < <(git -C "$dir" rev-list --left-right --count @{upstream}...HEAD 2>/dev/null || echo "0 0")
  [ "${ahead:-0}" -gt 0 ] && out+=" ${GREEN}↑${ahead}${RESET}"
  [ "${behind:-0}" -gt 0 ] && out+=" ${ORANGE}↓${behind}${RESET}"

  printf ' %s%s%s %s' "$GREY" "on" "$RESET" "$out"
}

line="${GREEN}${model}${RESET} ${GREY}${DIM}·${RESET} ${BLUE}$(pretty_dir)${RESET}$(git_part)"
[ -n "$style" ] && [ "$style" != "default" ] && line+=" ${GREY}${DIM}[${style}]${RESET}"

printf '%s' "$line"
