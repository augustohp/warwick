---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git branch:*), Bash(git log:*), Bash(ls:*), Bash(cat:*), Bash(tree:*)
description: Create commit of staged changes.
---
## Commit rules

- Use the same language as previous commit messages.
- Verbs on the infinitive, using imperative active voice. The commit is the actor doing the change.
- Prefer plain english, with phrases and paragraphs.
- Message composed of a "subject" and a "body" separated by a blank line.
  - "subject" line should be <70 chars.
    - DO NOT use conventional commits.
	- Focus on the user-facing impact or behavior change rather than technical implementation details
    - Use present tense third person when describing what the system does (e.g., "Reacts to...", "Validates...", "Sends...")
  - "body" should be <72 chars per line.
    - Describes decisions and provides valuable information of what was considered.
	- Source of context for future devs to identify if a behavior is a bug or a feature.
- DO NOT change author information or add co-authors.

## Context

- Changes to consider in the commit: !`git diff --cached`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes and rules you will:
1. Draft a commit message (with "subject" and "body").
2. Ask user for revision.
3. Create a single commit.
