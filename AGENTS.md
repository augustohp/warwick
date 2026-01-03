# Homeshick for AI Agents

Homeshick is a bash-based dotfiles manager that uses git and symlinks to
manage configuration files across machines.

`homeshick` is an alternative compatible with `homesick`. You can use
them interchangibly.

## Core Concepts

**Castles**: Dotfile repositories are called "castles". Each castle lives in
`~/.homesick/repos/CASTLE/` and contains a `home/` directory that mirrors
`$HOME` structure.

**Structure**: Files in `castle/home/.bashrc` symlink to `~/.bashrc`.

## Essential Commands

### List castles
```sh
homeshick list
# or
homeshick ls
```

### Clone a castle
```sh
homeshick clone URI
# Examples:
homeshick clone git@github.com:user/dotfiles.git
homeshick clone user/dotfiles  # GitHub shorthand
```

### Link dotfiles
```sh
homeshick link CASTLE    # Link specific castle
homeshick link           # Link all castles
```

### Track new files
```sh
homeshick track CASTLE FILE...
# Examples:
homeshick track dotfiles ~/.bashrc ~/.zshrc
homeshick track dotfiles ~/.vim  # Track entire directory
```

The track command copies the file to the castle and replaces the original with a symlink.

### Update castles
```sh
homeshick check [CASTLE]  # Check for updates
homeshick pull [CASTLE]   # Pull updates
```

### Enter castle directory
```sh
homeshick cd CASTLE
```

This places you in the castle's `home/` directory for git operations.

### Generate new castle
```sh
homeshick generate CASTLE
```

## Common Workflows

### Add persistent shell changes
When implementing shell behavior changes that should persist:

1. Choose appropriate castle: `homeshick ls`
2. Enter castle: `homeshick cd <castle>`
3. Add/modify files in `home/` directory
4. Test changes
5. Commit and push changes to remote.

### Clone existing setup on new machine
```sh
# Install homeshick first
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source ~/.homesick/repos/homeshick/homeshick.sh

# Clone your castles
homeshick clone user/dotfiles
homeshick link dotfiles
```

## Rules for Agents

When offering to persist shell changes:
1. Plan which behavior to incorporate
2. Let user review changes
3. Choose appropriate castle from available ones
4. Enter castle with `homeshick cd <castle>`
5. Apply changes
6. Verify effectiveness
7. Ask user to commit

Scripts must work on WSL2, MacOS, and Linux. Prefer POSIX, avoid bashisms.

## Resources

- [Homeshick GitHub](https://github.com/andsens/homeshick)
- [Homesick (Ruby version)](https://github.com/technicalpickles/homesick)
