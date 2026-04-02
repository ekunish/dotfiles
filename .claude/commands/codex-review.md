---
name: codex-review
description: Run OpenAI Codex CLI to review code changes
---

Run OpenAI Codex CLI (`codex review`) to review the current code changes.

## Steps

1. First, check `git status` and `git diff --stat` to understand what changes exist
2. Run the Codex review command via Bash:
   - If `$ARGUMENTS` is provided: `codex review $ARGUMENTS`
   - If no arguments: `codex review --uncommitted`
3. Display the review results to the user

## Common usage patterns
- `/codex-review` — Review all uncommitted changes (staged + unstaged + untracked)
- `/codex-review --base main` — Review changes compared to main branch
- `/codex-review --commit HEAD` — Review the latest commit
