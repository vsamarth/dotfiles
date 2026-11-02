# Remote session maintenance

How to list, read, close and sweep remote sessions. A **remote session** is a multiplexer pane, other than your own, running Claude Code with Remote Control on. Commands for each operation are in [MUX.md](MUX.md).

## Finding them

Walk every pane in every group and get the process id of the program it runs. Claude Code writes a status file for each running process, `~/.claude/sessions/<pid>.json`; read only that file, never the `.key` files beside it. In it:

- `bridgeSessionId` is set when Remote Control is on: the pane is a remote session, and its link is `https://claude.ai/code/<bridgeSessionId>`. A pane with no status file, or one without `bridgeSessionId`, is not a remote session.
- `status` is `idle` when Claude is waiting at an empty prompt. Anything else (working, or waiting on a question or permission) is **active**. **Idle time** is now minus `statusUpdatedAt` (milliseconds since the epoch) while `status` is `idle`.
- `cwd` under `.claude/worktrees/` means the session has its own worktree.

The status file is Claude Code's internal format. If it's missing or its fields have changed, fall back to the screen: a remote session's screen shows `remote-control is active` until newer output pushes it away, and Claude Code redraws in place, so that line doesn't stay in the scrollback.

## List

Show every remote session grouped by project, one row each: the tab name, the state with its idle time, the link and any worktree. Done when every pane from the scan has been classified.

## Read

To report what a session did, read its conversation log, `~/.claude/projects/*/<sessionId>.jsonl`, using `sessionId` from its status file. Each line is one JSON record:
- `type` `user` records whose `message.content` is a string are the user's messages;
- `type` `assistant` records hold `message.content[]` blocks, where `text` blocks are Claude's replies and `tool_use` blocks are its actions.

Logs run to megabytes, mostly tool output. Pull out the messages and replies first, and open tool calls only where a reply leaves something unclear. Report what was asked, what was done, what changed on disk (files, branches, installs) and what's left for the user. Done when every user message in the log is accounted for.

## Close

1. Close **gracefully**: type `/exit` into the pane and press Enter. Claude ends the remote session, removes its worktree if it is clean, and the pane closes itself. Killing the pane directly skips all of that and leaves a locked worktree behind, so do that only after `/exit` has failed.
2. If Claude asks about its worktree instead of exiting, the worktree has uncommitted changes or commits. **Keep** it: the user's work outlives the session.
3. Confirm the pane is gone, then remove the group if it has no tabs left.

The conversation survives a close. `claude --resume` in the session's dir brings it back.

## Sweep

A remote session is **stale** after 7 days idle. Run the scan, then show the stale sessions with their idle times and let the user pick which to close. Close only the ones picked, using the steps above. Active sessions are never stale, whatever their age. Done when every pick is closed and no empty group remains.
