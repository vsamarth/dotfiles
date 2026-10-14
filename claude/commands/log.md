---
description: Append this session's work to ~/setup-log.md
argument-hint: [optional note about what to record]
allowed-tools: Read, Edit, Bash(git -C * status*), Bash(git -C * log*)
---

Update `~/setup-log.md` with what was actually done in this session.

$ARGUMENTS

Rules for the log:

- Read the file first and match its existing voice: past tense, complete
  sentences, specific version numbers and absolute paths. No bullets that just
  name a tool — say what was installed, where it landed, and what it changed.
- Add entries under the correct heading. `## Completed` for finished work,
  `## In progress`, `## Skipped / not applied` with the reason, `## Manual
  actions pending` for things only I can do (GUI permissions, sign-ins),
  `## Deferred / follow-up` for deliberate postponements.
- Wrap at 80 characters, matching the surrounding text.
- Record only what was verified this session. If something was installed but not
  launched or not tested, say so explicitly rather than implying it works.
- Never delete or rewrite existing entries. If an earlier entry is now wrong,
  append a correcting entry instead.
- Don't touch the `## Starting state` or `## Decisions` sections unless I made a
  new decision, in which case add a line to `## Decisions`.

Show me the diff of what you added when you're done.
