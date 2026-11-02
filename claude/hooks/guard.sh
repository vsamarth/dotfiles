#!/usr/bin/env bash
# PreToolUse hook for Bash. Asks before commands that touch secrets or
# force-push, which the permission patterns in settings.json can't fully catch
# (Read deny rules don't cover `cat`, and `git -C dir push --force` slips past
# prefix patterns). It asks rather than blocks, matching AGENTS.md "Ask first".
set -euo pipefail

cmd="$(jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

reason=""
if grep -Eq '(~|\$HOME|/Users/[^/]+)/\.(ssh|aws)(/|\b)|\.env(\.|\b)|\.pem\b|\bid_(rsa|ed25519|ecdsa)\b' <<<"$cmd"; then
  reason="touches secrets or key files"
elif grep -Eq '\bsecurity +(find-(generic|internet)-password|dump-keychain)\b' <<<"$cmd"; then
  reason="reads the Keychain"
elif grep -Eq '\bgit\b.*\bpush\b.*(--force|--force-with-lease|(^| )-[a-zA-Z]*f\b| \+[^ ]+)' <<<"$cmd" ||
     grep -Eq '\bgit +pf\b' <<<"$cmd"; then
  reason="force-pushes"
fi

[ -z "$reason" ] && exit 0
jq -n --arg r "This command $reason (AGENTS.md: ask first)." \
  '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $r}}'
