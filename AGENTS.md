# Warwick Castle Instructions

This is the authoritative policy for Augusto's Homeshick castles. A sibling
castle's `AGENTS.md` contains only local additions or restrictions. Local
security, employer, and publishing restrictions take precedence.

## Castle Ownership

- `warwick`: shared shell behavior, platform profiles, and base Git settings.
- `warwick-llm`: reusable personal AI agents, skills, and configuration.
- `warwick-vim`: shared Vim and Neovim configuration.
- `warwick-azi`, `warwick-picpay`, `warwick-kobold`, and `yak-shaver`:
  isolated consulting or employer identities and material.
- `homeshick`: upstream software; do not modify it as part of castle work.

Put a change in the narrowest owning castle. Never move employer material to a
personal repository merely to make it publishable.

## Safe Homeshick Workflow

- Castles live under `~/.homesick/repos/<castle>`; tracked files under `home/`
  mirror paths under `$HOME`.
- Prefer Homeshick. Use `homeshick help [command]` for current syntax.
- Prefer SSH remotes in the form `git@github.com:owner/repository.git` when the
  current environment is authorized for that remote.
- Inspect `git status --short` before pulling, linking, or editing a castle.
- Preserve unrelated changes and stage explicit paths only.
- Confirm which castle owns a deployed symlink before changing its target.
- Use shallow directory symlinks deliberately; do not convert linking styles as
  unrelated cleanup.
- Commit, push, rewrite history, or change a shared remote only when explicitly
  requested and authorized. A clean worktree is required before castle updates.

## Supported Platforms

Changes should behave coherently on WSL2, macOS, headless Linux, and Raspberry
Pi/ARM Linux while allowing guarded platform-specific behavior.

- Bash startup files may use Bash and should declare that contract.
- Standalone scripts should use POSIX `sh` unless Bash is explicitly required.
- Prefer `$HOME`, XDG variables, `command -v`, and OS/architecture capability
  checks over usernames, absolute installation paths, or assumed package tools.
- Do not treat every ARM or `aarch64` host as a Raspberry Pi.
- Keep work-only assumptions in the work castle that owns them.
- Do not install packages or persistently mutate a machine during shell startup
  without explicit approval.
- Validate platform-specific changes on the owning platform when possible. If
  that is unavailable, state what remains unverified.

## Secrets and Work Boundaries

- Never commit passwords, API tokens, private keys, session/auth state, paste
  caches, generated runtime files, or machine-local state.
- Public keys and CA certificates are not credentials, but employer-owned
  material must remain in its employer castle.
- Treat credentials already tracked by Git as compromised; removing the current
  file does not remove repository history.
- Re-express reusable lessons from work as generic behavior only. Never copy
  employer source, certificates, endpoints, prompts, issue data, logs, internal
  names, or credentials into a personal repository.

## Validation

- Review the complete staged diff before every commit.
- Check shell syntax without sourcing startup files that can mutate the host.
- Verify identity-specific Git changes with `git config --show-origin`.
- Secret-scan staged content and report checks that could not be run.
