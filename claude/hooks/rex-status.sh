#!/usr/bin/env bash
# Report Claude's state to Rex with the Program Status Protocol, so Rex's tabs
# and session picker show which sessions are working, blocked on me, or done.
# Usage (from a hook): rex-status.sh working|blocked|done   (hook JSON on stdin)
# https://www.superlogical.com/rex/docs/build/program-status
state="${1:-}"
[ -n "${REX_BLOCK:-}" ] || exit 0   # not running inside Rex

input="$(cat)"
b64() { printf '%s' "$1" | base64 | tr -d '\n'; }

# Hooks have no terminal of their own; write to the one Claude runs in.
tty=""; pid=$PPID
for _ in 1 2 3 4; do
  t="$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')"
  if [ -n "$t" ] && [ "$t" != "??" ]; then tty="/dev/$t"; break; fi
  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"; [ -n "$pid" ] || break
done
[ -w "$tty" ] || exit 0

seq="state=$state:app=claude-code"
case "$state" in
  blocked)
    type="$(jq -r '.notification_type // .tool_name // empty' <<<"$input")"
    case "$type" in
      *permission*) seq="$seq:kind=permission" ;;
      *) seq="$seq:kind=question" ;;
    esac
    msg="$(jq -r '.message // empty' <<<"$input")"
    [ -z "$msg" ] && [ "$type" = AskUserQuestion ] &&
      msg="$(jq -r '.tool_input.questions[0].question // empty' <<<"$input")"
    [ -n "$msg" ] && seq="$seq:msg=$(b64 "${msg:0:300}")"
    ;;
  working|done) ;;
  *) exit 0 ;;
esac

printf '\033]7501;%s\033\\' "$seq" > "$tty"
