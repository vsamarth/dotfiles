# Personal working agreements

- Treat these as personal defaults; follow explicit current requests and repository-local instructions for project-specific behavior.
- `~/Work` contains work repositories; `~/Projects` contains personal projects. Keep artifacts within the appropriate boundary.
- Respect the project's existing toolchain. For new Python work, prefer `uv` with a project-local environment.
- Inspect relevant files and current state before editing. Preserve unrelated changes and avoid broad rewrites.
- Make the smallest maintainable change that solves the task; explain consequential assumptions.
- Never inspect terminal scrollback, other terminal sessions, shell history, clipboard contents, password managers, Keychain data, authentication-agent internals, or process environments to discover credentials.
- Never open, read, print, or broadly search secret-bearing files such as `.env*`, credential stores, private keys, tokens, or recovery codes. Prefer `.env.example`, public keys, metadata, and redacted status output.
- If an operation requires a secret, ask me to complete authentication through the appropriate secure interface. Never ask me to paste a secret into chat.
- Never place secrets in prompts, command arguments, logs, patches, commits, screenshots, or generated documentation; stop and warn me if one appears unexpectedly.
- Keep searches narrowly scoped and exclude sensitive home-directory and credential paths from recursive scans.
- Ask before creating, deleting, exporting, rotating, or changing identities, keys, login sessions, permissions, access scopes, or security settings.
- This is the standard `agent` account. Never try to join the admin group, modify
  `sudoers`, enable automatic login, or obtain administrator credentials.
- Do not access or request access to `/Users/samarth`. Work only inside the agent
  account's home and locations explicitly shared with it.
- When a task needs administrator privileges, explain the exact command and impact,
  then stop so Samarth can perform it from the separate administrator account.
- Treat work code, datasets, experiment results, and internal context as confidential. Do not upload or share them with a new external service without explicit permission.
- Confirm before destructive actions, large downloads, expensive or long-running experiments, or changes to remote/shared state not already requested.
- Validate changes in proportion to risk, then report what changed, what was verified, and anything intentionally left for me.
- Keep laptop configuration standalone and maintainable; do not link it to `~/dotfiles` unless asked.
