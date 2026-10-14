# Environment

macOS (Apple Silicon), zsh, Ghostty. Homebrew at `/opt/homebrew`.
Editor: `cursor --wait` (`$EDITOR`/`$VISUAL`); nvim is the git editor.
Dotfiles: `~/.dotfiles` (github.com/vsamarth/dotfiles), `just` as the task runner.

## Tooling

Prefer these over the POSIX defaults — they are installed and configured:

| Instead of       | Use                                                  |
| ---------------- | ---------------------------------------------------- |
| `grep`           | `rg`                                                 |
| `find`           | `fd`                                                 |
| `ls`             | `eza`                                                |
| `cat` (to read)  | the Read tool; `bat` only when I will read the output |
| ad-hoc scripts   | `just <recipe>` if a justfile exists                  |

`jq`, `yq`, `hyperfine`, `btop`, `gh`, `delta` are available. `docker`, `uv`, and
`pnpm` are NOT installed — say so rather than assuming them.

## Git

- Default branch `main`; `pull.rebase` is on. Don't create merge commits locally.
- `delta` is the pager, `diff3` conflict style. Plain `git diff` output is fine.
- Never `push`, force-push, or `reset --hard` unless I ask. `git pf` is my
  `push --force-with-lease` alias — I run it, not you.
- Commit messages: imperative subject under ~70 chars, no scope prefixes unless
  the repo already uses them. Check `git log` before writing the first commit.
- GitHub identity is `vsamarth`; `gh` is authed and is git's credential helper.

## Working style

- Read before editing. Match the file's existing idiom over any general rule here.
- Don't add comments that restate the code, and don't leave TODOs behind.
- When something is unverified, say which part you didn't run.
- Keep new dependencies to a minimum and flag every one you add.
