# Decisions

Append durable decisions in chronological order. Do not delete an old decision when
it changes; add a new entry that names the decision it supersedes.

## Foundational decisions

### 2026-08-12 — Separate identity, account, host, and runtime

- **Context:** Kit needs a stable identity without coupling it to a particular runtime
  or machine implementation.
- **Decision:** The personal agent is Kit, its macOS security account is `agent`, its
  host is `den`, and Hermes may later provide the runtime.
- **Why:** Human-facing identity should persist while infrastructure remains replaceable
  and permissions stay obvious in logs.
- **Consequences:** Runtime changes do not rename Kit; operating-system permissions are
  always granted to the auditable `agent` account.
- **Supersedes:** `none`.

### 2026-08-12 — Keep administration human-controlled

- **Context:** An autonomous runtime should not hold the authority needed to remove its
  own security boundaries.
- **Decision:** `samarth` remains the administrator and recovery account; `agent`
  remains a standard user with no passwordless `sudo` or blanket Full Disk Access.
- **Why:** This preserves a separate recovery and approval path.
- **Consequences:** Privileged work pauses for Samarth to review and perform it.
- **Supersedes:** `none`.

### 2026-08-12 — Separate continuity from credential recovery

- **Context:** Kit needs durable operational memory across restarts, while credentials
  must remain recoverable if Kit or den is unavailable.
- **Decision:** Non-secret continuity lives in `~/Kit`; login passwords and recovery
  keys live only in Samarth's external recovery system.
- **Why:** A journal readable by Kit cannot safely serve as Kit's credential vault.
- **Consequences:** `~/Kit` is independently backed up, contains no secrets, and can
  be restored without exposing credentials to Kit.
- **Supersedes:** `none`.

## Entry template

### YYYY-MM-DD — Short decision title

- **Context:** What required a decision?
- **Decision:** What was chosen?
- **Why:** What tradeoffs or evidence mattered?
- **Consequences:** What becomes easier, harder, allowed, or prohibited?
- **Supersedes:** Earlier entry, or `none`.
