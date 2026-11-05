/retro Scope: every Claude Code session from the last 7 days, across all projects. The transcripts are the `*.jsonl` files under `~/.claude/projects/` modified in that window. They are mostly API payloads, so start from `bin/retro-digest` in this worktree: it prints every session in the window as a condensed read (my messages, your replies and tool calls, clipped results). Open a raw file only to look closer at a moment the digest shows.

You're in a scratch worktree of my dotfiles, which holds my global agent setup: `agents/AGENTS.md` (loaded into every session), `claude/settings.json`, `claude/hooks/` and `instructions.md`. Look for what would help every future session: corrections I gave more than once, preferences I restated, procedures done by hand that deserve a global skill, mistakes a hook could prevent, and AGENTS.md lines that proved to be no-ops or wrong.

Make the strongest proposals as edits in this worktree, and draft a new skill as `agents/skills/<name>/SKILL.md`. Findings that matter to one project only belong in your summary. The repo is public, so the edits carry no project names, hosts, people or details lifted from the transcripts.

Finish with a summary ranked by value: each proposal, the sessions that motivated it, and its expected effect. When nothing clears the bar, leave the files unchanged and say so.

Computer-use problems that recur across sessions are a candidate for one `using-computer` skill. Propose it when the same problem appears in two sessions or AGENTS.md needs a second computer-use rule; until then, leave it out.
