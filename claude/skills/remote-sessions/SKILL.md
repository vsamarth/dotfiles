---
name: remote-sessions
description: "Spawn Claude Code sessions with Remote Control on, grouped by project in the terminal multiplexer, and list, read, close or sweep them. Use when asked to spin up or start another Claude session, one to drive from the phone, what remote sessions are running or what they did, or to clean them up."
---

To list, read, close or sweep existing remote sessions, follow [MAINTENANCE.md](MAINTENANCE.md) instead of the steps below. The exact multiplexer command for every operation named here (find group, create group, add tab, read pane, send keys, close pane, remove group) is in [MUX.md](MUX.md).

Spawn a sibling Claude Code session the user drives from claude.ai or the Claude mobile app. Sessions are grouped by **project**: each project gets one multiplexer **group** (a Rex or tmux session), and every spawned Claude is a **tab** inside it, running in one **pane**. The link is how the user reaches it.

## Steps

1. **Settle the inputs.** Take each from the request, else use the default:
   - **dir**: the folder named, else the current working directory.
   - **project**: the basename of dir's git toplevel (dir itself outside git), with any leading dot dropped (`~/code/.config` → `config`).
   - **task**: two to four lowercase words joined by hyphens, naming the work (`fix-login-redirect`). It names the tab.
   - **prompt**: the starting prompt, if the user gave work for it; otherwise none, and the session waits for the user.
   - **worktree**: add `-w <task>` when this session is also editing that repo, so the two work in separate checkouts.

   Done when dir, project, task and prompt (or none) are fixed.

2. **Find the group** whose name is exactly project. Keep its id, or note there is none.

3. **Spawn** in the background, in dir, without moving the user's focus: add a tab named task to the group, or create the group with task as its first tab. Keep the group and pane ids. The command the tab runs:

   ```sh
   claude --remote-control <project>/<task> [-w <task>] \
     --append-system-prompt "This multiplexer session is the <project> project group, shared by several Claude sessions, so its name stays <project>. Name your own pane or tab instead." \
     ["<prompt>"]
   ```

   The Remote Control name `<project>/<task>` lists sessions by project on the phone too. The appended prompt guards the **group name**: multiplexer integrations (Rex's session hook is one) tell every Claude to rename its session after its first task, which would break the grouping for the next spawn.

4. **Read the pane** every couple of seconds until one of these shows:
   - a `https://claude.ai/code/session_…` link: go to step 5.
   - **"Is this a project you created or one you trust?"**: dir is untrusted, and trusting it is the user's security call. Leave the prompt waiting and ask. On yes, send the Down key, confirm the screen shows `❯ Yes, I trust this folder`, send Enter, and keep reading. On no, close the pane, then remove the group if it is now empty.
   - an error, or no link after about 30 seconds: close the pane and report its last lines.

5. **Hand off.** Reply with `<project>/<task>`, the link alone on its own line, the dir, and the group and pane ids. Leave the pane running: closing it ends the remote session.
