# Personal working agreements

Machine: my personal MacBook. Ghostty opens into herdr. There is
no text editor; `EDITOR` is nano only for rare cases. Browser: Helium.

## Defaults
- Follow explicit current requests, then repo-local instructions, then these.
- Personal projects live in `~/Projects`. Keep artifacts there.
- Default stack is TypeScript with pnpm and node. If a tool you need is
  missing (uv, Python, a build tool), say so and install it only when the task
  needs it.
- Inspect current state before editing. Preserve unrelated changes. Make the
  smallest maintainable change and explain consequential assumptions.

## Do freely
Install packages, create commits, branches and worktrees, edit and delete files
inside the project, fetch URLs and download files, and run heavy jobs. Push to
any branch, and open, update and merge PRs on my own repos. Create issues and
private repos. Work through software tasks end to end without checking in.

## Ask first
- Force-pushing (`--force`, `-f`, `--force-with-lease`, the `git pf` alias),
  deleting remote branches or repos, making a repo public, and publishing
  packages or releases.
- Reading secrets, the Keychain, `~/.ssh`, `~/.aws`, `.env*` or key files.
- Creating, deleting or changing identities, keys, logins, permissions, access
  scopes or security settings.
- Deleting outside the project, or any disk-level operation.
- Rewriting git history: `reset --hard`, `clean`, branch deletion, rebasing
  shared history.
- Losing data: dropping databases, pruning volumes, wiping caches that hold
  models or datasets.
- Acting as me toward others: sending messages or email, posting publicly,
  commenting on other people's repos, or spending money on APIs or cloud.

## Secrets
Secrets live in Proton Pass. Inject them at run time with
`pass-cli run -- <command>`. Never put a secret in a prompt, command argument,
log, patch, commit or generated document. If a secret appears unexpectedly,
stop and tell me. If an operation needs one, ask me to sign in through the
proper interface. Never ask me to paste one into chat.

## Reporting
Validate in proportion to risk. Then say what changed, what was verified, and
what you left for me. When something is unverified, say which part.

## This machine's setup
`~/.dotfiles` is a public repo and `instructions.md` is the source of truth.
Propose changes with the file contents before writing them. Do not keep a setup
log. Keep work names, hosts and tokens out of the repo.
