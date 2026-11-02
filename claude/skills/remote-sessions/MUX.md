# Multiplexer reference: Rex

Rex calls a group a **session**, a tab a **window** and a pane a **block**. Your own ids are in `$REX_SESSION` and `$REX_BLOCK`. Pass `-s <session_id>` with every block command: a bare block id only resolves inside your own Rex session.

| Operation | Command |
| --- | --- |
| Find group | `rex ls --json`, then the entry in `.sessions` whose `label` is project. Its id is `.session_id`. |
| Create group | `rex new <project> --window <task> --json -c <dir> -- <command>`. It opens without switching the user's screen. Group id `.session_id`, pane id `.initial_windows[0].block_ids[0]`. |
| Add tab | `rex window new -s <session_id> <task> --focus=false --json -c <dir> -- <command>`. Pane id `.block_ids[0]`. |
| List panes | `rex block ls -s <session_id> --json`, then `.blocks[]`. Tab names are in `rex session inspect <session_id> --json`. |
| Read pane | `rex capture -s <session_id> -b <block>`. Claude Code redraws in place, so this shows its current screen, not its history. |
| Pane's process id | `rex block call -s <session_id> -b <block> process`, then `.child.pid`. |
| Send text | `rex send -s <session_id> -b <block> '<text>'`. It sends no Enter. |
| Send key | `rex send-key -s <session_id> -b <block> <key>`, such as `enter` or `down`. |
| Close pane | `rex block close -s <session_id> <block>`. |
| Remove group | `rex kill <session_id>`. Rex keeps a group after its last tab closes, so remove empty groups yourself; `rex session inspect <session_id> --json` shows `windows` as `null` or an empty list. |

## Rex's session hook

`rex skill setup` installs a startup hook that tells every Claude in Rex to rename its Rex session after its first task. The `--append-system-prompt` in the spawn command is what keeps the project group's name.
