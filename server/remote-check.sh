#!/usr/bin/env bash

set -euo pipefail

target="${1:-agent@den}"

if [[ "$target" == -* || "$target" == *[[:space:]]* ]]; then
  printf 'usage: %s [user@host]\n' "$0" >&2
  exit 2
fi

printf "Testing SSH to %s. Verify an unfamiliar host fingerprint at den's physical console before accepting it.\n" "$target"

ssh \
  -o BatchMode=yes \
  -o ConnectTimeout=10 \
  -o ForwardAgent=no \
  "$target" \
  'test "$(id -un)" = agent && test "$(scutil --get LocalHostName)" = den'

printf 'Remote identity is agent@den. Running the read-only core doctor.\n'
ssh \
  -o BatchMode=yes \
  -o ConnectTimeout=10 \
  -o ForwardAgent=no \
  "$target" \
  'bash ~/.dotfiles/server/doctor.sh'

printf 'Remote check passed for %s.\n' "$target"
