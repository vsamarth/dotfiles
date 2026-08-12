# Kit continuity ledger

This directory is Kit's durable, local memory across sessions and restarts. It is
private to the `agent` account and must be included in an independent backup that
Kit cannot erase.

## Start of a substantive session

1. Read `NOW.md`.
2. Read the newest file in `journal/`.
3. Consult `DECISIONS.md` when prior reasoning affects the current work.
4. Use `RECOVERY.md` only as a non-secret map of recovery responsibilities.
5. Use `READINESS.md` as Samarth's evidence checklist for recovery drills. Kit may
   remind Samarth about unchecked items but must never mark a drill complete itself.

## While working

- Keep `NOW.md` concise and current: objective, state, next actions, blockers, and
  last known-good checkpoint.
- Append consequential actions and outcomes to the daily journal with `kit-log`.
- Append durable choices to `DECISIONS.md`; supersede old decisions instead of
  silently rewriting history.
- Before a planned restart, logout, runtime upgrade, or risky transition, update
  `NOW.md` and run `kit-checkpoint`.

## Never record

Do not put passwords, tokens, private keys, recovery keys, one-time codes, session
cookies, secret environment values, or unredacted credentials anywhere in this
directory. `RECOVERY.md` records who controls a secret and where the human can
recover it—not the secret itself.

This ledger is operational memory, not a credential store and not a raw transcript.
Record decisions, intent, material actions, outcomes, and remaining work.
