# Working agreements

Personal MacBook. Rex is my terminal and multiplexer, Helium my browser. I
don't use a text editor: I see your work through your replies and diffs, so
quote the text that matters rather than pointing me at a file.

## Working with me
- My messages are often dictated or typed fast. Read them for intent; "..."
  usually separates requests.
- Work end to end. When you need a decision, ask with your question tool
  (AskUserQuestion in Claude Code): recommended option first, each question
  standing on its own, related questions in one call. When my answer wouldn't
  change what you do, pick the sensible default and say so.
- Keep changes surgical and leave work that isn't yours as you found it.
- Run one step per shell call, or put a long sequence in a script.
- When I'm discussing an idea, answer and stop: build only on a clear
  "do it", "build" or "fix". "No preference" is not a yes.
- When you use my browser or Rex, close the tabs and panes you opened once
  you're done, unless I still need one.
- Run steps yourself, `sudo` included: it goes through Touch ID, so I only
  touch the sensor (a `sudo -n` probe wrongly reports that a password is
  needed). Asking for a sign-in is approval to drive it: run it in a Rex split
  and click through the browser yourself. Only what truly needs me, such as a
  password, 2FA or Touch ID, comes back to me, with the command alone in a code
  block and on my clipboard.
- Validate in proportion to risk, then say what changed, what you verified and
  what's left for me, naming anything unverified.

## Defaults
- New projects go in `~/Projects`.
- TypeScript with pnpm and node. Install another toolchain when a task needs
  it, and say so.
- Anything an agent reads (skills, docs, `instructions.md`) is writing for
  agents: use the writing-for-agents skill, and leave the exact command to the
  agent unless the exact form is the gotcha.

## Do freely
Install packages, create commits, branches and worktrees, edit and delete
files inside the project, fetch and download, and run heavy jobs. Push to any
branch, and open, update and merge PRs on my own repos. Create issues and
private repos. Use real keyboard and mouse input (`agent-desktop --headed`) when
an app offers no other way: check the app is in front first, and stop if I'm
typing.

## Ask first
- Force-pushing, deleting remote branches or repos, making a repo public, and
  publishing packages or releases.
- Reading secrets, the Keychain, `~/.ssh`, `~/.aws`, `.env*` or key files.
- Creating or changing identities, keys, logins, permissions, access scopes
  or security settings.
- Deleting outside the project, or any disk-level operation.
- Rewriting git history: `reset --hard`, `clean`, branch deletion, rebasing
  shared history.
- Losing data: dropping databases, pruning volumes, wiping model or dataset
  caches.
- Acting as me toward others: messages, email, public posts, comments on
  other people's repos, or spending money.

## Secrets
Secrets live in Proton Pass and reach commands only at run time, through
`pass-cli run -- <command>`, so they stay out of prompts, arguments, logs,
patches, commits and documents. If one appears unexpectedly, stop and tell
me. When something needs a secret, ask me to sign in through its own
interface.

## My setup
`~/.dotfiles` is public and holds this file and my machine setup;
`instructions.md` there is the source of truth. Propose dotfiles changes with
their exact text before writing them, and keep work names, hosts, tokens and
personal details out. When something would help every future session, such
as a preference I keep repeating or a workflow worth a global skill, suggest
it with the wording for this file or a skill; Claude's memory only reaches the
project it was saved in.
