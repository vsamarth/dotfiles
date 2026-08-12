#!/usr/bin/env bash

set -u

server_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failures=0

ok() { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }
note() { printf '---- %s\n' "$1"; }

printf '[core]\n'
if bash "$server_dir/doctor.sh"; then
  ok 'core doctor passed'
else
  bad 'core doctor failed'
fi

printf '\n[remote access]\n'
if /usr/bin/nc -z 127.0.0.1 22 >/dev/null 2>&1; then
  ok 'Remote Login is listening on TCP 22'
else
  bad 'Remote Login is not listening on TCP 22'
fi

check_private_path() {
  local target_path="$1"
  local expected_mode="$2"
  local owner mode

  if [[ ! -e "$target_path" ]]; then
    bad "$target_path is missing"
    return
  fi

  owner="$(stat -f '%Su' "$target_path")"
  mode="$(stat -f '%Lp' "$target_path")"
  if [[ "$owner" == "agent" && "$mode" == "$expected_mode" ]]; then
    ok "$target_path is owned by agent with mode $expected_mode"
  else
    bad "$target_path expected owner agent mode $expected_mode; got owner $owner mode $mode"
  fi
}

check_private_path "$HOME/.ssh" 700
check_private_path "$HOME/.ssh/authorized_keys" 600

firewall_tool='/usr/libexec/ApplicationFirewall/socketfilterfw'
if [[ -x "$firewall_tool" ]] && "$firewall_tool" --getglobalstate 2>/dev/null | grep -qi 'enabled'; then
  ok 'macOS application firewall is enabled'
else
  bad 'macOS application firewall is not confirmed enabled'
fi

if command -v tailscale >/dev/null 2>&1 && tailscale status --json 2>/dev/null | jq -e \
  '.BackendState == "Running" and .Self.Online == true and .Self.HostName == "den"' >/dev/null; then
  ok 'Tailscale CLI reports den online'
else
  bad 'Tailscale CLI integration is missing, den is misnamed, or den is offline'
fi

if launchctl print system/com.tailscale.tailscaled >/dev/null 2>&1; then
  ok 'CLI-only tailscaled is installed as a pre-login system service'
else
  note 'no system tailscaled service; the GUI variant may require a graphical login after every reboot'
fi

auto_login_user="$(defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null || true)"
if [[ -z "$auto_login_user" ]]; then
  ok 'automatic login is off'
else
  bad "automatic login is enabled for $auto_login_user"
fi

printf '\n[power]\n'
ac_power_settings="$(pmset -g custom | sed -n '/AC Power:/,$p')"
check_pmset() {
  local key="$1"
  local expected="$2"
  if printf '%s\n' "$ac_power_settings" | grep -Eq "^[[:space:]]*$key[[:space:]]+$expected$"; then
    ok "$key is $expected on AC power"
  else
    bad "$key is not $expected on AC power"
  fi
}

check_pmset sleep 0
check_pmset disksleep 0
check_pmset womp 1
check_pmset tcpkeepalive 1
check_pmset autorestart 1

printf '\n[authentication]\n'
if gh auth status >/dev/null 2>&1; then
  ok 'GitHub CLI is authenticated'
else
  bad 'GitHub CLI is not authenticated'
fi

if codex login status >/dev/null 2>&1; then
  ok 'Codex is authenticated'
else
  bad 'Codex is not authenticated'
fi

printf '\n[human-observed recovery evidence]\n'
readiness_file="$HOME/Kit/READINESS.md"
if [[ ! -f "$readiness_file" ]]; then
  bad "$readiness_file is missing"
elif grep -q '^- \[ \]' "$readiness_file"; then
  unchecked_count="$(grep -c '^- \[ \]' "$readiness_file")"
  bad "$readiness_file still has $unchecked_count unchecked drill(s)"
else
  ok 'Samarth has recorded every required recovery drill'
fi

if [[ "$failures" -gt 0 ]]; then
  printf '\n%s server-readiness check(s) failed.\n' "$failures" >&2
  exit 1
fi

printf '\nLocal readiness checks passed. Run server-remote-check from the controlling Mac after every network or SSH policy change.\n'
